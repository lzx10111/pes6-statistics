local Data = _G.Classes.Data
local MatchPlayerPass = {}
MatchPlayerPass.__index = MatchPlayerPass

setmetatable(MatchPlayerPass, { __index = Data })

function MatchPlayerPass:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPlayerPass:setData()
    self.passes = self:getPasses()
    self.crossPasses = self:getCrossPasses()
    self.successes = self:getSuccesses()
end

function MatchPlayerPass:getSimpleName()
    return "MatchPlayerPass"
end

function MatchPlayerPass:ignoredFields()
    return {"address"}
end

function MatchPlayerPass:getPasses()
    return self:readBaseValueBasedOnPattern64(1, 2)
end

function MatchPlayerPass:getCrossPasses()
    return self:readBaseValueIgnoringParity4(4)
end

function MatchPlayerPass:getSuccesses()
    return self.address:readFieldByIndex(3)
end

return MatchPlayerPass