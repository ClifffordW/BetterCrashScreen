-- This information tells other players more about the mod
name = "Better Crash Screen"
description = ""
author = "Niko"
version = "0.4" -- This is the version of the template. Change it to your own number.

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

local scales = {
}

for i = 1, 20 do
	scales[i] = {description = "x"..i/10, data = i/10}
end

local pos = {
	[1] = {description = "Default", data = 0}
}

for i = 2, 15 do
	pos[i] = {description = "+"..i.."0", data = i*10}
end

local opt_Empty = {{description = "", data = 0}}
local function Title(title,hover)
	return {
		name=title,
		hover=hover,
		options=opt_Empty,
		default=0,
	}
end


local SEPARATOR = Title("")

configuration_options = {



    Title("Crashscreen", "General Crashscreen Settings"),
    {
        name = "ReduxCrashScreen",
        label = "Crash Screen Style",
        hover = "",
        options =
        {
            { description = "Classic", data = "classic" },
            { description = "Modern",  data = "redux" },

        },
        default = "classic"

    },

    Title("Buttons", "Pick what mini buttons you want"),

    {
        name = "SaveLog",
        label = "Save Log Button",
        hover = "",
        options =
        {
            { description = "Enabled",  data = 1 },
            { description = "Disabled", data = 0 },

        },
        default = 1
    },

    {
        name = "DocumentsButton",
        label = "Open Clientlog Folder Button",
        hover = "",
        options =
        {
            { description = "Enabled",  data = 1 },
            { description = "Disabled", data = 0 },

        },
        default = 1
    },




}
