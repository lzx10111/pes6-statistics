local Data = _G.Classes.Data
local MatchSummaryStats = {}
MatchSummaryStats.__index = MatchSummaryStats

setmetatable(MatchSummaryStats, { __index = Data })

function MatchSummaryStats:setData()
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

function MatchSummaryStats:getSimpleName()
    return "MatchSummaryStats"
end

function MatchSummaryStats:getTeamName()
    local address1 = "pes6.exe+CD3C16"
    local address2 = "pes6.exe+CD6E3E"
    local arr = {}

    arr[1] = readString(address1, 100)
    arr[2] = readString(address2, 100)

    return arr
end

function MatchSummaryStats:getGoalsTotal()
    return self:getArrayFromTwoAddress("01017B38", "01017E2C", 1, 0)
end

function MatchSummaryStats:getGoalsFirstHalf()
    return self:getArrayFromTwoAddress("01017B30", "01017E24", 1, 0)
end

function MatchSummaryStats:getGoalsSecondHalf()
    return self:getArrayFromTwoAddress("01017B32", "01017E26", 1, 0)
end

function MatchSummaryStats:getGoalsFirstExtraTime()
    return self:getArrayFromTwoAddress("01017B34", "01017E28", 1, 0)
end

function MatchSummaryStats:getGoalsSecondExtraTime()
    return self:getArrayFromTwoAddress("01017B36", "01017E2A", 1, 0)
end

function MatchSummaryStats:getGoalsPenalties()
    return self:getArrayFromTwoAddress("01017B3C", "01017E30", 1, 0)
end

function MatchSummaryStats:getShots()
    return self:getArrayFromTwoAddress("01017B3E", "01017E32", 1, 0)
end

function MatchSummaryStats:getPenalties()
    return self:getArrayFromTwoAddress("01017B40", "01017E34", 1, 0)
end

function MatchSummaryStats:getShotsOnGoal()
    return self:getArrayFromTwoAddress("01017B42", "01017E36", 1, 0)
end

function MatchSummaryStats:getFreeKick()
    return self:getArrayFromAddress("010D04B0", 2, 1)
end

function MatchSummaryStats:getCornerKicks()
    local l = self:getArrayFromTwoAddress("01017B48", "01017E3C", 1, 0)
    local r = self:getArrayFromTwoAddress("01017B4A", "01017E3E", 1, 0)
    local arr = {}

    arr[1] = l[1] + r[1]
    arr[2] = l[2] + r[2]

    return arr
end

function MatchSummaryStats:getFouls()
    return self:getArrayFromTwoAddress("01017B44", "01017E38", 1, 0)
end

function MatchSummaryStats:getOffside()
    return self:getArrayFromTwoAddress("01017B46", "01017E3A", 1, 0)
end

function MatchSummaryStats:getYellowCards()
    return self:getArrayFromTwoAddress("01017B4C", "01017E40", 1, 0)
end

function MatchSummaryStats:getRedCards()
    return self:getArrayFromTwoAddress("01017B4D", "01017E41", 1, 0)
end

function MatchSummaryStats:getBallPossession()
    return self:getPercentageArrayFromAddress("pes6.exe+CD04BA")
end

return MatchSummaryStats
