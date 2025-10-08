local joystick = {
    active = false,
    id = nil,         -- touch id / mouse id
    baseX = 0,
    baseY = 0,        -- позиция основания
    stickX = 0,
    stickY = 0,       -- позиция стикa (мир/экран)
    radius = 70,      -- радиус основания
    deadzone = 8,     -- мёртвая зона
    maxDistance = 48, -- максимальная длина стика от центра
    dx = 0,
    dy = 0,       -- позиция стикa (относительная)
    power = 0,

    setRadius = function(self, value)
        self.radius = value
        self.deadzone = self.radius * 0.15
        self.maxDistance = self.radius * 0.8
    end,

    startJoystick = function(self, id, x, y)
        if self.id ~= nil then
            return false
        end
        self.active = true
        self.id = id
        self.baseX = x
        self.baseY = y
        self.stickX = x
        self.stickY = y
        return true
    end,

    moveJoystick = function(self, id, x, y)
        if self.id ~= id then
            return false
        end
        local dx = x - self.baseX
        local dy = y - self.baseY
        local dist = math.sqrt(dx * dx + dy * dy)
        if dist <= self.deadzone then
            self.stickX = self.baseX
            self.stickY = self.baseY
            dx = 0
            dy = 0
            dist = 0
        else
            local maxd = self.maxDistance
            if dist > maxd then
                dx = dx / dist * maxd
                dy = dy / dist * maxd
                dist = 1.0
            else
                dist = dist / maxd
            end
            self.stickX = self.baseX + dx
            self.stickY = self.baseY + dy
        end
        self.dx = dx
        self.dy = dy
        self.power = dist

        return true
    end,

    stopJoystick = function(self, id)
        if self.id ~= id then
            return false
        end
        self.active = false
        self.id = nil
        self.stickX = self.baseX
        self.stickY = self.baseY
        self.dx = 0
        self.dy = 0
        self.power = 0
        return true
    end,

    draw = function (self)
        if not self.active then
            return
        end
        -- base
        love.graphics.setColorF(0,0,0,0.45)
        love.graphics.circle("fill", self.baseX, self.baseY, self.radius)
        love.graphics.setColorF(1,1,1,0.06)
        love.graphics.circle("fill", self.baseX, self.baseY, self.maxDistance)
        -- outline base
        love.graphics.setColorF(0,0,0,0.6)
        love.graphics.setLineWidth(2)
        love.graphics.circle("line", self.baseX, self.baseY, self.radius)
        -- stick
        love.graphics.setColorF(1,1,1,0.9)
        love.graphics.circle("fill", self.stickX, self.stickY, self.radius*0.45)
        -- outline stick
        love.graphics.setColorF(0,0,0,0.6)
        love.graphics.setLineWidth(2)
        love.graphics.circle("line", self.stickX, self.stickY, self.radius*0.45)
    end
}

return joystick