local class = require('lib.hump.class')
local sti = require('lib.sti')
local inspect = require('lib.inspect')
local bump = require('lib.bump')

local Pathgrid = require('lib.jumper.grid')
local Pathfinder = require('lib.jumper.pathfinder')
local CloudsSpawner = require('entities.CloudsSpawner')
local MapAnalyzer = require('lib.MapAnalyzer')


local Field = class {
	onGrassShader = love.graphics.newShader[[
		extern Image grass;
		extern vec2 screen_size;
		extern number qx, qy, qw, qh, iw, ih;
		extern number y_origin;

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords);
			vec4 gr = Texel(grass, screen_coords / screen_size);

			vec2 quad_coords = vec2((texture_coords.x * iw - qx) / qw, (texture_coords.y * ih - qy) / qh);
			vec2 quad_central_origin = vec2((qx + quad_coords.x * qw) / iw, (qy + y_origin ) / ih);
			vec2 texture_to_origin = quad_central_origin - texture_coords;
			vec2 to_origin_pixel = vec2(texture_to_origin.x * iw, texture_to_origin.y * ih);
			vec2 origin_pixel = screen_coords + to_origin_pixel;
			vec2 origin_pixel_coords = vec2(origin_pixel.x / screen_size.x, origin_pixel.y / screen_size.y);
			vec2 origin = vec2((texture_coords.x * iw - qx) / qw, (texture_coords.y * ih - qy) / qh);

			if (Texel(grass, origin_pixel_coords).a > 0.0) {
				if (gr.a > 0.0 && quad_coords.y > 0.65 && quad_coords.x >= 0.0) {
					pixel = vec4(0.0, 0.0, 0.0, 0.0);
				}
			}
      return pixel * color;
    }
  ]],
	grassPitShader = love.graphics.newShader[[
		extern Image grass;
		extern vec2 screen_size;
		extern number y_origin;
		extern number qx, qw, iw;
		extern number width;

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords);
			number gr = Texel(grass, screen_coords / screen_size).a;
			number origin_gr = Texel(grass, vec2(screen_coords.x / screen_size.x, y_origin / screen_size.y)).a;
			number combined_gr = (1.0 - step(1.0, 1.0 - gr)) * (1.0 - step(1.0, 1.0 - origin_gr));

			number quad_coord_x = (texture_coords.x * iw - qx) / qw;
			combined_gr = combined_gr * step(abs(quad_coord_x - 0.5), width);

      return pixel * combined_gr * color;
    }
  ]],
	grassShadowShader = love.graphics.newShader[[
		extern Image grass;
		extern vec2 screen_size;
		extern number y_origin;

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords);
			number gr = Texel(grass, screen_coords / screen_size).a;
			//number origin_gr = Texel(grass, vec2(screen_coords.x / screen_size.x, y_origin / screen_size.y)).a;
			number combined_gr = (step(1.0, 1.0 - gr));// (*) (step(1.0, 1.0 - origin_gr));

      return pixel * combined_gr * color;
    }
  ]]
}

local function sortObjects(a, b)
	return a.y < b.y
end

local function removeEntityFromCell(cell, entity)
  local removeIndex = -1
  for i, v in ipairs(cell) do
    if v == entity then removeIndex = i break end
  end
  table.remove(cell, removeIndex)
end

