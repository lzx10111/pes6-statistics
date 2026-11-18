local Data = _G.Classes.Data
local Address = _G.Classes.Address

local TeamSubstitutionsList = {}
TeamSubstitutionsList.__index = TeamSubstitutionsList

setmetatable(TeamSubstitutionsList, { __index = Data })

local SUB_STRIDE = 8
local MAX_SLOTS  = 6

local ALL_OFFSETS = {}
local ALL_SIZES   = {}
for i = 0, MAX_SLOTS - 1 do
    local base = i * SUB_STRIDE
    table.insert(ALL_OFFSETS, base)
    table.insert(ALL_OFFSETS, base + 1)
    table.insert(ALL_OFFSETS, base + 2)

    table.insert(ALL_SIZES, 1)
    table.insert(ALL_SIZES, 1)
    table.insert(ALL_SIZES, 1)
end

function TeamSubstitutionsList:new(countAddrStr, listBaseAddrStr)
    local instance = setmetatable({}, TeamSubstitutionsList)
    instance.countAddress = Address:create(countAddrStr, { 0 }, { 1 }, 0)
    instance.listAddress  = Address:create(listBaseAddrStr, ALL_OFFSETS, ALL_SIZES, 0)

    instance.totalSubstitutions = 0
    instance.substitutions = {}
    return instance
end

function TeamSubstitutionsList:setData()
    self.countAddress:refresh()
    local total = self.countAddress:readFieldByIndex(1) or 0
    if total > MAX_SLOTS then
        total = MAX_SLOTS
    end

    self.totalSubstitutions = total
    self.substitutions = {}

    if total <= 0 then
        return
    end

    self.listAddress:refresh()

    for i = 0, total - 1 do
        local fieldBase   = i * 3
        local playerInId  = self.listAddress:readFieldByIndex(fieldBase + 1)
        local playerOutId = self.listAddress:readFieldByIndex(fieldBase + 2)
        local minute      = self.listAddress:readFieldByIndex(fieldBase + 3)

        if playerInId ~= nil and playerInId ~= 255 and playerOutId ~= nil and playerOutId ~= 255 then
            table.insert(self.substitutions, {
                slot        = i,
                playerInId  = playerInId,
                playerOutId = playerOutId,
                minute      = minute or 0
            })
        end
    end
end

function TeamSubstitutionsList:getSimpleName()
    return "TeamSubstitutionsList"
end

return TeamSubstitutionsList