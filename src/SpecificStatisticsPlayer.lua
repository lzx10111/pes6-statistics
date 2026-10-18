local RootClass = dofile('C:/Users/PC/Documents/pro_est_pes6/class/RootClass.lua')
local Address = dofile('C:/Users/PC/Documents/pro_est_pes6/class/AddressClass.lua')
local ScoreBoard = dofile('C:/Users/PC/Documents/pro_est_pes6/class/SpecificStatisticsScoreBoard.lua')
local ShotsOnGoal = dofile('C:/Users/PC/Documents/pro_est_pes6/class/SpecificStatisticsShotsOnGoal.lua')
local Pass = dofile('C:/Users/PC/Documents/pro_est_pes6/class/SpecificStatisticsPass.lua')
local PassesCut = dofile('C:/Users/PC/Documents/pro_est_pes6/class/SpecificStatisticsPassesCut.lua')
local CornerKick = dofile('C:/Users/PC/Documents/pro_est_pes6/class/SpecificStatisticsCornerKick.lua')
local Fouls = dofile('C:/Users/PC/Documents/pro_est_pes6/class/SpecificStatisticsFouls.lua')
local FoulKicks = dofile('C:/Users/PC/Documents/pro_est_pes6/class/SpecificStatisticsFoulKicks.lua')
local Dribbling = dofile('C:/Users/PC/Documents/pro_est_pes6/class/SpecificStatisticsDribbling.lua')
local PossessionZone = dofile('C:/Users/PC/Documents/pro_est_pes6/class/SpecificStatisticsPossessionZone.lua')

local SpecificStatistics = RootClass:new()

function SpecificStatistics:updateObjFromGame()
  self.scoreBoardObj = self:getScoreBoardObj()
  self.shotsOnGoalObj = self:getShotsOnGoalObj()
  self.passObj = self:getPassObj()
  self.passesCutObj = self:getPassesCutObj()
  self.cornerKickObj = self:getCornerKickObj()
  self.foulsObj = self:getFoulsObj()
  self.foulKicksObj = self:getFoulKicksObj()
  self.dribblingObj = self:getDribblingObj()
  self.possessionZoneObj = self:getPossessionZoneObj()
end

function SpecificStatistics:getSimpleName()
  return "SpecificStatistics"
end

function SpecificStatistics:getScoreBoardObj() -- falta saque de falta solamente!
  local obj = ScoreBoard:new()
  local addressObj = Address:new()
  local address = self:getAddressObj():AddValueToAddress(32)
  local typeValue = {1, 1, 1, 1, 1}
  local offset = {0, 1, 2, 3, 4}

  addressObj:setAddressFields(address, typeValue, offset)
  obj:setAddressObj(addressObj)
  obj:createObjFromGame()

  return obj
end

function SpecificStatistics:getShotsOnGoalObj() --complete!
  local obj = ShotsOnGoal:new()
  local addressObj = Address:new()
  local address = self:getAddressObj():AddValueToAddress(39)
  local typeValue = {1, 1, 1, 1, 1, 1, 1}
  local offset = {0, 1, 2, 3, 4, 5, 6}

  addressObj:setAddressFields(address, typeValue, offset)
  obj:setAddressObj(addressObj)
  obj:createObjFromGame()

  return obj
end

function SpecificStatistics:getPassObj() --complete!
  local obj = Pass:new()
  local addressObj = Address:new()
  local address = self:getAddressObj():AddValueToAddress(46)
  local typeValue = {1, 1, 1}
  local offset = {0, 1, 2}

  addressObj:setAddressFields(address, typeValue, offset)
  obj:setAddressObj(addressObj)
  obj:createObjFromGame()

  return obj
end

function SpecificStatistics:getPassesCutObj() --complete!
  local obj = PassesCut:new()
  local addressObj = Address:new()
  local address = self:getAddressObj():AddValueToAddress(63)
  local typeValue = {1}
  local offset = {0}

  addressObj:setAddressFields(address, typeValue, offset)
  obj:setAddressObj(addressObj)
  obj:createObjFromGame()

  return obj
end

function SpecificStatistics:getCornerKickObj() --complete!
  local obj = CornerKick:new()
  local addressObj = Address:new()
  local address = self:getAddressObj():AddValueToAddress(60)
  local typeValue = {1, 1, 1}
  local offset = {0, 2, 1}

  addressObj:setAddressFields(address, typeValue, offset)
  obj:setAddressObj(addressObj)
  obj:createObjFromGame()

  return obj
end

function SpecificStatistics:getFoulsObj() --complete
  local obj = Fouls:new()
  local addressObj = Address:new()
  local address = self:getAddressObj():AddValueToAddress(49)
  local typeValue = {1, 1, 1, 1, 1, 1}
  local offset = {0, 1, 2, 3, 5, 4}

  addressObj:setAddressFields(address, typeValue, offset)
  obj:setAddressObj(addressObj)
  obj:createObjFromGame()

  return obj
end

function SpecificStatistics:getFoulKicksObj() -- falta sf directo solamente!
  local obj = FoulKicks:new()
  local addressObj = Address:new()
  local address = self:getAddressObj():AddValueToAddress(56)
  local typeValue = {1, 1, 1, 1, 1}
  local offset = {0, 1, 1, 2, 3}

  addressObj:setAddressFields(address, typeValue, offset)
  obj:setAddressObj(addressObj)
  obj:createObjFromGame()

  return obj
end

function SpecificStatistics:getDribblingObj() --complete!
  local obj = Dribbling:new()
  local addressObj = Address:new()
  local address = self:getAddressObj():AddValueToAddress(0)
  local typeValue = {1, 2}
  local offset = {28, 0}

  addressObj:setAddressFields(address, typeValue, offset)
  obj:setAddressObj(addressObj)
  obj:createObjFromGame()

  return obj
end

function SpecificStatistics:getPossessionZoneObj() --complete!
  local obj = PossessionZone:new()
  local addressObj = Address:new()
  local address = self:getAddressObj():AddValueToAddress(38)
  local typeValue = {1}
  local offset = {0}

  addressObj:setAddressFields(address, typeValue, offset)
  obj:setAddressObj(addressObj)
  obj:createObjFromGame()

  return obj
end

return SpecificStatistics