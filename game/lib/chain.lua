local class = require('lib.hump.class')
local flux = require('lib.flux')
local queue = require('lib.queue')
local inspect = require('lib.inspect')
local vector = require('lib.hump.vector')


function createIterator(list)
  local i = 0
  local n = #list
  return function ()
    i = i + 1
    if i <= n then return list[i] end
  end
end


-- Chain
local Chain = class {}

function Chain:init()
  self.chain = {}
  self.completed = false
  self.localCompleted = false
  self.iter = nil
  self.current = nil
end

function Chain:start()
  self.completed = false
  self.localCompleted = false
  self:onStart()
  self.iter = createIterator(self.chain)
  self:startChain(self)
end

function Chain:startChain(c)
  self.current = c
  while (self.current ~= nil and self.current:isCompleted()) or
      (self.current == self and self.current:isLocallyCompleted()) do
    self.current = self:nextChain()
    if self.current ~= nil then
      self.current:start()
    end
  end
  if self.current == nil then
    self:complete()
  end
end

function Chain:nextChain() return self.iter() end

function Chain:update(dt)
  if self.current ~= nil then
    if self.current == self then
      self:onUpdate(dt)
      if self.current:isLocallyCompleted() then
        local c = self:nextChain()
        if c ~= nil then
          c:start()
        end
        self:startChain(c)
      end
    else
      self.current:update(dt)
      if self.current:isCompleted() then
        local c = self:nextChain()
        if c ~= nil then
          c:start()
        end
        self:startChain(c)
      end
    end
  end
end

function Chain:input(event)
  if not self:isLocallyCompleted() then self:onInput(event)
  elseif not self:isCompleted() then self.current:input(event) end
end

function Chain:getCurrent() return self.current end

function Chain:complete()
  if self:isLocallyCompleted() then
    self.completed = true
  end
  self.localCompleted = true
end

function Chain:isLocallyCompleted() return self.localCompleted end

function Chain:isCompleted() return self.completed end