function Field:init(mapPath, shadowsAlpha, uiDraw)
	self.map = sti(mapPath)
	self.world = bump.newWorld()
	self.analyzer = MapAnalyzer()
	self.highlight = {}
	for i = 1, self.map.width do
    self.highlight[i] = {}
    for j = 1, self.map.height do
      self.highlight[i][j] = false
    end
	end
	self.tileset = self.map.tilesets[1]
	self.grassCanvas = love.graphics.newCanvas(canvasSize.x, canvasSize.y)
	self.shadowsCanvas = love.graphics.newCanvas(canvasSize.x, canvasSize.y)
	self.shadowsAlpha = shadowsAlpha
	self.clouds = CloudsSpawner(0.6, self.map.width * self.map.tilewidth,
		self.map.height * self.map.tileheight)
	self.clouds:update(100)
	self.objects = self.map.layers["objects"].objects
	self.removingQueue = {}
	self.spiritSpawnPoints = {}
	self.entities = {}
	local boundsLayer = self.map.layers["bounds"]
	local specialsLayer = self.map.layers["specials"]
	local terrainsLayer = self.map.layers["terrains"]
	local collisions = self.map.layers["collisions"]
	local components = self.map.layers["components"]
	if collisions then
		for i, c in ipairs(collisions.objects) do
			self.world:add({ type = "solid", object = c }, c.x, c.y, c.width, c.height)
		end
	end
	self.playerSpawnPoint = nil
	self.villagerSpawnPoints = {}
	self.portal = nil
	if components then
		for i, c in ipairs(components.objects) do
			if c.type == "portal" then self.portal = c end
			if c.type == "villagerSpawn" then self.villagerSpawnPoints[c.name] = c end
			if c.type == "playerSpawn" then self.playerSpawnPoint = c end
		end
	end
	local obstaclesMap = {}
	for j = 1, self.map.height do
  	obstaclesMap[j] = {}
  	for i = 1, self.map.width do
			--print("tile: " .. inspect(terrainsLayer.data[j][i]))
			if boundsLayer.data[j][i] then
				if specialsLayer.data[j][i] and specialsLayer.data[j][i].id == 56 then
					self.spiritSpawnPoints[#self.spiritSpawnPoints + 1] = { x = i, y = j }
				end
				self.world:add({type = "bounds", x = i, y = j}, i * 32 - 32, j * 32 - 32, 32, 32)
				obstaclesMap[j][i] = tiles.bounds
			else
      	obstaclesMap[j][i] = tiles.grass
			end
			if terrainsLayer.data[j][i] and terrainsLayer.data[j][i].type == "Mountains" then
				obstaclesMap[j][i] = tiles.bounds
				self.world:add({type = "solid", x = i, y = j}, i * 32 - 32, j * 32 - 32, 32, 32)
			end
			if specialsLayer.data[j][i] and specialsLayer.data[j][i].id == 56 then
				local grass = { type = "grass" }
				self.world:add(grass, i * 32 - 32, j * 32 - 32, 32, 32)
			end
  	end
	end

	self.typesGrid = {}
	self.entitiesGrid = {}
	for i = 1, self.map.width do
  	self.typesGrid[i] = {}
		self.entitiesGrid[i] = {}
  	for j = 1, self.map.height do
			if boundsLayer.data[j][i] then
				self.typesGrid[i][j] = tiles.bounds
			else
      	self.typesGrid[i][j] = tiles.grass
			end
			self.entitiesGrid[i][j] = {}
  	end
	end

	self.pathGrid = Pathgrid(obstaclesMap)
	self.pathFinder = Pathfinder(self.pathGrid, "ASTAR", function(...) return self:_defaultWalkable(...) end)
	--self.pathFinder:setMode('ORTHOGONAL')
	self.uiDraw = uiDraw
end

function Field:_defaultWalkable(v, x, y)
	return v ~= -1 and #self.entitiesGrid[x][y] == 0
end

function Field:_onlyPathWalkable(v, x, y)
	return v ~= -1 and self.map.layers["terrains"].data[y][x].type == "Path"
end

function Field:update(dt)
	self.map:update(dt)
	self.clouds:update(dt)
	for entity, pos in pairs(self.entities) do
		if pos then	entity:update(dt, self.world) end
	end
	for obj, v in pairs(self.removingQueue) do
		self:_removeObject(obj)
	end
	self.removingQueue = {}
end

function Field:draw()
  -- drawing background elements below anything else
	self.map:drawTileLayer("background")
	self.map:drawTileLayer("terrains")
	love.graphics.push("all")
	love.graphics.setCanvas(self.grassCanvas)
	love.graphics.clear()
	--love.graphics.translate(0, 32)
	self.map:drawTileLayer("tallGrass")
	love.graphics.pop()
	love.graphics.push("all")
	local gX, gY = love.graphics.inverseTransformPoint(0, 0)
	love.graphics.draw(self.grassCanvas, gX, gY, 0, 1, 1)
	love.graphics.pop()

	if self.map.layers["rocks"] then self.map:drawTileLayer("rocks") end

	-- shadows drawing
	love.graphics.push("all")
	love.graphics.setCanvas(self.shadowsCanvas)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.clear()
	love.graphics.setColor(35, 33, 61, 255)
	local gX, gY = love.graphics.inverseTransformPoint(0, 0)
	love.graphics.origin()
	love.graphics.translate(-gX, -gY)
	self.clouds:drawShadow()
	love.graphics.setShader(self.grassShadowShader)
	self.grassShadowShader:send("screen_size", { canvasSize.x, canvasSize.y })
	self.grassShadowShader:send('grass', self.grassCanvas)
	for _, obj in ipairs(self.objects) do
		if obj["drawShadow"] ~= nil then
			obj:drawShadow(self.grassShadowShader)
		elseif obj.gid ~= nil and self.map.tiles[obj.gid].properties["shadowWidth"] ~= nil then
			local tile = self.map.tiles[obj.gid]
			love.graphics.ellipse("fill", obj.x + 16 + tile.properties.shadowOffsetX, obj.y,
				tile.properties.shadowWidth / 2, tile.properties.shadowHeight / 2)
		end
	end
	love.graphics.pop()

	love.graphics.push("all")
	--love.graphics.setColor(255, 255, 255, 128)
	love.graphics.setColor(255, 255, 255, self.shadowsAlpha)
	local gX, gY = love.graphics.inverseTransformPoint(0, 0)
	love.graphics.draw(self.shadowsCanvas, gX, gY, 0, 1, 1)
	love.graphics.pop()

	--[[love.graphics.push("all")
	love.graphics.setColor(180, 240, 255, 100)
	for i = 1, self.map.width do
    for j = 1, self.map.height do
			if self.highlight[i][j] then
				local cell = self.highlight[i][j]
				love.graphics.setColor(cell.color[1], cell.color[2], cell.color[3], cell.color[4])
				love.graphics.draw(self.highlightImage, i * 32 - 32, j * 32 - 32)
			end
    end
	end
	love.graphics.pop()]]
	--self.uiDraw()

	-- ordered objects
	--for i, entity in ipairs(self.entities) do
	--	entity.y = entity.y + 0.5 / i
	--end
	table.sort(self.objects, sortObjects)
	--for i, entity in ipairs(self.entities) do
	--	entity.y = entity.y - 0.5 / i
	--end

	self.grassPitShader:send("screen_size", { canvasSize.x, canvasSize.y })
	self.grassPitShader:send('grass', self.grassCanvas)
	love.graphics.setShader(self.onGrassShader)
	self.onGrassShader:send("screen_size", { canvasSize.x, canvasSize.y })
	self.onGrassShader:send("grass", self.grassCanvas)
	for _, obj in ipairs(self.objects) do
		if obj["draw"] ~= nil then
			obj:draw(self.grassPitShader)
		else
			local tile = self.map.tiles[obj.gid]
			--print(inspect(self.map.tilesets[1]))
			local image = self.map.tilesets[1].image--"assets/images/village_tileset.png"]
			local qx, qy, qw, qh = tile.quad:getViewport()
		  self.onGrassShader:send("qx", qx)
		  self.onGrassShader:send("qy", qy)
		  self.onGrassShader:send("qw", qw)
		  self.onGrassShader:send("qh", qh)
		  self.onGrassShader:send("iw", image:getWidth())
		  self.onGrassShader:send("ih", image:getHeight())
			self.onGrassShader:send("y_origin", 32)
			love.graphics.draw(image, tile.quad,
				obj.x, obj.y - 32, 0, 1, 1, 0, 0, 0, 0)
		end
	end
	love.graphics.setShader()

	self.map:drawTileLayer("bounds")
