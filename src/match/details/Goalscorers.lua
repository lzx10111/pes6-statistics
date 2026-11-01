local Data = _G.Classes.Data
local Address = _G.Classes.Address
local TeamGoalscorersList = _G.Classes.TeamGoalscorersList
local Goalscorers = {}
Goalscorers.__index = Goalscorers

setmetatable(Goalscorers, { __index = Data })

Goalscorers.home = Address:build(TeamGoalscorersList, "010D04E1", { -38, 0, 36, 72 }, { 1, 1, 1, 1 })
Goalscorers.away = Address:build(TeamGoalscorersList, "010D04F3", { -55, 0, 36, 234 }, { 1, 1, 1, 1 })

function Goalscorers:setData()
    if self.home then
        self.home:setData()
    end

    if self.away then
        self.away:setData()
    end
end

function Goalscorers:getSimpleName()
    return "Goalscorers"
end

return Goalscorers