local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddClassPostConstruct("widgets/scripterrorwidget",
    function(self, title, text, buttons, texthalign, additionaltext, textsize, timeout, ...)
        local TEMPLATES_OLD, TEMPLATES = require "widgets/templates", require "widgets/redux/templates"
        local is_combined, closerto_log = env.GetModConfigData("CombinedButtons"), env.GetModConfigData("ButtonsCloserToLog")
        local button_y = closerto_log and 185 or 275
        local has_classicframe = env.GetModConfigData("ClassicFrame")



        if env.GetModConfigData("ReduxCrashScreen") ~= "redux" then
            
            if env.GetModConfigData("DocumentsButton") == 1 then
                --Client log location button
                self.documentsbutton = self.root:AddChild(TEMPLATES_OLD.IconButton("images/button_icons2.xml",
                    "local_filter.tex",
                    STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.CLIENTLOG_LOC, false, true,
                    function() TheSim:OpenDocumentsFolder() end, { font = BODYTEXTFONT }))
                self.documentsbutton:SetPosition(-450, 275)
                self.documentsbutton:SetTextSize(22)
                self.documentsbutton.text:SetPosition(100, 0)
                self.documentsbutton.text_shadow:SetPosition(102, 0)
                self.documentsbutton:SetScale(0.89)
                self.documentsbutton.text:SetHAlign(ANCHOR_LEFT)
                self.documentsbutton.text_shadow:SetHAlign(ANCHOR_LEFT)


                self.documentsbutton:SetTextColour(255, 255, 255, 1)
            end

            

            ----------------------------------------------------



            function CW_CreateTextFileCommand(text)
                local modname = KnownModIndex:GetModFancyName(env.modname)
                local filename = string.lower(string.gsub(modname, " ", "")) .. "_quicklog.txt"

                local file = io.open(filename, "w")
                if file then
                    file:write(text)
                    file:close()
                end
            end

            --Client log location button
            if env.GetModConfigData("SaveLog") == 1 then
                self.createquick_log = self.root:AddChild(TEMPLATES_OLD.IconButton("images/button_icons.xml", "save.tex",
                    STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.SAVEQUICKLOG, false, true, function()
                        CW_CreateTextFileCommand(text)
                        self.text:SetString(text.."\nQuicklog has been saved to Don't Starve Together's data folder.")

                    end,
                    { font = BODYTEXTFONT }))
                self.createquick_log:SetPosition(-450, 220)
                self.createquick_log:SetTextSize(22)
                self.createquick_log.text:SetPosition(122, 0)
                self.createquick_log.text_shadow:SetPosition(122 + 2, 0)

                self.createquick_log:SetScale(0.89)
                self.createquick_log.text:SetHAlign(ANCHOR_LEFT)
                self.createquick_log.text_shadow:SetHAlign(ANCHOR_LEFT)



                self.createquick_log:SetTextColour(255, 255, 255, 1)
            end

            ----------------------------------------------------
        else
            --Client log location button

            if env.GetModConfigData("DocumentsButton") == 1 then
                self.documentsbutton = self.root:AddChild(TEMPLATES.IconButton("images/button_icons2.xml",
                    "local_filter.tex",
                    STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.CLIENTLOG_LOC, false, true,
                    function() TheSim:OpenDocumentsFolder() end, { font = HEADERFONT }))
                self.documentsbutton:SetPosition(-450, 275)
                self.documentsbutton:SetTextSize(22)
                self.documentsbutton.text:SetPosition(122, 0)
                self.documentsbutton.text_shadow:SetPosition(122 + 2, 0)
                self.documentsbutton:SetTextColour(255, 255, 255, 1)
                self.documentsbutton:SetScale(0.89)

                self.documentsbutton.text:SetHAlign(ANCHOR_LEFT)
                self.documentsbutton.text_shadow:SetHAlign(ANCHOR_LEFT)
            end
            ----------------------------------------------------



            function CreateTextFileCommand(text)
                local modname = KnownModIndex:GetModFancyName(env.modname)
                local filename = string.lower(string.gsub(modname, " ", "")) .. "_quicklog.txt"

                local file = io.open(filename, "w")
                if file then
                    file:write(text)
                    file:close()
                end
            end

            if env.GetModConfigData("SaveLog") == 1 then
                self.createquick_log = self.root:AddChild(TEMPLATES.IconButton("images/button_icons.xml", "save.tex",
                    STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.SAVEQUICKLOG, false, true, function()
                        CreateTextFileCommand(text)
                        self.text:SetString(text.."\nQuicklog has been saved to Don't Starve Together's data folder.")
                    end,
                    { font = HEADERFONT }))
                self.createquick_log:SetPosition(-450, 220)
                self.createquick_log:SetTextSize(22)
                self.createquick_log.text:SetPosition(152, 0)
                self.createquick_log.text_shadow:SetPosition(152 + 2, 0)

                self.createquick_log.text:SetHAlign(ANCHOR_LEFT)
                self.createquick_log.text_shadow:SetHAlign(ANCHOR_LEFT)
                self.createquick_log:SetScale(0.89)

                self.createquick_log:SetTextColour(255, 255, 255, 1)
            end
        end

        if env.GetModConfigData("ReduxCrashScreen") ~= "redux" and has_classicframe then
            self.documentsbutton:SetPosition(255, 125 + 55)
            self.createquick_log:SetPosition(255, 125)


            

            
        end

        if is_combined and closerto_log  then
            
            


            
                self.createquick_log:SetPosition(-390, button_y)
                self.createquick_log.text:Hide()
                self.createquick_log.text_shadow:Hide()

                self.documentsbutton:SetPosition(-450, button_y)

                self.documentsbutton.text:Hide()
                self.documentsbutton.text_shadow:Hide()

        
        
        
        end
   
   
   
   
    end)
