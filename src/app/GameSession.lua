local Data = _G.Classes.Data
local GameSession = {
    status = {
        isGameRunning = false,
        startTime = nil,
        endTime = nil,
        startTimestamp = 0,
        endTimestamp = 0,
        sessionDuration = 0
    }
}

GameSession.__index = GameSession

setmetatable(GameSession, { __index = Data })

function GameSession:setGameOpened()
    local currentTimestamp = os.time()

    self.status.isGameRunning = true
    self.status.startTime = os.date("%Y-%m-%d %H:%M:%S", currentTimestamp)
    self.status.startTimestamp = currentTimestamp

    self.status.endTime = nil
    self.status.endTimestamp = 0
    self.status.sessionDuration = 0
end

function GameSession:setGameClosed()
    local currentTimestamp = os.time()

    self.status.isGameRunning = false
    self.status.endTime = os.date("%Y-%m-%d %H:%M:%S", currentTimestamp)
    self.status.endTimestamp = currentTimestamp

    if self.status.startTimestamp and self.status.startTimestamp > 0 then
        self.status.sessionDuration = os.difftime(self.status.endTimestamp, self.status.startTimestamp)
    end
end

return GameSession