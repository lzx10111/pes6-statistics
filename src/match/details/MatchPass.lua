local Data = _G.Classes.Data
local MatchPass = {}
MatchPass.__index = MatchPass

setmetatable(MatchPass, { __index = Data })

function MatchPass:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPass:setData()
    self.passes = self:getPasses()
    self.crossPasses = self:getCrossPasses()
    self.successes = self:getSuccesses()
end

function MatchPass:getSimpleName()
    return "MatchPass"
end

function MatchPass:ignoredFields()
    return {"address"}
end

function MatchPass:getPasses()
    return self.address:readFieldByIndex(1)
end

function MatchPass:getCrossPasses()
    return self.address:readFieldByIndex(2)
end

function MatchPass:getSuccesses()
    return self.address:readFieldByIndex(3)
end

return MatchPass
