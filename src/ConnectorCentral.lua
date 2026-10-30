local ConnectorCentral = {
    settings = {
        currentMethod = "TEMP_JSON",
        port = 65432,
        host = "127.0.0.1",
        tempJsonPath = "C:/Windows/Temp/"
    }
}

local function transmitBySocket(jsonString)
    local socket = require("socket")
    local tcp = socket.tcp()
    tcp:settimeout(2)

    local success, err = tcp:connect(ConnectorCentral.settings.host, ConnectorCentral.settings.port)
    if success then
        tcp:send(jsonString)
        tcp:close()
        return true
    else
        return false
    end
end

local function transmitByTempJson(jsonString)
    local path = ConnectorCentral.settings.tempJsonPath
    if not path:match("[/\\]$") then
        path = path .. "/"
    end

    ---@diagnostic disable-next-line: undefined-global
    local filename = path .. "pes6_payload_" .. getTickCount() .. ".json"
    ---@diagnostic disable-next-line: undefined-global
    local sl = createStringList()

    if sl then
        sl.add(jsonString)
        sl.saveToFile(filename)
        sl.destroy()
        return true
    else
        return false
    end
end

local function transmitBySharedMemory(jsonString)
    return false
end

function ConnectorCentral:send(dataType, dataContent)
    local json = require("json")
    local payload = {
        type = dataType,
        data = dataContent
    }
    local jsonString = json.encode(payload)
    local method = self.settings.currentMethod

    if method == "SOCKET" then
        return transmitBySocket(jsonString)
    elseif method == "TEMP_JSON" then
        return transmitByTempJson(jsonString)
    elseif method == "SHARED_MEMORY" then
        return transmitBySharedMemory(jsonString)
    else
        return false
    end
end

return ConnectorCentral