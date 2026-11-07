local Console = _G.Classes.Console
local json = require("json")

local FormEventsJsonViewer = {}

local function populateTree(treeView, parentNode, luaData)
    for key, value in pairs(luaData) do
        if type(value) == 'table' then
            local isArray = (#value > 0)
            local nodeLabel = isArray and string.format("%s [Array]", tostring(key)) or tostring(key)

            local childNode = parentNode.add(nodeLabel)
            populateTree(treeView, childNode, value)
        else
            local displayValue = tostring(value)
            if type(value) == 'string' then displayValue = '"' .. displayValue .. '"' end
            local displayText = string.format("%s: %s", tostring(key), displayValue)

            parentNode.add(displayText)
        end
    end
end

function FormEventsJsonViewer.onBtnParseClick(frmJsonViewer, command, directLuaString)
    local components = frmJsonViewer.components

    local jsonString = directLuaString or "{}"
    ---@diagnostic disable-next-line: undefined-global
    createThread(function(thread)
        local success, parsedTable = pcall(json.decode, jsonString)

        thread.synchronize(function()
            components.treeView.beginUpdate()
            components.treeView.Items.clear()

            if success and parsedTable then
                local rootNode = components.treeView.Items.add("JSON_DATA_ROOT")
                populateTree(components.treeView, rootNode, parsedTable)
                rootNode.expand(false)
            else
                Console.system("The provided string is not a valid JSON.", command or "JSON_VIEWER")
            end

            components.treeView.endUpdate()
        end)
    end)
end

function FormEventsJsonViewer.onFormClose()
    return caHide
end

return FormEventsJsonViewer