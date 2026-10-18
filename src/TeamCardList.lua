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

function TeamCardList:getTotalCards()
    return readShortInteger(self.address.address)
end

function TeamCardList:getCards()
    return self:getDoubleArrayFromAddress(self.address:AddValueToAddress(2), self:getTotalCards(), 4, 1, 3)
end

return TeamCardList
