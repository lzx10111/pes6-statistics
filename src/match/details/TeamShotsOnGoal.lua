local Data = _G.Classes.Data
local Address = _G.Classes.Address

local TeamShotsOnGoal = {}
TeamShotsOnGoal.__index = TeamShotsOnGoal

setmetatable(TeamShotsOnGoal, { __index = Data })

local SIDE_TO_TEAM_FLAG = {
    home = 0,
    away = 1
}

function TeamShotsOnGoal:new(o)
    o = o or {}
    setmetatable(o, self)
    return o
end

function TeamShotsOnGoal:setData()
    self.countAddr:refresh()
    self.address:refresh()

    self.shots = self:getShots()
    self.totalShots = #self.shots
end

function TeamShotsOnGoal:getSimpleName()
    return "TeamShotsOnGoal"
end

function TeamShotsOnGoal:ignoredFields()
    return { "address", "countAddr", "side" }
end

function TeamShotsOnGoal:buildShotSteps(stepsPtrDec, stepsCount)
    local steps = {}
    local stepsBaseHex = string.format("%X", stepsPtrDec)

    for j = 0, stepsCount - 1 do
        local stepAddr = Address:create(
            stepsBaseHex,
            { 0, 1, 2, 3, 4, 8, 12, 16, 20, 24, 28 },
            { 1, 1, 1, 1, 1, 5, 5, 5, 5, 5, 5 },
            j * 32
        )

        table.insert(steps, {
            team           = stepAddr:readFieldByIndex(1), -- +0x00: 0 = Home, 1 = Away
            playerId       = stepAddr:readFieldByIndex(2), -- +0x01: ID exacto en MatchPlayers (04 = Abidal, 09 = Nasri...)
            playerPosition = stepAddr:readFieldByIndex(3), -- +0x02: 0 = PT, 1 = DE, 2 = ME, 3 = DL
            flag           = stepAddr:readFieldByIndex(4), -- +0x03: Flag de contacto/conducción
            actionType     = stepAddr:readFieldByIndex(5), -- +0x04: Tipo de acción (Pase bajo, Disparo, Balón suelto...)
            startX         = stepAddr:readFieldByIndex(6),
            startY         = stepAddr:readFieldByIndex(7),
            endX           = stepAddr:readFieldByIndex(8),
            endY           = stepAddr:readFieldByIndex(9),
            targetX        = stepAddr:readFieldByIndex(10),
            targetY        = stepAddr:readFieldByIndex(11)
        })

    end

    return steps
end

function TeamShotsOnGoal:getShots()
    local shotsList = {}
    local targetTeamFlag = SIDE_TO_TEAM_FLAG[self.side] or 0
    local totalMatchShots = self.countAddr:readFieldByIndex(1) or 0

    for i = 0, totalMatchShots - 1 do
        local shotAddr = Address:create(
            self.address.address,
            { 0, 1, 2, 3, 4, 6, 7, 8 },
            { 1, 1, 1, 1, 2, 1, 1, 3 },
            i * 12
        )

        local shotNodeIndex = shotAddr:readFieldByIndex(1) or 0
        local stepsCount    = shotAddr:readFieldByIndex(7) or 0
        local stepsPtrDec   = shotAddr:readFieldByIndex(8) or 0
        local steps         = self:buildShotSteps(stepsPtrDec, stepsCount)

        local shooterNode  = steps[shotNodeIndex + 1]
        local shotTeamFlag = shooterNode and shooterNode.team or 0

        if shotTeamFlag == targetTeamFlag then
            table.insert(shotsList, {
                shooterNodeIndex = shotNodeIndex,
                assistNodeIndex  = shotAddr:readFieldByIndex(2),
                homeScore        = shotAddr:readFieldByIndex(3),
                awayScore        = shotAddr:readFieldByIndex(4),
                distance         = shotAddr:readFieldByIndex(5),
                minute           = shotAddr:readFieldByIndex(6),
                stepsCount       = stepsCount,
                steps            = steps
            })
        end
    end

    return shotsList
end

return TeamShotsOnGoal