local Console = _G.Classes.Console
local MatchStateReader = {}

MatchStateReader.Phases = {
    MATCH_START                        = "MATCH_START",
    FIRST_HALF_START                   = "FIRST_HALF_START",
    FIRST_HALF_IN_PROGRESS             = "FIRST_HALF_IN_PROGRESS",
    FIRST_HALF_END                     = "FIRST_HALF_END",
    HALF_TIME                          = "HALF_TIME",
    SECOND_HALF_START                  = "SECOND_HALF_START",
    SECOND_HALF_IN_PROGRESS            = "SECOND_HALF_IN_PROGRESS",
    SECOND_HALF_END                    = "SECOND_HALF_END",
    EXTRA_TIME_FIRST_HALF_START        = "EXTRA_TIME_FIRST_HALF_START",
    EXTRA_TIME_FIRST_HALF_IN_PROGRESS  = "EXTRA_TIME_FIRST_HALF_IN_PROGRESS",
    EXTRA_TIME_FIRST_HALF_END          = "EXTRA_TIME_FIRST_HALF_END",
    EXTRA_TIME_HALF_TIME               = "EXTRA_TIME_HALF_TIME",
    EXTRA_TIME_SECOND_HALF_START       = "EXTRA_TIME_SECOND_HALF_START",
    EXTRA_TIME_SECOND_HALF_IN_PROGRESS = "EXTRA_TIME_SECOND_HALF_IN_PROGRESS",
    EXTRA_TIME_SECOND_HALF_END         = "EXTRA_TIME_SECOND_HALF_END",
    PENALTY_SHOOTOUT_START             = "PENALTY_SHOOTOUT_START",
    PENALTY_SHOOTOUT_IN_PROGRESS       = "PENALTY_SHOOTOUT_IN_PROGRESS",
    PENALTY_SHOOTOUT_END               = "PENALTY_SHOOTOUT_END",
    FULL_TIME                          = "FULL_TIME",
    POST_MATCH                         = "POST_MATCH",
    MATCH_PAUSED                       = "MATCH_PAUSED"
}

MatchStateReader.phase = MatchStateReader.Phases.MATCH_START
MatchStateReader.save = false
MatchStateReader.isMatchActive = false

function MatchStateReader:getMatchTimer()
    return readInteger("pes6.exe+37E098C")
end

function MatchStateReader:getInMatch()
    return readByte("pes6.exe+36635CC")
end

function MatchStateReader:getPeriodIndicator()
    return readByte("pes6.exe+37E148D")
end

function MatchStateReader:getTimeScaleFactor()
    return readFloat("pes6.exe+37E147C")
end

function MatchStateReader:getEngineClockState()
    return readByte("pes6.exe+C104F4")
end

function MatchStateReader:getFirstHalfEnd()
    return readByte("pes6.exe+3689F3F")
end

function MatchStateReader:getSecondHalfEnd()
    return readByte("pes6.exe+3689F40")
end

function MatchStateReader:getExtraTimeFirstHalfEnd()
    return readByte("pes6.exe+3689F41")
end

function MatchStateReader:getExtraTimeSecondHalfEnd()
    return readByte("pes6.exe+3689F42")
end

function MatchStateReader:getPenaltyShootoutEnd()
    return readByte("pes6.exe+3689F43")
end

function MatchStateReader:getFullTime()
    return readByte("pes6.exe+3689F44")
end

function MatchStateReader:getMenuBackground()
    return readByte("pes6.exe+CCF404")
end

function MatchStateReader:isMatchActiveForKickoff()
    local totalPartido = 162000 / self.timeScaleFactor
    return self.engineClockState == 1 and self.matchTimer < totalPartido and self.matchTimer > 0
end

function MatchStateReader:updateData()
    self.firstHalfEnd = self:getFirstHalfEnd()
    self.secondHalfEnd = self:getSecondHalfEnd()
    self.extraTimeFirstHalfEnd = self:getExtraTimeFirstHalfEnd()
    self.extraTimeSecondHalfEnd = self:getExtraTimeSecondHalfEnd()
    self.penaltyShootoutEnd = self:getPenaltyShootoutEnd()
    self.fullTime = self:getFullTime()
    self.menuBackground = self:getMenuBackground()

    self.matchTimer = self:getMatchTimer()
    self.inMatch = self:getInMatch()
    self.periodIndicator = self:getPeriodIndicator()
    self.timeScaleFactor = self:getTimeScaleFactor()
    self.engineClockState = self:getEngineClockState()

    self.isMatchActive = self:isMatchActiveForKickoff()

    self:updatePhase()
