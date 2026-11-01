local Data = _G.Classes.Data
local Address = _G.Classes.Address
local MatchPlayerPerformance = _G.Classes.MatchPlayerPerformance
local MatchPlayerCornerKick = _G.Classes.MatchPlayerCornerKick
local MatchPlayerDribbling = _G.Classes.MatchPlayerDribbling
local MatchPlayerFoulKicks = _G.Classes.MatchPlayerFoulKicks
local MatchPlayerFouls = _G.Classes.MatchPlayerFouls
local MatchPlayerPass = _G.Classes.MatchPlayerPass
local MatchPlayerPassesCut = _G.Classes.MatchPlayerPassesCut
local MatchPlayerPossessionZone = _G.Classes.MatchPlayerPossessionZone
local MatchPlayerScoreBoard = _G.Classes.MatchPlayerScoreBoard
local MatchPlayerShotsOnGoal = _G.Classes.MatchPlayerShotsOnGoal
local PlayerMatchStats = {}
PlayerMatchStats.__index = PlayerMatchStats

setmetatable(PlayerMatchStats, { __index = Data })

function PlayerMatchStats:new(o)
    o = o or {}
    setmetatable(o, self)

    o.matchPerformance = Address:build(MatchPlayerPerformance, o.baseAddress, { 0, 1 }, { 1, 1 }, -2)
    o.matchCornerKick = Address:build(MatchPlayerCornerKick, o.baseAddress, { 0, 14, 15, 16 }, { 1, 1, 1, 1 }, 9)
    o.matchDribbling = Address:build(MatchPlayerDribbling, o.baseAddress, { 0, 5, 6 }, { 1, 1, 1 }, 31)
    o.matchFoulKicks = Address:build(MatchPlayerFoulKicks, o.baseAddress, { 0, 1, 2, 3 }, { 1, 1, 1, 1 }, 26)
    o.matchFouls = Address:build(MatchPlayerFouls, o.baseAddress, { 0, 1, 2, 3 }, { 1, 1, 1, 1 }, 20)
    o.matchPass = Address:build(MatchPlayerPass, o.baseAddress, { 0, 1, 2, 3 }, { 1, 1, 1, 1 }, 16)
    o.matchPassesCut = Address:build(MatchPlayerPassesCut, o.baseAddress, { 0 }, { 1 }, 30)
    o.matchPossessionZone = Address:build(MatchPlayerPossessionZone, o.baseAddress, { 0 }, { 2 }, 0)
    o.matchScoreBoard = Address:build(MatchPlayerScoreBoard, o.baseAddress, { 0, 1, 2, 3, 4 }, { 1, 1, 1, 1, 1 }, 2)
    o.matchShotsOnGoal = Address:build(MatchPlayerShotsOnGoal, o.baseAddress, { 0, 1, 2, 3, 4, 5, 6 }, { 1, 1, 1, 1, 1, 1, 1 }, 10)

    return o
end

function PlayerMatchStats:setData()
    self:updateData()
end

function PlayerMatchStats:getSimpleName()
    return "PlayerMatchStats"
end

function PlayerMatchStats:ignoredFields()
    return {"baseAddress"}
end

return PlayerMatchStats