local env = env
GLOBAL.setfenv(1, GLOBAL)


local sel_font = (env.GetModConfigData("bettercrashscreen_fonts") == 1 and type(env.GetModConfigData("font")) ~= "number") and env.GetModConfigData("font") or BODYTEXTFONT


env.AddClassPostConstruct("widgets/scripterrorwidget",
    function(self, title, text, buttons, texthalign, additionaltext, textsize, timeout, ...)
        local Menu = require "widgets/menu"
        local Button = require "widgets/button"
        local AnimButton = require "widgets/animbutton"
        local Text = require "widgets/text"
        local Image = require "widgets/image"
        local UIAnim = require "widgets/uianim"
        local Widget = require "widgets/widget"
        local TEMPLATES = require "widgets/templates"

        local has_classicframe = env.GetModConfigData("ClassicFrame")


        local STYLES =
        {

            dark = {
                bgconstructor = function(root)
                    local bg = root:AddChild(Image("images/fepanels.xml", "wideframe.tex"))
                    bg:SetScale(0.70, 0.70)
                    bg:SetPosition(0, 10)
                    return bg
                end,
                title = { font = TITLEFONT, size = 50, colour = { 1, 1, 1, 1 } },
                text = { font = NEWFONT_OUTLINE, size = 28, colour = { 1, 1, 1, 1 } },
            },
        }







        self.style = "dark"
        assert(STYLES[self.style])




        local buttons =
        {
            {
                text = InGamePlay() and STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].RETURNTOMENU or
                    STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].GAMERELOAD,
                cb = function()
                    if InGamePlay() then
                        TheNet:Disconnect(true) -- The game seems to have issues if we don't manually disconnect
                    end
                    TheSim:ResetError()
                    SimReset()
                end
            },
        }
        if ThePlayer and ThePlayer.Network:IsServerAdmin() and (TheNet:GetServerIsClientHosted() and TheNet:GetIsHosting()) then   -- If the server is client hosted then the game has trouble reloading.
            table.insert(buttons,
                {
                    text = STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SCRIPTERRORRESTART,
                    cb = function()
                        TheSim:ResetError()
                        c_reset()
                    end
                })
        end
        --[[     table.insert(buttons, 1,
    {
        text = "Copy to Clipboard",
        cb = function()
            copy_to_clipboard(text)
        end
    }) ]]
        if (InGamePlay() or ThePlayer) and not TheNet:GetServerIsClientHosted() then
            table.insert(buttons,
                {
                    text = STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].RECONNECT,
                    cb = function()
                        local listing = TheNet:GetServerListing()

                        local locationData = { bettercrashscr_cached_server = listing }
                        local jsonString = json.encode(locationData)
                        TheSim:SetPersistentString("BetterCrashScreen", jsonString, false)

                        TheNet:Disconnect(true)

                        TheSim:ResetError()
                        SimReset()
                    end
                })
        end





        if has_classicframe then
            self.classic_frame = STYLES[self.style].bgconstructor(self.root)
            self.classic_frame:SetScale(1.25, 1.25)

            self.additionaltext:MoveToFront()
            self.text:MoveToFront()

            self.title:MoveToFront()
            self.menu:MoveToFront()
            self.black:SetTint(0, 0, 0, 0.75)
        end

        self.menu_new = self.root:AddChild(Menu(buttons, 385, true, nil, true))
        self.menu_new:SetHRegPoint(ANCHOR_MIDDLE)
        self.menu_new:SetPosition(0, -315, 0)
        self.menu_new:SetScale(0.63)






        self.additionaltext:SetFont(sel_font)
        self.text:SetFont(sel_font)
        self.title:SetFont(env.GetModConfigData("bettercrashscreen_fonts") == 1 and type(env.GetModConfigData("font")) ~= "number" and env.GetModConfigData("font") or
        BODYTEXTFONT)
    end)
