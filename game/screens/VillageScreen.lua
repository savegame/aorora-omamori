local class = require('lib.hump.class')
local keys = require('lib.keys')
local inspect = require('lib.inspect')
local chain = require('lib.chain')
local bump = require('lib.bump')

local Field = require('entities.Field')
local SpiritHunter = require('entities.SpiritHunter')
local Villager = require('entities.Villager')
local StateMachine = require('lib.StateMachine')
local Pointer = require('entities.Pointer')

local world
local player
local field
local pointer
local queue = chain.Queue()
local cogset = chain.Cogset()


--[[  villager = Villager('assets/images/female_adults.png', 1, 3,
"",

--Ragazza con una passione/hobby che la fa "viaggiare" ed emozionarsi.
--Ma non riesce a raggiungere le persone/fallisce.
, {})
  self:addVillager(villager)


  villager = Villager('assets/images/female_adults.png', 1, 6,
"",

--Bambino che si rende conto che i suoi genitori stanno facendo di tutto
--per riuscire a istruirlo nel modo migliore, non vuole deluderli ma é spaventato.
, {})
  self:addVillager(villager)]]

local VillageScreen = class {}

function VillageScreen:init(ScreenManager)
	self.screen = ScreenManager

  self.day = 0

  self.statements = {
    "Деревня: Первый день",
    "Деревня: Второй день",
    "Деревня: Третий день",
    "Деревня: Последний день"
  }
end

function VillageScreen:reset()
  self.day = 0
end

function VillageScreen:addVillager(villager)
  local spawnPoint = field.villagerSpawnPoints[""..villager.spawnPoint]
  --print(inspect(spawnPoint))
  field:addObject(villager, (spawnPoint.x + 16) / 32, (spawnPoint.y + 16) / 32)
end

function VillageScreen:activate()
  self.day = self.day + 1

  local playerStart = { x = 7, y = 7 }

	field = Field("assets/maps/village.lua", 64,
		function()
			pointer:drawCellSelection()
		end
	)

	player = SpiritHunter()
	field:addObject(player, playerStart.x, playerStart.y + 3)

  pointer = Pointer()
  pointer:addBounds(0, 0, field.map.width * 32, field.map.height * 32)
  pointer:follow(player, { x = -16, y = -28 })

  for i, v in ipairs(data.villagers) do
    if not v.helped then
      self:addVillager(v)
    end
  end

  local portal = {
    type = "interactable",
    text = function()
      return self.day < 4 and "Идти в лес" or "Уйти"
    end,
    x = field.portal.x, y = field.portal.y,
    width = field.portal.width,
    height = field.portal.height,
    interact = function()
      local c = chain.Instant(function()
        if self.day < 4 then
          globals.player.controllable = false
          sounds.start:play()
          gameState:doFadeOutMusic()
          gameState:transition("field")
        else
          globals.player.controllable = false
          sounds.start:play()
          gameState:doFadeOutMusic()

          local finale = globals.fadeblack:show()
          finale:push(chain.Wait(1.0))
          finale:push(globals.fadeblack:dialog(
[[Пришло время покинуть деревню.]]))
          finale:push(globals.fadeblack:hideDialog())
          finale:push(globals.fadeblack:dialog(
[[Тебе удалось помочь людям?

Маленький жест — вот и всё, что нужно.]]))
          finale:push(globals.fadeblack:hideDialog())
          finale:push(chain.Wait(1.5))

          local helped = 0
          for i, v in ipairs(data.villagers) do
            if v.helped then
              helped = helped + 1
            end
          end
          if helped > 0 then
            finale:push(globals.fadeblack:dialog(
[[По мере того как время шло...]]))
            finale:push(globals.fadeblack:hideDialog())
            finale:push(chain.Wait(1.5))
        end

          for i, v in ipairs(data.villagers) do
            if v.helped then
              finale:push(globals.fadeblack:dialog(v.outcome))
              finale:push(globals.fadeblack:hideDialog())
              finale:push(chain.Wait(1.5))
            end
          end
          finale:push(chain.Wait(1.0))

          finale:push(globals.fadeblack:dialog(
[[Пусть люди, которым ты помогаешь, станут твоим Омамори.]]))
          finale:push(globals.fadeblack:hideDialog())

          finale:push(chain.Wait(2.5))

          finale:push(globals.fadeblack:dialog(
[["Теперь, Жизнь Живёт Тобой."]]))
          finale:push(globals.fadeblack:hideDialog())

          finale:push(chain.Wait(2.5))

          finale:push(chain.Instant(function()
            reset()
            gameState:transition("/")
          end))

          cogset:push(finale)
        end
      end)
      queue:push(c)
    end,
    hover = function(inside) end
  }
  field.world:add(portal, portal.x, portal.y, portal.width, portal.height)



  globals.camera = pointer
  globals.player = player
  globals.queue = queue

  gameState:doChangeMusic(music.village, 0.1)
  cogset:push(chain.Wait(2.0)
    :push(chain.Instant(function() sounds.village:play() end))
    :push(chain.Rings()
      :pushParallel(globals.inventory:show())
      :pushParallel(globals.statement:show(self.statements[self.day]))
    )
  )
end

function VillageScreen:update(dt)
	queue:update(dt)
  cogset:update(dt)
	field:update(dt)
	pointer:update(dt)
	globals.inspector:update(dt)
  globals.textbox:update(dt)
end

function VillageScreen:draw()
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
  globals.omamori:draw()
  globals.statement:draw()
  --globals.fadeblack:draw()
end

function VillageScreen:input(event)
  player:input(event)
  queue:input(event)
  cogset:input(event)
end

function VillageScreen:keypressed(key)
	self:input({ type = "pressed", key = key})
end

function VillageScreen:keyreleased(key)
	self:input({ type = "released", key = key})
end

function VillageScreen:touchpressed(id, x, y, dx, dy, pressure)
	self:input({ type = "pressed", key = "touch"})
end

function VillageScreen:touchreleased(id, x, y, dx, dy, pressure)
	self:input({ type = "released", key = "touch"})
end

return VillageScreen