function Chain:push(c)
  self.chain[#self.chain + 1] = c
  return self
end

function Chain:size()
  local length = 1
  for c in pairs(self.chain) do
    length = length + c:size()
  end
  return length
end

function Chain:onStart() self:complete() end

function Chain:onUpdate(dt) end

function Chain:onInput(event) end


-- Rings
local Rings = class { __includes = Chain }

function Rings:init()
  Chain.init(self)
  self.parallel = {}
end

function Rings:pushParallel(c)
  self.parallel[#self.parallel + 1] = c
  return self
end

function Rings:onStart()
  for i, c in ipairs(self.parallel) do
    c:start()
  end
  local completed = 0
  for i, c in ipairs(self.parallel) do
    if c:isCompleted() then
      completed = completed + 1
    end
  end
  if completed >= #self.parallel then
    self:complete()
  end
end

function Rings:onUpdate(dt)
  local completed = 0
  for i, c in ipairs(self.parallel) do
    if c:isCompleted() then
      completed = completed + 1
    else
      c:update(dt)
    end
  end
  if completed >= #self.parallel then
    self:complete()
  end
end

function Rings:onInput(event)
  for i, c in ipairs(self.parallel) do
    if not c:isCompleted() then c:input(event) end
  end
end


-- Instant
local Instant = class { __includes = Chain }

function Instant:init(func)
  Chain.init(self)
  self.func = func
end

function Instant:onStart()
  self.func()
  self:complete()
end


-- Tween
local Tween = class { __includes = Chain }

function Tween:init(tweenInit)
  Chain.init(self)
  self.tweens = nil
  self.tweenInit = tweenInit
end

function Tween:createTween()
  return self.tweenInit(self.tweens)
end

function Tween:_isCompleted()
  return #self.tweens == 0
end

function Tween:onStart()
  self.tweens = flux.group()
  self.tweenInit(self.tweens)
  self:onUpdate(0)
  if self:_isCompleted() then
    self:complete()
  end
end

function Tween:onUpdate(dt)
  self.tweens:update(dt)
  if self:_isCompleted() then
    self:complete()
  end
end


-- Wait
local Wait = class { __includes = Chain }

function Wait:init(seconds)
  Chain.init(self)
  self.passed = 0
  self.seconds = seconds
end

function Wait:onStart()
  self.passed = 0
end

function Wait:onUpdate(dt)
  self.passed = self.passed + dt
  if self.passed >= self.seconds then
    self:complete()
  end
end


-- Dynamic
local Dynamic = class { __includes = Chain }

function Dynamic:init(chainCreator)
  Chain.init(self)
  self.dynamic = 0
  self.chainCreator = chainCreator
end

function Dynamic:onStart()
  self.dynamic = self.chainCreator()
  self.dynamic:start()
  if self.dynamic:isCompleted() then
    self:complete()
  end
end

function Dynamic:onUpdate(dt)
  self.dynamic:update(dt)
  if self.dynamic:isCompleted() then
    self:complete()
  end
end

function Dynamic:onInput(event)
  if not self.dynamic:isCompleted() then
    self.dynamic:input(event)
  end
end


-- MoveTo
local MoveTo = class { __includes = Chain }

function MoveTo:init(entity, target, speed, threshold, maxTime)
	Chain.init(self)
	self.entity = entity
	self.target = target
  self.speed = speed
  self.threshold = threshold or 2
  self.maxTime = maxTime or -1
end

function MoveTo:onStart()
  self.time = 0
  if vector(self.entity.x, self.entity.y):dist(self.target) <= self.threshold then
    self.entity:move(vector(0, 0))
		self:complete()
	end
end

function MoveTo:onUpdate(dt)
  self.time = self.time + dt
  local distance = vector(self.entity.x, self.entity.y):dist(self.target)
	local newDirection = vector(self.target.x - self.entity.x, self.target.y - self.entity.y):normalized()
  self.entity:move(newDirection * math.min(self.speed * dt, distance))
  distance = vector(self.entity.x, self.entity.y):dist(self.target)
  if distance <= self.threshold or (self.maxTime >= 0 and self.time >= self.maxTime) then
    self.entity:move(vector(0, 0))
		self:complete()
	end
end


-- Shift
local Shift = class { __includes = Chain }

function Shift:init(entity, shift, duration, easeFunc)
	Chain.init(self)
	self.entity = entity
	self.shift = shift
  self.duration = duration
  self.ease = easeFunc
end

function Shift:onStart()
  self.time = 0
  self.moved = vector(0, 0)
end

function Shift:onUpdate(dt)
  self.time = self.time + dt
  local realValue = self.ease(self.time / self.duration)
  local value = math.min(1, realValue)
  local totalMove = vector(value * self.shift.x, value * self.shift.y)
  local delta = vector(totalMove.x - self.moved.x, totalMove.y - self.moved.y)
  self.moved = self.moved + delta

  self.entity:move(delta)

  if self.time >= self.duration then self:complete() end
end
-- New
--[[
local New = class { __includes = Chain }

function New:init(onStart, onUpdate, onInput)
  Chain.init(self)
  self._onStart = onStart
  self._onUpdate = onUpdate
  self._onInput = onInput
end

function New:onStart()
  if
  self.dynamic:start()
  if self.dynamic:isCompleted() then
    self:complete()
  end
end

function New:onUpdate(dt)
  self.dynamic:update(dt)
  if self.dynamic:isCompleted() then
    self:complete()
  end
end
]]

-- Queue
local Queue = class {}

function Queue:init()
  self.chains = queue()
  self.current = nil
end

function Queue:push(c)
  self.chains:pushRight(c)
end

function Queue:update(dt)
  local completed = false
  if self.current ~= nil then
    self.current:update(dt)
    if self.current ~= nil and self.current:isCompleted() then
      completed = true
    end
  else
    completed = true
  end
  while completed == true do
    self.current = self.chains:popLeft()
    if self.current ~= nil then
      self.current:start()
      if self.current ~= nil and self.current:isCompleted() then
        completed = true
      else
        completed = false
      end
    else
      completed = false
    end
  end
end

function Queue:clear()
  self.current = nil
  self.chains:clear()
end

function Queue:size()
  return self.chains:size()
end

function Queue:input(event)
  if self.current ~= nil then
    self.current:input(event)
  end
end


-- Cogset
local Cogset = class {}

function Cogset:init()
  self.chains = {}
  self.toStart = {}
end

function Cogset:push(c)
  self.toStart[#self.toStart + 1] = c
end

function Cogset:update(dt)
  for i, c in ipairs(self.toStart) do
    c:start()
    --print("started chain "..i.. " "..inspect(c))
    self.chains[#self.chains + 1] = c
  end
  self.toStart = {}
  for i = #self.chains, 1, -1 do
    local c = self.chains[i]
    if c:isCompleted() then
      table.remove(self.chains, i)
    else
      c:update(dt)
    end
  end
end

function Cogset:clear()
  self.toStart = {}
  self.chains = {}
end

function Cogset:size()
  return #self.chains
end

function Cogset:input(event)
  for i, c in ipairs(self.chains) do
    c:input(event)
  end
end

return {
  Chain   = Chain,
  Rings   = Rings,
  Instant = Instant,
  Tween   = Tween,
  Wait    = Wait,
  Dynamic = Dynamic,
  MoveTo  = MoveTo,
  Shift   = Shift,
  Queue   = Queue,
  Cogset  = Cogset
}
