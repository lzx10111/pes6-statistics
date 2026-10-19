local Data = _G.Classes.Data
local TeamCardList = {}
TeamCardList.__index = TeamCardList

setmetatable(TeamCardList, { __index = Data })

function TeamCardList:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function TeamCardList:setData()
    self.totalCards = self:getTotalCards()
    self.cards = self:getCards()
end

function TeamCardList:getSimpleName()
    return "TeamCardList"
end

function TeamCardList:ignoredFields()
    return {"address"}
end

function TeamCardList:getTotalCards()
    return self.address:readByTypeIntegerWithIndex(1)
end

function TeamCardList:getCards()
    return self:getDoubleArrayFromAddress(self.address.address, self:getTotalCards(), 4, 1, 3)
end

return TeamCardList
