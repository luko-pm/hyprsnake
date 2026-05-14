local Timer = {}

---@type HL.Timer
local timer

---@param callback function
---@param timeout integer
Timer.setup = function(callback, timeout)
    timer = hl.timer( callback, { timeout = timeout, type = "repeat", enabled = false })
end

Timer.start = function()
    timer:set_enabled(true)
end

Timer.stop = function()
    timer:set_enabled(false)
end

return Timer
