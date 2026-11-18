local ConsoleDocs = {}

ConsoleDocs.entries = {
    cd = {
        usage = "/cd <index | name | prefix | .. | />",
        desc  = "Navigates into a JSON branch by index (from /ls), name, or prefix. Use '..' to go back or '/' for root."
    },
    clear = {
        usage = "/clear",
        desc  = "Clears all messages and resets colors in the console window."
    },
    help = {
        usage = "/help [index | command | prefix]",
        desc  = "Lists all commands with indices, or shows detailed help for a specific command."
    },
    ls = {
        usage = "/ls",
        desc  = "Lists all keys and values inside the current JSON path with navigation indices."
    },
    pwd = {
        usage = "/pwd",
        desc  = "Displays the current JSON path (e.g., root.shotsOnGoal.home)."
    },
    save = {
        usage = "/save [subpath]",
        desc  = "Sends/saves only the current JSON branch (or full GameData if at root)."
    },
    save_game_data = {
        usage = "/save_game_data",
        desc  = "Forces a full save of all current match data."
    },
    view = {
        usage = "/view [subpath]",
        desc  = "Opens the current JSON branch (or optional subpath) in the data viewer."
    },
    view_classnames = {
        usage = "/view_classnames",
        desc  = "Displays all registered classes in _G.Classes."
    },
    view_game_data = {
        usage = "/view_game_data",
        desc  = "Opens the current JSON branch in the data viewer (alias for /view)."
    }
}

function ConsoleDocs.get(cmdName)
    return ConsoleDocs.entries[cmdName]
end

return ConsoleDocs