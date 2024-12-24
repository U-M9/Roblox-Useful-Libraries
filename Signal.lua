type Connection = {
	Connected: boolean,
	Disconnect: (self: Connection) -> (),
	callback: (...any) -> ()
}

type Signal = {
	new: () -> Signal,
	Connect: (self: Signal, callback: (...any) -> ()) -> Connection,
	Fire: (self: Signal, ...any) -> (),
	DisconnectAll: (self: Signal) -> ()
}

local Signal = {}
Signal.__index = Signal

function Signal.new(): Signal
	local self = setmetatable({}, Signal)
	self._connections = {} :: {Connection}
	return self
end

function Signal:Connect(callback: (...any) -> ()): Connection
	assert(type(callback) == "function", "Expected callback to be a function")

	local connection: Connection = {
		Connected = true,
		Disconnect = function(self)
			if not self.Connected then return end
			self.Connected = false
			for i, conn in ipairs(self._connections) do
				if conn == self then
					table.remove(self._connections, i)
					break
				end
			end
			self.callback = nil
		end,
		callback = callback
	}

	table.insert(self._connections, connection)
	return connection
end

function Signal:Fire(...: any)
	for _, connection in ipairs(self._connections) do
		if connection.Connected then
			task.spawn(connection.callback, ...)
		end
	end
end

function Signal:DisconnectAll()
	for _, connection in ipairs(self._connections) do
		connection.Connected = false
		connection.callback = nil
	end
	table.clear(self._connections)
end

return Signal
