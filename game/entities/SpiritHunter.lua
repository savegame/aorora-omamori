local class = require('lib.hump.class')
local anim8 = require('lib.anim8')
local flux = require('lib.flux')
local chain = require('lib.chain')
local vector = require('lib.hump.vector')
local inspect = require('lib.inspect')

local StateMachine = require('lib.StateMachine')

local SpiritHunter = class {
  playerImage = love.graphics.newImage('assets/images/spirit_seeker_hunter.png')
}

local function moveFilter(item, other)
  if other.type == "spirit" or other.type == "tree"
    or other.type == "grass" or other.type == "interactable" then return "cross" end
  return "slide"
end

local function interactFilter(item)
  if item.type == "interactable" then return true end
  return false
end

local function forestFilter(item)
  if item.type == "grass" then return true end
  return false
end

local function getInputDir()
  local dir = vector(0, 0)
  if love.keyboard.isDown(keys.DPad_right) then dir.x = dir.x + 1 end
  if love.keyboard.isDown(keys.DPad_up) then dir.y = dir.y - 1 end
  if love.keyboard.isDown(keys.DPad_left) then dir.x = dir.x - 1 end
  if love.keyboard.isDown(keys.DPad_down) then dir.y = dir.y + 1 end
  if dir:len() > 0 then dir = dir:normalized() end
  return dir
end

--[[local MoveEntity = class { __includes = chain.Chain,
	init = function(self, entity, shift, duration, easeFunc)
		chain.Chain.init(self)
		self.entity = entity
		self.shift = shift
    self.duration = duration
    self.ease = easeFunc
	end,

	onStart = function(self)
    self.time = 0
    self.moved = vector(0, 0)
	end,

	onUpdate = function(self, dt)
    self.time = self.time + dt
    local value = math.min(1, self.ease(self.time / self.duration))
    local totalMove = vector(value * self.shift.x, value * self.shift.y)
    local delta = vector(totalMove.x - self.moved.x, totalMove.y - self.moved.y)
    self.moved = self.moved + delta

    self.entity:move(delta)

    if value >= 1 then self:complete() end
	end
}]]

local MoveToEntity = class { __includes = chain.Chain,
	init = function(self, entity, target, speed, threshold)
		chain.Chain.init(self)
		self.entity = entity
		self.target = target
    self.speed = speed
    self.threshold = threshold or 2
	end,

	onStart = function(self)
    if vector(self.entity.x, self.entity.y):dist(self.target) <= self.threshold then
			self:complete()
		end
	end,

	onUpdate = function(self, dt)
    local distance = vector(self.entity.x, self.entity.y):dist(self.target)
		local newDirection = vector(self.target.x - self.entity.x, self.target.y - self.entity.y):normalized()
    self.entity:move(newDirection * math.min(self.speed * dt, distance))
    distance = vector(self.entity.x, self.entity.y):dist(self.target)
    if distance <= self.threshold then
			self:complete()
		end
	end
}

