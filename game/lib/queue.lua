local class = require('lib.hump.class')

local Queue = class {}

function Queue:init()
  self.first = 0
  self.last = -1
  self.qSize = 0
end

function Queue:pushLeft(value)
  local first = self.first - 1
  self.first = first
  self[first] = value
  self.qSize = self.qSize + 1
end

function Queue:pushRight(value)
  local last = self.last + 1
  self.last = last
  self[last] = value
  self.qSize = self.qSize + 1
end

function Queue:popLeft()
  local first = self.first
  if first > self.last then return nil end
  local value = self[first]
  self[first] = nil        -- to allow garbage collection
  self.first = first + 1
  self.qSize = self.qSize - 1
  return value
end

function Queue:popRight()
  local last = self.last
  if self.first > last then return nil end
  local value = self[last]
  self[last] = nil         -- to allow garbage collection
  self.last = last - 1
  self.qSize = self.qSize - 1
  return value
end

function Queue:clear()
  for k, v in pairs(self) do
    self[k] = nil
  end
  self.first = 0
  self.last = -1
  self.qSize = 0
end

function Queue:size()
  return self.qSize
end

return Queue
