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
    return self:readBaseValueIgnoringParity(1)
end

function MatchScoreBoard:getTotalgoals()
    return self:readBaseValueIgnoringParity(2)
end

function MatchScoreBoard:getPenalties()
    return self:readBaseValueIgnoringParity8(3)
end

function MatchScoreBoard:getFoulKick()
    return self:readBaseValueIgnoringParity2(4)
end

function MatchScoreBoard:getAssists()
    return self:readBaseValueIgnoringParity4(5)
end

return MatchScoreBoard