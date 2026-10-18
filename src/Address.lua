local String = _G.Classes.String
local Address = {}
Address.__index = Address

setmetatable(Address, { __index = String })

function Address:new(o)
    o = o or {}
    setmetatable(o, self)
    return o
end

function Address:build(TargetClass, baseAddress, offsets, typeValues, addValue)
    local finalAddress = baseAddress

    if addValue then
        finalAddress = Address.add(baseAddress, addValue)
    end

    local finalOffsets = offsets or {}
    local finalTypeValues = typeValues or {}

    local addrObj = self:new({
        address = finalAddress,
        typeValue = finalTypeValues,
        offset = finalOffsets
    })

    return TargetClass:new({ address = addrObj })
end

function Address:getSimpleName()
    return "Address"
end

function Address:setPointer(address, offset)
    local value = ""

    self:setAddress(address)
    for i = 1, #offset do
        value = self:readByTypeInteger(3, self:getAddress())
        value = string.format("%X", value)
        self:setAddress(value)
        self:setAddress(self:AddValueToAddress(tonumber(offset[i], 16)))
    end
end

function Address:AddValueToAddress(value)
    return Address.add(self.address, value)
end

function Address:AddOffsetToAddress(value)
    local offset = self.offset[value]
    if offset == nil then return nil end
    return Address.add(self.address, offset)
end

function Address:readByTypeIntegerWithIndex(index)
    local typeValue = self.typeValue[index]
    local address = self:AddOffsetToAddress(index)
    if typeValue == nil or address == nil then return nil end
    return self:readByTypeInteger(typeValue, address)
end

function Address.add(hexAddress, valueToAdd)
    return string.format("%X", tonumber(hexAddress, 16) + valueToAdd)
end

return Address
