local Data = _G.Classes.Data
local MatchFouls = {}
MatchFouls.__index = MatchFouls

setmetatable(MatchFouls, { __index = Data })

function MatchFouls:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchFouls:setData()
    self.fouls = self:getFouls()
    self.directFouls = self:getDirectFouls()
    self.indirectFouls = self:getIndirectFouls()
    self.offside = self:getOffside()
    self.yellowCards = self:getYellowCards()
    self.redCards = self:getRedCards()
end

function MatchFouls:getSimpleName()
    return "MatchFouls"
end

function MatchFouls:ignoredFields()
    return {"address"}
end

function MatchFouls:getFouls()
    return self.address:readByTypeIntegerWithIndex(1)
end

function MatchFouls:getDirectFouls()
    return self.address:readByTypeIntegerWithIndex(2)
end

function MatchFouls:getIndirectFouls()
    return self.address:readByTypeIntegerWithIndex(3)
end

function MatchFouls:getOffside()
    return self.address:readByTypeIntegerWithIndex(4)
end

function MatchFouls:getYellowCards()
    return self.address:readByTypeIntegerWithIndex(5)
end

function MatchFouls:getRedCards()
    return self.address:readByTypeIntegerWithIndex(6)
end

return MatchFouls
