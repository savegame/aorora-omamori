local class = require('lib.hump.class')
local chain = require('lib.chain')


local Inventory = class {}

function Inventory:init(font)
  self.x = 0
  self.y = 0
  self.font = font
  self.image = love.graphics.newImage("assets/images/inventory.png")
  self.alpha = 0
  self.xoffset = -16
  self.visible = false
end

function Inventory:show()
  local c = chain.Instant(function()
    self.visible = true
  end)
  c:push(chain.Tween(function(group)
    group:to(self, 0.5, { alpha = 255, xoffset = 0 })
  end))
  return c
end

function Inventory:hide()
  local c = chain.Tween(function(group)
    group:to(self, 0.5, { alpha = 0, xoffset = -16 })
  end)
  c:push(chain.Instant(function()
    self.visible = false
  end))
  return c
end

function Inventory:update(dt)

end

function Inventory:draw()
  if self.visible then
    love.graphics.push('all')
    love.graphics.setColor(255, 255, 255, self.alpha)
    local x = self.x + self.xoffset
    love.graphics.draw(self.image, x, self.y)

    for k, v in pairs(data.spirits) do
      local i = 0
      if k == "love" then i = 0
      elseif k == "success" then i = 2
      elseif k == "wealth" then i = 1
      elseif k == "study" then i = 3 end
      love.graphics.printf(v, x + 18 + i * 32, self.y + 5, 16, "center")
      --love.graphics.print(v, x + 22 + i * 32, self.y + 5)
      i = i + 1
    end

    love.graphics.pop()
  end
end

return Inventory
