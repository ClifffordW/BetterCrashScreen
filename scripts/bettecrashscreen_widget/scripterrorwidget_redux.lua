local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddClassPostConstruct(
	"widgets/scripterrorwidget",
	function(self, title, text, buttons, texthalign, additionaltext, textsize, timeout, ...)
		local Menu = require("widgets/menu")
		local Button = require("widgets/button")
		local AnimButton = require("widgets/animbutton")
		local Text = require("widgets/text")
		local Image = require("widgets/image")
		local UIAnim = require("widgets/uianim")
		local Widget = require("widgets/widget")
		local TEMPLATES = require("widgets/redux/templates")
		local NineSlice = require("widgets/nineslice")

		self.root:SetScaleMode(SCALEMODE_NONE)

		self.black:SetTint(0, 0, 0, 0.75)
		local title = "Error in the Constant"

		self.title:SetFont(HEADERFONT)
		self.title:SetString(title)
		self.title:SetRegionSize(480 * 2, 200)
		self.title:SetPosition(0, 250, 0)

		local bg_frame_w = 950
		local bg_frame_w_offset = 125
		local bg_frame_h_offset = 125
		local item_grid_initial_x = 80
		local COLUMN_WIDTH = 160
		local COLUMN_HEIGHT = 150

		self.frame = self.root:AddChild(NineSlice("images/dialogcurly_9slice.xml"))

		local top = self.frame:AddCrown("crown-top-fg.tex", ANCHOR_MIDDLE, ANCHOR_TOP, 0, 68)
		local top_bg = self.frame:AddCrown("crown-top.tex", ANCHOR_MIDDLE, ANCHOR_TOP, 0, 44)
		top_bg:MoveToBack()
		-- Background overlaps behind and foreground overlaps in front.
		local bottom = self.frame:AddCrown("crown-bottom-fg.tex", ANCHOR_MIDDLE, ANCHOR_BOTTOM, 0, -14)
		bottom:MoveToFront()
		self.frame:SetSize(bg_frame_w, 400 + bg_frame_h_offset)
		self.frame:SetScale(0.7, 0.7)
		self.frame:SetPosition(0, 0)

		self.frame.mid_center:SetTint(0, 0, 0, 0.85)

		if self.frame.elements then
			--dumptable(self.frame.elements)

			local only_elements = {
				"mid_right",
				"mid_center",
			}

			for k, v in pairs(self.frame.elements) do
				--print(k, v)

				v:SetTint(255, 255, 255, 0.88)
			end
		end

		local buttons = {

			{
				text = InGamePlay()
						and STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].MENURELOAD
					or STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].GAMERELOAD,
				cb = function()
					TheSim:ResetError()
					SimReset()
				end,
			},
		}

		if ThePlayer and ThePlayer.Network:IsServerAdmin() then
			table.insert(buttons, 1, {
				text = STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SCRIPTERRORRESTART,
				cb = function()
					TheSim:ResetError()
					c_reset()
				end,
			})
		end

		--[[ 		table.insert(buttons, 1, {
			text = "Copy to Clipboard",
			cb = function()

			end,
		}) ]]

		if ThePlayer and TheWorld and InGamePlay() and not TheNet:GetServerIsClientHosted() then
			table.insert(buttons, 1, {
				text = "Reconnect",
				cb = function()
					local listing = TheNet:GetServerListing()

					local locationData = { bettercrashscr_cached_server = listing }
					local jsonString = json.encode(locationData)
					TheSim:SetPersistentString("BetterCrashScreen", jsonString, false)

					TheNet:Disconnect(true)

					TheSim:ResetError()
					SimReset()
				end,
			})
		end

		self.title_shadow = self.root:AddChild(Text(HEADERFONT, 50))
		self.title_shadow:SetPosition(0, 252, 0)
		self.title_shadow:SetColour(0, 0, 0, 1)
		self.title_shadow:SetString(title)
		self.title:MoveToFront()
		self.title:SetSize(50)

		self.menu_new = self.root:AddChild(Menu(buttons, 385, true, nil, true))
		self.menu_new:SetHRegPoint(ANCHOR_MIDDLE)
		self.menu_new:SetPosition(0, -250, 0)
		self.menu_new:SetScale(0.63)

		local defaulttextsize = 24
		if textsize then
			defaulttextsize = textsize
		end

		self.text:SetSize(26)
		self.text:SetFont(HEADERFONT)
		self.text_shadow = self.root:AddChild(Text(HEADERFONT, 26))
		self.text_shadow:SetPosition(2, 50, 0)
		self.text:SetPosition(0, 50, 0)

		self.text_shadow:SetColour(0, 0, 0, 1)
		self.text_shadow:SetString(text)
		self.text_shadow:SetRegionSize(480 * 2, 200)
		self.text_shadow:EnableWordWrap(true)

		self.additionaltext:SetFont(HEADERFONT)

		self.additionaltext_shadow = self.root:AddChild(Text(HEADERFONT, 23))
		self.additionaltext_shadow:SetPosition(2, -125, 0)
		self.additionaltext_shadow:SetVAlign(ANCHOR_TOP)

		self.additionaltext_shadow:SetColour(0, 0, 0, 1)
		self.additionaltext_shadow:SetString(additionaltext)
		self.additionaltext_shadow:SetRegionSize(480 * 2, 100)
		self.additionaltext_shadow:EnableWordWrap(true)
		self.additionaltext:SetPosition(0, -125, 0)

		self.additionaltext:SetSize(23)
		self.additionaltext:SetPosition(0, -125, 0)

		self.additionaltext:MoveToFront()

		self.text_shadow:SetFont(HEADERFONT)

		self.text_shadow:SetVAlign(ANCHOR_TOP)

		if texthalign then
			self.text_shadow:SetHAlign(texthalign)
		end

		self.text:MoveToFront()

		self.menu:MoveToFront()

		self.menu:SetPosition(0, -195, 0)

		for k, v in pairs(self.menu_new.items) do
			--dumptable(v)

			v:SetFont(HEADERFONT)
			v:SetTextColour(RGB(0, 0, 0, 255))
			v:SetTextFocusColour(RGB(0, 0, 0, 0.65))
			v.horizontal = false

			v:SetTextures(
				"images/global_redux.xml",
				"button_carny_xlong_normal.tex",
				"button_carny_xlong_hover.tex",
				"button_carny_xlong_disabled.tex",
				nil,
				nil,
				{ 0.75, 0.85 }
			)
		end

		for k, v in pairs(self.menu.items) do
			--dumptable(v)

			v:SetFont(HEADERFONT)
			v:SetTextColour(RGB(0, 0, 0, 255))
			v:SetTextFocusColour(RGB(0, 0, 0, 0.65))
			v.horizontal = false

			v:SetTextures(
				"images/global_redux.xml",
				"button_carny_xlong_normal.tex",
				"button_carny_xlong_hover.tex",
				"button_carny_xlong_disabled.tex",
				nil,
				nil,
				{ 0.75, 0.85 }
			)
			v:SetScale(0.72)
		end

		self.root:SetScale(1.08)
	end
)
