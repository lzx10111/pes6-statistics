local Data = _G.Classes.Data
local MatchPassesCut = {}
MatchPassesCut.__index = MatchPassesCut

setmetatable(MatchPassesCut, { __index = Data })

function MatchPassesCut:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPassesCut:setData()
    self.numberOfPassesCut = self:getNumberOfPassesCut()
end

function MatchPassesCut:getSimpleName()
    return "MatchPassesCut"
end

function MatchPassesCut:ignoredFields()
    return {"address"}
end

function MatchPassesCut:getNumberOfPassesCut()
    return self.address:readByTypeIntegerWithIndex(1)
end

return MatchPassesCut