function SpiritHunter:init()
	self.type = "keeper"
	self.info = "Keeper"
	self.tweens = flux.group()
	self.x = 0
	self.y = 0
  self.velocity = vector(0, 0)
	self.height = 16
	self.origin = 16
	self.flipped = false
  self.controllable = true
  self.prepareSpeed = 26
  self.walkSpeed = 34
  self.runSpeed = 76
  self.speed = self.walkSpeed
  self.visibility = 1
  self.backwards = false
  self.bushWidth = 1.0
  self.hidden = false
  self.width = 14
  self.height = 14
  self.interactable = nil
  self.queue = chain.Queue()
  self.trees = {}

	local g = anim8.newGrid(64, 64, self.playerImage:getWidth(), self.playerImage:getHeight())
	local animIdle = anim8.newAnimation(g('1-6', 1), 0.12)
	local animWalk = anim8.newAnimation(g('7-8', 1, '1-8', 2, '1-6', 3), 0.09)
  local animRun = anim8.newAnimation(g('7-8', 3, '1-6', 4), 0.08)
  local animDash = anim8.newAnimation(g('7-8', 9), { 0.5, 0.1 }, 'pauseAtEnd')

  local animPrep = anim8.newAnimation(g('7-8', 4), { 0.08, 0.3 }, 'pauseAtEnd')
  local animPrepareWalk = anim8.newAnimation(g('7-8', 7, '1-8', 8, '1-6', 9), 0.09)
	--local animAttack = anim8.newAnimation(g('7-8', 4, '1-8', 5, '1-3', 6),
	--	{ 0.06, 0.3, 0.03, 0.03, 0.1, 0.03, 0.03, 0.8, 0.1, 0.06, 0.04, 0.15, 0.1 }, 'pauseAtEnd')
  local animAttackFront = anim8.newAnimation(g('1-8', 5, '1-3', 6),
		{ 0.03, 0.03, 0.1, 0.03, 0.03, 0.8, 0.1, 0.06, 0.04, 0.15, 0.1 }, 'pauseAtEnd')
  local animAttackBack = anim8.newAnimation(g('4-8', 6, '1-6', 7),
    { 0.03, 0.03, 0.1, 0.03, 0.03, 0.8, 0.1, 0.06, 0.04, 0.15, 0.1 }, 'pauseAtEnd')

	self.animations = {
    idle = animIdle, walk = animWalk, run = animRun, dash = animDash,
    prepare = animPrep, prepareWalk = animPrepareWalk, attack = animAttackFront, attackBack = animAttackBack }
	self.sprite = { image = self.playerImage, animation = animIdle }

  local grassPitImage = assets.grassPitImage
  g = anim8.newGrid(32, 16, grassPitImage:getWidth(), grassPitImage:getHeight())
  local animGrass = anim8.newAnimation(g('1-4', 1), { 0.16, 0.1, 0.16, 0.1 }, function(anim, loops)
    if self.velocity:len2() > 0 then
      anim:gotoFrame(1)
      anim:resume()
    else
      anim:pause()
    end
  end)
  self.grassSprite = { image = grassPitImage, animation = animGrass }

  self.fsm = StateMachine({
    initial = "wander",
    states = {
      wander = class {

    		entered = function(this)
          self:setAnimation("idle", true)
        end,

    		update = function(this, dt)
          local dir = vector(0, 0)
          if self.controllable then
            local dir = getInputDir()
            dir = vector(dir.x * self:getSpeed(self.speed), dir.y * self:getSpeed(self.speed))
  					self:move(vector(dir.x * dt, dir.y * dt))

            if love.keyboard.isDown(keys.A) and self.interactable == nil then
              return self.fsm:switch("attack")
            end
          end

          if self.velocity:len() > 0 then
            if love.keyboard.isDown(keys.X) then
              self:setAnimation("run")
              self.visibility = 2
              self.speed = self.runSpeed
            else
              self:setAnimation("walk")
              self.visibility = 1
              self.speed = self.walkSpeed
            end
          else
            self:setAnimation("idle")
          end
          if self.velocity.x ~= 0 then self:setFlipped(self.velocity.x < 0) end
        end,

    		input = function(this, event)
          if event.type == "pressed" and event.key == keys.A and self.controllable then
            if self.interactable ~= nil then
              self.interactable.interact()
            end
          end
        end,
    		exited = function(this)
          self.visibility = 1
        end
    	},

      attack = class {

    		entered = function(this, maxCharge, dashTimer)
          self.visibility = 1
          this.dashTimer = dashTimer or 0
          this.charge = 0.0
          this.minCharge = 0.16
          this.maxCharge = maxCharge or 0.5
          if maxCharge == 0 then
            this.maxCharge = 0.5
            this.charge = 0.5
            self:setAnimation("prepare")
          else
            self:setAnimation("prepare", true)
          end
        end,

    		update = function(this, dt)
          local dir = vector(0, 0)
          if self.controllable then
            dir = getInputDir()
            dir = vector(dir.x * self:getSpeed(self.prepareSpeed), dir.y * self:getSpeed(self.prepareSpeed))
            self:move(vector(dir.x * dt, dir.y * dt))
          end
          if self.velocity:len() > 0 then
            self:setAnimation("prepareWalk")
          else
            local toEnd = self.sprite.animation ~= self.animations.prepare
            self:setAnimation("prepare")
            if toEnd then
              self.sprite.animation:gotoFrame(#self.sprite.animation.frames)
            end
          end
          if (dir.x > 0 and self.flipped) or (dir.x < 0 and not self.flipped) then
            self.backwards = true else self.backwards = false end
          this.dashTimer = math.max(0, this.dashTimer - dt)
          this.charge = this.charge + dt
          local dir = getInputDir()
          if dir:len() == 0 then
            dir = self.flipped and vector(-1, 0) or vector(1, 0)
          end
          --if dir.x ~= 0 then self:setFlipped(dir.x < 0) end

          if this.charge >= this.minCharge and not love.keyboard.isDown(keys.A) then
            local multiplier = math.min(1.0, 0.4 + (this.charge - this.minCharge) / (this.maxCharge - this.minCharge)*0.6)
            self.fsm:switch("slash", vector(dir.x * multiplier, dir.y * multiplier))
          end
        end,

    		input = function(this, event)
          if event.type == "pressed" and event.key == keys.X
              and this.dashTimer == 0 and self.controllable then
            self.fsm:switch("dash", getInputDir())
          end
        end,

    		exited = function(this)
          self.visibility = 1
          self.backwards = false
        end
    	},

      dash = class {

    		entered = function(this, dir)
          self.visibility = 1
          self:setAnimation("dash", true)
          --self:setAnimation("attack", true)
          local c = chain.Shift(self, dir * 48.0, 0.6, function(p)
            p = 1 - p
            return 1 - (p * p * p)-- * p * p)-- * p * p)-- * p * p)-- * p * p)-- * p * p)
          end)
          c:push(chain.Instant(function() self.fsm:switch("attack", 0, 1.0) end))
          self.queue:push(c)
        end,

    		update = function(this, dt) end,
    		input = function(this, event) end,
    		exited = function(this)
          self.visibility = 1
        end
    	},

      slash = class {

    		entered = function(this, dir)
          self.hit = {}
          self.visibility = 2
          if (dir.x > 0 and self.flipped) or (dir.x < 0 and not self.flipped) then
            self:setFlipped(not self.flipped)
            self:setAnimation("attackBack", true)
          else
            self:setAnimation("attack", true)
          end
          local c = chain.Shift(self, dir * 64.0, 1.47, function(p)
            p = 1 - p
            return 1 - (p * p * p * p * p * p * p * p * p * p * p * p * p)
          end)
          c:push(chain.Instant(function() self.fsm:switch("wander") end))
          self.queue:push(c)
        end,

    		update = function(this, dt) end,
    		input = function(this, event)
          if event.type == "event" and event.event == "spiritHit" then
            if not self.hit[event.spirit] then
              event.spirit:hit()
              self.hit[event.spirit] = true
            end
          end
        end,
    		exited = function(this)
          self.visibility = 1
        end
    	},
    }
  })
