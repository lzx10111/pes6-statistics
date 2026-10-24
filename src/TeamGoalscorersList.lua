local Data = _G.Classes.Data
local TeamGoalscorersList = {}
TeamGoalscorersList.__index = TeamGoalscorersList

setmetatable(TeamGoalscorersList, { __index = Data })

function TeamGoalscorersList:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function TeamGoalscorersList:setData()
    self.scorersCount = self:getScorersCount()
    self.players = self:getPlayers()
    self.goalCounts = self:getGoalCounts()
    self.minutes = self:getMinutes()
end

function TeamGoalscorersList:getSimpleName()
    return "TeamGoalscorersList"
end

function TeamGoalscorersList:ignoredFields()
    return {"address"}
end

function TeamGoalscorersList:getScorersCount()
    return self.address:readFieldByIndex(1)
end

function TeamGoalscorersList:getPlayers()
    return self:getArrayFromAddress(self.address:AddOffsetToAddress(2), self.scorersCount, 1, 1)
end

function TeamGoalscorersList:getGoalCounts()
    return self:getArrayFromAddress(self.address:AddOffsetToAddress(3), self.scorersCount, 1, 1)
end

function TeamGoalscorersList:getMinutes()
    local arr = self:getDoubleArrayFromAddress(self.address:AddOffsetToAddress(4), self.scorersCount, 10, 1, 10)

    for _, row in ipairs(arr) do
        for i = #row, 1, -1 do
            if row[i] == 0 then
                table.remove(row, i)
            end
        end
    end

    return arr
end

return TeamGoalscorersList