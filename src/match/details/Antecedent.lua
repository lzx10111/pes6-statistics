local Data = _G.Classes.Data
local Address = _G.Classes.Address
local Antecedent = {}
Antecedent.__index = Antecedent

setmetatable(Antecedent, { __index = Data })

Antecedent.address = Address:new({
        address = "010D0691",
        typeValue = {1, 1},
        offset = {0, 2}
    })

function Antecedent:setData()
    self.total = self:getTotal()
    self.records = self:getRecords()
end

function Antecedent:getSimpleName()
    return "Antecedent"
end

function Antecedent:getRecords()
    local address = self.address:addOffsetToAddress(2)
    local total = self:getTotal()

    return self:getDoubleArrayFromAddress(address, total, 3, 1, 3)
end

function Antecedent:getTotal()
    return self.address:readFieldByIndex(1)
end

return Antecedent