end

function MatchStateReader:updatePhase()
    local isOutOfMatch = (self.inMatch == 0 and self.periodIndicator == 0)
    local lastPhase = (self.phase == MatchStateReader.Phases.SECOND_HALF_END or
                       self.phase == MatchStateReader.Phases.EXTRA_TIME_SECOND_HALF_END or
                       self.phase == MatchStateReader.Phases.PENALTY_SHOOTOUT_END)

    if isOutOfMatch then
        if self.phase ~= MatchStateReader.Phases.MATCH_START then
            self.phase = MatchStateReader.Phases.MATCH_START
        end
        return
    end

    if self.fullTime == 1 and lastPhase then
        if self.phase == MatchStateReader.Phases.SECOND_HALF_END then
            Console.match("Full-time. Match ended in regular time.")
        elseif self.phase == MatchStateReader.Phases.EXTRA_TIME_SECOND_HALF_END then
            Console.match("Full-time. Match ended in extra time.")
        elseif self.phase == MatchStateReader.Phases.PENALTY_SHOOTOUT_END then
            Console.match("Full-time. Match decided by penalty shootout.")
        end

        self.phase = MatchStateReader.Phases.MATCH_START
        self.save = true
        return
    end

    if not self.isMatchActive and self.phase == MatchStateReader.Phases.MATCH_START then
        self.phase = MatchStateReader.Phases.FIRST_HALF_START
        Console.match("Pre-match phase started.")
        return
    end

    if self.menuBackground ~= 5 then
        if self.isMatchActive and self.phase == MatchStateReader.Phases.FIRST_HALF_START then
            self.phase = MatchStateReader.Phases.FIRST_HALF_END
            Console.match("Kickoff! First half has started.")
            return
        end
    end

    if self.firstHalfEnd == 1 and self.phase == MatchStateReader.Phases.FIRST_HALF_END then
        self.phase = MatchStateReader.Phases.SECOND_HALF_START
        self.save = true
        Console.match("Half-time interval.")
        return
    end

    if self.menuBackground ~= 5 then
        if self.isMatchActive and self.firstHalfEnd ~= 1 and self.phase == MatchStateReader.Phases.SECOND_HALF_START then
            self.phase = MatchStateReader.Phases.SECOND_HALF_END
            Console.match("Second half has started.")
            return
        end
    end

    if self.secondHalfEnd == 1 and self.phase == MatchStateReader.Phases.SECOND_HALF_END then
        self.phase = MatchStateReader.Phases.EXTRA_TIME_FIRST_HALF_START
        self.save = true
        Console.match("End of regular time.")
        return
    end

    if self.menuBackground ~= 5 then
        if self.isMatchActive and self.secondHalfEnd ~= 1 and self.phase == MatchStateReader.Phases.EXTRA_TIME_FIRST_HALF_START then
            self.phase = MatchStateReader.Phases.EXTRA_TIME_FIRST_HALF_END
            Console.match("Extra time started.")
            return
        end
    end

    if self.extraTimeFirstHalfEnd == 1 and self.phase == MatchStateReader.Phases.EXTRA_TIME_FIRST_HALF_END then
        self.phase = MatchStateReader.Phases.EXTRA_TIME_SECOND_HALF_START
        self.save = true
        Console.match("Extra time half-time.")
        return
    end

    if self.menuBackground ~= 5 then
        if self.isMatchActive and self.extraTimeFirstHalfEnd ~= 1 and self.phase == MatchStateReader.Phases.EXTRA_TIME_SECOND_HALF_START then
            self.phase = MatchStateReader.Phases.EXTRA_TIME_SECOND_HALF_END
            Console.match("Extra time second half started.")
            return
        end
    end

    if self.extraTimeSecondHalfEnd == 1 and self.phase == MatchStateReader.Phases.EXTRA_TIME_SECOND_HALF_END then
        self.phase = MatchStateReader.Phases.PENALTY_SHOOTOUT_START
        self.save = true
        Console.match("End of extra time.")
        return
    end

    if self.menuBackground ~= 5 then
        if self.isMatchActive and self.extraTimeSecondHalfEnd ~= 1 and self.phase == MatchStateReader.Phases.PENALTY_SHOOTOUT_START then
            self.phase = MatchStateReader.Phases.PENALTY_SHOOTOUT_END
            Console.match("Penalty shootout has started.")
            return
        end
    end
end

function MatchStateReader:getSimpleName()
    return "MatchStateReader"
end

return MatchStateReader
