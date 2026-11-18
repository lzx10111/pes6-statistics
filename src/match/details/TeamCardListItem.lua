local Data = _G.Classes.Data
local TeamCardListItem = {}
TeamCardListItem.__index = TeamCardListItem

setmetatable(TeamCardListItem, { __index = Data })

function TeamCardListItem:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function TeamCardListItem:getSimpleName()
    return "TeamCardListItem"
end

return TeamCardListItem