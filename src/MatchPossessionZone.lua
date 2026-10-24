local Data = _G.Classes.Data
local MatchPossessionZone = {}
MatchPossessionZone.__index = MatchPossessionZone

setmetatable(MatchPossessionZone, { __index = Data })

function MatchPossessionZone:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPossessionZone:setData()
    self.number = self:getNumber()
end

function MatchPossessionZone:getSimpleName()
    return "MatchPossessionZone"
end

function MatchPossessionZone:ignoredFields()
    return {"address"}
end

function MatchPossessionZone:getNumber()
    return self.address:readFieldByIndex(1)
end

return MatchPossessionZone
