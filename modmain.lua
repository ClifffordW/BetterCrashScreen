modimport("scripts/strings")
modimport("scripts/autoreconnect")
if GetModConfigData("ReduxCrashScreen") ~= "redux" then
    modimport("scripts/errorwidget_classic")
else
    modimport("scripts/errorwidget_redux")
end

local env = env
GLOBAL.setfenv(1, GLOBAL)



DisplayError = function(error)
    SetPause(true,"DisplayError")
    if global_error_widget ~= nil then
        return nil
    end

    print (error) -- Failsafe since sometimes the error screen is no shown

    local ingame = InGamePlay()
    
    local errorheading = string.sub(error, 0, string.find(error, "\n") -1)

    local modnames = ModManager:GetEnabledModNames()

    local modnamesstr = ""
    local involvedmodnamesstr = ""
    local involvedmods = {}
    local maincausemodnamestr = ""
    local maincause = nil
    local othercausesmodnamesstr = ""
    local othercauses = {}
    for k,modname in ipairs(modnames) do
        local patternmodname = string.gsub(modname, "%-", "%%-")
        if string.find(error, "/"..patternmodname.."/") ~= nil then
            table.insert(involvedmods, modname)

            involvedmodnamesstr = involvedmodnamesstr.."\""..KnownModIndex:GetModFancyName(modname).."\" "

            if maincause == nil and string.find(errorheading, "/"..patternmodname.."/") ~= nil then
                maincause = modname
                maincausemodnamestr = "\""..KnownModIndex:GetModFancyName(modname).."\" "
            else
                table.insert(othercauses, modname)
                othercausesmodnamesstr = othercausesmodnamesstr.."\""..KnownModIndex:GetModFancyName(modname).."\" "
            end
        end
        modnamesstr = modnamesstr.."\""..KnownModIndex:GetModFancyName(modname).."\" "
    end

    -- print("involvedmods", #involvedmods)
    -- print("maincause", maincausemodnamestr)
    -- print("othercauses", #othercauses)

    local disablemodsbuttonstr = nil
    local disablemodsbuttonfn = nil
    if #involvedmods > 0 then -- Mods are involved in crash
        if maincause ~= nil then -- A specific mod had ran into an error...
            if #othercauses > 0 then -- Due to other mods

                disablemodsbuttonstr = STRINGS.UI.MAINSCREEN.MODQUIT -- Disable Mods
                disablemodsbuttonfn = function() 
                    for i, modname in ipairs(othercauses) do
                        KnownModIndex:Disable(modname)
                    end 
                end

            else -- On it's own

                disablemodsbuttonstr = STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.MODONEQUIT -- Disable Mod
                disablemodsbuttonfn = function()
                    KnownModIndex:Disable(maincause)
                end

            end
        else -- The game had ran into an error, mods were involved

            disablemodsbuttonstr = STRINGS.UI.MAINSCREEN.MODQUIT -- Disable Mods
            disablemodsbuttonfn = function()
                for i, modname in ipairs(involvedmods) do -- In this case involvedmods and othercases should be identical, but just in case they are not.
                    KnownModIndex:Disable(modname)
                end
            end

        end
    else -- No mods known to have caused an issue

        disablemodsbuttonstr = STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.MODALLQUIT -- Disable All Mods
        disablemodsbuttonfn = function()
            KnownModIndex:DisableAllMods()
        end

    end

    local buttons = nil
    if IsNotConsole() then
        buttons = {}
        -- if ingame then
        --     table.insert(buttons, {text=STRINGS.UI.MAINSCREEN.RETURNTOMENU, cb = function()
        --         TheSim:ResetError()
        --         TheNet:Disconnect(true)
        --         -- ForceAssetReset()
        --         -- SimReset()
        --         TheSim:Reset()
        --     end})
        -- else
        --     table.insert(buttons, {text=STRINGS.UI.MAINSCREEN.RESETMENU, cb = function()
        --         TheSim:ResetError()
        --         c_reset()
        --     end})
        -- end

        table.insert(buttons, {text=STRINGS.UI.MAINSCREEN.SCRIPTERRORQUIT, cb = function() TheSim:ForceAbort() end})

        -- if not ingame then
            table.insert(buttons, {text=disablemodsbuttonstr, cb = function() -- Annoying that cb has no arguments, I would love to change the button's text when clicked.
                
                disablemodsbuttonfn()

                ForceAssetReset()
                KnownModIndex:Save(function()
                    -- TheSim:ResetError()
                    -- SimReset()
                end)

            end})
        -- end

        table.insert(buttons, {text=STRINGS.UI.MAINSCREEN.MODFORUMS, nopop=true, cb = function() VisitURL("http://forums.kleientertainment.com/forum/79-dont-starve-together-beta-mods-and-tools/") end })
    end

    local titlestr = (maincause ~= nil and #involvedmods > 0) and
        string.format(STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.MODCRASH, maincausemodnamestr) or
        STRINGS.UI.MAINSCREEN.MODFAILTITLE

    local modstext = #involvedmods > 0 and
        ((maincause == nil or #othercauses == 0) and
            STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.SUSPECTEDMODS..involvedmodnamesstr or
            STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.SUSPECTEDCONFLICTS..othercausesmodnamesstr
        ) or
        STRINGS.UI.MAINSCREEN.SCRIPTERRORMODWARNING..modnamesstr

    SetGlobalErrorWidget(
            titlestr,
            error,
            buttons,
            ANCHOR_LEFT,
            modstext,
            20
            )
end