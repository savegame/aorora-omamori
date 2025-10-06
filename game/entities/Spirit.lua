local class = require('lib.hump.class')
local anim8 = require('lib.anim8')
local chain = require('lib.chain')
local vector = require('lib.hump.vector')
local inspect = require('lib.inspect')
local signal = require('lib.hump.signal')

local StateMachine = require('lib.StateMachine')


local Spirit = class {
	images = {
		love = love.graphics.newImage('assets/images/spirit_love.png'),
		success = love.graphics.newImage('assets/images/spirit_success.png'),
		study = love.graphics.newImage('assets/images/spirit_study.png'),
		wealth = love.graphics.newImage('assets/images/spirit_wealth.png')
	}
}

local function moveFilter(item, other)
  if other.type == "spirit" or other.type == "keeper"
		or other.type == "tree" or other.type == "grass" then return "cross" end
  return "slide"
end

local function escapeFilter(item, other)
  if other.type == "spirit" or other.type == "keeper" or other.type == "bounds"
		or other.type == "tree" or other.type == "grass" then return "cross" end
  return "slide"
end

local function forestFilter(item)
  if item.type == "grass" then return true end
  return false
end

local function lerp(a, b, t) return (1 - t) * a + t * b end

local MoveSpirit = class { __includes = chain.Chain,
	init = function(self, spirit, target, threshold)
		chain.Chain.init(self)
		self.spirit = spirit
		self.target = target
		self.threshold = threshold or 4
	end,

	onStart = function(self)
		if vector(self.spirit.x, self.spirit.y):dist(self.target) <= self.threshold then
			self:complete()
		end
	end,

	onUpdate = function(self, dt)
		if vector(self.spirit.x, self.spirit.y):dist(self.target) <= self.threshold then
			self:complete()
			return
		end
		local newDirection = vector(self.target.x - self.spirit.x, self.target.y - self.spirit.y):normalized()

		self.spirit.direction = vector(
				lerp(self.spirit.direction.x, newDirection.x, 0.1),
				lerp(self.spirit.direction.y, newDirection.y, 0.1)
				):normalized()
	end
}

function Spirit:init(field, type)
	self.field = field
	self.type = "spirit"
	self.info = type
	self.signals = signal.new() -- caught(), escaped()
	self.x = 0
	self.y = 0
	self.direction = vector(0, 0)
	self.altitude = 0
	self.origin = 1
	self.shadowScale = 1.0
	self.width = 12
  self.height = 12
	self.walkSpeed = 24
	self.awaySpeed = 38
	self.escapeSpeed = 50
	self.bushWidth = 1.0
	self.hidden = false
	self.hide = true
	self.trees = {}
	self.closeAlertRadius = 28
	self.mediumAlertRadius = 42
	self.farAlertRadius = 60
	self.queue = chain.Queue()
	self.cogset = chain.Cogset()

	local image = self.images[type]
	local g = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
	local animIdle = anim8.newAnimation(g('1-8', 1), 0.12)
	--local animHit = anim8.newAnimation(g('1-6', 2), 0.1, 'pauseAtEnd')
	local animCatch = anim8.newAnimation(g('1-8', 2, '1-8', 3, '1-8', 4, '1-2', 5, '3-3', 6),
		{ 0.04, 0.04, 0.04, 1.0, 0.05, 0.05, 0.05,
		0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1,
	 	0.08, 0.06, 0.06, 0.06, 0.5, 0.1, 0.1, 0.1}, 'pauseAtEnd')
	local animDisappear = anim8.newAnimation(g('3-8', 5, '1-1', 6), 0.05, 'pauseAtEnd')
	local animAppear = anim8.newAnimation(g('8-3', 5), 0.05, function(anim, loops) self:_appeared(anim) end)

	self.animations = {idle = animIdle, catch = animCatch,
		disappear = animDisappear, appear = animAppear }
	self.sprite = {image = image, animation = animIdle }

	local grassPitImage = assets.grassPitImage
  g = anim8.newGrid(32, 16, grassPitImage:getWidth(), grassPitImage:getHeight())
  local animGrass = anim8.newAnimation(g('1-4', 1), { 0.16, 0.1, 0.16, 0.1 }, function(anim, loops)
    if self.direction:len2() > 0 then
      anim:gotoFrame(1)
      anim:resume()
    else
      anim:pause()
    end
  end)
  self.grassSprite = { image = grassPitImage, animation = animGrass }
end