end

function Field:getPath(start, target)
	return self.pathFinder:getPath(start.x, start.y, target.x, target.y)
end

function Field:_weightedCostEvaluation(node, neighbour, finder, clearance)
	local mCost = self.map.layers["terrains"].data[neighbour:getY()][neighbour:getX()].properties.walk_cost
	if node._g + mCost < neighbour._g then
		neighbour._parent = node
		neighbour._g = node._g + mCost
	end
end

function Field:getPathWeighted(start, target)
	return self:getPath(start, target)
	--return self.pathFinder:getPath(start.x, start.y, target.x, target.y, nil, nil,
	--	function(...) return self:_weightedCostEvaluation(...) end)
end

function Field:getPathCustomWeighted(start, target, costFunc)
	return self.pathFinder:getPath(start.x, start.y, target.x, target.y, nil, nil, costFunc)
end

function Field:getPathAllCustomWeighted(start, target, costFunc)
	self.pathFinder:setWalkable(function(...) return true end)
	local path = self.pathFinder:getPath(start.x, start.y, target.x, target.y, nil, nil,
		costFunc)
	self.pathFinder:setWalkable(function(...) return self:_defaultWalkable(...) end)

	return path
end

function Field:getPathRouted(start, target)
	self.pathFinder:setWalkable(function(...) return self:_onlyPathWalkable(...) end)
	local path = self.pathFinder:getPath(start.x, start.y, target.x, target.y, nil, nil,
		function(...) return self:_weightedCostEvaluation(...) end)
	self.pathFinder:setWalkable(function(...) return self:_defaultWalkable(...) end)

	--local finalPath = {}
	--for node, count in path:nodes() do
	--	if count <= steps + 1 then
	--		finalPath[#finalPath + 1] = node
	--	else
	--		break
	--	end
	--end
	return path
end

function Field:getEntitiesNodes(entities)
	local nodes = {}
	for i, e in ipairs(entities) do
		local pos = self.entities[e]
		nodes[#nodes + 1] = { x = pos.x, y = pos.y }
	end
	return nodes
end

function Field:getNodesWithEntityOfType(type)
	local nodes = {}
	for e, pos in pairs(self.entities) do
		if e.type == type then nodes[#nodes + 1] = { x = pos.x, y = pos.y } end
	end
	return nodes
end

function Field:getEntitesOfType(type)
	local entities = {}
	for e, pos in pairs(self.entities) do
		if e.type == type then entities[#entities + 1] = e end
	end
	return entities
end

function Field:getAllWalkableNeightbours(nodes)
	local result = {}
	for i, n in ipairs(nodes) do
		for j, ng in ipairs(self:getWalkableNeightbours(n.x, n.y)) do
			result[#result + 1] = ng
		end
	end
	return result
end

function Field:getMarkedForAttackEntityContainingNeightbours(x, y, type)
	local nodes = {}
	if x < self.pathGrid:getWidth() and self.pathGrid:getMap()[y][x + 1] >= 0
			and #self.entitiesGrid[x + 1][y] > 0 and self.entitiesGrid[x + 1][y][1].type == type then
		nodes.right = { x = x + 1, y = y } end
	if y > 1 and self.pathGrid:getMap()[y - 1][x] >= 0
			and #self.entitiesGrid[x][y - 1] > 0 and self.entitiesGrid[x][y - 1][1].type == type then
		nodes.up = { x = x, y = y - 1 } end
	if x > 1 and self.pathGrid:getMap()[y][x - 1] >= 0
			and #self.entitiesGrid[x - 1][y] > 0 and self.entitiesGrid[x - 1][y][1].type == type then
		nodes.left = { x = x - 1, y = y } end
	if y < self.pathGrid:getHeight() and self.pathGrid:getMap()[y + 1][x] >= 0
			and #self.entitiesGrid[x][y + 1] > 0 and self.entitiesGrid[x][y + 1][1].type == type then
		nodes.down = { x = x, y = y + 1 } end

	local toRemove = {}
	for k, v in pairs(nodes) do
		local valid = false
		local arrival = { x = v.x, y = v.y }
		local hits = 0
		local adding = { x = 0, y = 0 }
		v.entities = {}
		if k == "right" then adding.x = 1 end
		if k == "up" then adding.y = -1 end
		if k == "left" then adding.x = -1 end
		if k == "down" then adding.y = 1 end

		local newPos = { x = v.x, y = v.y }
		repeat
			if #self.entitiesGrid[newPos.x][newPos.y] > 0
					and self.entitiesGrid[newPos.x][newPos.y][1].type == type then
				v.entities[#v.entities + 1] = self.entitiesGrid[newPos.x][newPos.y][1]
			end

			newPos.x = newPos.x + adding.x
			newPos.y = newPos.y + adding.y
			if self:isWalkableAndFree(newPos.x, newPos.y) then
				valid = true
				arrival = newPos
			end
			hits = hits + 1
		until(valid	or #self.entitiesGrid[newPos.x][newPos.y] == 0 or self.entitiesGrid[newPos.x][newPos.y][1].type ~= type)

		if valid then
			v.arrival = arrival
			v.hits = hits
		else
			toRemove[#toRemove + 1] = k
		end
	end
	for i, v in ipairs(toRemove) do
		nodes[v] = nil
	end
	return nodes
end

function Field:getWalkableNeightbours(x, y)
	local nodes = {}
	if x < self.pathGrid:getWidth() and self.pathGrid:getMap()[y][x + 1] >= 0 then
		nodes[#nodes + 1] = { x = x + 1, y = y } end
	if y > 1 and self.pathGrid:getMap()[y - 1][x] >= 0 then
		nodes[#nodes + 1] = { x = x, y = y - 1 } end
	if x > 1 and self.pathGrid:getMap()[y][x - 1] >= 0 then
		nodes[#nodes + 1] = { x = x - 1, y = y } end
	if y < self.pathGrid:getHeight() and self.pathGrid:getMap()[y + 1][x] >= 0 then
		nodes[#nodes + 1] = { x = x, y = y + 1 } end
	return nodes
end

function Field:isWalkableAndFree(x, y)
	if x <= self.pathGrid:getWidth() and x > 0 and y <= self.pathGrid:getHeight() and y > 0
			and self.pathGrid:getMap()[y][x + 1] >= 0 and #self.entitiesGrid[x][y] == 0 then
		return true
	end
	return false
end

function Field:filterHighlighted(nodes)
	local filtered = {}
	for i, n in ipairs(nodes) do
		if self.highlight[n.x][n.y] then filtered[#filtered + 1] = n end
	end
	return filtered
end

function Field:filterEntitiesFree(nodes)
	local filtered = {}
	for i, n in ipairs(nodes) do
		if #self.entitiesGrid[n.x][n.y] == 0 then
			filtered[#filtered + 1] = n
		end
	end
	return filtered
end

function Field:highlightCells(nodes, highlight) -- false or { type = "", color = { 0, 0, 0, 0 } }
	for i, n in ipairs(nodes) do
		self.highlight[n.x][n.y] = highlight
	end
end

function Field:isHighlighted(x, y)
	return self.highlight[x][y]
end

function Field:clearHighlights()
	for i = 1, self.map.width do
    for j = 1, self.map.height do
      self.highlight[i][j] = false
    end
	end
end

function Field:getReachableCellsFrom(x, y, maxCost)
	return self.analyzer:calculateFilteredFrom(x, y, self.pathGrid, maxCost, 0, function(x, y)
		--print(inspect(self.map.layers["terrains"].data[y][x]))
		return self.map.layers["terrains"].data[y][x].properties.walk_cost
	end)
end

function Field:getCustomReachableCellsFrom(x, y, maxCost, costFunc)
	return self.analyzer:calculateFilteredFrom(x, y, self.pathGrid, maxCost, 0, costFunc)
end

function Field:getCustomReachableCellsAllFrom(x, y, maxCost, costFunc)
	return self.analyzer:calculateFilteredFrom(x, y, self.pathGrid, maxCost, -1, costFunc)
end

function Field:getReachableFreeCellsFrom(x, y, maxCost)
	return self.analyzer:calculateFilteredFrom(x, y, self.pathGrid, maxCost, 0, function(x, y)
		return self.map.layers["terrains"].data[y][x].properties.walk_cost
	end, function(node)
		return node.walkable and #self.entitiesGrid[node.x][node.y] == 0
	end)
end

function Field:containsObject(object, gridX, gridY)
	for i, o in ipairs(self.entitiesGrid[gridX][gridY]) do
		if o == object then return true end
	end
	return false
end

function Field:addTree(tree)
	self.entities[tree] = { x = 0, y = 0 }
	table.insert(self.objects, tree)
	self.world:add(tree, tree.x - tree.width / 2, tree.y - tree.height,
		tree.width, tree.height)
end

function Field:addObject(object, gridX, gridY)
	self.entities[object] = { x = gridX, y = gridY }
	table.insert(self.objects, object)
	--table.insert(self.entitiesGrid[gridX][gridY], object)
	object:enterWorld(self)
	object:setPosition(object:gridToPosition(gridX, gridY))
  --object.x, object.y = object:gridToPosition(gridX, gridY)
	--self.world:add(object, object.x - object.width / 2, object.y - object.height,
		--object.width, object.height)
end

function Field:removeObject(object)
	if self.entities[object] ~= nil then
		self.removingQueue[object] = true
		return true
	end
	return false
end

function Field:_removeObject(object)
	if self.entities[object] ~= nil then
		x, y = self.entities[object].x, self.entities[object].y
		self.entities[object] = nil

    --removeEntityFromCell(self.entitiesGrid[x][y], object)
		removeEntityFromCell(self.objects, object)
		--table.remove(self.objects, object)
		--self.world:remove(object)
		object:exitWorld(self)
		return true
	end
	return false
end

function Field:moveObject(object, gridX, gridY)
	if self.entities[object] ~= nil then
		x, y = self.entities[object].x, self.entities[object].y
		self.entities[object].x = gridX
		self.entities[object].y = gridY

    removeEntityFromCell(self.entitiesGrid[x][y], object)
		table.insert(self.entitiesGrid[gridX][gridY], object)
    object.x, object.y = object:gridToPosition(gridX, gridY)
		return true
	end
	return false
end

return Field
