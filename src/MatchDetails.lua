local Data = _G.Classes.Data
local Antecedent = _G.Classes.Antecedent
local MatchResultsHome = _G.Classes.MatchResultsHome
local MatchResultsAway = _G.Classes.MatchResultsAway
local HomeCardRegistration = _G.Classes.HomeCardRegistration
local MatchDetails = {}
MatchDetails.__index = MatchDetails

setmetatable(MatchDetails, { __index = Data })

MatchDetails.antecedent = Antecedent:new()
MatchDetails.matchResultsHome = MatchResultsHome
MatchDetails.matchResultsAway = MatchResultsAway
-- MatchDetails.homeCardRegistration = HomeCardRegistration:new()

function MatchDetails:setData()
    self:updateData()
end

function MatchDetails:getSimpleName()
    return "MatchDetails"
end

return MatchDetails