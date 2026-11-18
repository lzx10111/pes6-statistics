local Data = _G.Classes.Data
local Address = {}
Address.__index = Address

setmetatable(Address, { __index = Data })

function Address:new(o)
    o = o or {}
    setmetatable(o, self)
    return o
end

function Address:create(baseAddress, offsets, typeValues, addValue)
    -- Si viene con nombre de módulo (ej. "pes6.exe+CD31F0"), lo convertimos a hex puro una sola vez
    if type(baseAddress) == "string" and baseAddress:find("+") then
        local resolved = getAddress(baseAddress)
        if resolved then
            baseAddress = string.format("%X", resolved)
        end
    end

    local isPointer = type(addValue) == "table"

    local addrObj = self:new({
        baseAddress    = baseAddress,
        address        = baseAddress,
        typeValue      = typeValues or {},
        offset         = offsets or {},
        pointerOffsets = isPointer and addValue or nil
    })

    if isPointer then
        addrObj:setPointer(baseAddress, addValue)
    else
        addrObj.address = Address.add(baseAddress, addValue)
    end

    return addrObj
end

function Address:refresh()
    if self.baseAddress and self.pointerOffsets then
        self:setPointer(self.baseAddress, self.pointerOffsets)
    end
end

function Address:build(TargetClass, baseAddress, offsets, typeValues, addValue)
    if not TargetClass then
        error("Error: 'TargetClass' es nil. ¿Olvidaste cargar la clase o está mal el nombre?")
    end

    local addrObj = self:create(baseAddress, offsets, typeValues, addValue)
    return TargetClass:new({ address = addrObj })
end

function Address:getSimpleName()
    return "Address"
end

function Address:setPointer(address, offset)
    self.address = address
    for i = 1, #offset do
        local value = self:readByType(3, self.address)
        if not value or value == 0 then
            self.address = "0"
            return
        end
        self.address = string.format("%X", value)
        self.address = self:addValueToAddress(tonumber(offset[i], 16))
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
    return self:readByType(typeValue, address)
end

function Address.add(hexAddress, valueToAdd)
    if hexAddress == nil or hexAddress == "" then
        hexAddress = "0"
    end

    if valueToAdd == nil then
        valueToAdd = 0
    end

    local baseDecimal = tonumber(hexAddress, 16) or 0
    local sumaDecimal = tonumber(valueToAdd) or 0

    return string.format("%X", baseDecimal + sumaDecimal)
end

return Address
