local class = require('lib.hump.class')
local patchy = require('lib.patchy')
local anim8 = require('lib.anim8')


local UIInspector = class {}

function UIInspector:init(font)
  self.x = 0
  self.y = 0
  self.font = font
  self.patch = patchy.load("assets/images/prompt_inspector.png")
	self.left = 12
	self.right = 7
	self.top = 11
	self.bottom = 12

  self.mLeft = 2
  self.mRight = 2

  self.minWidth = 32

  self.visible = true
  self.text = ""

  local image = love.graphics.newImage('assets/images/buttons_21.png')
  local g = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
	local animA = anim8.newAnimation(g('1-2', 1), 0.4)
  local animB = anim8.newAnimation(g('1-2', 2), 0.4)
  local animX = anim8.newAnimation(g('1-2', 3), 0.4)
  local animY = anim8.newAnimation(g('1-2', 4), 0.4)

  self.buttonAnims = {
    a = animA,
    b = animB,
    x = animX,
    y = animY
  }

  self.button = { image = image, animation = animA }
end

function UIInspector:show(button, text)
  self.visible = true
  self.button.animation = self.buttonAnims[button]
  self.text = text
end

function UIInspector:hide()
  self.visible = false
  self.text = ""
end

function UIInspector:update(dt)
  self.button.animation:update(dt)
end

function UIInspector:draw()
  if self.visible then
    local width = math.max(math.floor(self.font:getWidth(self.text) + 0.5), self.minWidth)
    local x = math.floor(self.x - (self.left + self.right + self.mLeft + self.mRight + width) / 2 + 0.5)
    local w = math.floor(self.left + self.right + self.mLeft + self.mRight + width + 0.5)

    self.patch:draw(x, self.y -1, w, 32)
  	love.graphics.printf(self.text, x + self.left + self.mLeft, self.y + self.top - 2, width , "center")
    self.button.animation:draw(self.button.image, x - 14, self.y - 2)
  end
end

return UIInspector
