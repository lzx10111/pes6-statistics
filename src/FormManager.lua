local Console = _G.Classes.Console
local ConnectorCentral = _G.Classes.ConnectorCentral

local FormManager = {
    form = nil,
    components = {},
    trayIcon = nil,
    popupMenu = nil,
    tmrProcessCheck = nil,
    tmrMemoryReader = nil,
    tmrDataSaver = nil,
    isChecking = false,
    allowClose = false
}

function FormManager:init(ceForm)
    self.form = ceForm
    self:mapComponents()
    self:setupEvents()
    self:setupTrayIcon()
    self:loadCurrentSettings()
end

function FormManager:mapComponents()
    self.components.lstConsole    = self.form["lstConsole"]
    self.components.lblStatus     = self.form["lblStatus"]
    self.components.cmbMethod     = self.form["cmbMethod"]
    self.components.edtPort       = self.form["edtPort"]
    self.components.edtTempPath   = self.form["edtTempPath"]
    self.components.btnBrowseTemp = self.form["btnBrowseTemp"]
    self.components.edtDevPath    = self.form["edtDevPath"]
    self.components.btnBrowseDev  = self.form["btnBrowseDev"]
    self.components.btnSave       = self.form["btnSave"]
    self.components.btnClose      = self.form["btnClose"]

    self.components.cmbCommands     = self.form["cmbCommands"]
    self.components.edtCommandInput = self.form["edtCommandInput"]

    if self.components.lstConsole then
        Console.init(self.components.lstConsole)
    end
end

function FormManager:setupEvents()
    self:destroyAllTimers()

    self.tmrProcessCheck = createTimer(nil)
    self.tmrProcessCheck.Interval = 1000
    self.tmrProcessCheck.OnTimer = function()
        self:onProcessCheckTick()
    end
    self.tmrProcessCheck.Enabled = true

    self.tmrMemoryReader = createTimer(nil)
    self.tmrMemoryReader.Interval = 100
    self.tmrMemoryReader.OnTimer = function()
        self:onMemoryReaderTick()
    end
    self.tmrMemoryReader.Enabled = false

    self.tmrDataSaver = createTimer(nil)
    self.tmrDataSaver.Interval = 1000
    self.tmrDataSaver.OnTimer = function()
        self:onDataSaverTick()
    end
    self.tmrDataSaver.Enabled = false

    if self.components.cmbMethod then
        self.components.cmbMethod.onChange = function()
            self:onMethodChanged()
        end
    end

    if self.components.btnBrowseTemp then
        self.components.btnBrowseTemp.onClick = function()
            self:selectDirectory("edtTempPath")
        end
    end

    if self.components.btnBrowseDev then
        self.components.btnBrowseDev.onClick = function()
            self:selectDirectory("edtDevPath")
        end
    end

        -- ========================================================
    -- Eventos de la Consola Interactiva (Autocompletar y ENTER)
    -- ========================================================
    if self.components.cmbCommands and self.components.edtCommandInput then
        
        -- Detectar cambio en el ComboBox para autocompletar
        self.components.cmbCommands.onChange = function()
            local idx = self.components.cmbCommands.getItemIndex()
            if idx > 0 then
                local cmd = self.components.cmbCommands.getItems().getString(idx)
                
                if cmd == "clear" then
                    self.components.edtCommandInput.Text = ""
                    self.components.cmbCommands.setItemIndex(0)
                    Console.system("[Consola]: Entrada cancelada.")
                else
                    self.components.edtCommandInput.Text = cmd
                    self.components.edtCommandInput.setFocus()
                end
            end
        end

        -- Detectar ENTER o letras de descarte rápido en el Input
        self.components.edtCommandInput.onKeyPress = function(sender, key)
            if string.byte(key) == 13 then -- 13 es la tecla ENTER
                local inputCmd = self.components.edtCommandInput.Text

                if string.sub(inputCmd, 1, 1) == "/" then
                    inputCmd = string.sub(inputCmd, 2)
                end

                -- Procesamiento y enrutamiento de comandos
                if inputCmd == "save_data" then
                    Console.system("save_data -> Force saves game data.")
                    self.tmrDataSaver.Enabled = true
                elseif inputCmd == "set_classification_perfect" then
                    Console.system("[Ejecutando]: Ajustando calificaciones a 10.0...")
                elseif inputCmd ~= "" then
                    Console.system("[Error]: Comando '" .. inputCmd .. "' no reconocido.")
                end

                -- Limpiar estado
                self.components.edtCommandInput.Text = ""
                self.components.cmbCommands.setItemIndex(0)
                return false
            end
        end
    end
    -- ========================================================

    if self.components.btnSave then
        self.components.btnSave.onClick = function()
            self:onSavePressed()
        end
    end

    if self.components.btnClose then
        self.components.btnClose.onClick = function()
            self.allowClose = true
            self.form.close()
        end
    end

        self.form.OnClose = function()
        if not self.allowClose then
            if self.trayIcon then
                self.trayIcon.Visible = true
            end
            return caHide
        else
            Console.clear()
            self:destroyAllTimers()
            self:destroyTray()
            
            _G.Classes = nil
            
            self.form = nil
            self.components = {} -- Asegura una tabla limpia
            self.isChecking = false
            self.allowClose = false -- Reseteamos el flag para la próxima apertura
            
            return caFree
        end
    end
