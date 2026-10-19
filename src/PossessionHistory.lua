local Data = _G.Classes.Data
local Address = _G.Classes.Address
local TeamPossessionHistory = _G.Classes.TeamPossessionHistory
local PossessionHistory = {}
PossessionHistory.__index = PossessionHistory

setmetatable(PossessionHistory, { __index = Data })

PossessionHistory.home = Address:build(TeamPossessionHistory, "010D0888", { 0, 20 }, { 1 })
PossessionHistory.away = Address:build(TeamPossessionHistory, "010D0892", { 0, 130 }, { 1 })

function PossessionHistory:setData()
    if self.home then
        self.home:setData()
    end

    if self.away then
        self.away:setData()
    end
end

function PossessionHistory:getSimpleName()
    return "PossessionHistory"
end

return PossessionHistory