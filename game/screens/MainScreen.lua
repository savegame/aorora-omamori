local class = require('lib.hump.class')
local keys = require('lib.keys')

local MainScreen = class {}

function MainScreen:init(ScreenManager)
	self.screen = ScreenManager
end

function MainScreen:activate()
end

function MainScreen:draw()
	love.graphics.print("Main", 10, 10)
end

function MainScreen:keypressed(key)
	if key == keys.A then
		self.screen:view('test/index', 'Hello World!')
	end
end

function MainScreen:touchpressed(id, x, y, dx, dy, pressure)
	self:input({ type = "pressed", key = "touch"})
end

function MainScreen:touchreleased(id, x, y, dx, dy, pressure)
	self:input({ type = "released", key = "touch"})
end

return MainScreen
