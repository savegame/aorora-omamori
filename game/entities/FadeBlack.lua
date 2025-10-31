local class = require('lib.hump.class')
local chain = require('lib.chain')
local utf8 = require("utf8")


local FadeBlack = class {}

local Dialog = class { __includes = chain.Chain,
	init = function(self, textbox, text, charactersPerSecond)
		chain.Chain.init(self)
		self.textbox = textbox
		self.text = text
    self.charsPerSecond = charactersPerSecond or 20.0
		self.currentCharacters = 0.0
	end,

	onStart = function(self)
    self.textbox.textAlpha = 255
  end,

	onUpdate = function(self, dt)
    -- print("update ", self.text)
		self.currentCharacters = self.currentCharacters + dt * self.charsPerSecond
    local charNumber = math.floor(self.currentCharacters)
    local bytesOffset = utf8.offset(self.text, charNumber)
    if charNumber == 0 then
      bytesOffset = 0
    elseif bytesOffset then
      bytesOffset = charNumber == 0 and 0 or (bytesOffset - 1)
    else 
      bytesOffset = string.len(self.text)
    end
    -- print(("Char pos %1i and bytes offset %1i"):format(charNumber, bytesOffset))
    self.textbox.text = string.sub(self.text, 0, bytesOffset)
    -- print("textbox text: ", self.textbox.text)
    local isDownA = love.keyboard.isDown(keys.A) or touchButtons.button_A.pressed
    if isDownA and self.currentCharacters >= utf8.len(self.text) then
      self:complete()
    end
	end,

  onInput = function(self, event)
    if event.type == "pressed" and event.key == keys.A then
      self.charsPerSecond = 50.0
    end
  end
}

function FadeBlack:init(font)
  self.x = 0
  self.y = 0
  self.font = font
	self.left = 12
	self.right = 12
	self.top = 12
	self.bottom = 12
  self.alpha = 0
  self.textAlpha = 0

  self.visible = false
  self.text = ""
end

function FadeBlack:show()
  local c = chain.Instant(function()
    self.visible = true
    self.textAlpha = 255
  end)
  c:push(chain.Tween(function(group)
    group:to(self, 2.0, { alpha = 255 })
  end))
  return c
end

function FadeBlack:dialog(text)
  local c = Dialog(self, text, 15)
  return c
end

function FadeBlack:hideDialog()
  local c = chain.Tween(function(group)
    group:to(self, 1.0, { textAlpha = 0 })
  end)
  c:push(chain.Instant(function()
    self.text = ""
  end))
  return c
end

function FadeBlack:hide()
  local c = chain.Tween(function(group)
    group:to(self, 1.0, { textAlpha = 0 })
  end)
  c:push(chain.Tween(function(group)
    group:to(self, 2.1, { alpha = 0 })
  end))
  c:push(chain.Instant(function()
    self.visible = false
    self.text = ""
  end))
  return c
end

function FadeBlack:update(dt)

end

function FadeBlack:draw()
  if self.visible then
    love.graphics.push('all')
    love.graphics.setColor(0, 0, 0, self.alpha)
    love.graphics.rectangle("fill", 0, 0, canvasSize.x, canvasSize.y)
    local width = self.font:getWidth(self.text)
    local height = select(2, string.gsub(self.text, "\n", "")) * self.font:getHeight(self.text)
    --local x = math.floor(self.x - (self.left + self.right + width) / 2 + 0.5)
    -- local x = self.x - (self.left + self.right + width) * 0.5
    local x = (canvasSize.x - width) * 0.5
    local w = self.left + self.right + width
    --local w = math.floor(self.left + self.right + width + 0.5)
    love.graphics.setColor(255, 255, 255, self.textAlpha)
  	love.graphics.printf(self.text, x, self.y - height * 0.5,
      width, "center")
    love.graphics.pop()
  end
end

return FadeBlack
