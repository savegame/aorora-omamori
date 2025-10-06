local class = require('lib.hump.class')
local keys = require('lib.keys')
local chain = require('lib.chain')

local queue = chain.Queue()
local cogset = chain.Cogset()


local TitleScreen = class {}

function TitleScreen:init(ScreenManager)
	self.screen = ScreenManager
end

function TitleScreen:reset()
  self.night = 0
end

function TitleScreen:activate()
  gameState:doChangeMusic(music.menu, 0.1)
  self.started = false
  --music.menu:play()
end

function TitleScreen:update(dt)
	queue:update(dt)
  cogset:update(dt)
end

function TitleScreen:draw()
	love.graphics.push("all")
	love.graphics.setColor(35, 33, 61, 255)
	love.graphics.rectangle("fill", 0, 0, canvasSize.x, canvasSize.y)
	love.graphics.setColor(255, 255, 255, 255)

  love.graphics.draw(assets.title)

  love.graphics.printf("Press Anything", 160 - 80, 160, 160, "center")

	love.graphics.pop()
  --globals.fadeblack:draw()
end

function TitleScreen:input(event)
  queue:input(event)
  cogset:input(event)

  if event.type == "pressed" and not self.started then
    self.started = true
    sounds.start:play()
    gameState:doFadeOutMusic()
		local c = globals.fadeblack:show()
		c:push(chain.Wait(1.0))
		c:push(globals.fadeblack:dialog("4 days, 3 nights.\n\nA village and its people."))
		c:push(globals.fadeblack:hideDialog())
		c:push(chain.Wait(1.5))
		c:push(chain.Instant(function()
			gameState:transition("village")
		end))
		queue:push(c)
  end
end

function TitleScreen:keypressed(key)
	self:input({ type = "pressed", key = key})
end

function TitleScreen:keyreleased(key)
	self:input({ type = "released", key = key})
end

return TitleScreen
