local FormEventsTimers = {}

function FormEventsTimers.onProcessCheckTick(formManager)
    if formManager.isChecking then return end
    formManager.isChecking = true

    if not formManager.form or not formManager.tmrProcessCheck or not formManager.tmrProcessCheck.Enabled then
        formManager.isChecking = false
        return
    end

    if not formManager.components.lblStatus then
        formManager.isChecking = false
        return
    end

    if not _G.Classes or not _G.Classes.App or not _G.Classes.App.status then
        formManager.isChecking = false
        return
    end

    local pid = getProcessIDFromProcessName("pes6.exe") or 0
    local isGameRunningNow = (pid ~= 0)
    local appInstance = _G.Classes.App

    if isGameRunningNow then
        if formManager.components.lblStatus then
            formManager.components.lblStatus.Caption = "PES6 Status: Connected"
            formManager.components.lblStatus.Font.Color = 0x00FF00
        end

        if not appInstance.status.isGameRunning then
            openProcess(pid)
            appInstance:setGameOpened()
            if formManager.tmrMemoryReader then
                formManager.tmrMemoryReader.Enabled = true
            end
        end
    else
        if formManager.components.lblStatus then
            formManager.components.lblStatus.Caption = "PES6 Status: Disconnected"
            formManager.components.lblStatus.Font.Color = 0x0000FF
        end

        if appInstance.status.isGameRunning then
            appInstance:setGameClosed()
            if formManager.tmrMemoryReader then
                formManager.tmrMemoryReader.Enabled = false
            end
            if formManager.tmrDataSaver then
                formManager.tmrDataSaver.Enabled = false
            end
        end
    end

    formManager.isChecking = false
end

function FormEventsTimers.onMemoryReaderTick(formManager)
    local reader = _G.Classes.MatchStateReader
    if not reader then return end

    reader:updateData()

    if reader.save then
        reader.save = false
        formManager.pendingSave = true
    end

    if formManager.pendingSave and reader.menuBackground == 5 then
        formManager.pendingSave = false

        if formManager.tmrDataSaver then
            formManager.tmrDataSaver.Enabled = true
            Console.data("Data saving triggered: Menu background detected.")
        end
    end
end

function FormEventsTimers.onDataSaverTick(formManager)
    formManager.tmrDataSaver.Enabled = false

    local gameDataInstance = _G.Classes.GameData
    local connector = _G.Classes.ConnectorCentral

    if gameDataInstance and connector then
        gameDataInstance:updateData()
        local realTableData = gameDataInstance:toTable()

        Console.data("Saving match data...")

        ---@diagnostic disable-next-line: undefined-global
        createThread(function()
            local success, err = pcall(function()
                connector:send("MATCH_DATA", realTableData)
            end)

            ---@diagnostic disable-next-line: undefined-global
            synchronize(function()
                if success then
                    Console.data("Match data successfully saved.")
                else
                    Console.error("Critical failure: Match data could not be saved!")
                end
            end)
        end)
    end
end

return FormEventsTimers