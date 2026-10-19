local Data = _G.Classes.Data
local Address = _G.Classes.Address
local TeamCardList = _G.Classes.TeamCardList
local CardRegistration = {}
CardRegistration.__index = CardRegistration

setmetatable(CardRegistration, { __index = Data })

CardRegistration.home = Address:build(TeamCardList, "010D07C0", { -2 }, { 1 })
CardRegistration.away = Address:build(TeamCardList, "010D0824", { -101 }, { 1 })

function CardRegistration:setData()
    if self.home then
        self.home:setData()
    end

    if self.away then
        self.away:setData()
    end
end

function CardRegistration:getSimpleName()
    return "CardRegistration"
end

return CardRegistration