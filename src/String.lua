local Root = _G.Classes.Root
local String = {}
String.__index = String

setmetatable(String, { __index = Root })

function String:toString()
    local str = string.format("%s [ ", self:getSimpleName())
    local fields = self:getFields()
    local has_content = false

    if next(fields) ~= nil then
        has_content = true
        for key, value in pairs(fields) do
            -- 🛡️ ESCUDO ANTICRASH: Si la clave es un método interno o la metatabla, la ignoramos
            -- Esto evita que el script entre en la recursión infinita de las clases estáticas
            if key ~= "__index" and key ~= "super" and type(value) ~= "function" then
                
                if type(value) == "table" and getmetatable(value) ~= nil and type(value.toString) == "function" then
                    str = str .. value:toString() .. ", "
                else
                    str = str .. key .. "=" .. self:typeTostring(value) .. ", "
                end
                
            end
        end
    end

    if has_content then
        str = str:sub(1, -3)
    end

    return str .. " ]"
end


function String:toPrettyString(indent_level)
    indent_level = indent_level or 6
    local current_indent = string.rep(" ", indent_level)
    local next_indent = string.rep(" ", indent_level + 4)

    local str = string.format("%s [\n", self:getSimpleName())
    local fields = self:getFields()
    local has_content = false

    if next(fields) ~= nil then
        has_content = true
        for key, value in pairs(fields) do
            if type(value) == "table" and getmetatable(value) ~= nil then
                str = str .. next_indent .. value:toPrettyString(indent_level + 4) .. ",\n"
            else
                str = str .. next_indent .. key .. " = " .. self:typeToPrettyString(value, indent_level + 4) .. ",\n"
            end
        end
    end

    if has_content then
        str = str:sub(1, -3) .. "\n"
    end

    return str .. current_indent .. "]"
end

function Root:typeTostring(v)
    if type(v) ~= "table" then
        return tostring(v)
    end

    local str = "{ "
    for i = 1, #v do
        str = str .. self:typeTostring(v[i]) .. ", "
    end

    if #v > 0 then
        str = str:sub(1, -3)
    end

    return str .. " }"
end

function Root:typeToPrettyString(v, indent_level)
    indent_level = indent_level or 0
    if type(v) ~= "table" then
        return tostring(v)
    end

    local is_matrix = type(v[1]) == "table"

    if not is_matrix then
        local str = "{ "
        for i = 1, #v do
            str = str .. tostring(v[i]) .. ", "
        end
        if #v > 0 then str = str:sub(1, -3) end
        return str .. " }"
    else
        local current_indent = string.rep(" ", indent_level)
        local next_indent = string.rep(" ", indent_level + 4)
        local str = "{\n"

        for i = 1, #v do
            str = str .. next_indent .. self:typeToPrettyString(v[i], indent_level + 4) .. ",\n"
        end

        if #v > 0 then str = str:sub(1, -3) .. "\n" end
        return str .. current_indent .. "}"
    end
end

function String:getSimpleName()
    return "String"
end

return String