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

local function HeyVSauceMichaelHere()
    TheSim:GetPersistentString("BetterCrashScreen_EnabledMods", function(load_success, data)
        if load_success and data ~= nil then
            local status, bettercrashscr = pcall(function() return json.decode(data) end)
            if status and bettercrashscr then
                bettercrashscr_enabledmods = bettercrashscr.bettercrashscr_enabledmods
                loaded = true
            end
        end
    end)
end



--This code is so terrible, hopefully i will never be able to write this code again
AddClassPostConstruct("screens/redux/modsscreen", function(self, ...)
    local TEXT_OFFSET = 100

    local tableexists = type(bettercrashscr_enabledmods) == "table" and next(bettercrashscr_enabledmods) ~= nil

    local TEMPLATES = require("widgets/redux/templates")
    self.saveperistentmods = self.root:AddChild(
        TEMPLATES.IconButton(
            "images/button_icons.xml",
            "save.tex",
            tableexists == true and "Clear Saved Mods" or "Save Mods",
            false,
            true,
            function()
                HeyVSauceMichaelHere()
                tableexists = type(bettercrashscr_enabledmods) == "table" and next(bettercrashscr_enabledmods) ~= nil

                local mymods = KnownModIndex:GetModsToLoad()
                local locationData = { bettercrashscr_enabledmods = tableexists and {} or mymods }
                local jsonString = json.encode(locationData)
                TheSim:SetPersistentString("BetterCrashScreen_EnabledMods", jsonString, false,
                    function()
                        self.saveperistentmods.text:SetString(tableexists == true and "Save Mods" or "Clear Saved Mods")
                        self.saveperistentmods.text_shadow:SetString(tableexists == true and "Save Mods" or "Clear Saved Mods")
                    end)
            end,
            { font = HEADERFONT }
        )
    )
    self.saveperistentmods:SetPosition(-255, 325)
    self.saveperistentmods:SetTextSize(22)
    self.saveperistentmods.text:SetPosition(TEXT_OFFSET, 0)
    self.saveperistentmods.text_shadow:SetPosition(TEXT_OFFSET + 2, 0)
    self.saveperistentmods:SetScale(0.89)
    self.saveperistentmods.text:SetHAlign(ANCHOR_MIDDLE)
    self.saveperistentmods.text_shadow:SetHAlign(ANCHOR_MIDDLE)

    self.saveperistentmods:SetTextColour(255, 255, 255, 1)

    self.saveperistentmods.text:SetHAlign(ANCHOR_LEFT)
    self.saveperistentmods.text_shadow:SetHAlign(ANCHOR_LEFT)
end)


AddClassPostConstruct("screens/redux/mainscreen", function(self, ...)
    function CheckForDisabledMods()
        HeyVSauceMichaelHere()

        local tableexists = type(bettercrashscr_enabledmods) == "table" and next(bettercrashscr_enabledmods) ~= nil

        local PopupDialogScreenRedux = require "screens/redux/popupdialog"
        local modstoenable

        if InGamePlay() then return end









        if not tableexists then return end

        local isenabled = nil

        local function EnableDemMods(v)
            for _, v in pairs(bettercrashscr_enabledmods) do
                KnownModIndex:Enable(v)
            end

            KnownModIndex:Save()
            TheSim:ResetError()
            c_reset()
        end
        for _, v in pairs(bettercrashscr_enabledmods) do
            isenabled = KnownModIndex:IsModEnabled(v)
        end












        if not isenabled then
            local dialogue = PopupDialogScreenRedux("Mods are disabled!",
                "Your mods are disabled would you like to re-enable them?.", {
                    {
                        text = "Yes",
                        cb = function()
                            EnableDemMods(v)
                        end
                    }, {
                    text = "No",
                    cb = function()
                        TheFrontEnd:PopScreen()
                    end
                },


                }, nil, "big")

            TheFrontEnd:PushScreen(dialogue)
        end
    end

    self.inst:DoTaskInTime(0.35, function()
        CheckForDisabledMods()
    end)
end)
