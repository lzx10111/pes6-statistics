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
    local originalValue = self.address:readFieldByIndex(1)
    return self:getMaskedStat(originalValue)
end

function MatchPlayerShotsOnGoal:getShotsOnGoal()
    local byte1 = self.address:readFieldByIndex(2)
    return byte1 % 128
end

function MatchPlayerShotsOnGoal:getGoalkeeperSaves()
    local byte1 = self.address:readFieldByIndex(2)
    local byte2 = self.address:readFieldByIndex(3)

    local is_odd = (byte1 >= 128)
    local saves_base = byte2 % 32

    local goalkeeper_saves = saves_base * 2
    if is_odd then
        goalkeeper_saves = goalkeeper_saves + 1
    end

    return goalkeeper_saves
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
    local byte1 = self.address:readFieldByIndex(5)
    local byte2 = self.address:readFieldByIndex(6)

    local right_foot_position = math.floor(byte1 / 64)
    local right_foot_loops = byte2 % 16

    return (right_foot_loops * 4) + right_foot_position
end

function MatchPlayerShotsOnGoal:getLeftFoot()
    local byte2 = self.address:readFieldByIndex(6)
    local byte3 = self.address:readFieldByIndex(7)

    local left_foot_position = math.floor(byte2 / 64)
    local left_foot_loops = byte3 % 16

    return (left_foot_loops * 4) + left_foot_position
end

return MatchPlayerShotsOnGoal