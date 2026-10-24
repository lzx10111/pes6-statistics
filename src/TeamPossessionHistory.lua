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

function TeamPossessionHistory:ignoredFields()
    return {"address", "side"}
end

function TeamPossessionHistory:getTotalPercentage()
    local localPercentage = readByte("pes6.exe+CD04BA") or 0

    if self.side == "home" then
        return localPercentage
    elseif self.side == "away" then
        return 100 - localPercentage
    else
        return 0
    end
end

function TeamPossessionHistory:getPercentages()
    return self:getArrayFromAddress(self.address:AddOffsetToAddress(1), 10, 1, 1)
end

function TeamPossessionHistory:getHistory()
    return self:getArrayFromAddress(self.address:AddOffsetToAddress(2), 60, 2, 1)
end

return TeamPossessionHistory