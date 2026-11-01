local Data = _G.Classes.Data
local MatchFoulKicks = {}
MatchFoulKicks.__index = MatchFoulKicks

setmetatable(MatchFoulKicks, { __index = Data })

function MatchFoulKicks:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchFoulKicks:setData()
  self.numberOfFoulKick = self:getNumberOfFoulKick()
  self.directFoulKick = self:getDirectFoulKick()
  self.pass = self:getPass()
  self.shotsOnGoal = self:getShotsOnGoal()
  self.indirectFoulKick = self:getIndirectFoulKick()
end

function MatchFoulKicks:getSimpleName()
    return "MatchFoulKicks"
end

function MatchFoulKicks:ignoredFields()
    return {"address"}
end

function MatchFoulKicks:getNumberOfFoulKick()
    return self.address:readFieldByIndex(1)
end

function MatchFoulKicks:getDirectFoulKick()
    return self.address:readFieldByIndex(2)
end

function MatchFoulKicks:getPass()
    return self.address:readFieldByIndex(3)
end

function MatchFoulKicks:getShotsOnGoal()
    return self.address:readFieldByIndex(4)
end

function MatchFoulKicks:getIndirectFoulKick()
    return self.address:readFieldByIndex(5)
end

return MatchFoulKicks
