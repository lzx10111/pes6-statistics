_G.Classes = nil
collectgarbage("collect")

_G.Classes = {}

local function autoDiscoverAndFilterDevPath()
    local userPath = os.getenv("USERPROFILE") or "C:\\Users"
    local searchRoots = {
        userPath .. "\\Documents\\",
        userPath .. "\\Desktop\\",
        userPath .. "\\Downloads\\"
    }

    for _, path in ipairs(searchRoots) do
        ---@diagnostic disable-next-line: undefined-global
        local results = getFileList(path, "main.lua", true)

        if results and #results > 0 then
            for _, fullPath in ipairs(results) do
                if string.find(fullPath:lower(), "pes6-statistics", 1, true) then
                    local projectRoot = fullPath:match("(.*)[\\/][^\\/]*$") or fullPath

                    if not projectRoot:match("[\\/]$") then 
                        projectRoot = projectRoot .. "\\" 
                    end

                    return projectRoot .. "src\\"
                end
            end
        end
    end

    return nil
end

local devPath = autoDiscoverAndFilterDevPath()

_G.DEV_PATH = devPath

local classPathMap = {}

local function getDependencies(codeString)
    local deps = {}
    if not codeString then return deps end
    for dep in string.gmatch(codeString, "_G%.Classes%.([%a_][%w_]*)") do
        table.insert(deps, dep)
    end
    return deps
end

local function getFileCodeByPath(absolutePath, className)
    local codeString = nil
    local file = io.open(absolutePath, "r")
    if file then
        codeString = file:read("*all")
        file:close()
    else
        local filename = className:match("%.lua$") and className or (className .. ".lua")
        local tFile = findTableFile(filename)
        if tFile then
            local sl = createStringlist()
            ---@diagnostic disable-next-line: undefined-field
            sl.loadFromStream(tFile.getData())
            codeString = sl.Text
            sl.destroy()
        end
    end
    return codeString
end

local function resolveLoadOrder()
    local loadOrder = {}
    local visited = {}
    local tempVisited = {}
    local fileMap = {}

    ---@diagnostic disable-next-line: undefined-global
    local files = getFileList(_G.DEV_PATH, "*.lua", true) or {}
    local allClassNames = {}

    for _, filePath in ipairs(files) do
        local name = filePath:match("([^\\/]+)%.lua$")

        if name and name ~= "main" then
            table.insert(allClassNames, name)
            classPathMap[name] = filePath
            fileMap[name] = getFileCodeByPath(filePath, name)
        end
    end

    local function visit(className)
        if tempVisited[className] then
            print("⚠️ Dependencia cíclica potencial detectada en: " .. className)
            return
        end

        if not visited[className] then
            tempVisited[className] = true

            local code = fileMap[className]
            local deps = getDependencies(code)

            for _, depName in ipairs(deps) do
                if fileMap[depName] and depName ~= className then
                    visit(depName)
                end
            end

            tempVisited[className] = nil
            visited[className] = true
            table.insert(loadOrder, className)
        end
    end

    for _, className in ipairs(allClassNames) do
        visit(className)
    end

    return loadOrder
end

local function loadOrderedClass(className)
    if _G.Classes[className] then return _G.Classes[className] end

    local absolutePath = classPathMap[className]
    if not absolutePath then
        error("No se pudo mapear la ruta para la clase: " .. className)
    end

    local codeString = getFileCodeByPath(absolutePath, className)

    if codeString then
        local luaFunction, compileErr = loadstring(codeString)
        if luaFunction then
            local returnedClass = luaFunction()
            if returnedClass then
                _G.Classes[className] = returnedClass
                return returnedClass
            else
                error("Error: " .. className .. " no retornó ningún valor.")
            end
        else
            error("Error de sintaxis en " .. className .. " (" .. absolutePath .. "): " .. tostring(compileErr))
        end
    else
        error("No se pudo leer el archivo físico en: " .. absolutePath)
    end
end

local function initializeProject()
    local success, loadOrder = pcall(resolveLoadOrder)
    if not success then
        print("Error crítico ordenando dependencias: " .. tostring(loadOrder))
        return
    end

    for _, className in ipairs(loadOrder) do
        loadOrderedClass(className)
    end
end

_G.Classes = {}
initializeProject()

if _G.Classes.FormCreator and _G.Classes.FormCreator.build then
    _G.Classes.FormCreator:build()
else
    error("Error: No se pudo encontrar la clase estática FormCreator o su método build.")
end

_G.Classes.FormManager.allowClose = false
_G.Classes.FormManager:init(frmConfig)
frmConfig.show()

_G.Classes.FormCreator = nil
collectgarbage("collect")