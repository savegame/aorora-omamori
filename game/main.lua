--[[
-- LOADING SCREEN
-- Uncomment to activate
-- Can be an image for example

love.graphics.clear(255,255,255)
local w, h = love.window.getMode()

> love.graphics.draw(...)
> love.graphics.print(...)
> ...

love.graphics.present()
]]--


-- this fixes compatibility for LÖVE v11.x colors (0-255 instead of 0-1)
require('lib.compatibility')

love.graphics.setDefaultFilter("nearest", "nearest")

local Inventory = require('entities.Inventory')
local UIInspector = require('entities.UIInspector')
local TextBox = require('entities.TextBox')
local FadeBlack = require('entities.FadeBlack')
local StatementLabel = require('entities.StatementLabel')
local OmamoriDisplayer = require('entities.OmamoriDisplayer')
local Villager = require('entities.Villager')
local ScreenManager = require('lib.ScreenManager')

local TitleScreen = require('screens.TitleScreen')
local VillageScreen = require('screens.VillageScreen')
local FieldScreen = require('screens.FieldScreen')
-- screen canvas: 320x240
local canvas

canvasSize = { x = 320, y = 240 }
fonts = { default = nil, medium = nil }
buttons = require "buttons"
joystick = require "joystick"

touchButtons = {
    button_A = { pressed = false }
}

gameState = nil

globals = {
    camera = nil,
    player = nil,
    queue = nil,
    textbox = nil,
    inventory = nil,
    inspector = nil,
    statement = nil,
    omamori = nil,
    fadeblack = nil
}

assets = {
    title = nil,
    grassPitImage = nil
}

music = {
    menu = nil,
    hunting = nil,
    village = nil
}

sounds = {
    start = nil,
    hunt = nil,
    village = nil
}

data = {
    spirits = {
        love = 0,
        wealth = 0,
        success = 0,
        study = 0
    },
    villagers = {}
}

function reset()
    data = {
        spirits = {
            love = 0,
            wealth = 0,
            success = 0,
            study = 0
        },
        villagers = {}
    }
    gameState:reset()
    createVillagers()
end

local function createButtons()
    local buttonW, buttonH = 86, 86
    local margin = 16
    -- buttons:setDebug(true)
    buttons:setFont(love.graphics.newFont(46))
    touchButtons.button_A = buttons:createButton({
        x = love.graphics.getWidth() - margin * 2 - buttonW,
        y = love.graphics.getHeight() - margin * 2 - buttonH,
        w = buttonW,
        h = buttonH,
        label = "A"
    })
