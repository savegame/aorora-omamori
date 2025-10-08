local class = require('lib.hump.class')
local chain = require('lib.chain')


local TextBox = class {}

local Dialog = class { __includes = chain.Chain,
	init = function(self, textbox, text, charactersPerSecond)
		chain.Chain.init(self)
		self.textbox = textbox
		self.text = text
    self.charsPerSecond = charactersPerSecond or 20
		self.currentCharacters = 0
	end,

	onStart = function(self) end,

	onUpdate = function(self, dt)
		self.currentCharacters = self.currentCharacters + dt * self.charsPerSecond
    self.textbox.text = string.sub(self.text, 0, math.floor(self.currentCharacters))
    local isDownA = love.keyboard.isDown(keys.A) or touchButtons.button_A.pressed
    if isDownA and self.currentCharacters >= string.len(self.text) then
      self:complete()
    end
	end,

  onInput = function(self, event)
    if event.type == "pressed" and event.key == keys.A then
      self.charsPerSecond = 50.0
    end
  end

}

function TextBox:init(font)
  self.x = 0
  self.y = 0
  self.font = font
  self.image = love.graphics.newImage("assets/images/textbox.png")
  self.quad = love.graphics.newQuad(0, 0, 192, 66, 256, 64)
	self.left = 12
	self.right = 12
	self.top = 12
	self.bottom = 12
  self.alpha = 0
  self.height = 0

  self.visible = false
  self.text = ""
end

function TextBox:show()
  local c = chain.Instant(function()
    self.visible = true
    self.height = 0
  end)
  c:push(chain.Tween(function(group)
    group:to(self, 0.5, { alpha = 255, height = -16 })
  end))
  return c
end

function TextBox:dialog(text)
  local c = Dialog(self, text, 15)
  return c
end

function TextBox:hide()
  local c = chain.Tween(function(group)
    group:to(self, 0.5, { alpha = 0, height = 0 })
  end)
  c:push(chain.Instant(function()
    self.visible = false
    self.text = ""
  end))
  return c
end

function TextBox:update(dt)

end

function TextBox:draw()
  if self.visible then
    love.graphics.push('all')
    love.graphics.setColor(255, 255, 255, self.alpha)
    love.graphics.draw(self.image, self.quad, self.x - 96, self.y - 48 + self.height)
    local width = self.font:getWidth(self.text)
    local height = select(2, string.gsub(self.text, "\n", "")) * self.font:getHeight(self.text)
    local x = math.floor(self.x - (self.left + self.right + width) / 2 + 0.5)
    local w = math.floor(self.left + self.right + width + 0.5)

    --self.patch:draw(x, self.y -1, w, 32)
  	love.graphics.printf(self.text, x + self.left, self.y - 30 + self.height - height / 2.0,
      width, "center")
    love.graphics.pop()
  end
end

return TextBox