function Spirit:start(initialState)
	self.fsm = StateMachine({
    initial = initialState or "rest",
    states = {
			spawn = class {

    		entered = function(this)
          --self:setAnimation("idle")
					self.queue:clear()
					local c = self:goToRandomSpot()
					c:push(chain.Instant(function() self.fsm:switch("rest") end))
					self.queue:push(c)

					self.cogset:clear()
					local c = chain.Tween(function(group)
						group:to(self, 0.7, { bushWidth = 1.0 }):after(0.7, { bushWidth = 0.0 })
					end)
					self.cogset:push(c)
        end,

    		update = function(this, dt)
					local dir = self.direction
					self:move(vector(dir.x * self.walkSpeed * dt, dir.y * self.walkSpeed * dt), escapeFilter)

					if self:someoneAround() then
						self.fsm:switch("stepAway")
					end
        end,

    		input = function(this, event)
					if event.type == "event" and event.event == "hit" then
						self.fsm:switch(self.hidden and "vulnerable" or "caught")
					end
					self:_handleAppearDisappear(event)
				end,
    		exited = function(this) end
    	},

			rest = class {

    		entered = function(this, seconds)
          --self:setAnimation("idle")
					self.queue:clear()
					local c = chain.Wait(seconds or math.random(8, 16))
					c:push(chain.Instant(function() self.fsm:switch("wander") end))
					self.queue:push(c)
        end,

    		update = function(this, dt)
          local dir = self.direction
					self:move(vector(dir.x * self.walkSpeed * dt, dir.y * self.walkSpeed * dt))

					if self:someoneAround() then
						self.fsm:switch("stepAway")
					end
        end,

    		input = function(this, event)
					if event.type == "event" and event.event == "hit" then
						self.fsm:switch(self.hidden and "vulnerable" or "caught")
					end
					self:_handleAppearDisappear(event)
				end,
    		exited = function(this) end
    	},

			wander = class {

    		entered = function(this)
          --self:setAnimation("idle")
					self.queue:clear()
					local c = self:goToRandomSpot()
					c:push(chain.Instant(function() self.fsm:switch("rest") end))
					self.queue:push(c)

					self.cogset:clear()
					local c = chain.Tween(function(group)
						group:to(self, 0.7, { bushWidth = 1.0 }):after(0.7, { bushWidth = 0.0 })
					end)
					self.cogset:push(c)
        end,

    		update = function(this, dt)
					local dir = self.direction
					self:move(vector(dir.x * self.walkSpeed * dt, dir.y * self.walkSpeed * dt))

					if self:someoneAround() then
						self.fsm:switch("stepAway")
					end
        end,

    		input = function(this, event)
					if event.type == "event" and event.event == "hit" then
						self.fsm:switch(self.hidden and "vulnerable" or "caught")
					end
					self:_handleAppearDisappear(event)
				end,
    		exited = function(this) end
    	},

			vulnerable = class {

    		entered = function(this)
					self.hide = false
					self:setAnimation("appear", true)
					self.queue:clear()
					local c = chain.Shift(self, vector.fromPolar(math.random() * math.pi * 2) * 24.0, 0.8, function(p)
            p = 1 - p
            return 1 - (p * p * p * p)-- * p * p * p)-- * p * p)-- * p * p)-- * p * p)
          end)
					c:push(chain.Wait(0.5))
					c:push(chain.Instant(function() self.fsm:switch("escape") end))
					self.queue:push(c)
					self.cogset:clear()
					local cs = chain.Tween(function(group)
						group:to(self, 0.4, { bushWidth = 1.0 })
					end)
					self.cogset:push(cs)
        end,

    		update = function(this, dt)
          --local dir = self.direction
					--self:move(vector(dir.x * self.walkSpeed * dt, dir.y * self.walkSpeed * dt))
        end,

    		input = function(this, event) end,
    		exited = function(this) end
    	},

			escape = class {

    		entered = function(this)
          --self:setAnimation("idle")
					self.queue:clear()
					local c = self:escapeForest()
					c:push(chain.Instant(function()
						if self.sprite.animation ~= self.animations.disappear then
							self:setAnimation("disappear", true)
						end
					end))
					c:push(chain.Dynamic(function()
						return chain.Tween(function(group)
							group:to(self, 0.4, { bushWidth = 0.0 })
						end)
					end))
					c:push(chain.Instant(function()
						self.signals:emit("escaped")
						self.field:removeObject(self)
					end))
					--c:push(chain.Instant(function() self.fsm:switch("rest") end))
					self.queue:push(c)
        end,

    		update = function(this, dt)
					local dir = self.direction
					self:move(vector(dir.x * self.escapeSpeed * dt, dir.y * self.escapeSpeed * dt), escapeFilter)
        end,

    		input = function(this, event)
					if event.type == "event" and event.event == "hit" then
						self.fsm:switch("caught")
					end
				end,
    		exited = function(this) end
    	},

			stepAway = class {

    		entered = function(this)
					self.queue:clear()
					local c = chain.Wait(0.2)
					c:push(self:escapeForest())
					c:push(chain.Instant(function()
						if self.sprite.animation ~= self.animations.disappear then
							self:setAnimation("disappear", true)
						end
					end))
					c:push(chain.Dynamic(function()
						return chain.Tween(function(group)
							group:to(self, 0.4, { bushWidth = 0.0 })
						end)
					end))
					c:push(chain.Instant(function()
						self.signals:emit("escaped")
						self.field:removeObject(self)
					end))
					self.queue:push(c)

					self.cogset:clear()
					local cs = chain.Tween(function(group)
						group:to(self, 0.7, { bushWidth = 1.0 }):after(0.7, { bushWidth = 0.0 })
					end)
					self.cogset:push(cs)
        end,

    		update = function(this, dt)
					local dir = self.direction
					self:move(vector(dir.x * self.awaySpeed * dt, dir.y * self.awaySpeed * dt), escapeFilter)
        end,

    		input = function(this, event)
					if event.type == "event" and event.event == "hit" then
						self.fsm:switch(self.hidden and "vulnerable" or "caught")
					end
					self:_handleAppearDisappear(event)
				end,
    		exited = function(this) end
    	},

			caught = class {

    		entered = function(this)
					self.hide = false
					self.direction = vector(0, 0)
					self.queue:clear()
          self:setAnimation("catch", true)
					local c = self:catch()
					c:push(chain.Instant(function()
						data.spirits[self.info] = data.spirits[self.info] + 1
					end))
					self.queue:push(c)
        end,

    		update = function(this, dt)
          local dir = self.direction
					self:move(vector(dir.x * self.walkSpeed * dt, dir.y * self.walkSpeed * dt))
        end,

    		input = function(this, event) end,
    		exited = function(this) end
    	},
    }
  })
