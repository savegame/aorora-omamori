local class = require('lib.hump.class')
local chain = require('lib.chain')
local patchy = require('lib.patchy')


local OmamoriDisplayer = class {
  image = love.graphics.newImage("assets/images/omamori.png"),
  types = {
    love.graphics.newQuad(0, 0, 144, 128, 512, 256),
    love.graphics.newQuad(144, 0, 144, 128, 512, 256),
    love.graphics.newQuad(288, 0, 144, 128, 512, 256),
    love.graphics.newQuad(0, 128, 144, 128, 512, 256)
  }
}

function OmamoriDisplayer:init()
  self.x = 0
  self.y = 0
  self.alpha = 0
  self.scale = 0

  self.visible = false
  self.type = 0
end

function OmamoriDisplayer:show(type)
  local c = chain.Instant(function()
    self.visible = true
    self.type = type
    self.scale = 0.4
  end)
  c:push(chain.Tween(function(group)
    group:to(self, 0.5, {alpha = 255})
    group:to(self, 0.7, {scale = 1.0}):ease("elasticout")
  end))
  c:push(chain.Wait(2.0))
  c:push(chain.Tween(function(group)
    group:to(self, 0.4, { alpha = 0 }):delay(0.2)
    group:to(self, 0.6, { scale = 0.4 }):ease("quadin")
  end))
  c:push(chain.Instant(function()
    self.visible = false
  end))
  return c
end

function OmamoriDisplayer:update(dt)

end

function OmamoriDisplayer:draw()
  if self.visible then
    love.graphics.push('all')
    love.graphics.setColor(255, 255, 255, self.alpha)
    love.graphics.draw(self.image, self.types[self.type], self.x + 160, self.y + 120, 0,
      self.scale, self.scale, 72, 64)
    love.graphics.pop()
  end
end

return OmamoriDisplayer
