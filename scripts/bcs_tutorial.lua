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

local sel_font = type(GetModConfigData("font")) ~= "number" and GetModConfigData("font") or HEADERFONT

AddClassPostConstruct("screens/redux/multiplayermainscreen", function(self, ...)
	TheSim:GetPersistentString("BetterCrashScreen_updater", function(load_success, data)
		if load_success and data ~= nil then
			local status, bcs_data_updater = GLOBAL.pcall(function()
				return GLOBAL.json.decode(data)
			end)
			if status and bcs_data_updater then
				self.should_autoupdate_bcs = bcs_data_updater.autoupdate
				self.seen_autoupdate_bcs = bcs_data_updater.wasseen

				self.loaded = true
			end
		end
	end)

	if self.should_autoupdate_bcs and modname then
		--print(modname)
		TheFrontEnd.overlayroot.inst:DoTaskInTime(2, function()
			if
				IsWorkshopMod(modname)
				and modname.version ~= ""
				and modname.version ~= KnownModIndex:GetModInfo(modname).version
			then
				TheSim:UpdateWorkshopMod(modname)
				print("[Workshop] Updating: " .. modname)
			end
		end)
	end

	local PopupDialogScreen = require("screens/redux/popupdialog")

	if not self.seen_autoupdate_bcs then
		self.inst:DoTaskInTime(0.5, function()
			TheFrontEnd:PushScreen(
				PopupDialogScreen(
					"Better Crash Screen Update",
					"Would you like the mod to get autoupdated everytime it gets update?",
					{
						{
							text = "Yes",
							cb = function()
								local locationData = { autoupdate = true, wasseen = true }
								local jsonString = GLOBAL.json.encode(locationData)

								GLOBAL.TheSim:SetPersistentString("BetterCrashScreen_updater", jsonString, false)

								TheFrontEnd:PopScreen()
							end,
						},

						{
							text = "No",
							cb = function()
								local locationData = { autoupdate = false, wasseen = true }
								local jsonString = GLOBAL.json.encode(locationData)

								GLOBAL.TheSim:SetPersistentString("BetterCrashScreen_updater", jsonString, false)

								TheFrontEnd:PopScreen()
							end,
						},
					}
				)
			)
		end)
	end

	local Menu = require("widgets/menu")
	local Button = require("widgets/button")
	local AnimButton = require("widgets/animbutton")
	local Text = require("widgets/text")
	local Image = require("widgets/image")
	local UIAnim = require("widgets/uianim")
	local Widget = require("widgets/widget")
	local TEMPLATES = require("widgets/redux/templates")
	local NineSlice = require("widgets/nineslice")
	local PopupDialogScreenRedux = require("screens/redux/popupdialog")

	function self.CustomIconButton2(
		iconAtlas,
		iconTexture,
		labelText,
		sideLabel,
		alwaysShowLabel,
		onclick,
		textinfo,
		defaultTexture
	)
		local btn = TEMPLATES.StandardButton(onclick, nil, { 70, 70 }, { iconAtlas, iconTexture })

		if not textinfo then
			textinfo = {}
		end

		if sideLabel then
			-- A label to the left of the button.
			btn.label = btn:AddChild(
				Text(
					textinfo.font or NEWFONT,
					textinfo.size or 25,
					labelText,
					textinfo.colour or _G.UICOLOURS.GOLD_CLICKABLE
				)
			)
			btn.label:SetRegionSize(150, 70)
			btn.label:EnableWordWrap(true)
			btn.label:SetHAlign(ANCHOR_RIGHT)
			btn.label:SetPosition(-115, 2)
		elseif alwaysShowLabel then
			-- A label below the button.
			btn:SetTextSize(textinfo.size or 25)
			btn:SetText(labelText, true)
			btn.text:SetPosition(1, -38)
			btn.text_shadow:SetPosition(-1, -40)
			btn:SetFont(textinfo.font or NEWFONT)
			btn:SetDisabledFont(textinfo.font or NEWFONT)
			btn:SetTextColour(textinfo.colour or _G.UICOLOURS.GOLD_CLICKABLE)
			btn:SetTextFocusColour(textinfo.focus_colour or _G.UICOLOURS.GOLD_FOCUS)
		else
			-- Only show hovertext.
			btn:SetHoverText(labelText, {
				font = textinfo.font or NEWFONT_OUTLINE,
				offset_x = textinfo.offset_x or 2,
				offset_y = textinfo.offset_y or -45,
				colour = textinfo.colour or _G.UICOLOURS.WHITE,
				bg = textinfo.bg,
			})
		end

		return btn
	end

	TheSim:GetPersistentString("BetterCrashScreen_tutorial", function(load_success, data)
		if load_success and data ~= nil then
			local status, bettercrashscr = pcall(function()
				return json.decode(data)
			end)
			if status and bettercrashscr then
				self.bettercrashscr_seentutorial = bettercrashscr.bettercrashscr_tutorial
				self.loaded = true
			end
		end
	end)

	if GetModConfigData("RewatchTutorial") == 1 then
		local locationData = { bettercrashscr_tutorial = false }
		local jsonString = json.encode(locationData)
		self.rewatchbutton = self.fixed_root:AddChild(
			self.CustomIconButton2(
				"images/button_icons.xml",
				"undo.tex",
				STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].REWATCH,
				false,
				true,
				function()
					TheSim:SetPersistentString("BetterCrashScreen_tutorial", jsonString, false)

					TheSim:ResetError()
					c_reset()
				end,
				{ font = NEWFONT_OUTLINE, size = 24 }
			)
		)

		self.rewatchbutton:SetScale(0.85)
		self.rewatchbutton:SetPosition(600, -290)

		self.rewatchbutton.text:SetPosition(-100, -50)
		self.rewatchbutton.text_shadow:SetPosition(-98, -50)
	end

	local locationData = { bettercrashscr_tutorial = true }
	local jsonString = json.encode(locationData)

	function AttachToMouse(widget)
		local x, y
		local followhandler

		local function UpdatePosition(self, x, y)
			widget:SetPosition(Vector3(x, y, 0))
		end

		followhandler = TheInput:AddMoveHandler(function(mx, my)
			UpdatePosition(widget, mx, my)
		end)

		widget.FollowMouse = function(self)
			if followhandler == nil then
				followhandler = TheInput:AddMoveHandler(function(mx, my)
					UpdatePosition(self, mx, my)
				end)
				self:SetPosition(TheInput:GetScreenPosition())
			end
		end

		widget:FollowMouse()
	end

	self.bettercrashscr_seentutorial = true

	TheSim:GetPersistentString("BetterCrashScreen_tutorial", function(load_success, data)
		if load_success and data ~= nil then
			local status, bettercrashscr = pcall(function()
				return json.decode(data)
			end)
			if status and bettercrashscr then
				self.bettercrashscr_seentutorial = bettercrashscr.bettercrashscr_tutorial
				self.loaded = true
			end
		end
	end)

	if not self.bettercrashscr_seentutorial then
		self.crashbg = self.fixed_root:AddChild(
			Image("images/tutorial.xml", "tutorial_" .. TUNING.BETTECRASHSCREEN_LANGUAGE .. ".tex")
		)

		local crashbg = self.crashbg
		crashbg:MoveToFront()

		crashbg:SetScale(0.68)
		crashbg:Hide()

		self.help_arrow = self.fixed_root:AddChild(UIAnim())
		self.help_circle = self.help_arrow:AddChild(UIAnim())

		local helparrow = self.help_arrow
		local helparrow_anim = self.help_arrow:GetAnimState()

		helparrow_anim:SetBank("detectivehayseed_hint")
		helparrow_anim:SetBuild("detectivehayseed_hint")
		helparrow_anim:SetDeltaTimeMultiplier(0)
		helparrow_anim:PlayAnimation("show_arrow", true)
		helparrow:SetScale(0.25)

		local helpcircle = self.help_circle
		local helpcircle_anim = self.help_circle:GetAnimState()

		helpcircle_anim:SetBank("detectivehayseed_hint")
		helpcircle_anim:SetBuild("detectivehayseed_hint")
		helpcircle_anim:PlayAnimation("show_circle", true)
		helpcircle:SetScale(1)

		helpcircle:MoveToBack()
		helpcircle:Hide()

		helparrow_anim:SetDeltaTimeMultiplier(0.85)
		helpcircle_anim:SetDeltaTimeMultiplier(0.85)

		helparrow:Hide()

		for k, v in pairs(self.fixed_root.children) do
			v:Hide()
		end

		self.skipbutton = self.fixed_root:AddChild(
			self.CustomIconButton2(
				"images/button_icons.xml",
				"undo.tex",
				STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SKIP,
				false,
				true,
				function()
					TheSim:SetPersistentString("BetterCrashScreen_tutorial", jsonString, false)

					TheSim:ResetError()
					c_reset()
				end,
				{ font = NEWFONT_OUTLINE, size = 24 }
			)
		)

		self.skipbutton:SetPosition(450, -250)

		--self.motd_panel:Disable()

		local vol = 0.75
		require("defs.sound.bcs_fmodtable")

		--This is a stupid thing but i dont have the brain for better one
		local _sound = TheFrontEnd:GetSound()
		cw_PlayFMODEvent("helping_arrow_bg", 0.12)
		helparrow.inst:DoPeriodicTask(FRAMES, function()
			if not _sound:PlayingSound("helparrow") then
				cw_PlayFMODEvent("helping_arrow", 0.75)
			end

			if helparrow.shown then
				_sound:SetVolume("helparrow", vol)
			else
				_sound:SetVolume("helparrow", 0)
			end
		end)

		self.inst:DoTaskInTime(0.5, function()
			_sound:SetVolume("FEMusic", 0)
			cw_PlayFMODEvent("helping_arrow_bg", 0.12)
			if TUNING.BETTECRASHSCREEN_LANGUAGE == "pt" then
				cw_PlayFMODEvent("voiceover_pt", 0.75)
			else
				cw_PlayFMODEvent("voiceover", 0.10)
			end

			crashbg:Show()
		end)

		local x = -420
		local x_big = -225

		self.inst:DoTaskInTime(0, function()
			--Reload
			self.inst:DoTaskInTime(TUNING.BETTECRASHSCREEN_LANGUAGE == "pt" and 27.5 or 22.5, function()
				helparrow:Show()
				helparrow:SetPosition(x_big, -235)
			end)

			--Reload Save
			self.inst:DoTaskInTime(TUNING.BETTECRASHSCREEN_LANGUAGE == "pt" and 32.5 or 25.2, function()
				helparrow:SetPosition(x_big + 225, -235)
			end)

			--Reconnect
			self.inst:DoTaskInTime(TUNING.BETTECRASHSCREEN_LANGUAGE == "pt" and 43.8 or 33.8, function()
				helparrow:Show()
				helparrow:SetPosition(x_big + 225 + 225, -235)
			end)

			--Reconnect Hide
			self.inst:DoTaskInTime(TUNING.BETTECRASHSCREEN_LANGUAGE == "pt" and 54.5 or 45.1, function()
				helparrow:Hide()
			end)

			--Folder
			self.inst:DoTaskInTime(TUNING.BETTECRASHSCREEN_LANGUAGE == "pt" and 62.25 or 49.25, function()
				helparrow:Show()
				helparrow:SetPosition(-420, 180)
			end)

			--Save
			self.inst:DoTaskInTime(TUNING.BETTECRASHSCREEN_LANGUAGE == "pt" and 72.189 or 56.4, function()
				helparrow:SetPosition(x + 50, 180)
			end)

			--GLobe
			self.inst:DoTaskInTime(TUNING.BETTECRASHSCREEN_LANGUAGE == "pt" and 92.252 or 72.2, function()
				helparrow:SetPosition(x + 50 + 50, 180)
			end)

			--Disable Mods
			self.inst:DoTaskInTime(TUNING.BETTECRASHSCREEN_LANGUAGE == "pt" and 108.663 or 79.4, function()
				helparrow:SetPosition(x_big + 230, -180)
			end)

			self.inst:DoTaskInTime(TUNING.BETTECRASHSCREEN_LANGUAGE == "pt" and 118 or 86.4, function()
				helparrow:Hide()
			end)

			self.inst:DoTaskInTime(TUNING.BETTECRASHSCREEN_LANGUAGE == "pt" and 118.5 or 86.9, function()
				helparrow:Kill()
			end)

			self.inst:DoTaskInTime(TUNING.BETTECRASHSCREEN_LANGUAGE == "pt" and 130 or 99, function()
				cw_StopFMODEvent("helping_arrow_bg")
				TheSim:SetPersistentString("BetterCrashScreen_tutorial", jsonString, false)
			end)

			self.inst:DoTaskInTime(TUNING.BETTECRASHSCREEN_LANGUAGE == "pt" and 145 or 110.2, function()
				self.help_arrow = self:AddChild(UIAnim())
				self.help_circle = self.help_arrow:AddChild(UIAnim())

				local helparrow = self.help_arrow
				local helparrow_anim = self.help_arrow:GetAnimState()

				helparrow_anim:SetBank("detectivehayseed_hint")
				helparrow_anim:SetBuild("detectivehayseed_hint")
				helparrow_anim:SetDeltaTimeMultiplier(0)
				helparrow_anim:PlayAnimation("show_arrow", true)
				helparrow:SetScale(0.25)

				local helpcircle = self.help_circle
				local helpcircle_anim = self.help_circle:GetAnimState()

				helpcircle_anim:SetBank("detectivehayseed_hint")
				helpcircle_anim:SetBuild("detectivehayseed_hint")
				helpcircle_anim:PlayAnimation("show_circle", true)
				helpcircle:SetScale(1)

				helpcircle:MoveToBack()
				helpcircle:Hide()

				helparrow_anim:SetDeltaTimeMultiplier(0.85)
				helpcircle_anim:SetDeltaTimeMultiplier(0.85)

				helparrow:Hide()

				local vol = 0.75

				--This is a stupid thing but i dont have the brain for better one
				local _sound = TheFrontEnd:GetSound()
				helparrow.inst:DoPeriodicTask(FRAMES, function()
					if not _sound:PlayingSound("helparrow") then
						cw_PlayFMODEvent("helping_arrow", 0.75)
					end

					if helparrow.shown then
						_sound:SetVolume("helparrow", vol)
					else
						_sound:SetVolume("helparrow", 0)
					end
				end)

				AttachToMouse(helparrow)
				helparrow:SetPosition(0, 0)
				helparrow:Show()
				helpcircle:SetScale(0.45, 0.45)
				helpcircle:SetPosition(10, -25)
				helpcircle:Show()
			end)

			self.inst:DoTaskInTime(25, function() end)

			self.inst:DoTaskInTime(153, function()
				self.help_arrow:Hide()
				TheFrontEnd:Fade(FADE_IN, 2)
				_sound:SetVolume("FEMusic", 1)
			end)

			self.inst:DoTaskInTime(153.25, function()
				self.help_arrow:Kill()
				crashbg:Kill()

				if self.skipbutton then
					self.skipbutton:Kill()
				end

				for k, v in pairs(self.fixed_root.children) do
					v:Show()
				end
				self.motd_panel:Enable()
			end)
		end)

		helparrow:SetScale(0.1)
	end
end)