end

function SpiritHunter:getSpeed(value)
  return value * (self.hidden and 0.7 or 1.0)
end

function SpiritHunter:getVisibility()
  return self.visibility - (self.hidden and 1 or 0)
end

function SpiritHunter:move(shift)
  local actualX, actualY, cols, len = self.world:move(self,
    self.x - self.width / 2 + shift.x, self.y - self.height + shift.y, moveFilter)
  self.velocity = vector(actualX + self.width / 2 - self.x, actualY + self.height - self.y)
  self.x = actualX + self.width / 2
  self.y = actualY + self.height

  for i = 1, len do
    if cols[i].other.type == "spirit" then
      self.fsm:input({ type = "event", event = "spiritHit", spirit = cols[i].other })
    end
  end
end

function SpiritHunter:moveTo(target)
  return MoveToEntity(self, target, self.walkSpeed, 0.1)
end

function SpiritHunter:enterWorld(field)
  self.world = field.world
  self.world:add(self, self.x - self.width / 2, self.y - self.height, self.width, self.height)
end

function SpiritHunter:exitWorld(field)
  self.world = nil
  field.world:remove(self)
end

function SpiritHunter:update(dt)
  local items, len = self.world:queryRect(self.x - self.width / 2, self.y - self.height, self.width, self.height, interactFilter)
  local prevInteractable = self.interactable
  if len > 0 then
    local closest = items[1]
    for i, v in ipairs(items) do
      if (v.x * v.x + v.y * v.y) < (closest.x * closest.x + closest.y * closest.y) then
        closest = v
      end
    end
    self.interactable = closest
	else
    self.interactable = nil
	end

  if self.interactable then
    globals.inspector:show("a", self.interactable.text())
    --globals.inspector:show("a", '()[]{}±&\\/©#*+-=:;?!><\'_",. ')
  else
    globals.inspector:hide()
  end
  if self.interactable ~= prevInteractable then
    if prevInteractable then prevInteractable.hover(false) end
    if self.interactable then self.interactable.hover(true) end
  end

  local items, len = self.world:queryRect(self.x - self.width / 2, self.y - self.height, self.width, self.height, forestFilter)
	if len > 0 then
		self.hidden = true
	else
    self.hidden = false
  end
  --[[local dir = vector(0, 0)
  if love.keyboard.isDown(keys.DPad_right) then dir.x = dir.x + 1 end
  if love.keyboard.isDown(keys.DPad_up) then dir.y = dir.y - 1 end
  if love.keyboard.isDown(keys.DPad_left) then dir.x = dir.x - 1 end
  if love.keyboard.isDown(keys.DPad_down) then dir.y = dir.y + 1 end
  if dir:len() > 0 then
    dir = dir:normalized()
    self:setAnimation("walk")
  else
    self:setAnimation("idle")
  end

  if dir.x ~= 0 then self:setFlipped(dir.x < 0) end

  local actualX, actualY, cols, len = world:move(self,
    self.x - self.width / 2 + dir.x * self.walkSpeed * dt, self.y - self.height + dir.y * self.walkSpeed * dt, moveFilter)
  self.x = actualX + self.width / 2
  self.y = actualY + self.height]]
  self.fsm:update(dt)
  self.queue:update(dt)

  --[[
  local prevTrees = {}
  for k, v in pairs(self.trees) do
    if v ~= nil then prevTrees[k] = false end
  end
  self.trees = {}
  if dir:len() > 0 then
    for i = 1, len do
      local other = cols[i].other
      if other.type == "tree" then
        if self.trees[other] == nil then
          self.trees[other] = true
          other:addMoving()
        else
          prevTrees[other] = true
        end
      end
    end
  end
  for k, v in pairs(prevTrees) do
    if not v then k:removeMoving() end
  end]]

	self.tweens:update(dt)
	self.sprite.animation:update(dt * (self.backwards and -1.0 or 1.0))
  self.grassSprite.animation:update(dt)
  if self.velocity:len2() > 0 then
    self.grassSprite.animation:resume()
  end
