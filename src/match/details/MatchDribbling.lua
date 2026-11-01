local Data = _G.Classes.Data
local MatchDribbling = {}
MatchDribbling.__index = MatchDribbling

setmetatable(MatchDribbling, { __index = Data })

function MatchDribbling:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchDribbling:setData()
    self.number = self:getNumber()
    self.distanceTraveled = self:getDistanceTraveled()
end

function MatchDribbling:getSimpleName()
    return "MatchDribbling"
end

function MatchDribbling:ignoredFields()
    return {"address"}
end

function MatchDribbling:getNumber()
    return self.address:readFieldByIndex(1)
end

function MatchDribbling:getDistanceTraveled()
    return self.address:readFieldByIndex(2)
end

return MatchDribbling
