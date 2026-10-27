local Data = _G.Classes.Data
local Bit = _G.Classes.Bit
local MatchPlayerFouls = {}
MatchPlayerFouls.__index = MatchPlayerFouls

setmetatable(MatchPlayerFouls, { __index = Data })

function MatchPlayerFouls:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPlayerFouls:setData()
    self.fouls = self:getFouls()
    self.directFouls = self:getDirectFouls()
    self.indirectFouls = self:getIndirectFouls()
    self.offside = self:getOffside()
    self.yellowCards = self:getYellowCards()
    self.redCards = self:getRedCards()
end

function MatchPlayerFouls:getSimpleName()
    return "MatchPlayerFouls"
end

function MatchPlayerFouls:ignoredFields()
    return {"address"}
end

function MatchPlayerFouls:getFouls()
    return self:readBaseValueIgnoringParity2(1)
end

function MatchPlayerFouls:getDirectFouls()
    return self.address:readFieldByIndex(2)
end

function MatchPlayerFouls:getIndirectFouls()
    local byte1 = self.address:readFieldByIndex(3)
    if not byte1 then return 0 end

    if byte1 >= 0x80 then
        return byte1 - 0x80
    else
        return byte1
    end
end

function MatchPlayerFouls:getOffside()
    local byte1 = self.address:readFieldByIndex(3)
    local byte2 = self.address:readFieldByIndex(4)
    if not byte1 or not byte2 then return 0 end

    local lowNibbleSecond = Bit.band(byte2, 0x0F)
    local baseOffsides = 0

    if lowNibbleSecond >= 8 then
        baseOffsides = (lowNibbleSecond - 8) * 2
    else
        baseOffsides = lowNibbleSecond * 2
    end

    local highNibbleFirst = Bit.rshift(Bit.band(byte1, 0xF0), 4)
    local isOdd = Bit.band(highNibbleFirst, 0x08) == 0x08

    local totalOffsides = baseOffsides
    if isOdd then
        totalOffsides = totalOffsides + 1
    end

    return totalOffsides
end

function MatchPlayerFouls:getYellowCards()
    local byte1 = self.address:readFieldByIndex(4)
    if not byte1 then return 0 end
    return Bit.rshift(Bit.band(byte1, 0xF0), 4)
end

function MatchPlayerFouls:getRedCards()
    local byte1 = self.address:readFieldByIndex(4)
    if not byte1 then return 0 end
    local lowNibble = Bit.band(byte1, 0x0F)
    if lowNibble >= 8 then
        return 1
    else
        return 0
    end
end

return MatchPlayerFouls