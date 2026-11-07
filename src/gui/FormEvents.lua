local Console = _G.Classes.Console
local ConnectorCentral = _G.Classes.ConnectorCentral
local GameData = _G.Classes.GameData
local FormManagerJsonViewer = _G.Classes.FormManagerJsonViewer
local json = require("json")
local FormEvents = {}

function FormEvents.onCmbMethodChange(formManager)
    if not formManager.components.cmbMethod then return end

    local method = formManager.components.cmbMethod.Text

    if formManager.components.edtPort then
        formManager.components.edtPort.Enabled = (method == "SOCKET")
    end
end

function FormEvents.onBtnBrowseTempClick(formManager)
    FormEvents.selectDirectory(formManager, "edtTempPath")
end

function FormEvents.onBtnBrowseDevClick(formManager)
    FormEvents.selectDirectory(formManager, "edtDevPath")
end

function FormEvents.onCmbCommandsChange(formManager)
    local idx = formManager.components.cmbCommands.getItemIndex()
    if idx > 0 then
        local cmd = formManager.components.cmbCommands.getItems().getString(idx)

        if cmd == "clear" then
            formManager.components.edtCommandInput.Text = ""
            formManager.components.cmbCommands.setItemIndex(0)
            Console.system("Command input cleared.")
        else
            formManager.components.edtCommandInput.Text = cmd
            formManager.components.edtCommandInput.setFocus()
        end
    end
end

function FormEvents.onEdtCommandInputKeyPress(formManager, key)
    if string.byte(key) == 13 then
        local inputCmd = formManager.components.edtCommandInput.Text

        if string.sub(inputCmd, 1, 1) == "/" then
            inputCmd = string.sub(inputCmd, 2)
        end

        if inputCmd == "save_game_data" then
            Console.system("Force saves game data.", "save_game_data")
            formManager.tmrDataSaver.Enabled = true
        elseif inputCmd == "view_game_data" then
            Console.system("View game data.", "view_game_data")
            ---@diagnostic disable-next-line: undefined-global
            createThread(function(thread)
                GameData:updateData()
                local data = GameData:toTable()

                thread.synchronize(function()
                    FormEvents.viewData("view_game_data", data)
                end)
            end)
        elseif inputCmd == "view_classnames" then
            Console.system("View classnames.", "view_classnames")
            local classNames = {}

            for className, _ in pairs(_G.Classes) do
                table.insert(classNames, className)
            end

            FormEvents.viewData("view_classnames", classNames)
        elseif inputCmd ~= "" then
            Console.system("Invalid command: " .. inputCmd)
        end

        formManager.components.edtCommandInput.Text = ""
        formManager.components.cmbCommands.setItemIndex(0)
        return false
    end
end

function FormEvents.onBtnSaveClick(formManager)
    local settings = ConnectorCentral.settings

    if formManager.components.cmbMethod then
        settings.currentMethod = formManager.components.cmbMethod.Text
    end

    if formManager.components.edtPort then
        settings.port = tonumber(formManager.components.edtPort.Text) or settings.port
    end

    if formManager.components.edtTempPath then
        settings.tempJsonPath = formManager.components.edtTempPath.Text
    end

    if formManager.components.edtDevPath then
        _G.DEV_PATH = formManager.components.edtDevPath.Text
    end

    Console.system("Settings saved successfully.")
end

function FormEvents.onBtnCloseClick(formManager)
    FormEvents.onTrayExitClick(formManager)
end

function FormEvents.onTrayShowForm(formManager)
    if formManager.form then
        formManager.form.show()
    end
end

function FormEvents.onTrayExitClick(formManager)
    formManager.allowClose = true
    if formManager.form then
        formManager.form.close()
    end
end

function FormEvents.onFormClose(formManager)
    if not formManager.allowClose then
        if formManager.trayIcon then
            formManager.trayIcon.Visible = true
        end
        return caHide
    else
        Console.clear()
        formManager:destroyAllTimers()
        formManager:destroyTray()

        formManager.form = nil
        formManager.components = {}
        formManager.isChecking = false
        formManager.allowClose = false

        return caFree
    end
end

function FormEvents.selectDirectory(formManager, targetEditName)
    local dialog = createSelectDirectoryDialog(formManager.form)
    ---@diagnostic disable-next-line: undefined-field
    if dialog.execute() then
        if formManager.components[targetEditName] then
            formManager.components[targetEditName].Text = dialog.FileName
        end
    end
end

function FormEvents.viewData(command, data)
    local payload = {
        data = data
    }
    local jsonString = json.encode(payload)

    FormManagerJsonViewer:loadJsonString(jsonString, command)
    FormManagerJsonViewer.form:show()
end

return FormEvents