local Data = _G.Classes.Data
local MatchTacticalHeatmaps = {}
MatchTacticalHeatmaps.__index = MatchTacticalHeatmaps

setmetatable(MatchTacticalHeatmaps, { __index = Data })

function MatchTacticalHeatmaps:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchTacticalHeatmaps:setData()
    self.offensiveZone = self:getOffensiveZone()
    self.defensiveZone = self:getDefensiveZone()
    self.throwIn = self:getThrowIn()
    self.freeKick = self:getFreeKick()
end

function MatchTacticalHeatmaps:getSimpleName()
    return "MatchTacticalHeatmaps"
end

function MatchTacticalHeatmaps:ignoredFields()
    return {"address"}
end

function MatchTacticalHeatmaps:getOffensiveZone()
    local address = self.address:addOffsetToAddress(1)
    return self:getArrayFromAddress(address, 18, 1, 1)
end

function MatchTacticalHeatmaps:getDefensiveZone()
    local address = self.address:addOffsetToAddress(2)
    return self:getArrayFromAddress(address, 18, 1, 1)
end

function MatchTacticalHeatmaps:getThrowIn() -- Incomplete
    local address = self.address:addOffsetToAddress(3)
    return self:getArrayFromAddress(address, 96, 2, 1)
end

function MatchTacticalHeatmaps:getFreeKick() -- Incomplete
    local address = self.address:addOffsetToAddress(4)
    return self:getArrayFromAddress(address, 96, 2, 1)
end

return MatchTacticalHeatmaps