end

function FormManager:setupTrayIcon()
    self:destroyTray()

    local success, tray = pcall(function()
        return createComponentClass('TTrayIcon', self.form)
    end)
    
    if not success or not tray then
        return
    end

    self.trayIcon = tray
    self.trayIcon.Hint = "PES6 Match Connector"

    pcall(function()
        local tFile = findTableFile("trayIcon.ico")
        if tFile then
            local sl = createStringlist()
            sl.loadFromStream(tFile.getData())
            
            self.trayIcon.Icon.loadFromStream(tFile.getData())
            
            sl.destroy()
        end
    end)

    self.popupMenu = createPopupMenu(self.form)

    local menuShow = createMenuItem(self.popupMenu)
    menuShow.Caption = "Show Window"
    menuShow.OnClick = function()
        self.form.show()
    end
    self.popupMenu.Items.add(menuShow)

    local menuExit = createMenuItem(self.popupMenu)
    menuExit.Caption = "Exit"
    menuExit.OnClick = function()
        self.allowClose = true
        self.form.close()
    end
    self.popupMenu.Items.add(menuExit)

    self.trayIcon.PopupMenu = self.popupMenu
    self.trayIcon.OnClick = function()
        self.form.show()
    end

    self.trayIcon.Visible = true
end

function FormManager:destroyAllTimers()
    local timers = {self.tmrProcessCheck, self.tmrMemoryReader, self.tmrDataSaver}
    for _, tmr in ipairs(timers) do
        if tmr then
            tmr.Enabled = false
            tmr.OnTimer = nil
            tmr.destroy()
        end
    end
    self.tmrProcessCheck = nil
    self.tmrMemoryReader = nil
    self.tmrDataSaver = nil
end

function FormManager:destroyTray()
    if self.trayIcon then
        self.trayIcon.Visible = false
        self.trayIcon.PopupMenu = nil
        self.trayIcon = nil
    end
    if self.popupMenu then
        self.popupMenu.destroy()
        self.popupMenu = nil
    end
end

function FormManager:loadCurrentSettings()
    local settings = ConnectorCentral.settings

    if self.components.cmbMethod then
        self.components.cmbMethod.Items.clear()
        self.components.cmbMethod.Items.add("SOCKET")
        self.components.cmbMethod.Items.add("TEMP_JSON")
        self.components.cmbMethod.Items.add("SHARED_MEMORY")
        self.components.cmbMethod.Text = settings.currentMethod
    end

    if self.components.edtPort then
        self.components.edtPort.Text = tostring(settings.port)
    end

    if self.components.edtTempPath then
        self.components.edtTempPath.Text = settings.tempJsonPath
    end

    if _G.DEV_PATH and self.components.edtDevPath then
        self.components.edtDevPath.Text = _G.DEV_PATH
    end

    if self.components.lblStatus then
        self.components.lblStatus.Caption = "PES6 Status: Disconnected"
        self.components.lblStatus.Font.Color = 0x0000FF
    end

    if self.components.cmbCommands then
        self.components.cmbCommands.Items.clear()
        self.components.cmbCommands.Items.add("--- Seleccionar Comando ---")
        self.components.cmbCommands.Items.add("save_data")
        self.components.cmbCommands.Items.add("save_console_data")
        self.components.cmbCommands.Items.add("clear")
        self.components.cmbCommands.setItemIndex(0)
    end

    self:onMethodChanged()
