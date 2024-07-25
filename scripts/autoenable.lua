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
                bettercrashscr_mimenabledmods = bettercrashscr.bettercrashscr_mimenabledmods

                loaded = true
            end
        end
    end)
end



--This code is so terrible, hopefully i will never be able to write this code again 这个代码太可怕了，希望我再也写不出这个代码了
AddClassPostConstruct("screens/redux/modsscreen", function(self, ...)
    local TEXT_OFFSET = 100

    local mymods_mim
    local is_mim_enabled = KnownModIndex.IsMiMEnabled and true or false

    local tableexists = type(bettercrashscr_enabledmods) == "table" and next(bettercrashscr_enabledmods) ~= nil
    local tableexists_mim = type(bettercrashscr_mimenabledmods) == "table" and next(bettercrashscr_mimenabledmods) ~= nil


    local TEMPLATES = require("widgets/redux/templates")

    
    if GetModConfigData("savemodspos") == 0 then 
        self.saveperistentmods_big = self.optionspanel:AddChild(TEMPLATES.StandardButton(nil, tableexists == true and STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SAVEPERISTENTMODS_CLEAR or STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SAVEPERISTENTMODS_SAVE))
        self.saveperistentmods_big:SetScale(.7)
        self.saveperistentmods_big:SetPosition(105, -310)

        



        self.saveperistentmods_big.onclick = function ()


            HeyVSauceMichaelHere()
                    tableexists = type(bettercrashscr_enabledmods) == "table" and next(bettercrashscr_enabledmods) ~= nil
                    tableexists_mim = type(bettercrashscr_mimenabledmods) == "table" and next(bettercrashscr_mimenabledmods) ~= nil

                    local mymods = KnownModIndex:GetModsToLoad()
                    mymods_mim = is_mim_enabled and KnownModIndex:GetMiMMods() or nil

                    if is_mim_enabled and mymods_mim then
                        local keys = {}

                        for k in pairs(mymods_mim) do 
                            table.insert(keys, k)
                        end

                        mymods_mim = keys

                    end


                    local locationData = { bettercrashscr_enabledmods = tableexists and {} or mymods, bettercrashscr_mimenabledmods = tableexists_mim and {} or mymods_mim,  }
                    local jsonString = json.encode(locationData)
                    TheSim:SetPersistentString("BetterCrashScreen_EnabledMods", jsonString, false,
                        function()

                            self.saveperistentmods_big.text:SetString(tableexists == true and STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SAVEPERISTENTMODS_SAVE or STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SAVEPERISTENTMODS_CLEAR)
                        end)
            
        end

    else





        self.saveperistentmods = self.root:AddChild(
            TEMPLATES.IconButton(
                "images/button_icons.xml",
                "save.tex",
                tableexists == true and STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SAVEPERISTENTMODS_CLEAR or STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SAVEPERISTENTMODS_SAVE,
                false,
                true,
                function()
                    HeyVSauceMichaelHere()
                    tableexists = type(bettercrashscr_enabledmods) == "table" and next(bettercrashscr_enabledmods) ~= nil
                    tableexists_mim = type(bettercrashscr_mimenabledmods) == "table" and next(bettercrashscr_mimenabledmods) ~= nil

                    local mymods = KnownModIndex:GetModsToLoad()
                    mymods_mim = is_mim_enabled and KnownModIndex:GetMiMMods() or nil

                    if is_mim_enabled and mymods_mim then
                        local keys = {}

                        for k in pairs(mymods_mim) do 
                            table.insert(keys, k)
                        end

                        mymods_mim = keys

                    end


                    local locationData = { bettercrashscr_enabledmods = tableexists and {} or mymods, bettercrashscr_mimenabledmods = tableexists_mim and {} or mymods_mim,  }
                    local jsonString = json.encode(locationData)
                    TheSim:SetPersistentString("BetterCrashScreen_EnabledMods", jsonString, false,
                        function()
                            self.saveperistentmods.text:SetString(tableexists == true and STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SAVEPERISTENTMODS_SAVE or STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SAVEPERISTENTMODS_CLEAR)
                            self.saveperistentmods.text_shadow:SetString(tableexists == true and STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SAVEPERISTENTMODS_SAVE or STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].SAVEPERISTENTMODS_CLEAR)
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

    end
end)


AddClassPostConstruct("screens/redux/mainscreen", function(self, ...)
    function CheckForDisabledMods()
        HeyVSauceMichaelHere()

        local tableexists = type(bettercrashscr_enabledmods) == "table" and next(bettercrashscr_enabledmods) ~= nil
        local tableexists_mim = type(bettercrashscr_mimenabledmods) == "table" and next(bettercrashscr_mimenabledmods) ~= nil
        local is_mim_enabled = KnownModIndex.IsMiMEnabled and true or false


        local PopupDialogScreenRedux = require "screens/redux/popupdialog"
        local modstoenable

        if InGamePlay() then return end







        print(tableexists)
        if not tableexists or (is_mim_enabled and not tableexists_mim) then return end

        local isenabled = nil
        local isenabled_mim = nil
        local autoenablemim = GetModConfigData("autoenablemim") == 1


        local function EnableDemMods(v)

            
            for _, v in pairs(bettercrashscr_enabledmods) do

                if not KnownModIndex:DoesModExistAnyVersion(v) then
                    TheSim:SubscribeToMod(v)
                end

                KnownModIndex:Enable(v)
            end
            if is_mim_enabled then
                for _, v in pairs(bettercrashscr_mimenabledmods) do
                    if not KnownModIndex:DoesModExistAnyVersion(v) then
                        TheSim:SubscribeToMod(v)
                    end

                    KnownModIndex:MiMEnable(v)
                end
            end
            

            KnownModIndex:Save()
            TheSim:ResetError()
            c_reset()
        end
        for _, v in pairs(bettercrashscr_enabledmods) do
            isenabled = KnownModIndex:IsModEnabled(v)
        end
        if is_mim_enabled then
            for _, v in pairs(bettercrashscr_mimenabledmods) do
                isenabled_mim = KnownModIndex:IsMiMEnabled(v)
            end
        end
        







        if (not isenabled and GetModConfigData("autoapply") == 1) or (GetModConfigData("autoapply_mim") == 1 and (is_mim_enabled and not isenabled_mim)) then

            EnableDemMods(v)

            return
        end



        if not isenabled or (is_mim_enabled and not isenabled_mim)  then





            local dialogue = PopupDialogScreenRedux((is_mim_enabled and not isenabled_mim) and STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].TITLE_MIMMODSDISABLED or STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].TITLE_NORMALMODSDISABLED,
                    (is_mim_enabled and not isenabled_mim) and STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].MIMMODSDISABLED or STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN[TUNING.BETTECRASHSCREEN_LANGUAGE].NORMALMODSDISABLED, {
                    {
                        text = STRINGS.UI.MAINSCREEN.YES,
                        cb = function()
                            EnableDemMods(v)
                        end
                    }, {
                    text = STRINGS.UI.MAINSCREEN.NO,
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
