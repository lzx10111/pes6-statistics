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
    return self.address:readFieldByIndex(1)
end

function MatchFouls:getDirectFouls()
    return self.address:readFieldByIndex(2)
end

function MatchFouls:getIndirectFouls()
    return self.address:readFieldByIndex(3)
end

function MatchFouls:getOffside()
    return self:readBaseValueIgnoringParity2(4)
end

function MatchFouls:getYellowCards()
    return self:readBaseValueIgnoringParity8(5)
end

function MatchFouls:getRedCards()
    return self.address:readFieldByIndex(5) % 8
end

return MatchFouls