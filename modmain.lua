Assets = {
	Asset("SOUND", "sound/arrow.fsb"),
	Asset("SOUNDPACKAGE", "sound/arrow.fev"),
	Asset("ANIM", "anim/detectivehayseed_hint.zip"),

	Asset("ATLAS", "images/tutorial.xml"),
	Asset("IMAGE", "images/tutorial.tex"),


}





--print("FONT IS " .. GetModConfigData("font"))

modimport("scripts/strings")


modimport("scripts/autoenable")

modimport("scripts/autoreconnect")
if GetModConfigData("ReduxCrashScreen") ~= "redux" then
	modimport("scripts/errorwidget_classic")
else
	modimport("scripts/errorwidget_redux")
end
modimport("scripts/logrelated_buttons")

modimport("scripts/smallbonus")
modimport("scripts/bcs_tutorial")

do
    local GLOBAL = GLOBAL
    local modEnv = GLOBAL.getfenv(1)
    local rawget, setmetatable = GLOBAL.rawget, GLOBAL.setmetatable
    setmetatable(modEnv, {
        __index = function(self, index)
            return rawget(GLOBAL, index)
        end,
        -- lack of __newindex means it defaults to modEnv, so we don't mess up globals.
    })

    _G = GLOBAL
end



local logsender_seen_autosendlogs
local logsender_should_autosendlogs

	TheSim:GetPersistentString("BetterCrashScreen_logsender", function(load_success, data)
		if load_success and data ~= nil then
			local status, bcs_data_logsender
			= GLOBAL.pcall(function()
				return GLOBAL.json.decode(data)
			end)
			if status and bcs_data_logsender then
				logsender_should_autosendlogs = bcs_data_logsender.sendlogs
				logsender_seen_autosendlogs = bcs_data_logsender.wasseen

			end
		end
	end)



	local PopupDialogScreen = require("screens/redux/popupdialog")

	if not logsender_seen_autosendlogs then
		staticScheduler:ExecuteInTime(0.5, function()
			TheFrontEnd:PushScreen(
				PopupDialogScreen(
					"BCS Log Sender",
					"Would you like the mod to autosend crash logs to the developer?\nYou can also send it to your webhook Contact the dev!",
					{
						{
							text = "Yes",
							cb = function()
								local locationData = { sendlogs = true, wasseen = true }
								local jsonString = GLOBAL.json.encode(locationData)

								TheSim:ResetError()
								SimReset()

								GLOBAL.TheSim:SetPersistentString("BetterCrashScreen_logsender", jsonString, false)

								TheFrontEnd:PopScreen()
							end,
						},

						{
							text = "No",
							cb = function()
								local locationData = { sendlogs = false, wasseen = true }
								local jsonString = GLOBAL.json.encode(locationData)

								GLOBAL.TheSim:SetPersistentString("BetterCrashScreen_logsender", jsonString, false)

								TheFrontEnd:PopScreen()
							end,
						},
					}
				)
			)
		end)
	end




