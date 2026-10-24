local String = _G.Classes.String
local Bit = _G.Classes.Bit
local Data = {}
Data.__index = Data

setmetatable(Data, { __index = String })

function Data:setData()

end

function Data:updateData()
    local app = _G.Classes and _G.Classes.App
    if not app or not app.status.isGameRunning then
        return
    end

    local fields = self:getFieldClasses()

    for _, child in pairs(fields) do
        child:setData()
    end
end

function Data:toTable()
    local tbl = {}
    local fields = self:getFields()

    for key, value in pairs(fields) do
        if key ~= "__index" and key ~= "super" and type(value) ~= "function" then
            if type(value) == "table" then
                if type(value.toTable) == "function" then
                    tbl[key] = value:toTable()
                else
                    tbl[key] = value
                end
            else
                tbl[key] = value
            end
        end
    end

    return tbl
end

local function formatJsonPretty(str)
    local result = ""
    local indent = 0
    local inString = false

    for i = 1, #str do
        local c = str:sub(i, i)

        if c == '"' and str:sub(i-1, i-1) ~= '\\' then
            inString = not inString
        end

        if not inString then
            if c == '{' or c == '[' then
                indent = indent + 1
                result = result .. c .. "\n" .. string.rep("    ", indent)
            elseif c == '}' or c == ']' then
                indent = indent - 1
                result = result .. "\n" .. string.rep("    ", indent) .. c
            elseif c == ',' then
                result = result .. c .. "\n" .. string.rep("    ", indent)
            elseif c == ':' then
                result = result .. ": "
            else
                result = result .. c
            end
        else
            result = result .. c
        end
    end

    return result
end

function Data:toJson(pretty)
    local json = require("json")
    local cleanTable = self:toTable()
    local jsonString = json.encode(cleanTable)

    if pretty then
        return formatJsonPretty(jsonString)
    end

    return jsonString
end

function Data:getFieldsTotalSize(string_max_size)
    string_max_size = string_max_size or 32
    local total_bytes = 0
    local fields = self:getFields()

    for _, value in pairs(fields) do
        if type(value) == "table" and getmetatable(value) ~= nil then
            total_bytes = total_bytes + value:getFieldsTotalSize(string_max_size)
        else
            total_bytes = total_bytes + self:getValueSize(value, string_max_size)
        end
    end

    return total_bytes
end

function Data:getValueSize(value, string_max_size)
    string_max_size = string_max_size or 32
    local data_type = type(value)

    if data_type == "number" then
        if value % 1 == 0 then
            return 4
        else
            return 8
        end
    elseif data_type == "string" then
        return string_max_size
    elseif data_type == "boolean" then
        return 1
    elseif data_type == "table" then
        local total_table_bytes = 0
        for i = 1, #value do
            total_table_bytes = total_table_bytes + self:getValueSize(value[i], string_max_size)
        end
        return total_table_bytes
    end

    return 0
end

function Data:writeFieldsToMemory(base_address, string_max_size)
    string_max_size = string_max_size or 32
    local current_offset = 0
    local field_order = self:getFieldOrder()

    for i = 1, #field_order do
        local key = field_order[i]
        local value = self[key]

        if value ~= nil then
            local target_address = base_address + current_offset

            if type(value) == "table" and getmetatable(value) ~= nil then
                local bytes_written = value:writeFieldsToMemory(target_address, string_max_size)
                current_offset = current_offset + bytes_written
            else
                self:writeFieldRecursive(target_address, value, string_max_size)
                current_offset = current_offset + self:getValueSize(value, string_max_size)
            end
        end
    end

    return current_offset
end

function Data:writeFieldRecursive(addr, val, string_max_size)
    string_max_size = string_max_size or 32
    local data_type = type(val)

    if data_type == "number" then
        if val % 1 == 0 then
            writeInteger(addr, val)
        else
            writeDouble(addr, val)
        end
    elseif data_type == "string" then
        writeString(addr, val, string_max_size)
    elseif data_type == "boolean" then
        writeByte(addr, val and 1 or 0)
    elseif data_type == "table" then
        local table_offset = 0
        for j = 1, #val do
            self:writeFieldRecursive(addr + table_offset, val[j], string_max_size)
            table_offset = table_offset + self:getValueSize(val[j], string_max_size)
        end
    end
end

function Data:getMaskedStat(originalByte, divisor)
    if not originalByte then return 0 end
    divisor = divisor or 1

    local value = Bit.band(originalByte, 0x7F)

    return math.floor(value / divisor)
end

function Data:getSimpleName()
    return "Data"
end

return Data