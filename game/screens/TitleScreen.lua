local class = require('lib.hump.class')
local keys = require('lib.keys')
local chain = require('lib.chain')

local queue = chain.Queue()
local cogset = chain.Cogset()

local TitleScreen = class {}

local titlePos = {
    x = 0,
    y = 0,
    scale = 1
}

function TitleScreen:init(ScreenManager)
    self.screen = ScreenManager

    titlePos.scale = math.max(canvasSize.x / assets.title:getWidth(), 
                              canvasSize.y / assets.title:getHeight())
    titlePos.x = canvasSize.x - assets.title:getWidth() * titlePos.scale
    titlePos.y = canvasSize.y - assets.title:getHeight() * titlePos.scale
end

function TitleScreen:reset()
    self.night = 0
end

function TitleScreen:activate()
    gameState:doChangeMusic(music.menu, 0.1)
    self.started = false
    -- music.menu:play()
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

    love.graphics.draw(assets.title, titlePos.x, titlePos.y, 0, titlePos.scale, titlePos.scale)

    love.graphics.printf("Нажмите А что бы продолжить", canvasSize.x * 0.5 - 80, canvasSize.y * 0.8, 160, "center")

    love.graphics.pop()
    -- globals.fadeblack:draw()
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
        c:push(globals.fadeblack:dialog("4 дня, 3 ночи.\n\nДеревня и ее жители."))
        -- c:push(globals.fadeblack:dialog("4 days, 3 nights.\n\nA village and its people."))
        c:push(globals.fadeblack:hideDialog())
        c:push(chain.Wait(1.5))
        c:push(chain.Instant(function()
            gameState:transition("village")
        end))
        queue:push(c)
    end
end

function TitleScreen:keypressed(key)
    self:input({
        type = "pressed",
        key = key
    })
end

function TitleScreen:keyreleased(key)
    self:input({
        type = "released",
        key = key
    })
end

function TitleScreen:touchpressed(id, x, y, dx, dy, pressure)
    self:input({
        type = "pressed",
        key = "key_touch"
    })
end

function TitleScreen:touchreleased(id, x, y, dx, dy, pressure)
    self:input({
        type = "released",
        key = "key_touch"
    })
end

return TitleScreen
