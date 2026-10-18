local Data = _G.Classes.Data
local App = {
    status = {
        isGameRunning = false,
        startTime = nil,
        endTime = nil,
        startTimestamp = 0,
        endTimestamp = 0,
        sessionDuration = 0
    }
}

App.__index = App

setmetatable(App, { __index = Data })

function App:setGameOpened()
    local currentTimestamp = os.time()

    self.status.isGameRunning = true
    self.status.startTime = os.date("%Y-%m-%d %H:%M:%S", currentTimestamp)
    self.status.startTimestamp = currentTimestamp

    self.status.endTime = nil
    self.status.endTimestamp = 0
    self.status.sessionDuration = 0
end

function App:setGameClosed()
    local currentTimestamp = os.time()

    self.status.isGameRunning = false
    self.status.endTime = os.date("%Y-%m-%d %H:%M:%S", currentTimestamp)
    self.status.endTimestamp = currentTimestamp

    if self.status.startTimestamp and self.status.startTimestamp > 0 then
        self.status.sessionDuration = os.difftime(self.status.endTimestamp, self.status.startTimestamp)
    end
end

return App