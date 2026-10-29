local Data = _G.Classes.Data
local TeamSubstitutionsList = {}
TeamSubstitutionsList.__index = TeamSubstitutionsList

setmetatable(TeamSubstitutionsList, { __index = Data })

function TeamSubstitutionsList:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function TeamSubstitutionsList:setData()
    self.totalTeamSubstitutions = self:getTotalTeamSubstitutions()
    self.teamSubstitutions = self:getTeamSubstitutions()
end

function TeamSubstitutionsList:getSimpleName()
    return "TeamSubstitutionsList"
end

function TeamSubstitutionsList:ignoredFields()
    return {"address"}
end

function TeamSubstitutionsList:getTotalTeamSubstitutions()
    return readByte(self.address:AddOffsetToAddress(1))
end

function TeamSubstitutionsList:getTeamSubstitutions()
    return self:getDoubleArrayFromAddress(self.address:AddOffsetToAddress(2), self:getTotalTeamSubstitutions(), 8, 1, 4)
end

return TeamSubstitutionsList
