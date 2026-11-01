local Data = _G.Classes.Data
local MatchPlayerFoulKicks = {}
MatchPlayerFoulKicks.__index = MatchPlayerFoulKicks

setmetatable(MatchPlayerFoulKicks, { __index = Data })

function MatchPlayerFoulKicks:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPlayerFoulKicks:setData()
  self.numberOfFoulKick = self:getNumberOfFoulKick()
  self.directFoulKick = self:getDirectFoulKick()
  self.pass = self:getPass()
  self.shotsOnGoal = self:getShotsOnGoal()
  self.indirectFoulKick = self:getIndirectFoulKick()
end

function MatchPlayerFoulKicks:getSimpleName()
    return "MatchPlayerFoulKicks"
end

function MatchPlayerFoulKicks:ignoredFields()
    return {"address"}
end

function MatchPlayerFoulKicks:getNumberOfFoulKick()
    return self:readBaseValueIgnoringParity(1)
end

function MatchPlayerFoulKicks:getDirectFoulKick()
    return self:readBaseValueIgnoringParity(2)
end

function MatchPlayerFoulKicks:getPass()
    return self:readBaseValueBasedOnParity(2, 3)
end

function MatchPlayerFoulKicks:getShotsOnGoal()
    return self:readBaseValueBasedOnPattern32(3, 4)
end

function MatchPlayerFoulKicks:getIndirectFoulKick()
    return self:readBaseValueIgnoringParity8(4)
end

return MatchPlayerFoulKicks