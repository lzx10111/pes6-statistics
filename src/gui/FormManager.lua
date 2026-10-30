local FormEventsTimers = _G.Classes.FormEventsTimers
local FormEvents = _G.Classes.FormEvents
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
    self.components.lstConsole      = self.form["lstConsole"]
    self.components.lblStatus       = self.form["lblStatus"]
    self.components.cmbMethod       = self.form["cmbMethod"]
    self.components.edtPort         = self.form["edtPort"]
    self.components.edtTempPath     = self.form["edtTempPath"]
    self.components.btnBrowseTemp   = self.form["btnBrowseTemp"]
    self.components.edtDevPath      = self.form["edtDevPath"]
    self.components.btnBrowseDev    = self.form["btnBrowseDev"]
    self.components.btnSave         = self.form["btnSave"]
    self.components.btnClose        = self.form["btnClose"]

    self.components.cmbCommands     = self.form["cmbCommands"]
    self.components.edtCommandInput = self.form["edtCommandInput"]

    if self.components.lstConsole then
        Console.init(self.components.lstConsole)
    end
end

function FormManager:setupEvents()
    self:destroyAllTimers()

    ---@diagnostic disable-next-line: undefined-global
    self.tmrProcessCheck = createTimer(nil)
    self.tmrProcessCheck.Interval = 1000
    self.tmrProcessCheck.OnTimer = function()
        FormEventsTimers.onProcessCheckTick(self)
    end
    self.tmrProcessCheck.Enabled = true

    ---@diagnostic disable-next-line: undefined-global
    self.tmrMemoryReader = createTimer(nil)
    self.tmrMemoryReader.Interval = 100
    self.tmrMemoryReader.OnTimer = function()
        FormEventsTimers.onMemoryReaderTick(self)
    end
    self.tmrMemoryReader.Enabled = false

    ---@diagnostic disable-next-line: undefined-global
    self.tmrDataSaver = createTimer(nil)
    self.tmrDataSaver.Interval = 1000
    self.tmrDataSaver.OnTimer = function()
        FormEventsTimers.onDataSaverTick(self)
    end
    self.tmrDataSaver.Enabled = false

    if self.components.cmbMethod then
        self.components.cmbMethod.onChange = function()
            FormEvents.onCmbMethodChange(self)
        end
    end

    if self.components.btnBrowseTemp then
        self.components.btnBrowseTemp.onClick = function()
            FormEvents.onBtnBrowseTempClick(self)
        end
    end

    if self.components.btnBrowseDev then
        self.components.btnBrowseDev.onClick = function()
            FormEvents.onBtnBrowseDevClick(self)
        end
    end

    if self.components.cmbCommands and self.components.edtCommandInput then
        self.components.cmbCommands.onChange = function()
            FormEvents.onCmbCommandsChange(self)
        end

        self.components.edtCommandInput.onKeyPress = function(sender, key)
            return FormEvents.onEdtCommandInputKeyPress(self, key)
        end
    end

    if self.components.btnSave then
        self.components.btnSave.onClick = function()
            FormEvents.onBtnSaveClick(self)
        end
    end

    if self.components.btnClose then
        self.components.btnClose.onClick = function()
            FormEvents.onBtnCloseClick(self)
        end
    end

    self.form.OnClose = function()
        return FormEvents.onFormClose(self)
    end
end

function FormManager:setupTrayIcon()
    self:destroyTray()

    local success, tray = pcall(function()
        ---@diagnostic disable-next-line: undefined-global
        return createComponentClass('TTrayIcon', self.form)
    end)

    if not success or not tray then
        return
    end

    self.trayIcon = tray
    self.trayIcon.Hint = "PES6 Match Connector"

    self.popupMenu = createPopupMenu(self.form)

    local menuShow = createMenuItem(self.popupMenu)
    menuShow.Caption = "Show Window"
    menuShow.OnClick = function()
        FormEvents.onTrayShowForm(self)
    end
    self.popupMenu.Items.add(menuShow)

    local menuExit = createMenuItem(self.popupMenu)
    menuExit.Caption = "Exit"
    menuExit.OnClick = function()
        FormEvents.onTrayExitClick(self)
    end
    self.popupMenu.Items.add(menuExit)

    self.trayIcon.PopupMenu = self.popupMenu
    self.trayIcon.OnClick = function()
        FormEvents.onTrayShowForm(self)
    end

    self.trayIcon.Visible = true
end

function FormManager:destroyAllTimers()
    local timers = { self.tmrProcessCheck, self.tmrMemoryReader, self.tmrDataSaver }
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

    FormEvents.onCmbMethodChange(self)
end

return FormManager