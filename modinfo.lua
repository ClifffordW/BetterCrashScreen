


--Beta, Final, or leave for no name
versiontype = ""
name = "Better Crash Screen"


author = "Niko"



version = "0.5.4"




config = true
Language = "en"



contributors = "Cliffford W."
write_contributors = true
credits_only = false



main_icon = "bettercs"


priority = -100





api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false





all_clients_require_mod = false
client_only_mod = true 
server_only_mod = false










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





modinfo_ver = "2.0"
if config == true then


	--Config
	configuration_options =
	{
		

		Title("Language", "Pick langauge"),
    {
        name = "language",
        label = "Language",
        hover = "",
        options =
        {
            { description = "English", data = "en"},
            { description = "Portuguese",  data = "pt"},



        },
        default = "en"

    },

		Title("Crashscreen", "General Crashscreen Settings"),
    {
        name = "ReduxCrashScreen",
        label = "Crash Screen Style",
        hover = "",
        options =
        {
            { description = "Classic", data = "classic", hover="Pre-Forge Look"},
            { description = "Modern",  data = "redux", hover="Post-Forge Look (Redux)"},

        },
        default = "redux"

    },

    {
        name = "ClassicFrame",
        label = "Classic with Frame",
        hover = "Adds Frame to Classic crash screen",
        options =
        {
            { description = "Enabled", data = true},
            { description = "Disabled",  data = false},

        },
        default = false

    },




    {
        name = "reduxscale",
        label = "Modern Crashscreen Scale",
        hover = "",
        options =
        {
            { description = "Default", data = 1.08},
            { description = "1.15", data = 1.15},
            { description = "1.25", data = 1.25},
            { description = "1.4", data = 1.4},

        },
        default = 1.4

    },

    {
        name = "font",
        label = "Font Override",
        hover = "This does not apply  to the bottom buttons",
        options =
        {
            { description = "Default", data = 0},
--[[             { description = "Default Crash Screen Font", data = "NEWFONT"}, -- Scrapped
            { description = "Hammerhead", data = "HEADERFONT"}, ]]
            { description = "Talking font", data = "TALKINGFONT"},
            { description = "Wormwood's font", data = "TALKINGFONT_WORMWOOD"},
            { description = "Tradein guy font", data = "TALKINGFONT_TRADEIN"},
            { description = "Hermit's font", data = "TALKINGFONT_HERMIT"},
            { description = "PT Mono", data = "PTMONO"},
            { description = "Wildcard", data = "BETTERCRASHSCREEN_FONT_WILDCARD"},







        },
        default = 0

    },


    {
        name = "nostalgia",
        label = "Nostalgia",
        hover = "",
        options =
        {
            { description = "Enabled",  data = 1 },
            { description = "Disabled", data = 0 },

        },
        default = 0
    },

    Title("Tutorial"),

    {
        name = "RewatchTutorial",
        label = "Rewatch BCS Button",
        hover = "",
        options =
        {
            { description = "Enabled", data = 1},
            { description = "Disabled",  data = 0},

        },
        default = 1

    },



    Title("Top Buttons", "Pick what mini buttons you want"),

    {
        name = "SaveLog",
        label = "Save Log Button",
        hover = "Saves log into DST's data folder",
        options =
        {
            { description = "Enabled",  data = 1 },
            { description = "Disabled", data = 0 },

        },
        default = 1
    },

    {
        name = "AutoSaveLog",
        label = "Auto-Save Quicklog",
        hover = "Automatically Saves log into DST's data folder\n Doesnt create the Save button",
        options =
        {
            { description = "Enabled",  data = 1 },
            { description = "Disabled", data = 0 },

        },
        default = 0
    },

    {
        name = "DocumentsButton",
        label = "Clientlog Folder Button",
        hover = "Opens your DST documents folder. \nGo back by one folder to find client log",
        options =
        {
            { description = "Enabled",  data = 1 },
            { description = "Disabled", data = 0 },

        },
        default = 0
    },


    {
        name = "CombinedButtons",
        label = "Combined Buttons",
        hover = "Combines both buttons \nThis hides the text!",
        options =
        {
            { description = "Enabled",  data = true },
            { description = "Disabled", data = false },

        },
        default = true
    },

    {
        name = "ButtonsCloserToLog",
        label = "Closer Buttons",
        hover = "Puts the small buttons closer to the log \nOnly when combined!",
        options =
        {
            { description = "Enabled",  data = true },
            { description = "Disabled", data = false },

        },
        default = true
    },




			Title("󰀔 Mod Version"..":".." "..version),
			Title("󰀩 Modinfo Version:".." "..modinfo_ver)
				
	}
		
end


































icon_atlas = main_icon..".xml"
icon = main_icon..".tex"






versiontypes = {
    final = "[Final]",
    beta = "[Beta]",
    disc = "[Discontinued]",
    redux = "[Redux]",
}
versiontype = versiontypes[versiontype] or ""

modinfo_ver = modinfo_ver



if  versiontype == ""  then
	name = name
else
	name = name.." \n"..versiontype..""
end

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
	name = name .. " - GitHub Ver."
end


old_author = author
if contributors == "" or  contributors == nil  then 
	author = author

elseif write_contributors == true then
	author = author.." and ".." "..contributors
end






if Language == "en" or Language == nil or Language == "" then
	--Description Components
	desc = [[
Improves the crash screen to give more detailed information and makes it easier to understand.]]
	
    
    
    changelog= [[󰀏 What's New:

󰀈 Folder button disabled by default now

󰀈 Quicklog is now saved elsewhere and upon saving opens the location

󰀈 If log contains mod that caused crash it'll be labelled ex. (quick_log_menuremix) if it's other causes (quick_log_gamecrash)







    
]]
	




	--copyright = "Copyright © 2020 "..old_author
	credits = "󰀭 Credits:".." "..contributors
	mark2 = "󰀩 Modinfo Version:".." "..modinfo_ver


end




if write_contributors == true or credits_only == true and contributors ~= ""  then
	descfill = desc.."\n\n󰀝 Mod Version: "..version.."\n"..changelog.."\n\n"..credits.."\n\n"..mark2
elseif write_contributors == false or write_contributors == nil or credits_only == false or credits_only == nil and contributors == nil or contributors == "" then
	descfill = desc.."\n\n"..changelog.."\n 󰀝  Version:".." "..version.."\n\n"..mark2
end


description = descfill
description = description