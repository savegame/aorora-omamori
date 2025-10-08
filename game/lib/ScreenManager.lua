local class = require('lib.hump.class')
local chain = require('lib.chain')

local FadeBlack = require('entities.FadeBlack')
local TouchId = {}

local ScreenManager = class {}

local MusicVolume = class {
    __includes = chain.Chain,
    init = function(self, music, volume, duration)
        chain.Chain.init(self)
        self.music = music
        self.volume = volume
        self.duration = duration
    end,

    onStart = function(self)
        self.time = 0.0
        self.initial = self.music:getVolume()
        -- print("initial volume "..self.initial)
        self.shift = self.volume - self.initial
        -- print("shift volume "..self.shift)
    end,

    onUpdate = function(self, dt)
        self.time = self.time + dt
        -- print("time: "..self.time)
        local newVolume = math.max(0.0, math.min(1.0, self.initial + self.shift * (self.time / self.duration)))
        -- print("volume "..newVolume)

        self.music:setVolume(newVolume)
        -- self.music:play()

        if self.time >= self.duration then
            -- self.music:play()
            -- self.music:setVolume(1.0)
            -- print("is playing: "..(self.music:isPlaying() and "yes" or "no"))
            self:complete()
        end
    end,

    onInput = function(self, event)
    end
}

function ScreenManager:init(canvas)
    self.routes = {}
    self.currentScreen = nil
    self.currentPath = ''
    self.canvas = canvas
    self.fadeblack = FadeBlack(fonts.medium)
    self.fadeblack.x, self.fadeblack.y = canvasSize.x * 0.5, canvasSize.y * 0.5
    self.music = nil
    self.musicSet = chain.Cogset()
    self.cogset = chain.Cogset()
    self.queue = chain.Queue()

    self:registerEvents()

    touchButtons.button_A.onPress = function ()
        if self.activeScreen and self.activeScreen["keypressed"] then
            self.activeScreen["keypressed"](self.activeScreen, keys.A)
        end
    end

    touchButtons.button_A.onRelease = function ()
        if self.activeScreen and self.activeScreen["keyreleased"] then
            self.activeScreen["keyreleased"](self.activeScreen, keys.A)
        end
    end
end

function ScreenManager:event(event, arguments)
    if arguments == nil then
        arguments = {}
    elseif type(arguments) ~= 'table' then
        arguments = {arguments}
    end

    if self.activeScreen and self.activeScreen[event] then
        self.activeScreen[event](self.activeScreen, unpack(arguments))
    end
end

function ScreenManager:register(path, screenClass)
    local newRoute = {
        path = path,
        instance = screenClass(self)
    }

    if path == '/' then -- if screen is the root path then register it by default
        newRoute.instance:activate()
        self.activeScreen = newRoute.instance
        self.currentPath = '/'
    end

    return table.insert(self.routes, newRoute)
end

function ScreenManager:view(path, ...)
    for _, route in pairs(self.routes) do
        if path == route.path then
            route.instance:activate(...)
            self.activeScreen = route.instance
            self.currentPath = path
        end
    end
end

function ScreenManager:reset()
    for _, route in pairs(self.routes) do
        route.instance:reset()
    end
end

function ScreenManager:doChangeMusic(music, changeDuration)
    self.musicSet:clear()
    self.musicSet:push(self:changeMusic(music, changeDuration))
end

function ScreenManager:doFadeOutMusic(duration)
    self.musicSet:clear()
    self.musicSet:push(self:fadeOutMusic(duration))
end

function ScreenManager:changeMusic(newMusic, changeDuration)
    local dur = changeDuration or 1.0
    local c = chain.Instant(function()
        self.oldMusic = self.music
        self.music = newMusic
        newMusic:setVolume(0.0)
        newMusic:play()
    end)
    c:push(chain.Rings():pushParallel(MusicVolume(newMusic, 1.0, dur)):pushParallel(chain.Dynamic(function()
        if self.oldMusic then
            return MusicVolume(self.oldMusic, 0.0, dur)
        else
            return chain.Instant(function()
            end)
        end
    end)))
    c:push(chain.Dynamic(function()
        return chain.Instant(function()
            if self.oldMusic then
                self.oldMusic:stop()
                self.oldMusic = nil
            end
        end)
    end))

    return c
end

