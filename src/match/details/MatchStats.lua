local Data = _G.Classes.Data
local Address = _G.Classes.Address
local Math = _G.Classes.Math
local MatchHeatmaps = _G.Classes.MatchHeatmaps
local MatchCornerKick = _G.Classes.MatchCornerKick
local MatchDribbling = _G.Classes.MatchDribbling
local MatchFoulKicks = _G.Classes.MatchFoulKicks
local MatchFouls = _G.Classes.MatchFouls
local MatchPass = _G.Classes.MatchPass
local MatchPassesCut = _G.Classes.MatchPassesCut
local MatchPossessionZone = _G.Classes.MatchPossessionZone
local MatchScoreBoard = _G.Classes.MatchScoreBoard
local MatchShotsOnGoal = _G.Classes.MatchShotsOnGoal
local MatchStats = {}
MatchStats.__index = MatchStats

setmetatable(MatchStats, { __index = Data })

function MatchStats:new(o)
    o = o or {}
    setmetatable(o, self)

    local offsetsHeatmap = {}

    if o.side == "home" then
        offsetsHeatmap = {134, 296}
    elseif o.side == "away" then
        offsetsHeatmap = {164, 1196}
    end

    o.matchHeatmaps = Address:build(MatchHeatmaps, o.baseAddress, offsetsHeatmap, nil, 0)
    o.matchCornerKick = Address:build(MatchCornerKick, o.baseAddress, { 0, 2, 1 }, Math.replicate(1, 3), 33)
    o.matchDribbling = Address:build(MatchDribbling, o.baseAddress, { 0, 2 }, { 2, 2 }, 42)
    o.matchFoulKicks = Address:build(MatchFoulKicks, o.baseAddress, Math.multiples(1, 5), Math.replicate(1, 5), 36)
    o.matchFouls = Address:build(MatchFouls, o.baseAddress, Math.multiples(1, 6), Math.replicate(1, 6), 28)
    o.matchPass = Address:build(MatchPass, o.baseAddress, { 0, 4, 2 }, { 2, 1, 2 }, 22)
    o.matchPassesCut = Address:build(MatchPassesCut, o.baseAddress, { 0 }, { 1 }, 27)
    o.matchPossessionZone = Address:build(MatchPossessionZone, o.baseAddress, { 0 }, { 2 }, 0)
    o.matchScoreBoard = Address:build(MatchScoreBoard, o.baseAddress, { 0, 4, 5, 10 }, Math.replicate(1, 4), 2)
    o.matchShotsOnGoal = Address:build(MatchShotsOnGoal, o.baseAddress, Math.multiples(1, 7), Math.replicate(1, 7), 14)

    return o
end

function MatchStats:setData()
    self:updateData()
end

function MatchStats:getSimpleName()
    return "MatchStats"
end

function MatchStats:ignoredFields()
    return {"baseAddress"}
end

return MatchStats