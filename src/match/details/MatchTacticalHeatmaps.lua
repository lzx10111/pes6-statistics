local Data = _G.Classes.Data
local Math = _G.Classes.Math

local MatchTacticalHeatmaps = {}
MatchTacticalHeatmaps.__index = MatchTacticalHeatmaps

setmetatable(MatchTacticalHeatmaps, { __index = Data })

function MatchTacticalHeatmaps:new(o)
    o = o or {}
    setmetatable(o, self)
    return o
end

function MatchTacticalHeatmaps:setData()
    self.throwInCountAddr:refresh()
    self.throwInArrayAddr:refresh()
    self.freeKickCountAddr:refresh()
    self.freeKickArrayAddr:refresh()

    self.offensiveZone = self:getOffensiveZone()
    self.defensiveZone = self:getDefensiveZone()

    -- 1. Primero se ejecutan los getters de contador (preparan offset y typeValue)
    self.throwInCount  = self:getThrowInCount()
    self.freeKickCount = self:getFreeKickCount()

    -- 2. Después se ejecutan los getters de las flechas ya configuradas
    self.throwIn  = self:getThrowIn()
    self.freeKick = self:getFreeKick()
end

function MatchTacticalHeatmaps:getSimpleName()
    return "MatchTacticalHeatmaps"
end

function MatchTacticalHeatmaps:ignoredFields()
    return {
        "address",
        "throwInCountAddr",
        "throwInArrayAddr",
        "freeKickCountAddr",
        "freeKickArrayAddr"
    }
end

function MatchTacticalHeatmaps:getOffensiveZone()
    local address = self.address:addOffsetToAddress(1)
    return self:getArrayFromAddress(address, 18, 1, 1)
end

function MatchTacticalHeatmaps:getDefensiveZone()
    local address = self.address:addOffsetToAddress(2)
    return self:getArrayFromAddress(address, 18, 1, 1)
end

function MatchTacticalHeatmaps:prepareArrowsAddress(countAddr, arrayAddr)
    local totalCount = countAddr:readFieldByIndex(1) or 0
    local visibleCount = Math.clamp(totalCount, 0, 10)
    local totalFloats = visibleCount * 4

    arrayAddr.offset = Math.multiples(4, totalFloats)
    arrayAddr.typeValue = Math.replicate(5, totalFloats)

    return totalCount
end

function MatchTacticalHeatmaps:getThrowInCount()
    return self:prepareArrowsAddress(self.throwInCountAddr, self.throwInArrayAddr)
end

function MatchTacticalHeatmaps:getFreeKickCount()
    return self:prepareArrowsAddress(self.freeKickCountAddr, self.freeKickArrayAddr)
end

function MatchTacticalHeatmaps:readPreparedArrows(arrayAddr)
    local arrows = {}
    local visibleCount = #arrayAddr.offset / 4

    for i = 0, visibleCount - 1 do
        local baseIdx = i * 4
        table.insert(arrows, {
            startX = arrayAddr:readFieldByIndex(baseIdx + 1),
            startY = arrayAddr:readFieldByIndex(baseIdx + 2),
            endX   = arrayAddr:readFieldByIndex(baseIdx + 3),
            endY   = arrayAddr:readFieldByIndex(baseIdx + 4)
        })
    end

    return arrows
end

function MatchTacticalHeatmaps:getThrowIn()
    return self:readPreparedArrows(self.throwInArrayAddr)
end

function MatchTacticalHeatmaps:getFreeKick()
    return self:readPreparedArrows(self.freeKickArrayAddr)
end

return MatchTacticalHeatmaps