local Math = {}

-- Genera múltiplos: Math.multiples(3, 5) -> {0, 3, 6, 9, 12}
function Math.multiples(number, count)
    local result = {}
    for i = 0, count - 1 do
        table.insert(result, i * number)
    end
    return result
end

-- Genera repetidos: Math.repeat(1, 3) -> {1, 1, 1}
function Math.replicate(number, count)
    local result = {}
    for i = 1, count do
        table.insert(result, number)
    end
    return result
end

-- Limita un rango: Math.clamp(val, min, max)
function Math.clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

return Math