end

function SpiritHunter:draw(pitShader)
  local shader = love.graphics.getShader()
  local quad = self.sprite.animation.frames[self.sprite.animation.position]
  local qx, qy, qw, qh = quad:getViewport()
  shader:send("qx", qx)
  shader:send("qy", qy)
  shader:send("qw", qw)
  shader:send("qh", qh)
  shader:send("iw", self.sprite.image:getWidth())
  shader:send("ih", self.sprite.image:getHeight())
  shader:send("y_origin", 48)

	self.sprite.animation:draw(self.sprite.image, math.floor(self.x - 32 + 0.5),
    math.floor(self.y - 64 + self.origin + 0.5))

  love.graphics.push('all')
  love.graphics.setShader(pitShader)
  quad = self.grassSprite.animation.frames[self.grassSprite.animation.position]
  qx, qy, qw, qh = quad:getViewport()
  local _, originY = love.graphics.transformPoint(self.x, self.y)
	pitShader:send("qx", qx)
	pitShader:send("qw", qw)
	pitShader:send("qw", qw)
	pitShader:send("iw", self.grassSprite.image:getWidth())
  pitShader:send("y_origin", originY)
  pitShader:send("width", self.bushWidth)

  self.grassSprite.animation:draw(self.grassSprite.image, math.floor(self.x - 16 + 0.5),
    math.floor(self.y - 29 + self.origin + 0.5))
  love.graphics.pop()
  --love.graphics.circle("line", self.x, self.y, 2)
end

function SpiritHunter:drawShadow(shader)
  local _, originY = love.graphics.transformPoint(self.x, self.y)
  --shader:send("y_origin", originY)
	love.graphics.ellipse("fill", math.floor(self.x + 0.5), math.floor(self.y + 0.5), 9, 4)
end

function SpiritHunter:input(event)
  self.fsm:input(event)
end

function SpiritHunter:setFlipped(flipped)
	self.flipped = flipped
	self.sprite.animation.flippedH = self.flipped
end

function SpiritHunter:setAnimation(animation, reset)
	self.sprite.animation = self.animations[animation]
  if reset then
    self.sprite.animation:gotoFrame(1)
    self.sprite.animation:resume()
  end
	self.sprite.animation.flippedH = self.flipped
end

function SpiritHunter:setPosition(x, y)
  self.x, self.y = x, y
  self.world:update(self, self.x - self.width / 2, self.y - self.height)
end

function SpiritHunter:gridToPosition(gridX, gridY)
	return gridX * 32 - 16, gridY * 32 - 11
end

function SpiritHunter:attack(targetX, targetY)
	local c = chain.Instant(function()
		self:setFlipped(targetX < self.x)
		self:setAnimation("attack")
		self.sprite.animation:gotoFrame(1)
		self.sprite.animation:resume()
	end)

	c:push(chain.Wait(0.38))
	c:push(chain.Tween(function(group)
		group:to(self, 1.83 - 0.38, { x = targetX, y = targetY }):ease("thirteenout")
	end))
	c:push(chain.Instant(function() self:setAnimation("idle", true) end))

	return c
end

function SpiritHunter:followPath(path)
	local c = chain.Instant(function() self:setAnimation("run")	end)

	local lastNode
	for node, count in path:nodes() do
		if count == 1 then lastNode = node else
			local distance = math.abs(lastNode:getX() - node:getX()) + math.abs(lastNode:getY() - node:getY())
			local currentNode = lastNode
			local newPosX, newPosY = self:gridToPosition(node:getX(), node:getY())

			c:push(chain.Instant(function() if node:getX() ~= currentNode:getX() then
				self:setFlipped(node:getX() < currentNode:getX()) end
			end))
			c:push(chain.Tween(function(group)
				group:to(self, 0.25 * distance, { x = newPosX, y = newPosY }):ease("linear")
			end))

			lastNode = node
		end
	end
	c:push(chain.Instant(function() self:setAnimation("idle")	end))

	return c
end

return SpiritHunter
