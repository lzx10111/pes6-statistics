local Data = _G.Classes.Data
local MatchSummaryTeamStats = {}
MatchSummaryTeamStats.__index = MatchSummaryTeamStats

setmetatable(MatchSummaryTeamStats, { __index = Data })

function MatchSummaryTeamStats:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchSummaryTeamStats:setData()
    self.teamName = self:getTeamName()
    self.goalsFirstHalf = self:getGoalsFirstHalf()
    self.goalsSecondHalf = self:getGoalsSecondHalf()
    self.goalsFirstExtraTime = self:getGoalsFirstExtraTime()
    self.goalsSecondExtraTime = self:getGoalsSecondExtraTime()
    self.goalsPenalties = self:getGoalsPenalties()
    self.goalsTotal = self:getGoalsTotal()
    self.shots = self:getShots()
    self.shotsOnGoal = self:getShotsOnGoal()
    self.penalties = self:getPenalties()
    self.freeKick = self:getFreeKick()
    self.cornerKicks = self:getCornerKicks()
    self.fouls = self:getFouls()
    self.offside = self:getOffside()
    self.yellowCards = self:getYellowCards()
    self.redCards = self:getRedCards()
    self.ballPossession = self:getBallPossession()
end

function MatchSummaryTeamStats:getSimpleName()
    return "MatchSummaryTeamStats"
end

function MatchSummaryTeamStats:getGoalsFirstHalf()
    return self.address:readFieldByIndex(1)
end

function MatchSummaryTeamStats:getGoalsSecondHalf()
    return self.address:readFieldByIndex(2)
end

function MatchSummaryTeamStats:getGoalsFirstExtraTime()
    return self.address:readFieldByIndex(3)
end

function MatchSummaryTeamStats:getGoalsSecondExtraTime()
    return self.address:readFieldByIndex(4)
end

function MatchSummaryTeamStats:getGoalsTotal()
    return self.address:readFieldByIndex(5)
end

function MatchSummaryTeamStats:getGoalsPenalties()
    return self.address:readFieldByIndex(6)
end

function MatchSummaryTeamStats:getShots()
    return self.address:readFieldByIndex(7)
end

function MatchSummaryTeamStats:getPenalties()
    return self.address:readFieldByIndex(8)
end

function MatchSummaryTeamStats:getShotsOnGoal()
    return self.address:readFieldByIndex(9)
end

function MatchSummaryTeamStats:getFouls()
    return self.address:readFieldByIndex(10)
end

function MatchSummaryTeamStats:getOffside()
    return self.address:readFieldByIndex(11)
end

function MatchSummaryTeamStats:getCornerKicks()
    local l = self.address:readFieldByIndex(12)
    local r = self.address:readFieldByIndex(13)
    local arr = {}

    table.insert(arr, l + r)

    return arr
end

function MatchSummaryTeamStats:getYellowCards()
    return self.address:readFieldByIndex(14)
end

function MatchSummaryTeamStats:getRedCards()
    return self.address:readFieldByIndex(15)
end

function MatchSummaryTeamStats:getFreeKick()
    return self.address:readFieldByIndex(16)
end

function MatchSummaryTeamStats:getBallPossession()
    local percentage = readByte("pes6.exe+CD04BA") or 0

    if self.side == "home" then
        return percentage
    elseif self.side == "away" then
        return 100 - percentage
    else
        return 0
    end
end

function MatchSummaryTeamStats:getTeamName()
    local address = self.address:addOffsetToAddress(17)

    return readString(address, 100)
end

return MatchSummaryTeamStats
