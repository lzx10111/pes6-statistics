local Data = _G.Classes.Data
local Address = _G.Classes.Address
local TeamPossessionHistory = _G.Classes.TeamPossessionHistory
local PossessionHistoryArea = _G.Classes.PossessionHistoryArea
local PossessionHistory = {}
PossessionHistory.__index = PossessionHistory

setmetatable(PossessionHistory, { __index = Data })

PossessionHistory.home = Address:build(TeamPossessionHistory, "010D0888", { 0, 20 })
PossessionHistory.away = Address:build(TeamPossessionHistory, "010D0892", { 0, 130 })
PossessionHistory.area = Address:build(PossessionHistoryArea, "010D098C", { 0 })

PossessionHistory.home.side = "home"
PossessionHistory.away.side = "away"

function PossessionHistory:setData()
    if self.home then
        self.home:setData()
    end

    if self.away then
        self.away:setData()
    end

    if self.area then
        self.area:setData()
    end
end

function PossessionHistory:getSimpleName()
    return "PossessionHistory"
end

return PossessionHistory