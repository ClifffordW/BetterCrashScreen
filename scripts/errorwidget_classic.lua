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
        local TEMPLATES_OLD = require "widgets/templates"



        local buttons =
        {
            {
                text = InGamePlay() and STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.RETURNTOMENU or
                STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.GAMERELOAD,
                cb = function()

                    if InGamePlay() then
                        TheNet:Disconnect(true) -- The game seems to have issues if we don't manually disconnect
                    end
                    TheSim:ResetError()
                    SimReset()
                end
            },
        }
        if ThePlayer and ThePlayer.Network:IsServerAdmin() and not (TheNet:GetServerIsClientHosted() and TheNet:GetIsHosting()) then -- If the server is client hosted then the game has trouble reloading.
        table.insert(buttons,
            {
                text = STRINGS.UI.MAINSCREEN.SCRIPTERRORRESTART,
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
        table.insert(buttons,
            {
                text = STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.RECONNECT,
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


        --Client log location button
        self.documentsbutton = self.root:AddChild(TEMPLATES_OLD.IconButton("images/button_icons.xml", "folder.tex", STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.CLIENTLOG_LOC, false, true, function() TheSim:OpenDocumentsFolder() end, {font=NEWFONT}))
        self.documentsbutton:SetPosition(-450,250)
        self.documentsbutton:SetTextSize(22)
        self.documentsbutton.text:SetPosition(115,0)
        self.documentsbutton.text_shadow:SetPosition(125,0)
        self.documentsbutton.icon:SetScale(0.15)

        ----------------------------------------------------

        self.menu_new = self.root:AddChild(Menu(buttons, 385, true, nil, true))
        self.menu_new:SetHRegPoint(ANCHOR_MIDDLE)
        self.menu_new:SetPosition(0, -315, 0)
        self.menu_new:SetScale(0.63)
    end)