end

function Spirit:move(shift, filter)
	local f = filter or moveFilter
  local actualX, actualY, cols, len = self.world:move(self,
    self.x - self.width / 2 + shift.x, self.y - self.height + shift.y, f)
  self.velocity = vector(actualX + self.width / 2 - self.x, actualY + self.height - self.y)
  self.x = actualX + self.width / 2
  self.y = actualY + self.height
end

function Spirit:someoneAround()
	local dist = vector(globals.player.x, globals.player.y):dist(vector(self.x, self.y))
	if dist <= self.farAlertRadius then
		if globals.player:getVisibility() >= 2 then return true end
	end
	if dist <= self.mediumAlertRadius then
		if globals.player:getVisibility() >= 1 then return true end
	end
	if dist <= self.closeAlertRadius then
		if globals.player:getVisibility() >= 0 then return true end
	end

	return false
end

function Spirit:_handleAppearDisappear(event)
	if event.type == "event" and event.event == "appear" then
		self.cogset:clear()
		local c = chain.Tween(function(group)
			group:to(self, 0.4, { bushWidth = 1.0 })
		end)
		self.cogset:push(c)
		self:setAnimation("appear", true)
	end
	if event.type == "event" and event.event == "disappear" then
		self.cogset:clear()
		local c = chain.Tween(function(group)
			group:to(self, 0.4, { bushWidth = 0.0 })
		end)
		self.cogset:push(c)
		self:setAnimation("disappear", true)
	end
end

function Spirit:setAnimation(animation, reset)
	self.sprite.animation = self.animations[animation]
  if reset then
    self.sprite.animation:gotoFrame(1)
    self.sprite.animation:resume()
  end
end

function Spirit:_appeared(anim)
	self:setAnimation("idle", true)
end

function Spirit:enterWorld(field)
	self.field = field
  self.world = field.world
  self.world:add(self, self.x - self.width / 2, self.y - self.height, self.width, self.height)
end

function Spirit:exitWorld(field)
	self.field = nil
  self.world = nil
  field.world:remove(self)
end

function Spirit:update(dt)
	self.fsm:update(dt)
	self.queue:update(dt)
	self.cogset:update(dt)
	self.sprite.animation:update(dt)

	--self:move(vector(self.direction.x * self.walkSpeed * dt, self.direction.y * self.walkSpeed * dt))

	local items, len = self.world:queryRect(self.x - self.width / 2, self.y - self.height, self.width, self.height, forestFilter)
	if len > 0 then
		self.hidden = true
		if self.sprite.animation ~= self.animations.disappear and self.hide then
			self.fsm:input({ type = "event", event = "disappear" })
			--self:setAnimation("disappear", true)
		end
	else self.hidden = false end
	if (len == 0 or not self.hide) and self.sprite.animation == self.animations.disappear then
		self.fsm:input({ type = "event", event = "appear" })
		--self:setAnimation("appear", true)
	end

	self.grassSprite.animation:update(dt)
  if self.direction:len2() > 0 then
    self.grassSprite.animation:resume()
  end
