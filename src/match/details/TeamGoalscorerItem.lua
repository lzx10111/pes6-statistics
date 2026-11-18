local Data = _G.Classes.Data
local TeamGoalscorerItem = {}
TeamGoalscorerItem.__index = TeamGoalscorerItem

setmetatable(TeamGoalscorerItem, { __index = Data })

function TeamGoalscorerItem:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function TeamGoalscorerItem:getSimpleName()
    return "TeamGoalscorerItem"
end

return TeamGoalscorerItem