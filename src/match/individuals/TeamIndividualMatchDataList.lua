local Data = _G.Classes.Data
local Address = _G.Classes.Address
local Substitutions = _G.Classes.Substitutions
local PlayerMatchStats = _G.Classes.PlayerMatchStats
local TeamIndividualMatchDataList = {}
TeamIndividualMatchDataList.__index = TeamIndividualMatchDataList

setmetatable(TeamIndividualMatchDataList, { __index = Data })

function TeamIndividualMatchDataList:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function TeamIndividualMatchDataList:setData()
    self.playersMatchStats = self:getPlayersMatchStats()
end

function TeamIndividualMatchDataList:getSimpleName()
    return "TeamIndividualMatchDataList"
end

function TeamIndividualMatchDataList:ignoredFields()
    return {"address"}
end

function TeamIndividualMatchDataList:getPlayersMatchStats()
    Substitutions:setData()
    local totalSubstitutions = 0

    if self.side == "home" then
        totalSubstitutions = Substitutions.home.totalTeamSubstitutions
    elseif self.side == "away" then
        totalSubstitutions = Substitutions.away.totalTeamSubstitutions
    end

    local totalPlayers = 11 + totalSubstitutions
    local actualAddress = self.baseAddress
    local arr = {}

    for i=1, totalPlayers do
        arr[i] = PlayerMatchStats:new({baseAddress = actualAddress})
        arr[i]:setData()
        actualAddress = Address.add(actualAddress, 104)
    end

    return arr
end

return TeamIndividualMatchDataList