end

function Spirit:draw(pitShader)
	local shader = love.graphics.getShader()
  local quad = self.sprite.animation.frames[self.sprite.animation.position]
  local qx, qy, qw, qh = quad:getViewport()
  shader:send("qx", qx)
  shader:send("qy", qy)
  shader:send("qw", qw)
  shader:send("qh", qh)
  shader:send("iw", self.sprite.image:getWidth())
  shader:send("ih", self.sprite.image:getHeight())
  shader:send("y_origin", 32)

	self.sprite.animation:draw(self.sprite.image, self.x - 16, self.y - 28 + self.altitude)

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

  self.grassSprite.animation:draw(self.grassSprite.image, self.x - 16, self.y - 15 + self.origin)
  love.graphics.pop()

	love.graphics.push('all')
	if self.fsm.current == "stepAway" or self.fsm.current == "escape" then
		love.graphics.setColor(255, 150, 150, 255)
	else
		love.graphics.setColor(255, 255, 255, 255)
	end
  --love.graphics.circle("line", self.x, self.y, 2)
	love.graphics.pop()
end

function Spirit:drawShadow()
	love.graphics.ellipse("fill", self.x, self.y, 6 * self.shadowScale, 3 * self.shadowScale)
end

function Spirit:setPosition(x, y)
  self.x, self.y = x, y
  self.world:update(self, self.x - self.width / 2, self.y - self.height)
end

function Spirit:gridToPosition(gridX, gridY)
	return gridX * 32 - 16, gridY * 32 - 11
end

function Spirit:catch()
	local c = chain.Instant(function()
		self:setAnimation("catch", true)
	end)

	c:push(chain.Wait(2.88)) -- time of cut and catch
	c:push(chain.Tween(function(group)
		group:to(self, 0.4, { bushWidth = 0.0 })
	end))
	c:push(chain.Instant(function()
		self.signals:emit("caught")
		self.field:removeObject(self)
	end))

	return c
end

function Spirit:hit()
	self.fsm:input({type = "event", event = "hit" })
end

function Spirit:_weightedCostEvaluation(node, neighbour, finder, clearance)
	local mCost = self.field.map.layers["specials"].data[neighbour:getY()][neighbour:getX()] and 1 or 4
	if node._g + mCost < neighbour._g then
		neighbour._parent = node
		neighbour._g = node._g + mCost
	end
end

function Spirit:_escapeCostEvaluation(node, neighbour, finder, clearance)
	local mCost = math.max(1, 640 -
		math.pow(vector(node:getX(), node:getY()):dist(vector(math.floor(globals.player.x / 32) + 1,
		math.floor(globals.player.y / 32) + 1)), 2))
	mCost = mCost + vector(node:getX(), node:getY()):dist(vector(neighbour:getX(), neighbour:getY()))
	if node._g + mCost < neighbour._g then
		neighbour._parent = node
		neighbour._g = node._g + mCost
	end
end

