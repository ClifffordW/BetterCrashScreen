local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddClassPostConstruct("widgets/scripterrorwidget",
    function(self, title, text, buttons, texthalign, additionaltext, textsize, timeout, ...)
        local TEMPLATES_OLD = require "widgets/templates"
        local TEMPLATES = require "widgets/redux/templates"
        if env.GetModConfigData("ReduxCrashScreen") ~= "redux" then
            if env.GetModConfigData("DocumentsButton") == 1 then
                --Client log location button
                self.documentsbutton = self.root:AddChild(TEMPLATES_OLD.IconButton("images/button_icons2.xml",
                    "local_filter.tex",
                    STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.CLIENTLOG_LOC, false, true,
                    function() TheSim:OpenDocumentsFolder() end, { font = BODYTEXTFONT }))
                self.documentsbutton:SetPosition(-450, 275)
                self.documentsbutton:SetTextSize(22)
                self.documentsbutton.text:SetPosition(150, 0)
                self.documentsbutton.text_shadow:SetPosition(152, 0)
                self.documentsbutton:SetScale(0.89)

                self.documentsbutton:SetTextColour(255, 255, 255, 1)
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

            --Client log location button
            if env.GetModConfigData("SaveLog") == 1 then
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
                self.documentsbutton.text:SetPosition(150, 0)
                self.documentsbutton.text_shadow:SetPosition(152, 0)
                self.documentsbutton:SetTextColour(255, 255, 255, 1)
                self.documentsbutton:SetScale(0.89)
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
                    end,
                    { font = HEADERFONT }))
                self.createquick_log:SetPosition(-450, 220)
                self.createquick_log:SetTextSize(22)
                self.createquick_log.text:SetPosition(150, 0)
                self.createquick_log.text_shadow:SetPosition(152, 0)

                self.createquick_log:SetScale(0.89)

                self.createquick_log:SetTextColour(255, 255, 255, 1)
            end
        end
    end)
