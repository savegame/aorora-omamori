local class = require('lib.hump.class')
local chain = require('lib.chain')
local patchy = require('lib.patchy')


local StatementLabel = class {}

function StatementLabel:init(font)
  self.x = 0
  self.y = 0
  self.font = font
  self.patch = patchy.load('assets/images/statement_label.png')
  self.bgX = canvasSize.x + 16
  self.alpha = 0
  self.textAlpha = 0

  self.visible = false
  self.text = ""
end

function StatementLabel:show(text)
  local c = chain.Instant(function()
    self.visible = true
    self.text = text
    self.bgX = canvasSize.x + 16
  end)
  c:push(chain.Tween(function(group)
    group:to(self, 0.5, { textAlpha = 255, alpha = 255, bgX = 0 - 16 })
  end))
  c:push(chain.Wait(3.0))
  c:push(chain.Tween(function(group)
    group:to(self, 0.5, { textAlpha = 0, alpha = 0, bgX = -(canvasSize.x + 16) })
  end))
  c:push(chain.Instant(function()
    self.visible = false
  end))
  return c
end

function StatementLabel:update(dt)

end

function StatementLabel:draw()
  if self.visible then
    love.graphics.push('all')
    love.graphics.setColor(255, 255, 255, self.alpha * 0.8)
    self.patch:draw(self.x + self.bgX, self.y + 120 - 16, canvasSize.x + 32, 32)
    local height = select(2, string.gsub(self.text, "\n", "")) * self.font:getHeight(self.text)
    love.graphics.setColor(255, 255, 255, self.textAlpha)
  	love.graphics.printf(self.text, self.x, self.y + 120 - height / 2.0 - 6,
      canvasSize.x, "center")
    love.graphics.pop()
  end
end

return StatementLabel
