local class = require('lib.hump.class')
local anim8 = require('lib.anim8')
local chain = require('lib.chain')
local vector = require('lib.hump.vector')

local StateMachine = require('lib.StateMachine')
local Requirements = require('entities.Requirements')

local Villager = class {
  images = {
    maleAdults = love.graphics.newImage("assets/images/male_adults.png"),
    femaleAdults = love.graphics.newImage("assets/images/female_adults.png"),
    maleElders = love.graphics.newImage("assets/images/male_elders.png"),
    femaleElders = love.graphics.newImage("assets/images/female_elders.png"),
    femaleChildren = love.graphics.newImage("assets/images/female_children.png")
  }
}

function Villager:init(imageSet, index, spawnPoint,
    startDialog,
    summary,
    receiving,
    received,
    outcome,
    omamoriType,
    spiritRequirements)
	self.type = "villager"
	self.x = 0
	self.y = 0
  self.width = 20
  self.height = 12
  self.field = nil
  self.world = nil
  self.queue = chain.Queue()
  self.spawnPoint = spawnPoint
  self.startDialog = startDialog
  self.summary = summary
  self.receiving = receiving
  self.received = received
  self.outcome = outcome
  self.omamoriType = omamoriType
  self.spiritRequirements = spiritRequirements
  self.helped = false

  self.requirements = Requirements(fonts.medium)
  self.active = false

  self.interactable = {
    type = "interactable",
    text = function()
      return self:meetsRequirements() and self.active and "Give" or "Listen"
    end,
    x = 0, y = 0,
    width = 20,
    height = 14,
    offsetY = 8,
    interact = function()
      local c = chain.Instant(function() globals.player.controllable = false end)
      c:push(globals.player:moveTo(vector(self.x, self.y + 24)))
      c:push(chain.Instant(function()
        globals.player.velocity = vector(0, 0)
        globals.camera:follow(nil)
      end))
      c:push(chain.MoveTo(globals.camera, vector(self.x - 16, self.y - 40), 48, 2, 1))
      if not self.active then
        c:push(globals.textbox:show())
        c:push(globals.textbox:dialog(self.startDialog))
        c:push(globals.textbox:hide())
        c:push(globals.fadeblack:show())
        c:push(globals.fadeblack:dialog(self.summary))
        c:push(globals.fadeblack:hide())
      elseif self.active and self:meetsRequirements() then
        c:push(chain.Instant(function()
          for t, n in pairs(self.spiritRequirements) do
            data.spirits[t] = data.spirits[t] - n
          end
        end))
        c:push(globals.textbox:show())
        c:push(globals.textbox:dialog(self.receiving))
        c:push(globals.textbox:hide())
        c:push(chain.Instant(function()
          sounds.start:play()
        end))
        c:push(globals.omamori:show(self.omamoriType))
        c:push(globals.fadeblack:show())
        c:push(globals.fadeblack:dialog(self.received))
        c:push(chain.Instant(function()
          self.helped = true
          self.field:removeObject(self)
        end))
        c:push(globals.fadeblack:hide())
      else
        c:push(globals.textbox:show())
        c:push(globals.textbox:dialog(self.startDialog))
        c:push(globals.textbox:hide())
      end
      c:push(chain.Dynamic(function()
        return chain.MoveTo(globals.camera, vector(globals.player.x - 16, globals.player.y - 28), 48, 2, 1)
      end))
      c:push(chain.Instant(function()
        globals.camera:follow(globals.player, { x = -16, y = -28 })
        globals.player.controllable = true
        self.active = true
      end))
      globals.queue:push(c)
    end,
    hover = function(inside)
      if self.active then
        self.queue:clear()
        if inside then
          self.queue:push(self.requirements:show(self.spiritRequirements))
        else
          self.queue:push(self.requirements:hide())
        end
      end
    end
  }

	local image = self.images[imageSet]
	local g = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
	local animIdle = anim8.newAnimation(g('1-4', index), { 0.25, 0.1, 0.25, 0.1 })

	self.animations = { idle = animIdle }
	self.sprite = { image = image, animation = animIdle }

  self.fsm = StateMachine({
    initial = "idle",
    states = {
      idle = class {

    		entered = function(this)
          self:setAnimation("idle")
        end,

    		update = function(this, dt) end,
    		input = function(this, event) end,
    		exited = function(this) end
    	}
    }
  })
end

function Villager:meetsRequirements()
  local ok = true
  for k, v in pairs(self.spiritRequirements) do
    if data.spirits[k] < v then ok = false break end
  end
  return ok
end

function Villager:enterWorld(field)
  self.field = field
  self.world = field.world
  self.world:add(self, self.x - self.width / 2, self.y - self.height, self.width, self.height)
  self.world:add(self.interactable, self.x - self.interactable.width / 2,
    self.y - self.interactable.height + self.interactable.offsetY,
    self.interactable.width, self.interactable.height)
end

function Villager:exitWorld(field)
  self.field = nil
  self.world = nil
  field.world:remove(self)
  field.world:remove(self.interactable)
end

function Villager:update(dt)
  self.fsm:update(dt)
  self.queue:update(dt)
  self.sprite.animation:update(dt)
  self.requirements.x, self.requirements.y = self.x, self.y - 32
end

function Villager:draw()
	self.sprite.animation:draw(self.sprite.image, self.x - 16, self.y - 32)
  --love.graphics.circle("line", self.x, self.y, 2)
  self.requirements:draw()
end

function Villager:drawShadow()
	love.graphics.ellipse("fill", self.x, self.y, 9, 4)
end

function Villager:setPosition(x, y)
  self.x, self.y, self.interactable.x, self.interactable.y = x, y, x, y
  self.world:update(self, self.x - self.width / 2, self.y - self.height)
  self.world:update(self.interactable, self.x - self.interactable.width / 2,
    self.y - self.interactable.height + self.interactable.offsetY)
end

function Villager:gridToPosition(gridX, gridY)
	return gridX * 32 - 16, gridY * 32 - 11
end

function Villager:setAnimation(animation, reset)
	self.sprite.animation = self.animations[animation]
  if reset then
    self.sprite.animation:gotoFrame(1)
    self.sprite.animation:resume()
  end
end

return Villager
