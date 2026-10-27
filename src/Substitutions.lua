local Data = _G.Classes.Data
local Address = _G.Classes.Address
local TeamSubstitutionsList = _G.Classes.TeamSubstitutionsList
local Substitutions = {}
Substitutions.__index = Substitutions

setmetatable(Substitutions, { __index = Data })

Substitutions.home = Address:build(TeamSubstitutionsList, "03BE0A78", { 0, 0xBBA})
Substitutions.away = Address:build(TeamSubstitutionsList, "03BE0A79", { 0, 0xC44})

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