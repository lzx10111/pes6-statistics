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
    local byte1 = self.address:readFieldByIndex(1)
    local byte2 = self.address:readFieldByIndex(2)

    local passes_position = math.floor(byte1 / 64)
    local passes_loops = byte2 % 16

    return (passes_loops * 4) + passes_position
end

function MatchPlayerPass:getCrossPasses()
    local originalValue = self.address:readFieldByIndex(4)
    return self:getMaskedStat(originalValue, 4)
end

function MatchPlayerPass:getSuccesses()
    return self.address:readFieldByIndex(3)
end

return MatchPlayerPass