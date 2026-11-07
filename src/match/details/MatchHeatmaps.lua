local Data = _G.Classes.Data
local Address = _G.Classes.Address
local Math = _G.Classes.Math
local MatchIntervalHeatmaps = _G.Classes.MatchIntervalHeatmaps
local MatchTacticalHeatmaps = _G.Classes.MatchTacticalHeatmaps
local MatchHeatmaps = {}
MatchHeatmaps.__index = MatchHeatmaps

setmetatable(MatchHeatmaps, { __index = Data })

function MatchHeatmaps:new(o)
    o = o or {}
    setmetatable(o, self)

    o.matchTactical = Address:build(MatchTacticalHeatmaps, o.address:addOffsetToAddress(1), { 0, 18, 0, 0 }, nil, 0)
    o.matchInterval = Address:build(MatchIntervalHeatmaps, o.address:addOffsetToAddress(2), Math.multiples(96, 10), nil, 0)

    return o
end

function MatchHeatmaps:setData()
    if self.matchTactical then
        self.matchTactical:setData()
    end
    if self.matchInterval then
        self.matchInterval:setData()
    end
end

function MatchHeatmaps:getSimpleName()
    return "MatchHeatmaps"
end

function MatchHeatmaps:ignoredFields()
    return {"address"}
end

return MatchHeatmaps