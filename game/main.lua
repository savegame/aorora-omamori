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

-- load game
function love.load()
	--love.graphics.setDefaultFilter("nearest", "nearest")
	--fonts.default = love.graphics.newImageFont('assets/fonts/unispirits_hard.png', 'ÉÈÁÀÒÓÙÚÌÍ$úàáèéòóù}§{()[]jl£Q±p¢ygqjíì¾½¼W€&CDEFGHKMNORSTUVXYZ\\@¥©P0#÷*+/2345689AB?bJd7hkLt><1fli!¦|wmxasceuvnozr«=»,:″ˆ"\'′_- .', -1)
	fonts.medium = love.graphics.newImageFont('assets/fonts/comm_hard.png', 'ABCDEFGHIJKLMNOPQRSTUVWXYZÁÀÉÈÍÌÓÒÚÙabcdefghijklmnopqrstuvwxyzáàéèíìóòúù0123456789$£€¥()[]{}±&\\/©#*+-=:;?!><\'_",. ', -1)
	fonts.medium:setLineHeight(0.9)
	love.graphics.setFont(fonts.medium)

	globals.inventory = Inventory(fonts.medium)
	globals.inventory.x, globals.inventory.y = 0, 0

	globals.inspector = UIInspector(fonts.medium)
	globals.inspector.x, globals.inspector.y = 160, 240 - 27

	globals.textbox = TextBox(fonts.medium)
	globals.textbox.x, globals.textbox.y = 160, 120

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

	canvas = love.graphics.newCanvas(320, 240)

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
"It's a windy day, I'm not\nsure anyone will come...",

[[Hachiro recalls his father name, thinking
about how he raised him with sacrifice.

His father was a humble merchant,
selling primary goods to poor
people for little money.

He has now inherited his job,
but doesn't feel up to grow his
children the same way.]],

"Oh, is that for me?",

[[Hachiro looks at the amulet with skepticism.
However, holding it in his hands
moves something inside him.

He thanks you and leaves.]],

[[Hachiro started thinking about his
father as an inspiration to work even
harder than before.

Over the months, his efforts were rewarded.
He now remembers his father with a smile
on his face, thanking him for doing its best.

He became the best-known merchant in
the village and child support
was no longer a concern.]],

4, vNumbers[1]),


Villager('maleElders', 1, 5,
"I miss the good old days...",

[[Senichi mentions how he always wanted
to be a hero for his grandchild.

He says he tried hard, even succeeding in
his grandson's childhood.

Things have changed, his nephew no longer
respects him as he used to, and this
leaves him heartbroken.]],

"What do you have there,\nyoung man?",

[[Senichi feels a little surprised seeing
the amulet you're giving him.

It was the type of thing he used to
give to his nephew to encourage him.

He smiles at you and walks away.]],

[[Senichi learned to be the best supportive
grandfather for his nephew, sharing
his knowledge, his widsom and showing him
how much he can learn from him.

He became a hero again.
The only type of hero that truly exists.]],

1, vNumbers[2]),


Villager('femaleAdults', 1, 1,
"Just another morning.\n...",

[[Hana doesn't talk much.

The only things she expresses are
loneliness and inadequacy.

Her mother is the only one who speaks
to her, solely to hold her doing
nothing against her.

She's not willing to go on with things
the way they are.]],

"Hm? What? For me?",

[[The amulet initially feels
meaningless to the girl.

Then Hana realizes it was a gift.
From you, to her.
Because you care.

Suddenly, many of her forgotten
memories go through her mind.

She doesn't know what to say,
gives a hesitant goodbye and leaves.]],

[[Hana has learned to recognize how
worried people around her are.

She restored her ability to see
affection in people and made new
friends.

She began her journey to like herself.

She realized her life matters.]],

3, vNumbers[3]),


Villager('femaleElders', 1, 4,
"How I wish things were\ngoing well...",

[[Yoko has a tired expression,
result of many sleepless nights.

His nephew has been sick in bed
for weeks and no doctor can visit him.

She's questioning his figure as the
child only caregiver.

A tear runs down her face as she says she
wouldn't know what to do
if things go wrong.]],

"For me? Owh, you really\nare sweet...",

[[Yoko looks at what you gave her
with a suffering smile, appreciating
that you want to help her somehow.

Your action makes her think that it is
important to do everything you can,
with the energy you have, and all the joy
you have left.

She leaves, thanking you again
for your kindness.]],

[[Yoko stopped acting as though the worst
was going to happen and began to behave
as her nephew was relentlessly recovering.

A new energy filled his home, which
inevitably influenced the energy of those
around her.

Her grandson recovered.
She's now very old, and her last wish
is to make him ready to face life alone.]],

3, vNumbers[4]),


Villager('maleAdults', 2, 6,
"Is this really ok?\nI'm not sure.",

[[Masayuki says he loved a girl.
She was beautiful, kind, intelligent.

One day, when he was at the peak of
his love for her, she passed away.

He is now torn between the sincere need
to live freely and the inner obligation
to remain faithful to his first true love.]],

"A gift? Well, I have\nno reason to refuse. ",

[[Masayuki accepts the amulet with joy.

He realizes that this is the kind of
gratitude and happiness he wants to feel
and make others feel as well.

He undestands he is not able
to do it in his state.

He returns home, thanking you for letting
him understand what he really wants.]],

[[Masayuki began to think about
his true desires and what he wanted
to experience in life.

He wanted to see smiles on people's faces,
and to love, to love again.

He'll always remember his beloved as the
one who finally allowed him to love for
the first time and forever.]],

2, vNumbers[5]),


Villager('femaleChildren', 1, 7,
"...",

[[She takes her notebook and starts writing.

Once finished, she hands it to you with
a candid smile.

Keiko is deaf-mute, but still trying to
appreciate life and to love,
a boy in particular. You notice that when
you read his name her heart pounds.

However, she also thinks she doesn't stand
a chance in her condition.]],

"...",

[[Keiko takes the amulet and suddenly
starts to cry.

After getting back on her feet, she writes:

"Thank you."

She then runs away holding back the tears.]],

[[Keiko has approached the boy she likes.

Initially it was hard and she often felt
ridiculous.
However, her sincere and true
affection carried their relationship up to
the sky.

They are now learning to live
from each other's life.]],

1, vNumbers[6])
  }
end
