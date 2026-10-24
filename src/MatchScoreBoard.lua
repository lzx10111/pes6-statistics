local Data = _G.Classes.Data
local MatchScoreBoard = {}
MatchScoreBoard.__index = MatchScoreBoard

setmetatable(MatchScoreBoard, { __index = Data })

function MatchScoreBoard:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchScoreBoard:setData()
    self.goals = self:getGoals()
    self.totalgoals = self:getTotalgoals()
    self.penalties = self:getPenalties()
    self.foulKick = self:getFoulKick()
    self.assists = self:getAssists()
end

function MatchScoreBoard:getSimpleName()
    return "MatchScoreBoard"
end

function MatchScoreBoard:ignoredFields()
    return {"address"}
end

function MatchScoreBoard:getGoals()
    return self.address:readFieldByIndex(1)
end

function MatchScoreBoard:getTotalgoals()
    return self.address:readFieldByIndex(2)
end

function MatchScoreBoard:getPenalties()
    return self.address:readFieldByIndex(3)
end

function MatchScoreBoard:getFoulKick()
    return self.address:readFieldByIndex(4)
end

function MatchScoreBoard:getAssists()
    return self.address:readFieldByIndex(5)
end

return MatchScoreBoard
