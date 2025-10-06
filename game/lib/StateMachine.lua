local class = require('lib.hump.class')


local StateMachine = class {}

function StateMachine:init(conf)
  --[[ conf: table like this
  {
		initial = "wander",
		states = {
			wander = WanderState,
			wait = WaitState
		}
	}
  ]]
	self.states = {}
	for key, value in pairs(conf.states) do
		self.states[key] = value(self)
	end
	self:switch(conf.initial)
end

function StateMachine:switch(toState, ...)
	if self.state ~= nil then self.state:exited() end
	self.current = toState
	self.state = self.states[toState]
	self.state:entered(...)
end

function StateMachine:update(dt)
	self.state:update(dt)
end

function StateMachine:input(event)
	self.state:input(event)
end

return StateMachine
