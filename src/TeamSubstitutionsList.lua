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

function TeamSubstitutionsList:getTotalTeamSubstitutions()
    local address = self.address:AddOffsetToAddress(1)
    return readByte(address)
end

function TeamSubstitutionsList:getTeamSubstitutions()
    local address = self.address:AddOffsetToAddress(2)
    return self:getDoubleArrayFromAddress(address, self.totalTeamSubstitutions, 8, 4)
end

return TeamSubstitutionsList
