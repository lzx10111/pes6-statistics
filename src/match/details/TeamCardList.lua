local Data = _G.Classes.Data
local TeamCardListItem = _G.Classes.TeamCardListItem
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
    self.items = self:getItems()
end

function TeamCardList:getSimpleName()
    return "TeamCardList"
end

function TeamCardList:ignoredFields()
    return {"address", "cards"}
end

function TeamCardList:getTotalCards()
    return self.address:readFieldByIndex(1)
end

function TeamCardList:getCards()
    return self:getDoubleArrayFromAddress(self.address.address, self:getTotalCards(), 4, 1, 3)
end

function TeamCardList:getItems()
    local arr = {}
    local len = self.totalCards

    for i = 1, len do
        local item = self.cards[i]
        arr[i] = TeamCardListItem:new({
            minute = item[1],
            card = item[2],
            player = item[3]
        })
    end

    return arr
end

return TeamCardList
