local Data = _G.Classes.Data
local TeamSubstitutionsList = _G.Classes.TeamSubstitutionsList

local Substitutions = {}
Substitutions.__index = Substitutions

setmetatable(Substitutions, { __index = Data })

Substitutions.home = TeamSubstitutionsList:new("03BE0A78", "03BE1632")
Substitutions.away = TeamSubstitutionsList:new("03BE0A79", "03BE16BD")

function Substitutions:setData()
    if self.home then
        self.home:setData()
    end

    if self.away then
        self.away:setData()
    end
end

function Substitutions:getSimpleName()
    return "Substitutions"
end

return Substitutions