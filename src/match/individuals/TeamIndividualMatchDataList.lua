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
    Substitutions:setData()
    self.startingLineup    = self:getStartingLineup()
    self.playersMatchStats = self:getPlayersMatchStats()
end

function TeamIndividualMatchDataList:getSimpleName()
    return "TeamIndividualMatchDataList"
end

function TeamIndividualMatchDataList:ignoredFields()
    return { "address" }
end

function TeamIndividualMatchDataList:getStartingLineup()
    local subsBaseAddress = nil

    if self.side == "home" and Substitutions.home and Substitutions.home.listAddress then
        subsBaseAddress = Substitutions.home.listAddress.address
    elseif self.side == "away" and Substitutions.away and Substitutions.away.listAddress then
        subsBaseAddress = Substitutions.away.listAddress.address
    end

    if not subsBaseAddress then
        return {}
    end

    -- En memoria de PES 6, la alineacion titular (11 bytes) esta exactamente 75 bytes (-0x4B)
    -- antes de listAddress de cada equipo (03BE1632 - 0x4B = 03BE15E7; 03BE16BD - 0x4B = 03BE1672)
    local lineupAddress = Address.add(subsBaseAddress, -75)
    return self:getArrayFromAddress(lineupAddress, 11, 1, 1)
end

function TeamIndividualMatchDataList:getPlayersMatchStats()
    local totalSubstitutions = 0

    if self.side == "home" and Substitutions.home then
        totalSubstitutions = Substitutions.home.totalSubstitutions
    elseif self.side == "away" and Substitutions.away then
        totalSubstitutions = Substitutions.away.totalSubstitutions
    end

    local totalPlayers = 11 + totalSubstitutions
    local actualAddress = self.baseAddress
    local arr = {}

    for i = 1, totalPlayers do
        if i == 1 then
            arr[i] = PlayerMatchStats:new({ baseAddress = actualAddress, isGoalkeeper = true })
        else
            arr[i] = PlayerMatchStats:new({ baseAddress = actualAddress })
        end

        arr[i]:setData()
        actualAddress = Address.add(actualAddress, 104)
    end

    return arr
end

return TeamIndividualMatchDataList