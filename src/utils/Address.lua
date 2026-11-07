local Data = _G.Classes.Data
local Address = {}
Address.__index = Address

setmetatable(Address, { __index = Data })

function Address:new(o)
    o = o or {}
    setmetatable(o, self)
    return o
end

function Address:build(TargetClass, baseAddress, offsets, typeValues, addValue)
    if not TargetClass then
        error("Error: 'TargetClass' es nil. ¿Olvidaste cargar la clase o está mal el nombre?")
    end

    local finalAddress = baseAddress

    if addValue and type(addValue) == "number" and addValue > 0 then
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
        self:setAddress(self:addValueToAddress(tonumber(offset[i], 16)))
    end
end

function Address:addValueToAddress(value)
    return Address.add(self.address, value)
end

function Address:addOffsetToAddress(value)
    local offset = self.offset[value]
    if offset == nil then return nil end
    return Address.add(self.address, offset)
end

function Address:readFieldByIndex(index)
    local typeValue = self.typeValue[index]
    local address = self:addOffsetToAddress(index)
    if typeValue == nil or address == nil then return nil end
    return self:readByTypeInteger(typeValue, address)
end

function Address.add(hexAddress, valueToAdd)
    -- 🛡️ Si la dirección base llega como nil o vacía por un error del stack,
    -- la forzamos a "0" para que 'tonumber' no rompa el mod.
    if hexAddress == nil or hexAddress == "" then
        hexAddress = "0"
    end
    
    -- 🛡️ Si el valor a sumar es nil, asumimos que es 0
    if valueToAdd == nil then
        valueToAdd = 0
    end

    -- Realizamos la conversión matemática segura
    local baseDecimal = tonumber(hexAddress, 16) or 0
    local sumaDecimal = tonumber(valueToAdd) or 0

    return string.format("%X", baseDecimal + sumaDecimal)
end

return Address
