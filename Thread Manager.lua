local ThreadManager = {}
ThreadManager.__index = ThreadManager

function ThreadManager.new()
    local self = setmetatable({}, ThreadManager)
    self.threads = {}
    self.threadTimeout = 5 -- Timeout in seconds
    return self
end

function ThreadManager:createThread(func)
    local thread = {
        coroutine = coroutine.create(func),
        lastYieldTime = os.time()
    }
    table.insert(self.threads, thread)
    return thread
end

function ThreadManager:update()
    local currentTime = os.time()
    for i = #self.threads, 1, -1 do
        local thread = self.threads[i]
        local status = coroutine.status(thread.coroutine)
        if status == "dead" then
            table.remove(self.threads, i)
        else
            local elapsedTime = currentTime - thread.lastYieldTime
            if elapsedTime > self.threadTimeout then
                warn("Thread stuck in a loop without yielding for too long!")
                coroutine.resume(thread.coroutine) -- Attempt to resume, but this might not work if the thread is truly stuck
            else
                coroutine.resume(thread.coroutine)
            end
            thread.lastYieldTime = os.time()
        end
    end
end

return ThreadManager
