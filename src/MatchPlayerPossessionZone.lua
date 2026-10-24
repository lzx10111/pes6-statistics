local Data = _G.Classes.Data
local MatchPlayerPossessionZone = {}
MatchPlayerPossessionZone.__index = MatchPlayerPossessionZone

setmetatable(MatchPlayerPossessionZone, { __index = Data })

function MatchPlayerPossessionZone:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPlayerPossessionZone:setData()
    self.number = self:getNumber()
end

function MatchPlayerPossessionZone:getSimpleName()
    return "MatchPlayerPossessionZone"
end

function MatchPlayerPossessionZone:ignoredFields()
    return {"address"}
end

function MatchPlayerPossessionZone:getNumber()
    return self.address:readFieldByIndex(1)
end

return MatchPlayerPossessionZone