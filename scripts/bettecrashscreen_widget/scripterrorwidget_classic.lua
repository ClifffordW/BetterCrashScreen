--Reconnect MP Screen

local env = env
GLOBAL.setfenv(1, GLOBAL)





env.AddClassPostConstruct("widgets/scripterrorwidget",
    function(self, title, text, buttons, texthalign, additionaltext, textsize, timeout, ...)
        local Menu = require "widgets/menu"
        local Button = require "widgets/button"
        local AnimButton = require "widgets/animbutton"
        local Text = require "widgets/text"
        local Image = require "widgets/image"
        local UIAnim = require "widgets/uianim"
        local Widget = require "widgets/widget"
























        local buttons =
        {


            {
                text = InGamePlay() and STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].MENURELOAD or
                STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].GAMERELOAD,
                cb = function()
                    TheSim:ResetError()
                    SimReset()
                end
            },

        }






        if ThePlayer and ThePlayer.Network:IsServerAdmin() then
        table.insert(buttons, 1,
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


        if ThePlayer and TheWorld and InGamePlay() and not TheNet:GetServerIsClientHosted() then
        table.insert(buttons, 1,
            {
                text = "Reconnect",
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




        self.menu_new = self.root:AddChild(Menu(buttons, 385, true, nil, true))
        self.menu_new:SetHRegPoint(ANCHOR_MIDDLE)
        self.menu_new:SetPosition(0, -315, 0)
        self.menu_new:SetScale(0.63)
    end)
