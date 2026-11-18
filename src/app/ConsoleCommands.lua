local Console = _G.Classes.Console
local ConsoleDocs = _G.Classes.ConsoleDocs
local GameData = _G.Classes.GameData
local MatchStateReader = _G.Classes.MatchStateReader
local ConsoleCommands = {}

local currentPath = {}
local lastLsKeys = {}
local lastHelpCommands = {}

local INTERNAL_METHODS = {
    execute = true,
    getCommandList = true
}

local function resolveCurrentNode(extraPath)
    GameData:updateData()
    local data = GameData:toTable()
    data.matchInterval = MatchStateReader.matchInterval

    local node = data
    for _, key in ipairs(currentPath) do
        if type(node) == "table" then
            node = node[key] or node[tonumber(key)]
        else
            return nil
        end
    end

    if extraPath and extraPath ~= "" then
        for key in string.gmatch(extraPath, "[^%.]+") do
            if type(node) == "table" then
                node = node[key] or node[tonumber(key)]
            else
                return nil
            end
        end
    end

    return node
end

local function getPathString()
    return (#currentPath == 0) and "root" or ("root." .. table.concat(currentPath, "."))
end

function ConsoleCommands.pwd()
    Console.system("Current path: " .. getPathString(), "pwd")
end

function ConsoleCommands.ls()
    local node = resolveCurrentNode()
    if type(node) ~= "table" then
        Console.system("Current node is a value: " .. tostring(node), "ls")
        return
    end

    lastLsKeys = {}
    for k, _ in pairs(node) do
        table.insert(lastLsKeys, k)
    end
    table.sort(lastLsKeys, function(a, b) return tostring(a) < tostring(b) end)

    Console.system("Contents of " .. getPathString() .. ":", "ls")
    for idx, k in ipairs(lastLsKeys) do
        local v = node[k]
        local suffix = (type(v) == "table") and "/" or (" = " .. tostring(v))
        Console.system(string.format("  [%d] %s%s", idx, tostring(k), suffix))
    end
end

function ConsoleCommands.cd(formManager, formEvents, target)
    if not target or target == "" or target == "/" or target == "root" then
        currentPath = {}
        Console.system("Moved to: " .. getPathString(), "cd")
        ConsoleCommands.ls()
        return
    end

    if target == ".." then
        if #currentPath > 0 then table.remove(currentPath) end
        Console.system("Moved to: " .. getPathString(), "cd")
        ConsoleCommands.ls()
        return
    end

    local currentNode = resolveCurrentNode()
    if type(currentNode) ~= "table" then
        Console.error("Current path is not a table.")
        return
    end

    local matchedKey = nil
    local numTarget = tonumber(target)

    if numTarget and lastLsKeys[numTarget] ~= nil then
        matchedKey = lastLsKeys[numTarget]
    elseif currentNode[target] ~= nil then
        matchedKey = target
    else
        local lowerTarget = string.lower(target)
        local matches = {}
        for k, _ in pairs(currentNode) do
            local keyStr = tostring(k)
            if string.sub(string.lower(keyStr), 1, #lowerTarget) == lowerTarget then
                table.insert(matches, keyStr)
            end
        end
        table.sort(matches)
        if #matches == 1 then
            matchedKey = matches[1]
        elseif #matches > 1 then
            Console.system("Multiple matches: " .. table.concat(matches, ", "), "cd")
            return
        end
    end

    if matchedKey == nil then
        Console.error("Path not found: " .. getPathString() .. "." .. target)
        return
    end

    table.insert(currentPath, matchedKey)
    Console.system("Moved to: " .. getPathString(), "cd")
    ConsoleCommands.ls()
end

function ConsoleCommands.view(formManager, formEvents, extraPath)
    local fullLabel = getPathString() .. ((extraPath and extraPath ~= "") and ("." .. extraPath) or "")
    Console.system("Viewing: " .. fullLabel, "view")

    ---@diagnostic disable-next-line: undefined-global
    createThread(function(thread)
        local targetNode = resolveCurrentNode(extraPath)
        thread.synchronize(function()
            if targetNode ~= nil then
                formEvents.viewData(fullLabel, targetNode)
            else
                Console.error("Path not found: " .. fullLabel)
            end
        end)
    end)
end

function ConsoleCommands.save(formManager, formEvents, extraPath)
    local fullLabel = getPathString() .. ((extraPath and extraPath ~= "") and ("." .. extraPath) or "")

    if #currentPath == 0 and (not extraPath or extraPath == "") then
        Console.system("Force saves full game data.", "save")
        formManager.tmrDataSaver.Enabled = true
        return
    end

    Console.system("Saving partial data: " .. fullLabel, "save")

    ---@diagnostic disable-next-line: undefined-global
    createThread(function(thread)
        local targetNode = resolveCurrentNode(extraPath)
        if targetNode == nil then
            thread.synchronize(function() Console.error("Path not found: " .. fullLabel) end)
            return
        end

        local connector = _G.Classes.ConnectorCentral
        local success, err = pcall(function()
            connector:send("MATCH_DATA_PART", { path = fullLabel, data = targetNode })
        end)

        thread.synchronize(function()
            if success then
                Console.data("Saved successfully: " .. fullLabel)
            else
                Console.error("Failed to save " .. fullLabel .. ": " .. tostring(err))
            end
        end)
    end)
end

function ConsoleCommands.save_game_data(formManager)
    Console.system("Force saves game data.", "save_game_data")
    formManager.tmrDataSaver.Enabled = true
end

function ConsoleCommands.view_game_data(formManager, formEvents)
    ConsoleCommands.view(formManager, formEvents, nil)
end

function ConsoleCommands.view_classnames(formManager, formEvents)
    Console.system("View classnames.", "view_classnames")
    local classNames = {}
    for className, _ in pairs(_G.Classes) do
        table.insert(classNames, className)
    end
    formEvents.viewData("view_classnames", classNames)
end

function ConsoleCommands.clear()
    Console.clear()
end

function ConsoleCommands.help(formManager, formEvents, target)
    if #lastHelpCommands == 0 then
        lastHelpCommands = ConsoleCommands.getCommandList()
    end

    if not target or target == "" then
        lastHelpCommands = ConsoleCommands.getCommandList()
        Console.system("Available commands (use /help <index | prefix> for details):", "help")
        for idx, cmdName in ipairs(lastHelpCommands) do
            Console.system(string.format("  [%d] /%s", idx, cmdName))
        end
        return
    end

    if string.sub(target, 1, 1) == "/" then
        target = string.sub(target, 2)
    end

    local matchedCmd = nil
    local numTarget = tonumber(target)

    if numTarget and lastHelpCommands[numTarget] then
        matchedCmd = lastHelpCommands[numTarget]
    elseif ConsoleCommands[target] and not INTERNAL_METHODS[target] then
        matchedCmd = target
    else
        local lowerTarget = string.lower(target)
        local matches = {}
        for _, cmdName in ipairs(ConsoleCommands.getCommandList()) do
            if string.sub(string.lower(cmdName), 1, #lowerTarget) == lowerTarget then
                table.insert(matches, cmdName)
            end
        end
        if #matches == 1 then
            matchedCmd = matches[1]
        elseif #matches > 1 then
            Console.system("Multiple commands match '" .. target .. "': /" .. table.concat(matches, ", /"), "help")
            return
        end
    end

    if not matchedCmd then
        Console.error("Unknown command in help: " .. target)
        return
    end

    local doc = ConsoleDocs and ConsoleDocs.get(matchedCmd)
    if doc then
        Console.system(doc.desc, matchedCmd)
    else
        Console.system("Command /" .. matchedCmd .. " has no detailed description yet.", matchedCmd)
    end
end

function ConsoleCommands.getCommandList()
    local commands = {}
    for cmdName, handler in pairs(ConsoleCommands) do
        if type(handler) == "function" and not INTERNAL_METHODS[cmdName] then
            table.insert(commands, cmdName)
        end
    end
    table.sort(commands)
    return commands
end

function ConsoleCommands.execute(rawInput, formManager, formEvents)
    if not rawInput or rawInput == "" then return end

    local cmdName, arg = rawInput:match("^(%S+)%s*(.*)$")
    if not cmdName then return end

    local handler = ConsoleCommands[cmdName]
    if type(handler) == "function" and not INTERNAL_METHODS[cmdName] then
        handler(formManager, formEvents, arg)
    else
        Console.system("Invalid command: " .. cmdName .. " (type /help to see available commands)")
    end
end

return ConsoleCommands