end
-- load game
function love.load()
    local coef = love.graphics.getWidth() / love.graphics.getHeight()
    canvasSize.x = math.floor(canvasSize.y * coef)
    -- print("Screen canvas changed to:", canvasSize)
    createButtons()
    joystick:setRadius(64)

    --love.graphics.setDefaultFilter("nearest", "nearest")
    --fonts.default = love.graphics.newImageFont('assets/fonts/unispirits_hard.png', 'ÉÈÁÀÒÓÙÚÌÍ$úàáèéòóù}§{()[]jl£Q±p¢ygqjíì¾½¼W€&CDEFGHKMNORSTUVXYZ\\@¥©P0#÷*+/2345689AB?bJd7hkLt><1fli!¦|wmxasceuvnozr«=»,:″ˆ"\'′_- .', -1)
    fonts.medium = love.graphics.newImageFont('assets/fonts/arial_black_no_cleartype.png', 'АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюяЁёABCDEFGHIJKLMNOPQRSTUVWXYZAAEEIIOOUUabcdefghijklmnopqrstuvwxyzaaeeiioouu0123456789$?€?()[]{}±&\\/©#*+-=:;?!><\'_",. ', -1)
    -- fonts.medium = love.graphics.newImageFont('assets/fonts/comm_hard.png', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÀÉÈÍÌÓÒÚÙabcdefghijklmnopqrstuvwxyzáàéèíìóòúù0123456789$£€¥()[]{}±&\\/©#*+-=:;?!><\'_",. ', -1)
    fonts.medium:setLineHeight(0.9)
    love.graphics.setFont(fonts.medium)

    globals.inventory = Inventory(fonts.medium)
    globals.inventory.x, globals.inventory.y = 0, 0

    globals.inspector = UIInspector(fonts.medium)
    globals.inspector.x, globals.inspector.y = canvasSize.x * 0.5, 240 - 27

    globals.textbox = TextBox(fonts.medium)
    globals.textbox.x, globals.textbox.y = canvasSize.x * 0.5, canvasSize.y * 0.5

    --globals.fadeblack = FadeBlack(fonts.medium)
    --globals.fadeblack.x, globals.fadeblack.y = 160, 120

    globals.statement = StatementLabel(fonts.medium)

    globals.omamori = OmamoriDisplayer()

    assets.title = love.graphics.newImage('assets/images/title_screen.png')
    assets.grassPitImage = love.graphics.newImage('assets/images/grass_pit.png')

    music.menu = love.audio.newSource("assets/music/menu.ogg", "stream")
    music.menu:setLooping(true)
    music.hunting = love.audio.newSource("assets/music/hunting.ogg", "stream")
    music.hunting:setLooping(true)
    music.village = love.audio.newSource("assets/music/village.ogg", "stream")
    music.village:setLooping(true)

    sounds.start = love.audio.newSource("assets/sounds/start.ogg", "static")
    sounds.hunt = love.audio.newSource("assets/sounds/hunt.ogg", "static")
    sounds.village = love.audio.newSource("assets/sounds/village.ogg", "static")

    canvas = love.graphics.newCanvas(canvasSize.x, canvasSize.y)

    love.math.setRandomSeed(love.timer.getTime())

    createVillagers()

    gameState = ScreenManager(canvas)

    globals.fadeblack = gameState.fadeblack

    gameState:register('/', TitleScreen)
    gameState:register('field', FieldScreen)
    gameState:register('village', VillageScreen)

    gameState:view('/')
end

local function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

function createVillagers()
    local types = { "love", "success", "study", "wealth" }
    local amount = 18

    types = shuffle(types)

    local numbers = {
        [types[1]] = 8,
        [types[2]] = 6,
        [types[3]] = 4
    }

    local vNumbers = {
        { [types[1]] = 1, [types[2]] = 2 },
        { [types[1]] = 2, [types[3]] = 1 },
        { [types[2]] = 2, [types[1]] = 1 },
        { [types[2]] = 2, [types[1]] = 1 },
        { [types[1]] = 2, [types[3]] = 1 },
        { [types[3]] = 2, [types[1]] = 1 },
    }
    vNumbers = shuffle(vNumbers)


    data.villagers = {

Villager('maleAdults', 1, 2,
"Ветреный день, я не\nуверен, что кто-то придет...",

[[Хатиро вспоминает имя своего отца, думая
о том, как он воспитывал его с жертвуя многим.

Его отец был скромным торговцем,
продающим основные товары бедным
людям за небольшие деньги.

Теперь он унаследовал его работу,
но не чувствует себя способным растить
своих детей тем же способом.]],

"О, это для меня?",

[[Хатиро смотрит на амулет скептически.
Однако, держа его в руках,
что-то внутри него шевельнулось.

Он благодарит тебя и уходит.]],

[[Хатиро начал думать о своем
отце как об источнике вдохновения
и стал работы усерднее, чем раньше.

За месяцы его усилия были вознаграждены.
Теперь он вспоминает своего отца с улыбкой
на лице, благодаря его за то,
что тот сделал всё возможное.

Он стал самым известным торговцем в
деревне, и растить своих детей
больше не было проблемой.]],
4, vNumbers[1]),



Villager('maleElders', 1, 5,
"Я скучаю по старым\nдобрым временам...",

[[Сеничи рассказывает, как всегда
мечтал стать героем для своего внука.

Он говорит, что очень старался и даже
преуспел в этом во времена детства внука.

Но всё изменилось: внук больше не уважает
его, как прежде, и это разбивает старику сердце.]],

"Что у тебя там,\nмолодой человек?",

[[Сеничи чувствует лёгкое удивление, увидев
амулет, который ты ему даришь.

Это был такой же амулет, который он раньше
давал своему племяннику, чтобы порадовать его.

Он улыбается тебе и уходит.]],

[[Сеничи научился быть лучшим
дедушкой для своего внука, делясь
своими знаниями, мудростью и показывая ему,
сколько он может от него узнать.

Он снова стал героем. Единственным типом героя, 
который действительно существует.]],

1, vNumbers[2]),


Villager('femaleAdults', 1, 1,
"Обычное утро.\n...",

[[Хана не много говорит.

Единственное, что она выражает — это
одиночество и неполноценность.

Её мать — единственная, кто говорит
с ней, исключительно чтобы упрекать её за то,
что она ничего не делает.

Она не хочет продолжать жить
таким образом.]],

"Хм? Что? Для меня?",

[[Амулет сначала кажется
бессмысленным для девушки.

Затем Хана понимает, что это подарок.
От тебя, для неё.
Потому что ты заботишься.

Внезапно многие из её забытых
воспоминаний проходят через её разум.

Она не знает, что сказать,
прощается нерешительно и уходит.]],

[[Хана научилась распознавать, как
обеспокоены люди вокруг неё.

Она восстановила свою способность видеть
привязанность в людях и завела новых
друзей.

Она начала свой путь к принятию себя.

Она поняла, что её жизнь имеет значение.]],

3, vNumbers[3]),


Villager('femaleElders', 1, 4,
"Как я желаю, чтобы всё\nшло хорошо...",

[[Юко имеет усталый вид,
результат многих бессонных ночей.

Её племянник болен в постели
уже несколько недель, и ни один врач
не может его навестить.

Она сомневается в своей роли
единственного опекуна ребёнка.

Слеза стекает по её лицу, когда она говорит,
что не знает, что делать,
если что-то пойдёт не так.]],

"Для меня? Ох, ты действительно\nмилый...",

[[Юко смотрит на то, что ты ей дал
с страдающей улыбкой, ценя
то, что ты хочешь как-то ей помочь.

Твоё действие заставляет её подумать, 
что важно делать всё, что можешь,
с энергией, которая у тебя есть, и всей радостью,
которая у тебя осталась.

Она уходит, снова благодаря тебя
за твою доброту.]],

[[Юко перестала вести себя так, будто худшее
произойдёт, и начала вести себя
так, будто её племянник неуклонно выздоравливает.

Новая энергия наполнила её дом, что
неизбежно повлияло на энергию тех,
кто был вокруг неё.

Её внук выздоровел.
Она теперь очень стара, и её последнее желание
— подготовить его к самостоятельной жизни.]],
3, vNumbers[4]),


Villager('maleAdults', 2, 6,
"Это действительно нормально?\nЯ не уверен.",

[[Масайуки говорит, что любил девушку.
Она была красивой, доброй, умной.

Однажды, когда он был на пике
своей любви к ней, она умерла.

Теперь он разрывается между искренней потребностью
жить свободно и внутренней обязанностью
оставаться верным своей первой настоящей любви.]],

"Подарок? Ну, у меня\nнет причин отказываться. ",

[[Масайуки принимает амулет с радостью.

Он понимает, что это тот тип
благодарности и счастья, который он хочет чувствовать
и заставлять других чувствовать тоже.

Он осознаёт, что не способен
сделать это в своём состоянии.

Он возвращается домой, благодаря тебя за то, что
ты помог ему понять, чего он действительно хочет.]],

[[Масайуки начал думать о
своих истинных желаниях и о том, чего он хотел
испытать в жизни.

Он хотел видеть улыбки на лицах людей,
и любить, любить снова.

Он всегда будет помнить свою любимую как ту,
которая наконец позволила ему полюбить
впервые и навсегда.]],

2, vNumbers[5]),


Villager('femaleChildren', 1, 7,
"...",
[[Она берёт свою тетрадь и начинает писать.

Закончив, она передаёт её тебе с
искренней улыбкой.

Кэйко глухонемая, но всё ещё пытается
ценить жизнь и любить,
в частности, одного мальчика. Ты замечаешь это, когда
читаешь его имя, её сердце бьётся чаще.

Однако, она также думает, что у неё нет
шансов в её состоянии.]],

"...",

[[Кэйко берёт амулет и внезапно
начинает плакать.
Придя в себя, она пишет:

"Спасибо тебе."

Затем она убегает, сдерживая слёзы.]],

[[Кэйко подошла к мальчику, который ей нравится.

Сначала это было трудно, и она часто чувствовала
себя глупо.
Однако, её искреннее и настоящее
чувство вознесло их отношения к небесам.

Теперь они учатся жить
жизнью друг друга.]],

1, vNumbers[6])
  }
end
