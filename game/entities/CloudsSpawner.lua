local class = require('lib.hump.class')
local anim8 = require('lib.anim8')
local flux = require('lib.flux')


local CloudsSpawner = class {}

function CloudsSpawner:init(cloudsPerSecond, areaWidth, areaHeight)
	self.tweens = flux.group()
	self.cloudsPerSecond = cloudsPerSecond
	self.areaWidth = areaWidth
	self.areaHeight = areaHeight
	self.timer = 0
	self.clouds = {}
end

function CloudsSpawner:generateCloud()
	local ellipses = math.random(3, 8)
	local cloud = {ellipses = {}, w = 0, h = 0, x = 0, y = 0, speed = 0}
	local x = 0
	for i = 1, ellipses do
		local y = math.random(0, 32)
		local w = math.random(15, 24)
		local h = math.random(10, 15)
		cloud.ellipses[i] = { x = x + w, y = y + h, w = w, h = h}
		cloud.w = math.random(cloud.w, x + w * 2)
		cloud.h = math.random(cloud.h, y + h * 2)

		x = x + math.random(2, 26)
	end
	cloud.x = self.areaWidth
	cloud.y = math.random(-cloud.h / 2, self.areaHeight - cloud.h / 2)
	cloud.speed = math.random(6, 10)
	return cloud
end

function CloudsSpawner:update(dt)
	self.timer = self.timer + dt

	self:updateClouds(dt)

	while self.timer >= 1 / self.cloudsPerSecond do
		dt = dt - 1 / self.cloudsPerSecond
		self.timer = self.timer - 1 / self.cloudsPerSecond
		local newCloud = self:generateCloud()
		table.insert(self.clouds, newCloud)
		self:updateCloud(newCloud, dt)
	end
	--print("number of clouds: " .. #self.clouds)
	--self.tweens:update(dt)
end

function CloudsSpawner:updateClouds(dt)
	for i = #self.clouds, 1, -1 do
		local cloud = self.clouds[i]
		self:updateCloud(cloud, dt, i)
	end
	--for i, cloud in ipairs(self.clouds) do
		--self:updateCloud(cloud, dt)
	--end
end

function CloudsSpawner:updateCloud(cloud, dt, index)
	cloud.x = cloud.x - cloud.speed * dt
	if cloud.x + cloud.w <= 0 and index ~= nil then
		table.remove(self.clouds, index)
	end
end

function CloudsSpawner:drawShadow()
	for i, cloud in ipairs(self.clouds) do
		local x, y = cloud.x, cloud.y
		for j, ellipse in ipairs(cloud.ellipses) do
			love.graphics.ellipse("fill", cloud.x + ellipse.x, cloud.y + ellipse.y, ellipse.w, ellipse.h)
		end
	end
end

return CloudsSpawner
