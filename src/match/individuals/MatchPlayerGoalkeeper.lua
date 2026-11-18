local Data = _G.Classes.Data
local MatchPlayerGoalkeeper = {}
MatchPlayerGoalkeeper.__index = MatchPlayerGoalkeeper

setmetatable(MatchPlayerGoalkeeper, { __index = Data })

function MatchPlayerGoalkeeper:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPlayerGoalkeeper:setData()
    self.shotsOnGoalInArea  = self:getShotsOnGoalInArea()
    self.shotsOnGoalOutArea = self:getShotsOnGoalOutArea()
    self.missedShotsInArea  = self:getMissedShotsInArea()
    self.missedShotsOutArea = self:getMissedShotsOutArea()
    self.savesInArea        = self:getSavesInArea()
    self.savesOutArea       = self:getSavesOutArea()
    self.clearances         = self:getClearances()
    self.goalKicks          = self:getGoalKicks()

    self.shotsOnGoal        = self:getShotsOnGoal()
    self.missedShots        = self:getMissedShots()
    self.saves              = self:getSaves()
    self.opponentShots      = self:getOpponentShots()
end

function MatchPlayerGoalkeeper:getSimpleName()
    return "MatchPlayerGoalkeeper"
end

function MatchPlayerGoalkeeper:ignoredFields()
    return {"address"}
end

function MatchPlayerGoalkeeper:getShotsOnGoalInArea()
    return self.address:readFieldByIndex(1)
end

function MatchPlayerGoalkeeper:getShotsOnGoalOutArea()
    return self.address:readFieldByIndex(2)
end

function MatchPlayerGoalkeeper:getMissedShotsInArea()
    return self.address:readFieldByIndex(3)
end

function MatchPlayerGoalkeeper:getMissedShotsOutArea()
    return self.address:readFieldByIndex(4)
end

function MatchPlayerGoalkeeper:getSavesInArea()
    return self.address:readFieldByIndex(5)
end

function MatchPlayerGoalkeeper:getSavesOutArea()
    return self.address:readFieldByIndex(6)
end

function MatchPlayerGoalkeeper:getClearances()
    return self.address:readFieldByIndex(7)
end

function MatchPlayerGoalkeeper:getGoalKicks()
    return self.address:readFieldByIndex(8)
end

function MatchPlayerGoalkeeper:getShotsOnGoal()
    return self:getShotsOnGoalInArea() + self:getShotsOnGoalOutArea()
end

function MatchPlayerGoalkeeper:getMissedShots()
    return self:getMissedShotsInArea() + self:getMissedShotsOutArea()
end

function MatchPlayerGoalkeeper:getSaves()
    return self:getSavesInArea() + self:getSavesOutArea()
end

function MatchPlayerGoalkeeper:getOpponentShots()
    return self:getShotsOnGoal() + self:getMissedShots()
end

return MatchPlayerGoalkeeper