local Data = _G.Classes.Data
local MatchShotsOnGoal = {}
MatchShotsOnGoal.__index = MatchShotsOnGoal

setmetatable(MatchShotsOnGoal, { __index = Data })

function MatchShotsOnGoal:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchShotsOnGoal:setData()
    self.shots = self:getShots()
    self.shotsOnGoal = self:getShotsOnGoal()
    self.goalkeeperSaves = self:getGoalkeeperSaves()
    self.inTheArea = self:getInTheArea()
    self.header = self:getHeader()
    self.rightFoot = self:getRightFoot()
    self.leftFoot = self:getLeftFoot()
end

function MatchShotsOnGoal:getSimpleName()
    return "MatchShotsOnGoal"
end

function MatchShotsOnGoal:ignoredFields()
    return {"address"}
end

function MatchShotsOnGoal:getShots()
    return self.address:readByTypeIntegerWithIndex(1)
end

function MatchShotsOnGoal:getShotsOnGoal()
  return self.address:readByTypeIntegerWithIndex(2)
end

function MatchShotsOnGoal:getGoalkeeperSaves()
    return self.address:readByTypeIntegerWithIndex(3)
end

function MatchShotsOnGoal:getInTheArea()
    return self.address:readByTypeIntegerWithIndex(4)
end

function MatchShotsOnGoal:getHeader()
    return self.address:readByTypeIntegerWithIndex(5)
end

function MatchShotsOnGoal:getRightFoot()
    return self.address:readByTypeIntegerWithIndex(6)
end

function MatchShotsOnGoal:getLeftFoot()
    return self.address:readByTypeIntegerWithIndex(7)
end

return MatchShotsOnGoal
