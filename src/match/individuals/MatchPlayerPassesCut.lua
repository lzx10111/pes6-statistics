local Data = _G.Classes.Data
local MatchPlayerPassesCut = {}
MatchPlayerPassesCut.__index = MatchPlayerPassesCut

setmetatable(MatchPlayerPassesCut, { __index = Data })

function MatchPlayerPassesCut:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPlayerPassesCut:setData()
    self.numberOfPassesCut = self:getNumberOfPassesCut()
end

function MatchPlayerPassesCut:getSimpleName()
    return "MatchPlayerPassesCut"
end

function MatchPlayerPassesCut:ignoredFields()
    return {"address"}
end

function MatchPlayerPassesCut:getNumberOfPassesCut()
    return self.address:readFieldByIndex(1)
end

return MatchPlayerPassesCut