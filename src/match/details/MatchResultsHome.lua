local Data = _G.Classes.Data
local MatchStats = _G.Classes.MatchStats

MatchResultsHome = {}
MatchResultsHome.__index = MatchResultsHome

setmetatable(MatchResultsHome, { __index = Data })

MatchResultsHome.matchStats = MatchStats:new({baseAddress = "010D0D50"})

function MatchResultsHome:setData()
    if self.matchStats then
        self.matchStats:setData()
    end
end

function MatchResultsHome:getSimpleName()
    return "MatchResultsHome"
end

return MatchResultsHome