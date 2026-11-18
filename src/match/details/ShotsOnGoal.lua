local Data = _G.Classes.Data
local Address = _G.Classes.Address
local TeamShotsOnGoal = _G.Classes.TeamShotsOnGoal

local ShotsOnGoal = {}
ShotsOnGoal.__index = ShotsOnGoal

setmetatable(ShotsOnGoal, { __index = Data })

local shotsCountAddr = Address:create("pes6.exe+CD31F0", { 0 }, { 2 }, 0)
local shotsArrayAddr = Address:create("pes6.exe+CD31F4", nil, nil, { "0" })

ShotsOnGoal.home = TeamShotsOnGoal:new({
    address   = shotsArrayAddr,
    countAddr = shotsCountAddr,
    side      = "home"
})

ShotsOnGoal.away = TeamShotsOnGoal:new({
    address   = shotsArrayAddr,
    countAddr = shotsCountAddr,
    side      = "away"
})

function ShotsOnGoal:setData()
    if self.home then
        self.home:setData()
    end

    if self.away then
        self.away:setData()
    end
end

function ShotsOnGoal:getSimpleName()
    return "ShotsOnGoal"
end

return ShotsOnGoal