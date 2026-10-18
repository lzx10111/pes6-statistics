local Data = _G.Classes.Data
local Antecedent = {}
Antecedent.__index = Antecedent

setmetatable(Antecedent, { __index = Data })

function Antecedent:new(o)
    o = o or {}
    setmetatable(o, self)
    return o
end

function Antecedent:setData()
    self.total = self:getTotal()
    self.records = self:getRecords()
end

function Antecedent:getSimpleName()
    return "Antecedent"
end

function Antecedent:getRecords()
    local address = "010D0691"
    local total = self:getTotal()
    local record = {}
    local arr = {}

    for i = 1, total do
        for j = 1, 3 do
            address = string.format("%X", tonumber(address, 16) + 1)
            record[j] = readShortInteger(address)
        end

        arr[i] = record
        record = {}
    end

    return arr
end

function Antecedent:getTotal()
    return readShortInteger("010D0691")
end

return Antecedent
