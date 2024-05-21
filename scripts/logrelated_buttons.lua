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

AddClassPostConstruct(
	"widgets/scripterrorwidget",
	function(self, title, text, buttons, texthalign, additionaltext, textsize, timeout, error, ...)
		local Text = require("widgets/text")

		local sel_font = (GetModConfigData("bettercrashscreen_fonts") == 1 and type(GetModConfigData("font")) ~= "number") and GetModConfigData("font") or BODYTEXTFONT

		--text

		self.infotext = self.root:AddChild(Text(sel_font, 35))
		self.infotext:SetVAlign(ANCHOR_TOP)

		if texthalign then
			self.infotext:SetHAlign(ANCHOR_MIDDLE)
		end

		self.infotext:SetPosition(0, 200, 0)
		self.infotext:SetString("")
		self.infotext:EnableWordWrap(true)
		self.infotext:SetRegionSize(480 * 2, 200)
		self.infotext:MoveToFront()
		self.infotext:SetColour(RGB(255, 199, 41, 1))

		local TEXT_OFFSET = 100
		local TEMPLATES_OLD, TEMPLATES = require("widgets/templates"), require("widgets/redux/templates")
		local is_combined, closerto_log = GetModConfigData("CombinedButtons"), GetModConfigData("ButtonsCloserToLog")
		local button_y = closerto_log and 185 or 275
		local has_classicframe = GetModConfigData("ClassicFrame")



		



		local function CW_CreateTextFileCommand(text)
			local HideSensInfo = GetModConfigData("HideSensationalInfo") == 0

			local Username, KU = TheNet:GetLocalUserName(), HideSensInfo and TheNet:GetUserID() or "CLASSIFIED"
			

			local SteamID = HideSensInfo and TheSim:GetSteamIDNumber() or "CLASSIFIED"
			local is64bit = APP_ARCHITECTURE == "x32" and "32-bit" or APP_ARCHITECTURE == "x64" and "64-bit" or "??-bit"
			local ingamecrash = InGamePlay() and "Yes" or "No"
			local currentscreen = tostring(TheFrontEnd:GetActiveScreen())
			local modname_fancy = KnownModIndex:GetModFancyName(modname)


			local function CollectUserData()
				return "Modname: " .. modname_fancy.." ("..string.gsub(modname, "workshop%-", "")..")"..
				"\nUser: " .. Username .." \nKUID: "..KU.."\nSteamID32: "..SteamID.."\n".. 
				"\nSystem: " .. PLATFORM ..
				"\nGame Info: " .. TheSim:GetSteamBetaBranchName() .. 
				" branch (" .. tostring(is64bit) .. ") v" 
				.. APP_VERSION
				.."\nCrash During Gameplay: "..ingamecrash
				.."\nScreen: "..currentscreen
			
			end

			local modname = KnownModIndex:GetModFancyName(modname)

			local userinfo = CollectUserData()

			local currentDateTime = os.date("*t")

			local formattedDate =
				string.format("(%04d-%02d-%02d", currentDateTime.year, currentDateTime.month, currentDateTime.day)
			local formattedTime =
				string.format("%02d-%02d-%02d)", currentDateTime.hour, currentDateTime.min, currentDateTime.sec)

			local formattedDateTime = formattedDate .. " " .. formattedTime

			local modcause = BETTERCRASHSCREEN_CAUSE
					and string.gsub(
						string.lower(KnownModIndex:GetModFancyName("workshop-" .. BETTERCRASHSCREEN_CAUSE)),
						"%s+",
						""
					)
				or nil

			local whichfile = modcause or "gamecrash"

			local file = "quick_log_" .. whichfile .. " " .. formattedDateTime .. ".txt"

			TheSim:SetPersistentString("../" .. file, "\n\n"..userinfo.."\n\n"..text, false, function(succ)
				if succ then
					self.infotext:SetString(file .. " created.")
					if GetModConfigData("OpenSaveFolder") == 1 then
						TheSim:OpenDocumentsFolder()
					end
				else
					print("Erorr: Unable to write console contents to " .. file("..!"))
				end
			end)
		end

		if GetModConfigData("ReduxCrashScreen") == "classic" then
			self.documents_shown = false

			if GetModConfigData("DocumentsButton") == 1 then
				--Client log location button
				self.documentsbutton = self.root:AddChild(
					TEMPLATES_OLD.IconButton(
						"images/button_icons2.xml",
						"local_filter.tex",
						STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].CLIENTLOG_LOC,
						false,
						true,
						function()
							TheSim:OpenDocumentsFolder()
						end,
						{ font = sel_font }
					)
				)
				self.documentsbutton:SetPosition(-450, 275)
				self.documentsbutton:SetTextSize(22)
				self.documentsbutton.text:SetPosition(TEXT_OFFSET, 0)
				self.documentsbutton.text_shadow:SetPosition(TEXT_OFFSET + 2, 0)
				self.documentsbutton:SetScale(0.89)
				self.documentsbutton.text:SetHAlign(ANCHOR_LEFT)
				self.documentsbutton.text_shadow:SetHAlign(ANCHOR_LEFT)

				self.documentsbutton:SetTextColour(255, 255, 255, 1)

				self.documentsbutton.text:SetHAlign(ANCHOR_LEFT)
				self.documentsbutton.text_shadow:SetHAlign(ANCHOR_LEFT)

				self.documents_shown = true
			end

			self.workshopbutton = self.root:AddChild(
				TEMPLATES_OLD.IconButton(
					"images/button_icons.xml",
					"more_info.tex",
					STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].MODPAGE,
					false,
					true,
					function()
						if BETTERCRASHSCREEN_CAUSE then
							VisitURL(
								"https://steamcommunity.com/sharedfiles/filedetails/?id=" .. BETTERCRASHSCREEN_CAUSE
							)
						end
					end,
					{ font = sel_font }
				)
			)
			self.workshopbutton:SetPosition(-450, 220 - 55)
			self.workshopbutton:SetTextSize(22)
			self.workshopbutton.text:SetPosition(TEXT_OFFSET - 15, 0)
			self.workshopbutton.text_shadow:SetPosition(TEXT_OFFSET - 15 + 2, 0)
			self.workshopbutton:SetTextColour(255, 255, 255, 1)
			self.workshopbutton:SetScale(0.89)

			----------------------------------------------------
			self.workshopbutton.text:SetHAlign(ANCHOR_LEFT)
			self.workshopbutton.text_shadow:SetHAlign(ANCHOR_LEFT)

			if not BETTERCRASHSCREEN_CAUSE then
				self.workshopbutton:Hide()
			end

			--Client log location button
			if GetModConfigData("SaveLog") == 1 and GetModConfigData("AutoSaveLog") == 0 then
				self.createquick_log = self.root:AddChild(
					TEMPLATES_OLD.IconButton(
						"images/button_icons.xml",
						"save.tex",
						STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SAVEQUICKLOG,
						false,
						true,
						function()
							CW_CreateTextFileCommand(text)
						end,
						{ font = sel_font }
					)
				)
				self.createquick_log:SetPosition(-450, 285 - 45)
				self.createquick_log:SetTextSize(22)
				self.createquick_log.text:SetPosition(TEXT_OFFSET + 30, 0)
				self.createquick_log.text_shadow:SetPosition(TEXT_OFFSET + 30 + 2, 0)

				self.createquick_log:SetScale(0.75)

				self.createquick_log:SetTextColour(255, 255, 255, 1)

				self.createquick_log.text:SetHAlign(ANCHOR_LEFT)
				self.createquick_log.text_shadow:SetHAlign(ANCHOR_LEFT)
			else
				CW_CreateTextFileCommand(text)
				self.infotext:SetString(file .. " created.")
			end

			----------------------------------------------------
		end
		if GetModConfigData("ReduxCrashScreen") == "redux" then
			local TEXT_OFFSET = 125
			local sel_font = (GetModConfigData("bettercrashscreen_fonts") == 1 and type(GetModConfigData("font")) ~= "number") and GetModConfigData("font") or HEADERFONT

			--text

			self.infotext = self.root:AddChild(Text(sel_font, 18))
			self.infotext:SetVAlign(ANCHOR_TOP)

			if texthalign then
				self.infotext:SetHAlign(ANCHOR_MIDDLE)
			end

			self.infotext:SetPosition(0, 200, 0)
			self.infotext:SetString("")
			self.infotext:EnableWordWrap(true)
			self.infotext:SetRegionSize(480 * 2, 200)
			self.infotext:MoveToFront()
			self.infotext:SetColour(RGB(255, 199, 41, 1))

			--Client log location button

			self.documents_shown = false
			if GetModConfigData("DocumentsButton") == 1 then
				self.documentsbutton = self.root:AddChild(
					TEMPLATES.IconButton(
						"images/button_icons2.xml",
						"local_filter.tex",
						STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].CLIENTLOG_LOC,
						false,
						true,
						function()
							TheSim:OpenDocumentsFolder()
						end,
						{ font = sel_font }
					)
				)
				self.documentsbutton:SetPosition(-450, 285)
				self.documentsbutton:SetTextSize(22)
				self.documentsbutton.text:SetPosition(TEXT_OFFSET, 0)
				self.documentsbutton.text_shadow:SetPosition(TEXT_OFFSET + 2, 0)
				self.documentsbutton:SetTextColour(255, 255, 255, 1)
				self.documentsbutton:SetScale(0.75)

				self.documentsbutton.text:SetHAlign(ANCHOR_LEFT)
				self.documentsbutton.text_shadow:SetHAlign(ANCHOR_LEFT)

				self.documents_shown = true
			end
			----------------------------------------------------

			self.workshopbutton = self.root:AddChild(
				TEMPLATES.IconButton(
					"images/button_icons.xml",
					"more_info.tex",
					STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].MODPAGE,
					false,
					true,
					function()
						if BETTERCRASHSCREEN_CAUSE then
							VisitURL(
								"https://steamcommunity.com/sharedfiles/filedetails/?id=" .. BETTERCRASHSCREEN_CAUSE
							)
						end
					end,
					{ font = sel_font }
				)
			)
			self.workshopbutton:SetPosition(-450, 285 - 45 - 45)
			self.workshopbutton:SetTextSize(22)
			self.workshopbutton.text:SetPosition(TEXT_OFFSET - 15, 0)
			self.workshopbutton.text_shadow:SetPosition(TEXT_OFFSET - 15 + 2, 0)
			self.workshopbutton:SetTextColour(255, 255, 255, 1)
			self.workshopbutton:SetScale(0.75)

			self.workshopbutton.text:SetHAlign(ANCHOR_LEFT)
			self.workshopbutton.text_shadow:SetHAlign(ANCHOR_LEFT)

			if not BETTERCRASHSCREEN_CAUSE then
				self.workshopbutton:Hide()
			end

			if GetModConfigData("SaveLog") == 1 and GetModConfigData("AutoSaveLog") == 0 then
				self.createquick_log = self.root:AddChild(
					TEMPLATES.IconButton(
						"images/button_icons.xml",
						"save.tex",
						STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SAVEQUICKLOG,
						false,
						true,
						function()
							CW_CreateTextFileCommand(text)
						end,
						{ font = sel_font }
					)
				)
				self.createquick_log:SetPosition(-450, 285 - 45)
				self.createquick_log:SetTextSize(22)
				self.createquick_log.text:SetPosition(TEXT_OFFSET + 30, 0)
				self.createquick_log.text_shadow:SetPosition(TEXT_OFFSET + 30 + 2, 0)

				self.createquick_log:SetScale(0.75)

				self.createquick_log:SetTextColour(255, 255, 255, 1)

				self.createquick_log.text:SetHAlign(ANCHOR_LEFT)
				self.createquick_log.text_shadow:SetHAlign(ANCHOR_LEFT)
			else
				CW_CreateTextFileCommand(text)
				self.infotext:SetString(file .. " created.")
			end
		end

		if GetModConfigData("ReduxCrashScreen") ~= "redux" and has_classicframe then
			if self.documentsbutton then
				self.documentsbutton:SetPosition(255, 125 + 55)
			end
			if self.createquick_log then
				self.createquick_log:SetPosition(255, 125)
			end

			if self.workshopbutton then
				self.workshopbutton:SetPosition(255, 125 - 55)
			end
		end

		if is_combined and closerto_log then
			local offset = self.documents_shown and 0 or -60

			if self.createquick_log then
				self.createquick_log:SetScale(0.89)
				self.createquick_log:SetPosition(-390 + offset, button_y)
				self.createquick_log.text:Hide()
				self.createquick_log.text_shadow:Hide()
			end

			if self.documentsbutton then
				self.documentsbutton:SetPosition(-450, button_y)
				self.documentsbutton.text:Hide()
				self.documentsbutton.text_shadow:Hide()
				self.documentsbutton:SetScale(0.89)
			end

			if self.workshopbutton then
				self.workshopbutton:SetPosition(-390 + 60 + offset, button_y)
				self.workshopbutton.text:Hide()
				self.workshopbutton.text_shadow:Hide()
				self.workshopbutton:SetScale(0.89)
			end

			if GetModConfigData("ReduxCrashScreen") ~= "redux" and has_classicframe then
				if self.createquick_log then
					self.createquick_log:SetScale(0.89)
					self.createquick_log:SetPosition(-390 + offset, button_y)
					self.createquick_log.text:Hide()
					self.createquick_log.text_shadow:Hide()
				end

				if self.documentsbutton then
					self.documentsbutton:SetPosition(-450, button_y)
					self.documentsbutton.text:Hide()
					self.documentsbutton.text_shadow:Hide()
					self.documentsbutton:SetScale(0.89)
				end

				if self.workshopbutton then
					self.workshopbutton:SetPosition(-390 + 60 + offset, button_y)
					self.workshopbutton.text:Hide()
					self.workshopbutton.text_shadow:Hide()
					self.workshopbutton:SetScale(0.89)
				end
			end
		end
	end
)
