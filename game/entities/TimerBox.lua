local class = require('lib.hump.class')
local patchy = require('lib.patchy')
local anim8 = require('lib.anim8')


local TimerBox = class {
  patch = patchy.load("assets/images/timer_box.png")
}

function TimerBox:init(font)
  self.x = 0
  self.y = 0
  self.font = font
	self.left = 12
	self.right = 7
	self.top = 11
	self.bottom = 12

  self.mLeft = 2
  self.mRight = 2

  self.minWidth = 32

  self.visible = true
  self.time = 0
end

function TimerBox:show()
  self.visible = true
end

function TimerBox:hide()
  self.visible = false
end

function TimerBox:update(dt)
  self.time = math.max(0, self.time + dt)
end

function TimerBox:draw()
  if self.visible then
    self.patch:draw(self.x, self.y, 70, 30)
  	love.graphics.printf(math.ceil(self.time), self.x + 25, self.y + 9, 26, "right")
  end
end

return TimerBox
