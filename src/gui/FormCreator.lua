local FormCreator = {}

function FormCreator:build()
    if frmConfig then
        pcall(function() frmConfig.destroy() end)
        frmConfig = nil
    end

    -- Base Window
    frmConfig = createForm(false)
    frmConfig.Caption = "PES6 Match Connector Settings"
    frmConfig.Width = 520
    frmConfig.Height = 560
    frmConfig.Position = "poScreenCenter"
    frmConfig.BorderStyle = "bsSingle"

    -- Core Layout Constraints
    local leftMargin = 25
    local topMargin  = 25
    local contentWidth = frmConfig.Width - (leftMargin * 2)
    local labelColumnX = leftMargin
    local inputColumnX = 175
    local rowHeight = 32

    -- Status Row
    local lblStatus = createLabel(frmConfig)
    lblStatus.Name = "lblStatus"
    lblStatus.Parent = frmConfig
    lblStatus.Left = leftMargin
    lblStatus.Top = topMargin
    lblStatus.Font.Size = 10
    lblStatus.Font.Style = "['fsBold']"

    -- Row 1: Project Folder
    local lblDev = createLabel(frmConfig)
    lblDev.Parent = frmConfig
    lblDev.Left = labelColumnX
    lblDev.Top = topMargin + 35
    lblDev.Caption = "Project Folder:"

    local edtDevPath = createEdit(frmConfig)
    edtDevPath.Name = "edtDevPath"
    edtDevPath.Parent = frmConfig
    edtDevPath.Left = inputColumnX
    edtDevPath.Top = lblDev.Top - 3
    edtDevPath.Width = frmConfig.Width - inputColumnX - 85 - leftMargin

    local btnBrowseDev = createButton(frmConfig)
    btnBrowseDev.Name = "btnBrowseDev"
    btnBrowseDev.Parent = frmConfig
    btnBrowseDev.Left = inputColumnX + edtDevPath.Width + 10
    btnBrowseDev.Top = edtDevPath.Top - 1
    btnBrowseDev.Width = 75
    btnBrowseDev.Height = 23
    btnBrowseDev.Caption = "Browse..."

    -- Row 2: Transmission Method
    local lblMethod = createLabel(frmConfig)
    lblMethod.Parent = frmConfig
    lblMethod.Left = labelColumnX
    lblMethod.Top = lblDev.Top + rowHeight
    lblMethod.Caption = "Transmission Method:"

    local cmbMethod = createComboBox(frmConfig)
    cmbMethod.Name = "cmbMethod"
    cmbMethod.Parent = frmConfig
    cmbMethod.Left = inputColumnX
    cmbMethod.Top = lblMethod.Top - 3
    cmbMethod.Width = 180
    cmbMethod.Style = "csDropDownList"

    -- Row 3: Port
    local lblPort = createLabel(frmConfig)
    lblPort.Parent = frmConfig
    lblPort.Left = labelColumnX
    lblPort.Top = lblMethod.Top + rowHeight
    lblPort.Caption = "Port:"

    local edtPort = createEdit(frmConfig)
    edtPort.Name = "edtPort"
    edtPort.Parent = frmConfig
    edtPort.Left = inputColumnX
    edtPort.Top = lblPort.Top - 3
    edtPort.Width = 70

    -- Row 4: Temp Folder
    local lblTemp = createLabel(frmConfig)
    lblTemp.Parent = frmConfig
    lblTemp.Left = labelColumnX
    lblTemp.Top = lblPort.Top + rowHeight
    lblTemp.Caption = "Temp Folder:"

    local edtTempPath = createEdit(frmConfig)
    edtTempPath.Name = "edtTempPath"
    edtTempPath.Parent = frmConfig
    edtTempPath.Left = inputColumnX
    edtTempPath.Top = lblTemp.Top - 3
    edtTempPath.Width = frmConfig.Width - inputColumnX - 85 - leftMargin

    local btnBrowseTemp = createButton(frmConfig)
    btnBrowseTemp.Name = "btnBrowseTemp"
    btnBrowseTemp.Parent = frmConfig
    btnBrowseTemp.Left = inputColumnX + edtTempPath.Width + 10
    btnBrowseTemp.Top = edtTempPath.Top - 1
    btnBrowseTemp.Width = 75
    btnBrowseTemp.Height = 23
    btnBrowseTemp.Caption = "Browse..."

    -- Console Block
    local lblConsole = createLabel(frmConfig)
    lblConsole.Parent = frmConfig
    lblConsole.Left = leftMargin
    lblConsole.Top = lblTemp.Top + 40
    lblConsole.Caption = "Console Output:"

    ---@diagnostic disable-next-line: undefined-global
    local lstConsole = createListBox(frmConfig)
    lstConsole.Name = "lstConsole"
    lstConsole.Parent = frmConfig
    lstConsole.Left = leftMargin
    lstConsole.Top = lblConsole.Top + 20
    lstConsole.Width = contentWidth
    lstConsole.Height = 130

    local cmbCommands = createComboBox(frmConfig)
    cmbCommands.Name = "cmbCommands"
    cmbCommands.Parent = frmConfig
    cmbCommands.Left = leftMargin
    cmbCommands.Top = lstConsole.Top + lstConsole.Height + 12
    cmbCommands.Width = 200
    cmbCommands.Style = "csDropDownList"

    local edtCommandInput = createEdit(frmConfig)
    edtCommandInput.Name = "edtCommandInput"
    edtCommandInput.Parent = frmConfig
    edtCommandInput.Left = cmbCommands.Left + cmbCommands.Width + 10
    edtCommandInput.Top = cmbCommands.Top
    edtCommandInput.Width = contentWidth - cmbCommands.Width - 10
    edtCommandInput.Text = ""

    -- Action Buttons
    local btnClose = createButton(frmConfig)
    btnClose.Name = "btnClose"
    btnClose.Parent = frmConfig
    btnClose.Left = frmConfig.Width - leftMargin - 75
    btnClose.Top = frmConfig.Height - 25 - 25
    btnClose.Width = 75
    btnClose.Height = 25
    btnClose.Caption = "Close"

    local btnSave = createButton(frmConfig)
    btnSave.Name = "btnSave"
    btnSave.Parent = frmConfig
    btnSave.Left = btnClose.Left - 85
    btnSave.Top = btnClose.Top
    btnSave.Width = 75
    btnSave.Height = 25
    btnSave.Caption = "Save"
end

return FormCreator