end

function FormManager:selectDirectory(targetEditName)
    local dialog = createSelectDirectoryDialog(self.form)
    if dialog.execute() then
        if self.components[targetEditName] then
            self.components[targetEditName].Text = dialog.FileName
        end
    end
end

function FormManager:onProcessCheckTick()
    if self.isChecking then return end
    self.isChecking = true

    if not self.form or not self.tmrProcessCheck or not self.tmrProcessCheck.Enabled then
        self.isChecking = false
        return
    end

    if not self.components.lblStatus then
        self.isChecking = false
        return
    end

    if not _G.Classes or not _G.Classes.App or not _G.Classes.App.status then
        self.isChecking = false
        return
    end

    local pid = getProcessIDFromProcessName("pes6.exe")
    local isGameRunningNow = (pid ~= nil and pid ~= 0)
    local appInstance = _G.Classes.App

    if isGameRunningNow then
        if self.components.lblStatus then
            self.components.lblStatus.Caption = "PES6 Status: Connected"
            self.components.lblStatus.Font.Color = 0x00FF00
        end

        if not appInstance.status.isGameRunning then
            openProcess(pid)
            appInstance:setGameOpened()
            if self.tmrMemoryReader then
                self.tmrMemoryReader.Enabled = true
            end
        end
    else
        if self.components.lblStatus then
            self.components.lblStatus.Caption = "PES6 Status: Disconnected"
            self.components.lblStatus.Font.Color = 0x0000FF
        end

        if appInstance.status.isGameRunning then
            appInstance:setGameClosed()
            if self.tmrMemoryReader then
                self.tmrMemoryReader.Enabled = false
            end
            if self.tmrDataSaver then
                self.tmrDataSaver.Enabled = false
            end
        end
    end

    self.isChecking = false
end

function FormManager:onMemoryReaderTick()
    local reader = _G.Classes.MatchStateReader
    if not reader then return end

    reader:updateData()

    if reader.save then
        reader.save = false
        self.pendingSave = true
    end

    if self.pendingSave and reader.menuBackground == 5 then
        self.pendingSave = false

        if self.tmrDataSaver then
            self.tmrDataSaver.Enabled = true
            Console.data("Data saving triggered: Menu background detected.")
        end
    end
end

function FormManager:onDataSaverTick()
    self.tmrDataSaver.Enabled = false

    local gameDataInstance = _G.Classes.GameData
    local connector = _G.Classes.ConnectorCentral

    if gameDataInstance and connector then
        gameDataInstance:updateData()
        local realTableData = gameDataInstance:toTable()

        Console.data("Saving match data...")

        createThread(function()
            local success, err = pcall(function()
                connector:send("MATCH_DATA", realTableData)
            end)

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

function FormManager:onMethodChanged()
    if not self.components.cmbMethod then return end

    local method = self.components.cmbMethod.Text

    if self.components.edtPort then
        self.components.edtPort.Enabled = (method == "SOCKET")
    end
end

function FormManager:onSavePressed()
    local settings = ConnectorCentral.settings

    if self.components.cmbMethod then
        settings.currentMethod = self.components.cmbMethod.Text
    end

    if self.components.edtPort then
        settings.port = tonumber(self.components.edtPort.Text) or settings.port
    end

    if self.components.edtTempPath then
        settings.tempJsonPath = self.components.edtTempPath.Text
    end

    if self.components.edtDevPath then
        _G.DEV_PATH = self.components.edtDevPath.Text
    end

    Console.system("Settings saved successfully.")
end

return FormManager