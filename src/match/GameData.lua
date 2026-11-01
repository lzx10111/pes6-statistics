local Data = _G.Classes.Data
local MatchSummaryStats = _G.Classes.MatchSummaryStats
local MatchDetails = _G.Classes.MatchDetails
local IndividualMatchData = _G.Classes.IndividualMatchData
local GameData = {}
GameData.__index = GameData

setmetatable(GameData, { __index = Data })

GameData.MatchSummaryStats = MatchSummaryStats
GameData.matchDetails = MatchDetails
GameData.individualMatchData = IndividualMatchData

function GameData:getSimpleName()
    return "GameData"
end

function GameData:getDataSize()
    return self:getFieldsTotalSize()
end

return GameData