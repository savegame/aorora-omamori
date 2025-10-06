local class = require('lib.hump.class')
local queue = require('lib.queue')
local inspect = require('lib.inspect')


local MapAnalyzer = class {}

local function sortNodes(a, b)
	return a.cost > b.cost
end

local function standardWalkable(node)
  return node.walkable
end

function MapAnalyzer:init()
  self.openList = queue()
  self.costFunc = nil
  self.currentNode = nil
end

function MapAnalyzer:calculateFrom(x, y, map, walkable, costFunc)
	self.costFunc = costFunc
	local mapping = self:_initialize(map)

	self.openList:pushRight(mapping[x][y])
	while self.openList:size() > 0 do
		self:_generate_path(mapping, map)
  end
	for x = 1, map:getWidth() do
		for y = 1, map:getHeight() do
			mapping[x][y] = mapping[x][y].cost
    end
  end
	return mapping
end

function MapAnalyzer:calculateFilteredFrom(x, y, map, costCheckFunc, walkable, costFunc, walkableFunc)
	self.costFunc = costFunc
  local walkFunc = walkableFunc or standardWalkable
	local mapping = self:_initialize(map, walkable)
  local validNodes = {}

	self.openList:pushRight(mapping[x][y])
	while self.openList:size() > 0 do
		self:_generate_path(mapping, map, walkFunc)
  end
	for x = 1, map:getWidth() do
		for y = 1, map:getHeight() do
      if costCheckFunc(mapping[x][y].cost, x, y) and mapping[x][y].walkable then
        table.insert(validNodes, mapping[x][y])
      end
    end
  end
	return validNodes
end

function MapAnalyzer:_initialize(map, walkable)
  local mapping = {}
	for x = 1, map:getWidth() do
    mapping[x] = {}
		for y = 1, map:getHeight() do
			--mapping[x][y] = map:getNodeAt(x, y)
      mapping[x][y] = { x = x, y = y, cost = 0,
        type = "none", walkable = map:getMap()[y][x] >= walkable }
    end
  end
	return mapping
end

function MapAnalyzer:_generate_path(mapping, map, walkFunc)
  table.sort(self.openList, sortNodes)
	self.currentNode = self.openList:popRight()
	self.currentNode.type = "closed"

	self:_add_open_node(mapping, 0, -1,  map, walkFunc)
	self:_add_open_node(mapping, 1, 0,  map, walkFunc)
	self:_add_open_node(mapping, 0, 1,  map, walkFunc)
	self:_add_open_node(mapping, -1, 0,  map, walkFunc)
end

function MapAnalyzer:_add_open_node(mapping, x, y, map, walkFunc)
	if self.currentNode.x + x > 0 and self.currentNode.x + x <= map:getWidth() and
      self.currentNode.y + y > 0 and self.currentNode.y + y <= map:getHeight() then
		local newNode = mapping[self.currentNode.x + x][self.currentNode.y + y]
		if walkFunc(newNode) then
			if newNode.type == "none" then
				newNode.cost = self.currentNode.cost + 1-- self.costFunc(self.currentNode.x + x, self.currentNode.y + y)
				newNode.type = "open"
				self.openList:pushLeft(newNode)
      elseif newNode.type == "closed" then
        local cost = self.currentNode.cost + 1-- self.costFunc(self.currentNode.x + x, self.currentNode.y + y)
				if cost < newNode.cost then
					newNode.cost = cost
        end
      end
    end
  end
end

return MapAnalyzer
