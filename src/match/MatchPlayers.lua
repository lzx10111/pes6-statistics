local Data = _G.Classes.Data
local Address = _G.Classes.Address

local MatchPlayers = {}
MatchPlayers.__index = MatchPlayers

setmetatable(MatchPlayers, { __index = Data })

-- Dirección base de los futbolistas activos en el partido (0x348 = 840 bytes por jugador)
local PLAYERS_BASE_ADDR = Address:create("pes6.exe+37CF550", { 0 }, { 1 }, 0)
local PLAYER_STRUCT_SIZE = 0x348 -- 840 bytes
local NAME_OFFSET = 0x138        -- Offset del nombre corto ("Barthez", "Thuram", "Sagnol", "Vieira"...)
local TEAM_SLOT_COUNT = 32       -- 32 slots por equipo: 0..31 Home (Local), 32..63 Away (Visitante)

function MatchPlayers:new(o)
    o = o or {}
    setmetatable(o, self)
    return o
end

function MatchPlayers:setData()
    PLAYERS_BASE_ADDR:refresh()

    self.home = self:getTeamPlayers(0)
    self.away = self:getTeamPlayers(TEAM_SLOT_COUNT)
end

function MatchPlayers:getSimpleName()
    return "MatchPlayers"
end

-- Lee el nombre limpio desde +0x138 cortando al primer byte nulo (0x00)
function MatchPlayers:readPlayerName(playerBaseDec)
    local nameAddrHex = string.format("%X", playerBaseDec + NAME_OFFSET)
    local rawName = readString(nameAddrHex, 32) or ""
    return rawName:match("^([^%z]+)") or ""
end

-- Extrae la convocatoria completa de un equipo (startSlot = 0 para Home, 32 para Away)
function MatchPlayers:getTeamPlayers(startSlot)
    local players = {}
    local baseDec = tonumber(PLAYERS_BASE_ADDR.address, 16) or 0

    for i = 0, TEAM_SLOT_COUNT - 1 do
        local slotIndex = startSlot + i
        local playerBaseDec = baseDec + (slotIndex * PLAYER_STRUCT_SIZE)
        local playerBaseHex = string.format("%X", playerBaseDec)

        local shirtAddr = Address:create(playerBaseHex, { 0 }, { 1 }, 0)
        local rawShirt = shirtAddr:readFieldByIndex(1) or 255
        local name = self:readPlayerName(playerBaseDec)

        -- 255 (0xFF) en el dorsal indica slot vacío ("No registrado")
        if rawShirt ~= 255 and name ~= "" and name ~= "No registrado" then
            table.insert(players, {
                id          = i,            -- ID limpio dentro del equipo (0..22 / 0..31)
                slotIndex   = slotIndex,    -- Índice absoluto en la tabla (0..31 Home, 32..63 Away)
                shirtNumber = rawShirt + 1, -- Dorsal real (+0x00 + 1)
                name        = name          -- Nombre en +0x138
            })
        end
    end

    return players
end

-- Método auxiliar para consultar un jugador rápido desde otras clases (ej. TeamShotsOnGoal)
function MatchPlayers:findPlayer(side, playerId)
    local list = (side == "away") and self.away or self.home
    if not list then return nil end

    for _, player in ipairs(list) do
        if player.id == playerId then
            return player
        end
    end
    return nil
end

return MatchPlayers