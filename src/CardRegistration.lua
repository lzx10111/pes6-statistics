local Data = _G.Classes.Data
local Address = _G.Classes.Address
local TeamCardList = _G.Classes.TeamCardList
local CardRegistration = {}
CardRegistration.__index = CardRegistration

setmetatable(CardRegistration, { __index = Data })

function CardRegistration:new(o)
    o = o or {}
    setmetatable(o, self)

    o.home = Address:build(TeamCardList, "010D07BE")
    o.away = Address:build(TeamCardList, "010D07BE")

    o:updateData()

    return o
end

function CardRegistration:getSimpleName()
    return "CardRegistration"
end

return CardRegistration