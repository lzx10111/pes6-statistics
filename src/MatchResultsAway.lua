local Data = _G.Classes.Data
local MatchStats = _G.Classes.MatchStats

MatchResultsAway = {}
MatchResultsAway.__index = MatchResultsAway

setmetatable(MatchResultsAway, { __index = Data })

MatchResultsAway.matchStats = MatchStats:new({baseAddress = "010D0D8C"})

function MatchResultsAway:setData()
    if self.matchStats then
        self.matchStats:setData()
    end
end

function MatchResultsAway:getSimpleName()
    return "MatchResultsAway"
end

return MatchResultsAway