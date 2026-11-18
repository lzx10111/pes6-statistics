local Data = _G.Classes.Data
local TeamGoalscorerItem = _G.Classes.TeamGoalscorerItem
local TeamGoalscorerList = {}
TeamGoalscorerList.__index = TeamGoalscorerList

setmetatable(TeamGoalscorerList, { __index = Data })

function TeamGoalscorerList:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function TeamGoalscorerList:setData()
    self.scorersCount = self:getScorersCount()
    self.players = self:getPlayers()
    self.goalCounts = self:getGoalCounts()
    self.minutes = self:getMinutes()
    self.goalscorers = self:getGoalscorers()
end

function TeamGoalscorerList:getSimpleName()
    return "TeamGoalscorerList"
end

function TeamGoalscorerList:ignoredFields()
    return { "address", "players", "goalCounts", "minutes" }
end

function TeamGoalscorerList:getScorersCount()
    return self.address:readFieldByIndex(1)
end

function TeamGoalscorerList:getPlayers()
    return self:getArrayFromAddress(self.address:addOffsetToAddress(2), self.scorersCount, 1, 1)
end

function TeamGoalscorerList:getGoalCounts()
    return self:getArrayFromAddress(self.address:addOffsetToAddress(3), self.scorersCount, 1, 1)
end

function TeamGoalscorerList:getMinutes()
    local address = self.address:addOffsetToAddress(4)
    local len = self.scorersCount
    local interval = 10
    local typeValue = 1
    local sublen = self.goalCounts
    local arr = {}

    for i = 1, len do
        arr[i] = self:getArrayFromAddress(address, sublen[i], 1, typeValue)
        address = string.format("%X", tonumber(address, 16) + interval)
    end

    return arr
end

function TeamGoalscorerList:getGoalscorers()
    local arr = {}
    local len = self.scorersCount

    for i = 1, len do
        arr[i] = TeamGoalscorerItem:new({
            player = self.players[i],
            goalCount = self.goalCounts[i],
            minutes = self.minutes[i]
        })
    end

    return arr
end

return TeamGoalscorerList
