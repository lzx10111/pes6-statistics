local Data = _G.Classes.Data
local MatchIntervalHeatmaps = {}
MatchIntervalHeatmaps.__index = MatchIntervalHeatmaps

setmetatable(MatchIntervalHeatmaps, { __index = Data })

function MatchIntervalHeatmaps:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchIntervalHeatmaps:setData()
    self.interval0to15 = self:getInterval0to15()
    self.interval15to30 = self:getInterval15to30()
    self.interval30to45 = self:getInterval30to45()
    self.interval45to60 = self:getInterval45to60()
    self.interval60to75 = self:getInterval60to75()
    self.interval75to90 = self:getInterval75to90()
    self.interval0to45 = self:getInterval0to45()
    self.interval45to90 = self:getInterval45to90()
    self.interval90to105 = self:getInterval90to105()
    self.interval105to120 = self:getInterval105to120()
end

function MatchIntervalHeatmaps:getSimpleName()
    return "MatchIntervalHeatmaps"
end

function MatchIntervalHeatmaps:ignoredFields()
    return {"address"}
end

function MatchIntervalHeatmaps:getInterval0to15()
    local address = self.address:addOffsetToAddress(1)
    return self:getArrayFromAddress(address, 48, 2, 1)
end

function MatchIntervalHeatmaps:getInterval15to30()
    local address = self.address:addOffsetToAddress(2)
    return self:getArrayFromAddress(address, 48, 2, 1)
end

function MatchIntervalHeatmaps:getInterval30to45()
    local address = self.address:addOffsetToAddress(3)
    return self:getArrayFromAddress(address, 48, 2, 1)
end

function MatchIntervalHeatmaps:getInterval45to60()
    local address = self.address:addOffsetToAddress(4)
    return self:getArrayFromAddress(address, 48, 2, 1)
end

function MatchIntervalHeatmaps:getInterval60to75()
    local address = self.address:addOffsetToAddress(5)
    return self:getArrayFromAddress(address, 48, 2, 1)
end

function MatchIntervalHeatmaps:getInterval75to90()
    local address = self.address:addOffsetToAddress(6)
    return self:getArrayFromAddress(address, 48, 2, 1)
end

function MatchIntervalHeatmaps:getInterval0to45()
    local address = self.address:addOffsetToAddress(7)
    return self:getArrayFromAddress(address, 48, 2, 1)
end

function MatchIntervalHeatmaps:getInterval45to90()
    local address = self.address:addOffsetToAddress(8)
    return self:getArrayFromAddress(address, 48, 2, 1)
end

function MatchIntervalHeatmaps:getInterval90to105()
    local address = self.address:addOffsetToAddress(9)
    return self:getArrayFromAddress(address, 48, 2, 1)
end

function MatchIntervalHeatmaps:getInterval105to120()
    local address = self.address:addOffsetToAddress(10)
    return self:getArrayFromAddress(address, 48, 2, 1)
end

return MatchIntervalHeatmaps