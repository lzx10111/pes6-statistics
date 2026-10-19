local Data = _G.Classes.Data
local TeamPossessionHistory = {}
TeamPossessionHistory.__index = TeamPossessionHistory

setmetatable(TeamPossessionHistory, { __index = Data })

function TeamPossessionHistory:new(o)
    o = o or {}
    setmetatable(o, self)
    return o
end

function TeamPossessionHistory:setData()
    self.percentages = self:getPercentages()
    self.history = self:getHistory()
    self.totalPercentage = self:getTotalPercentage()
end

function TeamPossessionHistory:getSimpleName()
    return "TeamPossessionHistory"
end

function TeamPossessionHistory:getTotalPercentage()
    local array = self.percentages
    if not array or #array == 0 then
        return 0
    end

    local sum = 0
    local validBlocksCount = 0

    for i = 1, 6 do
        if array[i] then
            sum = sum + array[i]
            validBlocksCount = validBlocksCount + 1
        end
    end

    for i = 9, 10 do
        if array[i] and array[i] > 0 then
            sum = sum + array[i]
            validBlocksCount = validBlocksCount + 1
        end
    end

    if validBlocksCount == 0 then
        return 0
    end

    return math.floor((sum / validBlocksCount) + 0.5)
end

function TeamPossessionHistory:getPercentages()
    return self:getArrayFromAddress(self.address:AddOffsetToAddress(1), 10, 1, 1)
end

function TeamPossessionHistory:getHistory()
    return self:getArrayFromAddress(self.address:AddOffsetToAddress(2), 60, 2, 1)
end

return TeamPossessionHistory