function ScreenManager:fadeOutMusic(duration)
    local dur = duration or 1.0
    local c = chain.Dynamic(function()
        self.oldMusic = self.music
        self.music = nil
        if self.oldMusic then
            return MusicVolume(self.oldMusic, 0.0, dur)
        else
            return chain.Instant(function()
            end)
        end
    end)
    c:push(chain.Instant(function()
        if self.oldMusic then
            self.oldMusic:stop()
            self.oldMusic = nil
        end
    end))
    return c
end

function ScreenManager:transition(path, ...)
    local c = self.fadeblack:show()
    c:push(chain.Instant(function()
        self:view(path)
    end))
    c:push(self.fadeblack:hide())

    self.cogset:push(c)
end

-- Register Löve2D events
function ScreenManager:registerEvents()
    local _self = self

    -- Only the ones that could be used on a gameshell are not commented out!
    -- The events that are commented out with four '-', cause trouble when not being used

    -- function love.directorydropped(...) _self:event('directorydropped', ...) end
    function love.draw(...)
        love.graphics.setCanvas(self.canvas)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.clear()
        _self:event('draw', ...)
        _self.fadeblack:draw()
        love.graphics.setCanvas()
        love.graphics.draw(self.canvas, 0, 0, 0, love.graphics.getWidth() / self.canvas:getWidth(),
            love.graphics.getHeight() / self.canvas:getHeight())
        joystick:draw()
        buttons:draw()
    end
    ----function love.errhand(...) _self:event('errhand', ...) end
    ----function love.errorhandler(...) _self:event('errorhandler', ...) end
    -- function love.filedropped(...) _self:event('filedropped', ...) end
    function love.focus(...)
        _self:event('focus', ...)
    end
    function love.keypressed(...)
        if select(1, ...) == 'escape' then
            love.event.quit()
        end
        _self:event('keypressed', ...)
    end
    function love.keyreleased(...)
        _self:event('keyreleased', ...)
    end
    function love.lowmemory(...)
        _self:event('lowmemory', ...)
    end
    -- function love.mousefocus(...) _self:event('mousefocus', ...) end
    function love.mousepressed(x, y, button, istouch, pressed)
        if buttons:touchpressed("mouse_" .. button, x, y) then
            return
        elseif x <= love.graphics.getWidth() * 0.5 and joystick:startJoystick("mouse_" .. button, x, y) then
            return
        end
        _self:event('mousepressed', {x, y, button, istouch, pressed})
    end
    function love.mousemoved(x, y, dx, dy, istouch)
        if joystick:moveJoystick(joystick.id, x, y) then
            return
        end
        _self:event('mousemoved', {button, x, y}) 
    end
    function love.mousereleased(x, y, button, istouch, pressed)
        if joystick:stopJoystick("mouse_" .. button) then
            return
        elseif buttons:touchreleased("mouse_" .. button, x, y) then
            return
        end
        _self:event('mousereleased', {x, y, button, istouch, pressed})
    end
    function love.quit(...)
        _self:event('quit', ...)
    end
    function love.resize(...)
        _self:event('resize', ...)
    end
    ----function love.run(...) _self:event('run', ...) end
    function love.textedited(...)
        _self:event('textedited', ...)
    end
    function love.textinput(...)
        _self:event('textinput', ...)
    end
    function love.threaderror(...)
        _self:event('threaderror', ...)
    end
    function love.touchmoved(id, x, y, dx, dy, pressure)
        if joystick:moveJoystick(id, x, y) then
            return
        end
        _self:event('touchmoved', {id, x, y, dx, dy, pressure})
    end
    function love.touchpressed(id, x, y, dx, dy, pressure)
        if buttons:touchpressed(id, x, y, dx, dy, pressure) then
            return
        elseif x <= love.graphics.getWidth() * 0.5 and joystick:startJoystick(id, x, y) then
            return
        end
        _self:event('touchpressed', {id, x, y, dx, dy, pressure})
    end
    function love.touchreleased(id, x, y, dx, dy, pressure)
        if joystick:stopJoystick(id) then
            return
        elseif buttons:touchreleased(id, x, y, dx, dy, pressure) then
            return
        end
        _self:event('touchreleased', {id, x, y, dx, dy, pressure})
    end
    function love.update(...)
        _self.musicSet:update(...)
        _self.cogset:update(...)
        _self.queue:update(...)
        _self:event('update', ...)
    end
    function love.visible(...)
        _self:event('visible', ...)
    end
    -- function love.wheelmoved(...) _self:event('wheelmoved', ...) end
end

return ScreenManager
