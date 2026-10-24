local Data = _G.Classes.Data
local MatchPlayerCornerKick = {}
MatchPlayerCornerKick.__index = MatchPlayerCornerKick

setmetatable(MatchPlayerCornerKick, { __index = Data })

function MatchPlayerCornerKick:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPlayerCornerKick:setData()
    self.cornerKickTotal = self:getCornerKickTotal()
    self.cornerKickLeft = self:getCornerKickLeft()
    self.cornerKickRight = self:getCornerKickRight()
end

function MatchPlayerCornerKick:getSimpleName()
    return "MatchPlayerCornerKick"
end

function MatchPlayerCornerKick:ignoredFields()
    return {"address"}
end

function MatchPlayerCornerKick:getCornerKickTotal()
    return self.address:readFieldByIndex(1)
end

function MatchPlayerCornerKick:getCornerKickLeft()
    return self.address:readFieldByIndex(2)
end

function MatchPlayerCornerKick:getCornerKickRight()
    return self.address:readFieldByIndex(3)
end

return MatchPlayerCornerKick