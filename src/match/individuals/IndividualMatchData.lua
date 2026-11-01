local Data = _G.Classes.Data
local TeamIndividualMatchDataList = _G.Classes.TeamIndividualMatchDataList
local IndividualMatchData = {}
IndividualMatchData.__index = IndividualMatchData

setmetatable(IndividualMatchData, { __index = Data })

IndividualMatchData.home = TeamIndividualMatchDataList:new({baseAddress = "010CF63E", side = "home"})
IndividualMatchData.away = TeamIndividualMatchDataList:new({baseAddress = "010CFD8E", side = "away"})

function IndividualMatchData:setData()
    if self.home then
        self.home:setData()
    end

    if self.away then
        self.away:setData()
    end
end

function IndividualMatchData:getSimpleName()
    return "IndividualMatchData"
end

return IndividualMatchData