local Root = {}
Root.__index = Root

function Root:getSimpleName()
    return "Root"
end

function Root:getFields()
    local fields = {}
    local ignored = {}

    for _, fieldName in ipairs(self:ignoredFields()) do
        ignored[fieldName] = true
    end

    for key, value in pairs(self) do
        if type(value) ~= "function" and not ignored[key] then
            fields[key] = value
        end
    end

    return fields
end

function Root:getFieldClasses()
    local classes = {}
    
    for key, value in pairs(self) do
        if key ~= "__index" and key ~= "super" and type(value) ~= "function" then
            if type(value) == "table" and getmetatable(value) ~= nil then
                classes[key] = value
            end
        end
    end
    
    return classes
end

function Root:getFieldOrder()
    local field_order = {}
    local fields = self:getFields()

    for key in pairs(fields) do
        table.insert(field_order, key)
    end

    table.sort(field_order)

    return field_order
end

function Root:ignoredFields()
    return {}
end

function Root:readByTypeInteger(typeValue, address)
    if typeValue == 1 then
        return readByte(address)
    end
    if typeValue == 2 then
        return readSmallInteger(address)
    end
    if typeValue == 3 then
        return readInteger(address)
    end
    if typeValue == 4 then
        return readQword(address)
    end
end

function Root:getPercentageArrayFromAddress(address)
    local arr = {}

    arr[1] = readShortInteger(address)
    arr[2] = 100 - arr[1]

    return arr
end

function Root:getArrayFromAddress(address, len, interval, typeValue)
    typeValue = typeValue or 1
    local arr = {}

    for i = 1, len do
        arr[i] = self:readByTypeInteger(typeValue, address)
        address = string.format("%X", tonumber(address, 16) + interval)
    end

    return arr
end

function Root:getArrayFromTwoAddress(address1, address2, len, interval1, interval2)
    local a = {}
    local b = {}
    local arr = {}

    for i = 1, len do
        if len > 1 then
            a[i] = readShortInteger(address1)
            b[i] = readShortInteger(address2)

            address1 = string.format("%X", tonumber(address1, 16) + interval1)
            address2 = string.format("%X", tonumber(address2, 16) + interval2)
        else
            arr[1] = readShortInteger(address1)
            arr[2] = readShortInteger(address2)
        end
    end

    if len > 1 then
        arr[1] = a
        arr[2] = b
    end

    return arr
end

function Root:getDoubleArrayFromAddress(address, len, interval, typeValue, sublen)
    typeValue = typeValue or 1
    local arr = {}

    for i = 1, len do
        arr[i] = self:getArrayFromAddress(address, sublen, 1, typeValue)
        address = string.format("%X", tonumber(address, 16) + interval)
    end

    return arr
end

function Root:getStringArrayFromTwoAddress(address1, address2)
    local arr = {}

    arr[1] = readString(address1, 100)
    arr[2] = readString(address2, 100)

    return arr
end

return Root
