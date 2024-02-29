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
        self.documentsbutton = self.root:AddChild(TEMPLATES_OLD.IconButton("images/button_icons2.xml", "local_filter.tex",
            STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.CLIENTLOG_LOC, false, true,
            function() TheSim:OpenDocumentsFolder() end, { font = BODYTEXTFONT }))
        self.documentsbutton:SetPosition(-450, 275)
        self.documentsbutton:SetTextSize(22)
        self.documentsbutton.text:SetPosition(150, 0)
        self.documentsbutton.text_shadow:SetPosition(152, 0)
        ----------------------------------------------------


        
        function CreateTextFileCommand(text)
            local modname = KnownModIndex:GetModFancyName(env.modname)
            local filename = string.lower(string.gsub(modname, " ", "")).."_quicklog.txt"

            local file = io.open(filename, "w")
            if file then
                file:write(text)
                file:close()

            end
        end

        --Client log location button
        self.createquick_log = self.root:AddChild(TEMPLATES_OLD.IconButton("images/button_icons.xml", "save.tex",
        STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.SAVEQUICKLOG, false, true, function()
                
                CreateTextFileCommand(text)




               

            end,
            { font = BODYTEXTFONT }))
        self.createquick_log:SetPosition(-450, 220)
        self.createquick_log:SetTextSize(22)
        self.createquick_log.text:SetPosition(150, 0)
        self.createquick_log.text_shadow:SetPosition(152, 0)

        self.createquick_log:SetScale(0.89)
        self.documentsbutton:SetScale(0.89)
        
        self.documentsbutton:SetTextColour(255, 255, 255, 1)
        self.createquick_log:SetTextColour(255, 255, 255, 1)

        ----------------------------------------------------

        self.menu_new = self.root:AddChild(Menu(buttons, 385, true, nil, true))
        self.menu_new:SetHRegPoint(ANCHOR_MIDDLE)
        self.menu_new:SetPosition(0, -315, 0)
        self.menu_new:SetScale(0.63)
    end)
