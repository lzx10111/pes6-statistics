local Data = _G.Classes.Data
local MatchPlayerPerformance = {}
MatchPlayerPerformance.__index = MatchPlayerPerformance

setmetatable(MatchPlayerPerformance, { __index = Data })

function MatchPlayerPerformance:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPlayerPerformance:setData()
    self.classification = self:getClassification()
    self.minutes = self:getMinutes()
    self.position = self:getPosition()
end

function MatchPlayerPerformance:getSimpleName()
    return "MatchPlayerPerformance"
end

function MatchPlayerPerformance:ignoredFields()
    return {"address"}
end

function MatchPlayerPerformance:getClassification()
    local byte1 = self.address:readFieldByIndex(1)

    if byte1 == 0xF5 then
        return 0
    end

    return (byte1 & 0x0F) / 2
end

function MatchPlayerPerformance:getMinutes()
    local byte1 = self.address:readFieldByIndex(1)
    local byte2 = self.address:readFieldByIndex(2)

    if byte1 == 0xF5 and (byte2 & 0x0F) == 0x0F then
        return 0
    end

    local value1 = ((byte2 >> 4) & 0x0F) * 8
    local value2 = byte2 & 0x0F

    if (byte1 & 0x08) ~= 0 then
        value2 = value2 / 2
    else
        value2 = (value2 - 1) / 2
    end

    return value1 + value2
end

function MatchPlayerPerformance:getPosition()
    local byte1 = self.address:readFieldByIndex(2)
    return (byte1 >> 4) & 0x0F
end

return MatchPlayerPerformance