local class = require('lib.hump.class')
local chain = require('lib.chain')


local Requirements = class {}

function Requirements:init(font)
  self.x = 0
  self.y = 0
  self.font = font
  self.image = love.graphics.newImage("assets/images/spirits_requirements.png")
  self.quad = love.graphics.newQuad(0, 0, 64, 32, 128, 64)
  self.spirits = {
    love = love.graphics.newQuad(0, 32, 32, 32, 128, 64),
    success = love.graphics.newQuad(64, 32, 32, 32, 128, 64),
    wealth = love.graphics.newQuad(32, 32, 32, 32, 128, 64),
    study = love.graphics.newQuad(96, 32, 32, 32, 128, 64)
  }
  self.alpha = 0
  self.height = 0
  self.requirements = {}
  self.visible = false
end

function Requirements:show(requirements)
  local c = chain.Instant(function()
    self.requirements = requirements
    self.visible = true
  end)
  c:push(chain.Tween(function(group)
    group:to(self, 0.5, { alpha = 255, height = -16 })
  end))
  return c
end

function Requirements:hide()
  local c = chain.Tween(function(group)
    group:to(self, 0.5, { alpha = 0, height = 0 })
  end)
  c:push(chain.Instant(function()
    self.visible = false
    self.requirements = {}
  end))
  return c
end

function Requirements:update(dt)

end

function Requirements:draw()
  if self.visible then
    love.graphics.push('all')
    love.graphics.setColor(255, 255, 255, self.alpha)
    local y = self.y - 6 + self.height
    love.graphics.draw(self.image, self.quad, self.x - 32, y)

    local count = 0
    for k, v in pairs(self.requirements) do
      count = count + 1
    end
    local i = 0
    for k, v in pairs(self.requirements) do
      local x = self.x - 20 - (count - 1) * 14
      love.graphics.draw(self.image, self.spirits[k], x + 28 * i, y - 18)
      love.graphics.print("x"..v, x + 28 * i + 16, y - 2)
      i = i + 1
    end

    love.graphics.pop()
  end
end

return Requirements
