local Data = _G.Classes.Data
local MatchSummaryStats = _G.Classes.MatchSummaryStats
local MatchDetails = _G.Classes.MatchDetails
local PlayerMatchStats = _G.Classes.PlayerMatchStats
local GameData = {}
GameData.__index = GameData

setmetatable(GameData, { __index = Data })

GameData.MatchSummaryStats = MatchSummaryStats
GameData.matchDetails = MatchDetails
GameData.playerMatchStats1 = PlayerMatchStats:new({baseAddress = "010CFA4E"})
GameData.playerMatchStats2 = PlayerMatchStats:new({baseAddress = "010CF9E6"})
GameData.playerMatchStats3 = PlayerMatchStats:new({baseAddress = "010CF97E"})
GameData.playerMatchStats4 = PlayerMatchStats:new({baseAddress = "010CF916"})

function GameData:getSimpleName()
    return "GameData"
end

function GameData:getDataSize()
    return self:getFieldsTotalSize()
end

return GameData