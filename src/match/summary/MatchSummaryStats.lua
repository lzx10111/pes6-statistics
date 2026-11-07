local Data = _G.Classes.Data
local Address = _G.Classes.Address
local Math = _G.Classes.Math
local MatchSummaryTeamStats = _G.Classes.MatchSummaryTeamStats
local MatchSummaryStats = {}
MatchSummaryStats.__index = MatchSummaryStats

setmetatable(MatchSummaryStats, { __index = Data })

local offsets = Math.multiples(2, 15)
table.remove(offsets, 6)
table.insert(offsets, offsets[#offsets] + 1)

local offsetsHome = { table.unpack(offsets) }
table.insert(offsetsHome, offsetsHome[#offsetsHome] + 756067)
table.insert(offsetsHome, offsetsHome[#offsetsHome] + 14182)

local offsetsAway = { table.unpack(offsets) }
table.insert(offsetsAway, offsetsAway[#offsetsAway] + 755312)
table.insert(offsetsAway, offsetsAway[#offsetsAway] + 27021)

MatchSummaryStats.home = Address:build(MatchSummaryTeamStats, "01017B30", offsetsHome, Math.replicate(1, 16), 0)
MatchSummaryStats.away = Address:build(MatchSummaryTeamStats, "01017E24", offsetsAway, Math.replicate(1, 16), 0)

MatchSummaryStats.home.side = "home"
MatchSummaryStats.away.side = "away"

function MatchSummaryStats:setData()
    if self.home then
        self.home:setData()
    end

    if self.away then
        self.away:setData()
    end
end

function MatchSummaryStats:getSimpleName()
    return "MatchSummaryStats"
end

return MatchSummaryStats