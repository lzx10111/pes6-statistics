local Data = _G.Classes.Data
local Antecedent = _G.Classes.Antecedent
local Goalscorers = _G.Classes.Goalscorers
local PossessionHistory = _G.Classes.PossessionHistory
local Substitutions = _G.Classes.Substitutions
local MatchResultsHome = _G.Classes.MatchResultsHome
local MatchResultsAway = _G.Classes.MatchResultsAway
local CardRegistration = _G.Classes.CardRegistration
local MatchDetails = {}
MatchDetails.__index = MatchDetails

setmetatable(MatchDetails, { __index = Data })

MatchDetails.antecedent = Antecedent:new()
MatchDetails.goalscorers = Goalscorers
MatchDetails.possessionHistory = PossessionHistory
MatchDetails.substitutions = Substitutions
MatchDetails.matchResultsHome = MatchResultsHome
MatchDetails.matchResultsAway = MatchResultsAway
MatchDetails.cardRegistration = CardRegistration

function MatchDetails:setData()
    self:updateData()
end

function MatchDetails:getSimpleName()
    return "MatchDetails"
end

return MatchDetails