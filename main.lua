_G.Classes = nil
collectgarbage("collect")

_G.Classes = {}

_G.DEV_PATH = ""

local function getClassNames()
    return {
        "Console",
        "ConnectorCentral",
        "MatchStateReader",
        "FormManager",
        "Root",
        "String",
        "Data",
        "App",
        "Address",
        "MatchSummaryStats",
        "Antecedent",
        "MatchCornerKick",
        "MatchDribbling",
        "MatchFoulKicks",
        "MatchFouls",
        "MatchPass",
        "MatchPassesCut",
        "MatchPossessionZone",
        "MatchScoreBoard",
        "MatchShotsOnGoal",
        "MatchStats",
        "MatchResultsHome",
        "MatchResultsAway",
        "CardRegistration",
        "HomeCardRegistration",
        "MatchDetails",
        "GameData"
    }
end

local function createDynamicForm()
    if frmConfig then
        pcall(function() frmConfig.destroy() end)
        frmConfig = nil
    end

    -- Base Window
    frmConfig = createForm(false)
    frmConfig.Caption = "PES6 Match Connector Settings"
    frmConfig.Width = 520
    frmConfig.Height = 490
    frmConfig.Position = "poScreenCenter"
    frmConfig.BorderStyle = "bsSingle"

    -- Core Layout Constraints
    local leftMargin = 25
    local topMargin  = 25
    local contentWidth = frmConfig.Width - (leftMargin * 2) -- 470
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

    -- Row 1: Project Folder (lblDevPath + edtDevPath + btnBrowseDev)
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
    edtDevPath.Width = 280

    local btnBrowseDev = createButton(frmConfig)
    btnBrowseDev.Name = "btnBrowseDev"
    btnBrowseDev.Parent = frmConfig
    btnBrowseDev.Left = inputColumnX + edtDevPath.Width + 10
    btnBrowseDev.Top = edtDevPath.Top - 1
    btnBrowseDev.Width = 75
    btnBrowseDev.Height = 23
    btnBrowseDev.Caption = "Browse..."

    -- Row 2: Transmission Method (lblMethod + cmbMethod)
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

    -- Row 3: Port (lblPort + edtPort)
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

    -- Row 4: Temp Folder (lblTemp + edtTempPath + btnBrowseTemp)
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
    edtTempPath.Width = 280

    local btnBrowseTemp = createButton(frmConfig)
    btnBrowseTemp.Name = "btnBrowseTemp"
    btnBrowseTemp.Parent = frmConfig
    btnBrowseTemp.Left = inputColumnX + edtTempPath.Width + 10
    btnBrowseTemp.Top = edtTempPath.Top - 1
    btnBrowseTemp.Width = 75
    btnBrowseTemp.Height = 23
    btnBrowseTemp.Caption = "Browse..."

    -- Console Block (Occupies total width of upper components area)
    local lblConsole = createLabel(frmConfig)
    lblConsole.Parent = frmConfig
    lblConsole.Left = leftMargin
    lblConsole.Top = lblTemp.Top + 40
    lblConsole.Caption = "Console Output:"

    local lstConsole = createListBox(frmConfig)
    lstConsole.Name = "lstConsole"
    lstConsole.Parent = frmConfig
    lstConsole.Left = leftMargin
    lstConsole.Top = lblConsole.Top + 20
    lstConsole.Width = contentWidth
    lstConsole.Height = 170

    -- Action Buttons (Bottom - Right Aligned with 25px bottom boundary)
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

local function loadOrderedClass(className)
    if _G.Classes[className] then
        return _G.Classes[className]
    end

    local filename = className
    if not filename:match("%.lua$") then
        filename = filename .. ".lua"
    end

    local localPath = _G.DEV_PATH .. filename
    local codeString = nil

    local file = io.open(localPath, "r")
    if file then
        codeString = file:read("*all")
        file:close()
    else
        local tFile = findTableFile(filename)
        if tFile then
            local sl = createStringlist()
            ---@diagnostic disable-next-line: undefined-field
            sl.loadFromStream(tFile.getData())
            codeString = sl.Text
            sl.destroy()
        end
    end

    if codeString then
        local luaFunction, compileErr = loadstring(codeString)
        if luaFunction then
            local returnedClass = luaFunction()
            if returnedClass then
                _G.Classes[className] = returnedClass
                return returnedClass
            else
                error("Error: " .. filename .. " did not return any value.")
            end
        else
            error("Syntax error in " .. filename .. ": " .. tostring(compileErr))
        end
    else
        error("Could not find file for class: " .. filename)
    end
end

local function initializeProject()
    local loadOrder = getClassNames()

    for _, className in ipairs(loadOrder) do
        loadOrderedClass(className)
    end
end

if type(initializeProject) == "function" then
    _G.Classes = {}
    initializeProject()
else
    Console.error("Loader function not found yet or not initialized globally.")
end

createDynamicForm()

_G.Classes.FormManager.allowClose = false
_G.Classes.FormManager:init(frmConfig)

frmConfig.show()