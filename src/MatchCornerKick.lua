local Data = _G.Classes.Data
local MatchCornerKick = {}
MatchCornerKick.__index = MatchCornerKick

setmetatable(MatchCornerKick, { __index = Data })

function MatchCornerKick:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchCornerKick:setData()
    self.cornerKickTotal = self:getCornerKickTotal()
    self.cornerKickLeft = self:getCornerKickLeft()
    self.cornerKickRight = self:getCornerKickRight()
end

function MatchCornerKick:getSimpleName()
    return "MatchCornerKick"
end

function MatchCornerKick:ignoredFields()
    return {"address"}
end

function MatchCornerKick:getCornerKickTotal()
    return self.address:readByTypeIntegerWithIndex(1)
end

function MatchCornerKick:getCornerKickLeft()
    return self.address:readByTypeIntegerWithIndex(2)
end

function MatchCornerKick:getCornerKickRight()
    return self.address:readByTypeIntegerWithIndex(3)
end

return MatchCornerKick
