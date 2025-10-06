local class = require('lib.hump.class')
--local anim8 = require('lib.anim8')
--local flux = require('lib.flux')
--local signal = require('lib.hump.signal')

local Pointer = class {}

function Pointer:init()
	--self.tweens = flux.group()
	--self.signals = signal.new() -- cellHighlighted(x, y), cellSelected(x, y)
	self.bounds = nil
	self.x = 0
	self.y = 0
	self.gridX = 0
	self.gridY = 0
	self.following = nil
end

function Pointer:update(dt)
	if self.following then
		self.x, self.y = math.floor(self.following.x + self.followOffset.x + 0.5),
			math.floor(self.following.y + self.followOffset.y + 0.5)
	end
	if self.bounds then
		self.x = math.max(self.bounds.x + 160-16, math.min(self.x, self.bounds.x + self.bounds.width - 160-16))
		self.y = math.max(self.bounds.y + 120 - 16, math.min(self.y, self.bounds.y + self.bounds.height - 120 - 16))
	end
	--self.tweens:update(dt)
	--self.sprite.animation:update(dt)
  --self.cellSelection.animation:update(dt)
	--self.optionsMenu:update(dt)
	--self.optionsMenu.x, self.optionsMenu.y = math.floor(self.x + 0.5) - 77 - 4, math.floor(self.y + 0.5) - 8
end

function Pointer:move(shift)
  self.x, self.y = self.x + shift.x, self.y + shift.y
end

function Pointer:startPathTracking()
	self.pathTracker:restart()
	self.pathTracker:setGridPosition(self.gridX, self.gridY)
end

function Pointer:clearPathTracking()
	self.pathTracker:clear()
end

function Pointer:addBounds(x, y, width, height)
	self.bounds = { x = x, y = y, width = width, height = height }
end

function Pointer:removeBounds()
	self.bounds = nil
end

function Pointer:follow(object, offset)
	self.following = object
	self.followOffset = offset or { x = 0, y = 0 }
end

function Pointer:setOptionsVisible(visible, startFrom)
	--self.optionsVisible = visible
	--self.selected = startFrom or self.selected
end

function Pointer:draw()
	--self.sprite.animation:draw(self.sprite.image, self.x + 8, self.y - 16)
	--if self.optionsVisible then self.optionsMenu:draw() end
end

function Pointer:input(event)
	--if self.optionsVisible then self.optionsMenu:input(event) end
end

function Pointer:drawCellSelection()
	--self.cellSelection.animation:draw(self.cellSelection.image, self.x - 16, self.y - 16)
  --self.cellSelection.animation:draw(self.cellSelection.image, self.gridX * 32 - 32 - 16, self.gridY * 32 - 32 - 16)
  --self.pathTracker:draw()
end

function Pointer:gridToPosition(gridX, gridY)
	return gridX * 32 - 32, gridY * 32 - 32
end

function Pointer:setGridPosition(gridX, gridY)
  self.gridX, self.gridY = gridX, gridY
  self.x, self.y = self:gridToPosition(gridX, gridY)
  --self.pathTracker:setGridPosition(gridX, gridY)
  --self.signals:emit("cellHighlighted", gridX, gridY)
end

function Pointer:moveToCell(gridX, gridY)
  --if gridX > self.gridX then self.pathTracker:move("right") end
  --if gridX < self.gridX then self.pathTracker:move("left") end
  --if gridY > self.gridY then self.pathTracker:move("down") end
  --if gridY < self.gridY then self.pathTracker:move("up") end

	--self.gridX, self.gridY = gridX, gridY
	--local newX, newY = self:gridToPosition(gridX, gridY)
	--local tween = self.tweens:to(self, 0.2, { x = newX, y = newY })
	--self.tweens:update(0)
	--self.signals:emit("cellHighlighted", gridX, gridY)
	--return tween
end

return Pointer
