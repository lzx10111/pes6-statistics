local Data = _G.Classes.Data
local MatchPlayerShotsOnGoal = {}
MatchPlayerShotsOnGoal.__index = MatchPlayerShotsOnGoal

setmetatable(MatchPlayerShotsOnGoal, { __index = Data })

function MatchPlayerShotsOnGoal:new(o)
    o = o or {}
    setmetatable(o, self)

    return o
end

function MatchPlayerShotsOnGoal:setData()
    self.shots = self:getShots()
    self.shotsOnGoal = self:getShotsOnGoal()
    self.goalkeeperSaves = self:getGoalkeeperSaves()
    self.inTheArea = self:getInTheArea()
    self.header = self:getHeader()
    self.rightFoot = self:getRightFoot()
    self.leftFoot = self:getLeftFoot()
end

function MatchPlayerShotsOnGoal:getSimpleName()
    return "MatchPlayerShotsOnGoal"
end

function MatchPlayerShotsOnGoal:ignoredFields()
    return {"address"}
end

function MatchPlayerShotsOnGoal:getShots()
    return self:readBaseValueIgnoringParity(1)
end

function MatchPlayerShotsOnGoal:getShotsOnGoal()
    local byte1 = self.address:readFieldByIndex(2)
    return byte1 % 128
end

function MatchPlayerShotsOnGoal:getGoalkeeperSaves()
    return self:readBaseValueBasedOnParity(2, 3)
end

function MatchPlayerShotsOnGoal:getInTheArea()
    local byte2 = self.address:readFieldByIndex(3)
    local byte3 = self.address:readFieldByIndex(4)

    local area_pattern = math.floor(byte2 / 32)
    local area_loops = byte3 % 16

    return (area_loops * 8) + area_pattern
end

function MatchPlayerShotsOnGoal:getHeader()
    local byte1 = self.address:readFieldByIndex(5)
    return byte1 % 64
end

function MatchPlayerShotsOnGoal:getRightFoot()
    return self:readBaseValueBasedOnPattern64(5, 6)
end

function MatchPlayerShotsOnGoal:getLeftFoot()
    return self:readBaseValueBasedOnPattern64(6, 7)
end

return MatchPlayerShotsOnGoal