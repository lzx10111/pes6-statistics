local Data = _G.Classes.Data
local MatchPlayerHeatmap = {}
MatchPlayerHeatmap.__index = MatchPlayerHeatmap

setmetatable(MatchPlayerHeatmap, { __index = Data })

function MatchPlayerHeatmap:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPlayerHeatmap:setData()
    self.playZone = self:getPlayZone()
    self.shotZone = self:getShotZone()
    self.possessionZone = self:getPossessionZone()
end

function MatchPlayerHeatmap:getSimpleName()
    return "MatchPlayerHeatmap"
end

function MatchPlayerHeatmap:ignoredFields()
    return {"address"}
end

function MatchPlayerHeatmap:getPlayZone()
    local address = self.address:addOffsetToAddress(1)
    return self:getArrayFromAddress(address, 18, 1, 1)
end

function MatchPlayerHeatmap:getShotZone()
    local address = self.address:addOffsetToAddress(2)
    return self:getArrayFromAddress(address, 18, 1, 1)
end

function MatchPlayerHeatmap:getPossessionZone()
    local address = self.address:addOffsetToAddress(3)
    return self:getArrayFromAddress(address, 18, 1, 1)
end

return MatchPlayerHeatmap