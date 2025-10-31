local class = require('lib.hump.class')
local keys = require('lib.keys')
local inspect = require('lib.inspect')
local chain = require('lib.chain')

local Field = require('entities.Field')
local SpiritHunter = require('entities.SpiritHunter')
local Spirit = require('entities.Spirit')
local Pointer = require('entities.Pointer')
local StateMachine = require('lib.StateMachine')
local TimerBox = require('entities.TimerBox')
local Queue = require('lib.queue')

local world
local player
local spirits
local spiritsCheckOrder
local spiritsOfType
local spiritsCaught
local pointer
local field
local stateMachine
local timer
local queue = chain.Queue()
local cogset = chain.Cogset()

-- fix pathfinding with cost not calculating correctly on every cell

tiles = { bounds = -1, grass = 0, forest = 1, mountain = 2, village = 3, path = 4 }

local states = {

	hunt = class {
		entered = function(self, stateMachine)

		end,

		update = function(self, dt) end,

		input = function(self, event)
			player:input(event)
		end,

		exited = function(self) end
	}
}

function spiritTurn(spirit)
	local c = chain.Dynamic(function()
		local startingPos = field.entities[spirit]
		local targetPos = { x = 8, y = 7 }
		local path = field:getPathRouted(startingPos, targetPos)

		pointer:moveToCell(startingPos.x, startingPos.y)
		local ch = chain.Wait(0.3)
			:push(spirit:followPath(path, field, 3))
		return ch
	end)

	return c
end

local FieldScreen = class {}

function FieldScreen:init(ScreenManager)
	self.screen = ScreenManager

	self.night = 0

	self.statements = {
		"Лес: Первая ночь",
		"Лес: Вторая ночь",
		"Лес: Последняя ночь"
	}

	self.endStatements = {
		"Первая ночь: ",
		"Вторая ночь: ",
		"Последняя ночь: "
	}
end

function FieldScreen:reset()
  self.night = 0
end

function FieldScreen:spawnLoop()
	queue:push(
		chain.Instant(function()
			if spirits < 8 then self:spawnSpirit() end
		end)
		:push(chain.Wait(7))
		:push(chain.Instant(function()
			self:spawnLoop()
		end))
	)
end

function FieldScreen:spawnSpirit()
	local cell = field.spiritSpawnPoints[math.random(1, #field.spiritSpawnPoints)]

	local type = spiritsCheckOrder[1]
	for i, s in ipairs(spiritsCheckOrder) do
		if spiritsOfType[s] < spiritsOfType[type] then type = s end
	end

	local spirit = Spirit(field, type)
	spirit.signals:register("caught", function()
		spirits = spirits - 1
		spiritsOfType[type] = spiritsOfType[type] - 1
		spiritsCaught = spiritsCaught + 1
	end)
	spirit.signals:register("escaped", function()
		spirits = spirits - 1
		spiritsOfType[type] = spiritsOfType[type] - 1
	end)
	field:addObject(spirit, cell.x, cell.y)
	spirits = spirits + 1
	spiritsOfType[type] = spiritsOfType[type] + 1
	spirit:start("spawn")
	--print("spawned "..type.. " spirit")
end

local function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

function FieldScreen:activate()
	self.night = self.night + 1

	timer = TimerBox(fonts.medium)
	timer.x, timer.y = canvasSize.x - 62, -4

	timer.time = 300
	spiritsCheckOrder = { "love", "success", "study", "wealth" }
	spiritsCheckOrder = shuffle(spiritsCheckOrder)
	spiritsOfType = { love = 0, success = 0, study = 0, wealth = 0 }
	spiritsCaught = 0

	local playerStart = { x = 7, y = 6 }
	local pointerStart = playerStart--{ x = 5, y = 4 }
	local spiritStart = { x = 5, y = 5 }

	pointer = Pointer()

	field = Field("assets/maps/field_ashima.lua", 128,
		function()
			pointer:drawCellSelection()
		end
	)

	player = SpiritHunter()
	field:addObject(player, playerStart.x, playerStart.y)
	pointer:follow(player, { x = -16, y = -28 })

	spirits = 0

	pointer:setGridPosition(pointerStart.x, pointerStart.y)

	stateMachine = StateMachine({
		initial = "hunt",
		states = states
	})

	globals.camera = pointer
  globals.player = player
  globals.queue = queue

  queue:push(globals.inventory:show())

	self:spawnLoop()
	gameState:doChangeMusic(music.hunting, 0.1)
	cogset:push(chain.Wait(2)
		:push(chain.Instant(function() sounds.hunt:play() end))
		:push(globals.statement:show(self.statements[self.night]))
	)
end

function FieldScreen:update(dt)
	timer:update(-dt)
	if timer.time == 0 and player.controllable then
		gameState:doFadeOutMusic()
		sounds.hunt:play()
		player.controllable = false

		local statementText = self.endStatements[self.night]
		..spiritsCaught
		if spiritsCaught == 1 then
			statementText = statementText .. " Дух Пойман"
		elseif spiritsCaught < 5 then 
			statementText = statementText .. " Духа Поймано"
		else
			statementText = statementText .. " Духов Поймано"
		end
		local c = globals.statement:show(statementText)
		c:push(chain.Instant(function()
			gameState:transition("village")
		end))

		cogset:push(c)
	end
	queue:update(dt)
	cogset:update(dt)
	field:update(dt)
	pointer:update(dt)
	globals.inspector:update(dt)
  globals.textbox:update(dt)

	--print(love.graphics.getStats().texturememory)
end

function FieldScreen:draw()
	love.graphics.push("all")
	love.graphics.setColor(35, 33, 61, 255)
	love.graphics.rectangle("fill", 0, 0, canvasSize.x, canvasSize.y)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.translate(math.floor(canvasSize.x / 2 - pointer.x - 16 + 0.5), math.floor(canvasSize.y / 2 - pointer.y - 16 + 0.5))

	field:draw()

	love.graphics.pop()

  globals.inventory:draw()
	globals.inspector:draw()
  globals.textbox:draw()
	globals.statement:draw()
	timer:draw()
	--love.graphics.printf(math.floor(timer), 10, 5, 300, "right")
  --globals.fadeblack:draw()
end

function FieldScreen:input(event)
	stateMachine:input(event)
  player:input(event)
  queue:input(event)
	cogset:input(event)
end

function FieldScreen:keypressed(key)
	self:input({ type = "pressed", key = key})
end

function FieldScreen:keyreleased(key)
	self:input({ type = "released", key = key})
end

function FieldScreen:touchpressed(id, x, y, dx, dy, pressure)
	self:input({ type = "pressed", key = "touch"})
end

function FieldScreen:touchreleased(id, x, y, dx, dy, pressure)
	self:input({ type = "released", key = "touch"})
end

return FieldScreen
