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

    local tacticalBase = o.address:addOffsetToAddress(1)
    local isAway = (tonumber(tacticalBase, 16) or 0) > 0x10D0DF0

    o.matchTactical = MatchTacticalHeatmaps:new({
        address           = Address:create(tacticalBase, { 0, 18 }, nil, 0),
        throwInCountAddr  = Address:create("pes6.exe+CD31D8", { 0 }, { 3 }, isAway and { "10" } or { "0" }),
        throwInArrayAddr  = Address:create("pes6.exe+CD31D8", nil, nil, isAway and { "14", "0" } or { "4", "0" }),
        freeKickCountAddr = Address:create("pes6.exe+CD31D8", { 0 }, { 3 }, isAway and { "18" } or { "8" }),
        freeKickArrayAddr = Address:create("pes6.exe+CD31D8", nil, nil, isAway and { "1C", "0" } or { "C", "0" })
    })

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