function Spirit:goToRandomSpot()
	local start = vector(math.floor(self.x / 32) + 1, math.floor(self.y / 32) + 1)
	local cells = self.field:getCustomReachableCellsAllFrom(start.x, start.y,
		function(cost, x, y)
			return cost >= 1 and cost < 7
				and self.field.map.layers["specials"].data[y][x]
				and self.field.map.layers["specials"].data[y][x].id == 56
				and not self.field.map.layers["bounds"].data[y][x]
		end,
		function(x, y) --return 1
			if self.field.map.layers["specials"].data[y][x] then return 1 else return 4 end
		end)

	--for i, c in ipairs(cells) do
	--	print(inspect(c))
	--end
	local cell = cells[math.random(1, #cells)]

	local path = self.field:getPathCustomWeighted(start, cell, function(...) return self:_weightedCostEvaluation(...) end)
	if not path then
		print("null, selected from "..inspect(start) ..": " .. inspect(cell))
		return
	end
	return self:followPath(path)
end

function Spirit:spawnToRandomSpot()
	local start = vector(math.floor(self.x / 32) + 1, math.floor(self.y / 32) + 1)
	local cells = self.field:getCustomReachableCellsFrom(start.x, start.y,
		function(cost, x, y)
			return cost >= 1 and cost < 7
				and self.field.map.layers["specials"].data[y][x]
				and self.field.map.layers["specials"].data[y][x].id == 56
				and not self.field.map.layers["bounds"].data[y][x]
		end,
		function(x, y) --return 1
			if self.field.map.layers["specials"].data[y][x] then return 1 else return 4 end
		end)

	for i, c in ipairs(cells) do
		--print(inspect(c))
	end
	local cell = cells[math.random(1, #cells)]

	local path = self.field:getPathCustomWeighted(start, cell, function(...) return self:_weightedCostEvaluation(...) end)
	if not path then
		print("null, selected from "..inspect(start) ..": " .. inspect(cell))
		return
	end
	return self:followPath(path)
end

function Spirit:escapeForest()
	local start = vector(math.floor(self.x / 32) + 1, math.floor(self.y / 32) + 1)
	local cells = self.field:getCustomReachableCellsAllFrom(start.x, start.y,
		function(cost, x, y)
			return self.field.map.layers["bounds"].data[y][x]
		end,
		function(x, y) --return 1
			return math.max(1, 640 -
				math.pow(vector(x, y):dist(vector(math.floor(globals.player.x / 32) + 1,
				math.floor(globals.player.y / 32) + 1)), 2))
		end)
	local cheaper = nil
	for i, c in ipairs(cells) do
		if cheaper == nil or cheaper.cost > c.cost then cheaper = c end
	end
	local cell = cheaper

	local path = self.field:getPathAllCustomWeighted(start, cell, function(...) return self:_escapeCostEvaluation(...) end)
	if not path then
		print("null, selected from "..inspect(start) ..": " .. inspect(cell))
		return
	end
	return self:followPath(path)
end

function Spirit:followPath(path)
	local c = chain.Chain()

	local lastNode
	for node, count in path:nodes() do
		if count == 1 then lastNode = node else
			local distance = math.abs(lastNode:getX() - node:getX()) + math.abs(lastNode:getY() - node:getY())
			local newPosX, newPosY = self:gridToPosition(node:getX(), node:getY())

			c:push(MoveSpirit(self, vector(newPosX, newPosY)))
			lastNode = node
		end
	end

	c:push(chain.Instant(function() self.direction = vector(0, 0) end))

	return c
end

function Spirit:doFollowPath(path)
	local c = chain.Chain()

	local lastNode
	for node, count in path:nodes() do
		if count == 1 then lastNode = node else
			local distance = math.abs(lastNode:getX() - node:getX()) + math.abs(lastNode:getY() - node:getY())
			local newPosX, newPosY = self:gridToPosition(node:getX(), node:getY())

			c:push(MoveSpirit(self, vector(newPosX, newPosY)))
			lastNode = node
		end
	end

	c:push(chain.Instant(function() self.direction = vector(0, 0) end))
	c:push(chain.Wait(math.random(7, 16)))
	c:push(chain.Instant(function() self:doGoToRandomSpot() end))

	self.queue:push(c)
end

--[[function Spirit:doGoToRandomSpot()
	local start = vector(math.floor(self.x / 32) + 1, math.floor(self.y / 32) + 1)
	local cells = self.field:getCustomReachableCellsFrom(start.x, start.y,
		function(cost, x, y)
			return cost >= 1 and cost < 7
				and self.field.map.layers["specials"].data[y][x]
				and self.field.map.layers["specials"].data[y][x].id == 56
		end,
		function(x, y) --return 1
			if self.field.map.layers["specials"].data[y][x] then return 1 else return 4 end
		end)

	for i, c in ipairs(cells) do
		--print(inspect(c))
	end
	local cell = cells[math.random(1, #cells)]

	local path = self.field:getPathCustomWeighted(start, cell, function(...) return self:_weightedCostEvaluation(...) end)
	if not path then
		print("null, selected from "..inspect(start) ..": " .. inspect(cell))
		return
	end
	self:doFollowPath(path)
end]]

--[[function Spirit:followPath(path, field, steps)
	local c = chain.Chain()

	local lastNode
	for node, count in path:nodes() do
		if steps and count > steps + 1 then break end
		if count == 1 then lastNode = node else
			local distance = math.abs(lastNode:getX() - node:getX()) + math.abs(lastNode:getY() - node:getY())
			local newPosX, newPosY = self:gridToPosition(node:getX(), node:getY())

			c:push(chain.Tween(function(group)
				group:to(self, 0.25 * distance, { x = newPosX, y = newPosY }):ease("linear")
			end))
			lastNode = node
		end
	end

	if field then
		c:push(chain.Instant(function() field:moveObject(self, lastNode:getX(), lastNode:getY()) end))
	end

	return c
end]]

return Spirit
