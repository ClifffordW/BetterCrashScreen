-- This information tells other players more about the mod
name = "Better Crash Screen"
description = ""
author = "Niko"
version = "0.3" -- This is the version of the template. Change it to your own number.

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

-- Compatible with Don't Starve Together
dst_compatible = true

-- Not compatible with Don't Starve
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

-- Character mods are required by all clients
all_clients_require_mod = false

client_only_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = {
    "",
}

local function Title(title, hover)
    return {
        name = title,
        hover = hover,
        options = opt_Empty,
        default = 0,
    }
end
local SEPARATOR = Title("")

configuration_options = {
    
    

    Title("Crashscreen"),
    {
        name = "ReduxCrashScreen",
        label = "Crash Screen Style",
        hover = "",
        options =
        {
            {description = "Classic", data = "classic"},
            {description = "Modern", data = "redux"},

        },
        default = "classic"
    }

}
