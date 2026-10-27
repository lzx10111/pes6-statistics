local String = _G.Classes.String
local Bit = _G.Classes.Bit
local ByteDecoder = {}
ByteDecoder.__index = ByteDecoder

setmetatable(ByteDecoder, { __index = String })

function ByteDecoder:readBaseValueBasedOnParity(index1, index2)
    local byte1 = self.address:readFieldByIndex(index1)
    local byte2 = self.address:readFieldByIndex(index2)

    local is_odd = (byte1 >= 128)
    local base = byte2 % 32

    local value = base * 2
    if is_odd then
        value = value + 1
    end

    return value
end

function ByteDecoder:readBaseValueBasedOnFloatPattern(index1, index2)
    local byte1 = self.address:readFieldByIndex(index1)
    local byte2 = self.address:readFieldByIndex(index2)

    if not byte1 or not byte2 then return 0 end

    local w = byte1 + (byte2 * 256)
    local exponent = math.floor(w / 128) % 256
    local mantissa_bits = w % 128

    if exponent == 0 then
        return 0
    end

    return (1 + mantissa_bits / 128) * (2 ^ (exponent - 127))
end

function ByteDecoder:readBaseValueBasedOnPattern(index1, index2, divisor)
    local byte1 = self.address:readFieldByIndex(index1)
    local byte2 = self.address:readFieldByIndex(index2)

    local position = math.floor(byte1 / (divisor or 1))
    local loop_limit = (divisor == 32) and 8 or 16
    local loops = byte2 % loop_limit

    return (loops * 4) + position
end

function ByteDecoder:readBaseValueBasedOnPattern64(index1, index2)
    return self:readBaseValueBasedOnPattern(index1, index2, 64)
end

function ByteDecoder:readBaseValueBasedOnPattern32(index1, index2)
    return self:readBaseValueBasedOnPattern(index1, index2, 32)
end

function ByteDecoder:readBaseValueIgnoringParity(index, divisor)
    local byte1 = self.address:readFieldByIndex(index)

    if not byte1 then return 0 end
    divisor = divisor or 1

    local value = Bit.band(byte1, 0x7F)

    return math.floor(value / divisor)
end

function ByteDecoder:readBaseValueIgnoringParity2(index)
    return self:readBaseValueIgnoringParity(index, 2)
end

function ByteDecoder:readBaseValueIgnoringParity4(index)
    return self:readBaseValueIgnoringParity(index, 4)
end

function ByteDecoder:readBaseValueIgnoringParity8(index)
    return self:readBaseValueIgnoringParity(index, 8)
end

return ByteDecoder