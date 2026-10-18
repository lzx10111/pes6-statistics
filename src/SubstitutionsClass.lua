local RootClass = dofile('C:/Users/PC/Documents/pro_est_pes6/class/RootClass.lua')

local Substitutions = RootClass:new()

function Substitutions:updateObjFromGame()
  self.substitutionsTeamA = self:getSubstitutionsTeamA()
  self.substitutionsTeamB = self:getSubstitutionsTeamB()
  self.totalSubstitutionsTeamA = self:getTotalSubstitutionsTeamA()
  self.totalSubstitutionsTeamB = self:getTotalSubstitutionsTeamB()
end

function Substitutions:getSimpleName()
  return "Substitutions"
end

function Substitutions:getSubstitutionsTeamA()
  return self:getDoubleArrayFromAddress("03BE1632", self:getTotalSubstitutionsTeamA(), 8, 4)
end

function Substitutions:getSubstitutionsTeamB()
  return self:getDoubleArrayFromAddress("03BE16BD", self:getTotalSubstitutionsTeamB(), 8, 4)
end

function Substitutions:getTotalSubstitutionsTeamA()
  return readShortInteger("03BE0A78")
end

function Substitutions:getTotalSubstitutionsTeamB()
  return readShortInteger("03BE0A79")
end

return Substitutions