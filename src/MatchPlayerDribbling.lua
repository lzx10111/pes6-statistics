local Data = _G.Classes.Data
local MatchPlayerDribbling = {}
MatchPlayerDribbling.__index = MatchPlayerDribbling

setmetatable(MatchPlayerDribbling, { __index = Data })

function MatchPlayerDribbling:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPlayerDribbling:setData()
    self.number = self:getNumber()
    self.distanceTraveled = self:getDistanceTraveled()
end

function MatchPlayerDribbling:getSimpleName()
    return "MatchPlayerDribbling"
end

function MatchPlayerDribbling:ignoredFields()
    return {"address"}
end

function MatchPlayerDribbling:getNumber()
    return self.address:readFieldByIndex(1)
end

function MatchPlayerDribbling:getDistanceTraveled()
    return self.address:readFieldByIndex(2)
end

return MatchPlayerDribbling