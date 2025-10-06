local class = require('lib.hump.class')

local FieldScreen = require('screens.FieldScreen')

local Wander = class {}

function Wander:init()
	self.bipSound = love.audio.newSource("assets/sounds/bip.wav", "static")
end


function Wander:onStart()
	pointer:clearPathTracking()
	field:clearHighlights()
end


function Wander:onInput(event)
	if event.type ~= "pressed" then return end
	if event.key == keys.A then
		self.bipSound:play()
		if field:containsObject(player, pointer.gridX, pointer.gridY) then
			--self.queue:push(drag) -- TODO
      return self:complete()
		end
	end

	local gX, gY = pointer.gridX, pointer.gridY
	if event.key == keys.DPad_right then gX = gX + 1
	elseif event.key == keys.DPad_left then gX = gX - 1
	elseif event.key == keys.DPad_up then	gY = gY - 1
	elseif event.key == keys.DPad_down then	gY = gY + 1 end
	if (pointer.gridX ~= gX or pointer.gridY ~= gY) and field.typesGrid[gX][gY] > tiles.bounds then
		pointer:moveToCell(gX, gY)
		self.bipSound:play()
	end
end
