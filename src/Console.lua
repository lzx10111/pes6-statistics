Console = {
    lstConsole = nil,
    history = {},
    colors = {}
}

local emergencyLimit = 500

function Console.init(lstComponent)
    Console.lstConsole = lstComponent
    Console.history = {}
    Console.colors = {}

    if Console.lstConsole then
        Console.lstConsole.Style = 'lbOwnerDrawFixed'
        Console.lstConsole.ItemHeight = 18

        Console.lstConsole.OnDrawItem = function(sender, index, rect, state)
            local canvas = sender.Canvas

            canvas.Brush.Color = sender.Color or 0xFFFFFF
            canvas.fillRect(rect)

            if Console.colors and index < #Console.colors then
                local color = Console.colors[index + 1] or 0x000000
                canvas.Font.Color = color
            else
                canvas.Font.Color = 0x000000
            end

            if index < sender.Items.Count then
                local text = sender.Items.getString(index)
                canvas.textOut(rect.Left + 4, rect.Top + 2, text)
            end
        end
    end
end

local function writeToConsole(message, colorCode)
    table.insert(Console.history, message)

    if Console.lstConsole then
        if Console.lstConsole.Items.Count >= emergencyLimit then
            Console.clear()
            writeToConsole("[SYSTEM] Console auto-cleared due to emergency limit.", 0x0080FF)
        end

        Console.lstConsole.Items.add(message)
        table.insert(Console.colors, colorCode or 0x000000)
        Console.lstConsole.ItemIndex = Console.lstConsole.Items.Count - 1
    else
        print("[Console Error] ListBox not assigned: " .. tostring(message))
    end
end

function Console.log(message)
    writeToConsole(message, 0x000000)
end

function Console.error(message)
    writeToConsole("[ERROR] " .. message, 0x0000FF)
end

function Console.data(message)
    writeToConsole("[DATA] " .. message, 0x006400)
end

function Console.getHistory()
    return Console.history
end

function Console.clear()
    Console.colors = {}
    if Console.lstConsole then
        Console.lstConsole.Items.clear()
    end
end

return Console