DisplayError = function(error)
	SetPause(true, "DisplayError")

	if global_error_widget ~= nil then
		return nil
	end

	print(error) -- Failsafe since sometimes the error screen is no shown

	local ingame = InGamePlay()

	local errorheading = string.sub(error, 0, string.find(error, "\n") - 1)

	local modnames = ModManager:GetEnabledModNames()

	local modnamesstr = ""
	local involvedmodnamesstr = ""
	local involvedmods = {}
	local maincausemodnamestr = ""
	local maincause = nil
	local othercausesmodnamesstr = ""
	local modnameforurl = nil
	local othercauses = {}
	for k, modname in ipairs(modnames) do
		local patternmodname = string.gsub(modname, "%-", "%%-")
		if string.find(error, "/" .. patternmodname .. "/") ~= nil then
			table.insert(involvedmods, modname)

			involvedmodnamesstr = involvedmodnamesstr .. '"' .. KnownModIndex:GetModFancyName(modname) .. '" '

			if maincause == nil and string.find(errorheading, "/" .. patternmodname .. "/") ~= nil then
				maincause = modname
				modnameforurl = string.gsub(
					KnownModIndex:GetModActualName(KnownModIndex:GetModFancyName(modname)),
					"workshop%-",
					""
				)

				maincausemodnamestr = '"' .. KnownModIndex:GetModFancyName(modname) .. '" '
			else
				table.insert(othercauses, modname)
				othercausesmodnamesstr = othercausesmodnamesstr .. '"' .. KnownModIndex:GetModFancyName(modname) .. '" '
			end
		end
		modnamesstr = modnamesstr .. '"' .. KnownModIndex:GetModFancyName(modname) .. '" '
	end

	-- print("involvedmods", #involvedmods)
	-- print("maincause", maincausemodnamestr)
	-- print("othercauses", #othercauses)

	local disablemodsbuttonstr = nil
	local disablemodsbuttonfn = nil
	if #involvedmods > 0 then -- Mods are involved in crash
		if maincause ~= nil then -- A specific mod had ran into an error...
			if #othercauses > 0 then -- Due to other mods
				disablemodsbuttonstr = STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].MODQUIT -- Disable Mods
				disablemodsbuttonfn = function()
					for i, modname in ipairs(othercauses) do
						KnownModIndex:Disable(modname)
					end
				end
			else -- On it's own
				disablemodsbuttonstr =
					STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].MODONEQUIT -- Disable Mod
				disablemodsbuttonfn = function()
					KnownModIndex:Disable(maincause)
				end
			end
		else -- The game had ran into an error, mods were involved
			disablemodsbuttonstr = STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].MODQUIT -- Disable Mods
			disablemodsbuttonfn = function()
				for i, modname in ipairs(involvedmods) do -- In this case involvedmods and othercases should be identical, but just in case they are not.
					KnownModIndex:Disable(modname)
				end
			end
		end
	else -- No mods known to have caused an issue
		disablemodsbuttonstr = STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].MODALLQUIT -- Disable All Mods
		disablemodsbuttonfn = function()
			KnownModIndex:DisableAllMods()
		end
	end

	local buttons = nil
	if IsNotConsole() then
		buttons = {}
		-- if ingame then
		--     table.insert(buttons, {text=STRINGS.UI.MAINSCREEN.RETURNTOMENU, cb = function()
		--         TheSim:ResetError()
		--         TheNet:Disconnect(true)
		--         -- ForceAssetReset()
		--         -- SimReset()
		--         TheSim:Reset()
		--     end})
		-- else
		--     table.insert(buttons, {text=STRINGS.UI.MAINSCREEN.RESETMENU, cb = function()
		--         TheSim:ResetError()
		--         c_reset()
		--     end})
		-- end

		table.insert(buttons, {
			text = STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SCRIPTERRORQUIT,
			cb = function()
				TheSim:ForceAbort()
			end,
		})

		-- if not ingame then

		table.insert(buttons, {
			text = disablemodsbuttonstr,
			cb = function() -- Annoying that cb has no arguments, I would love to change the button's text when clicked.
				disablemodsbuttonfn()

				ForceAssetReset()
				KnownModIndex:Save(function()
					-- TheSim:ResetError()
					-- SimReset()
				end)
			end,
		})
		-- end
		if modnameforurl then
			BETTERCRASHSCREEN_CAUSE = modnameforurl

			--table.insert(buttons, {text=STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].MODPAGE, nopop=true, cb = function() VisitURL("https://steamcommunity.com/sharedfiles/filedetails/?id="..modnameforurl) end })
		end
		table.insert(buttons, {
			text = STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].MODFORUMS,
			nopop = true,
			cb = function()
				VisitURL("https://forums.kleientertainment.com/forums/forum/79-dont-starve-together-mods-and-tools/")
			end,
		})
	end

	local titlestr = (maincause ~= nil and #involvedmods > 0)
			and string.format(
				STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].MODCRASH,
				maincausemodnamestr
			)
		or STRINGS.UI.MAINSCREEN.MODFAILTITLE

	local modstext = #involvedmods > 0
			and ((maincause == nil or #othercauses == 0) and STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SUSPECTEDMODS .. involvedmodnamesstr or STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SUSPECTEDCONFLICTS .. othercausesmodnamesstr)
		or STRINGS.UI.MAINSCREEN.SCRIPTERRORMODWARNING .. modnamesstr

	SetGlobalErrorWidget(titlestr, error, buttons, ANCHOR_LEFT, modstext, 20)
end




if  logsender_should_autosendlogs and modname and not InGamePlay() then


	local OldFunc = _G.DisplayError

	local Username, KU = TheNet:GetLocalUserName(), TheNet:GetUserID()
	local is64bit = APP_ARCHITECTURE == "x32" and "32-bit" or APP_ARCHITECTURE == "x64" and "64-bit" or "??-bit"

	_G.DisplayError = function(error, ...)
		local ret = { OldFunc(error, ...) }




		-- Function to collect user data and format the error message
		local function CollectUserData(error)
			-- Match the error to get the relevant parts
			local file, line, msg = error:match('^%[string "([^"]+)"%]:(%d+): (.+)$')
			if not file then
				file, line, msg = error:match('([^:]+):(%d+): (.+)$')  -- Fallback for non-string errors
			end

			-- Default values if nothing was matched
			file = file or "Unknown file"
			line = line or "Unknown line"
			msg = msg or "Unknown error"

			-- Combine them into a formatted string without the first part
			local firstLine = file .. " " .. line .. " " .. msg

			-- Remove backslashes, colons, and single quotes from the first line
			firstLine = firstLine:gsub("\\", ""):gsub(":", ""):gsub("'", "") 


			local currentDateTime = os.date("*t")

			local formattedDate =
				string.format("%d.%02d.%02d", currentDateTime.day, currentDateTime.month, currentDateTime.year)
			local formattedTime =
				string.format("%02d:%02d:%02d", currentDateTime.hour, currentDateTime.min, currentDateTime.sec)

			local formattedDateTime = formattedDate .. " " .. formattedTime

			return 
				 "Date: " ..formattedDateTime
				.."\nModname: "
				.. modname
				.. "\nUser: "
				.. Username
				.. " ("
				.. KU
				.. ")"
				.. "\nSystem: "
				.. PLATFORM
				.. "\nGame Info: "
				.. TheSim:GetSteamBetaBranchName()
				.. " branch ("
				.. tostring(is64bit)
				.. ") v"
				.. APP_VERSION
				.. "\n\nSteam ID32: "
				.. TheSim:GetSteamIDNumber()
				.. "\n\n"
                .. "Error: " .. firstLine
				
		end

		-- Collect the user data and formatted error information
		local info = CollectUserData(error)

		
		if error and TheSim and modname then

			if not TUNING.BCS_WEBHOOK then return end


			local discord_avatars = {}
			local webhook_urls = {}
			local webhook_names = {}
		
			for _, webhook in pairs(TUNING.BCS_WEBHOOK) do
				table.insert(webhook_urls, webhook.URL)
				table.insert(discord_avatars, webhook.AVATAR)
				table.insert(webhook_names, webhook.NAME)
			end
		
			for i, webhook_url in ipairs(webhook_urls) do
				local avatar_url = discord_avatars[i] or discord_avatars[1]
				local webhook_name = webhook_names[i] or webhook_names[1]
		
				TheSim:QueryServer(
					webhook_url,
					function(result, isSuccessful, resultCode) end,
					"POST",
					json.encode({
						content = "```\n" .. info .. "```",  -- Send formatted info in code block
						username = webhook_name or "Crash Logs",  -- Optional: the username the bot will display as
						avatar_url = avatar_url or "https://cdn.forums.klei.com/monthly_2023_04/1_8IglXEKS5OVLm7qh-SXS0A.thumb.jpeg.34cd9d846281e3c1d4a9023321258153.jpeg"  -- Optional: URL for the bot's avatar image
					})
				)
			end
		end

		return unpack(ret)
	end
end