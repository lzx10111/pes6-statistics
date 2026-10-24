local Data = _G.Classes.Data
local PossessionHistoryArea = {}
PossessionHistoryArea.__index = PossessionHistoryArea

setmetatable(PossessionHistoryArea, { __index = Data })

function PossessionHistoryArea:new(o)
    o = o or {}
    setmetatable(o, self)
    return o
end

function PossessionHistoryArea:setData()
    self.area = self:getArea()
end

function PossessionHistoryArea:getSimpleName()
    return "PossessionHistoryArea"
end

function PossessionHistoryArea:ignoredFields()
    return {"address"}
end

function PossessionHistoryArea:getArea()
    return self:getArrayFromAddress(self.address:AddOffsetToAddress(1), 480, 2, 1)
end

return PossessionHistoryArea