do
    local GLOBAL = GLOBAL
    local modEnv = GLOBAL.getfenv(1)
    local rawget, setmetatable = GLOBAL.rawget, GLOBAL.setmetatable
    setmetatable(modEnv, {
        __index = function(self, index)
            return rawget(GLOBAL, index)
        end
        -- lack of __newindex means it defaults to modEnv, so we don't mess up globals.
    })

    _G = GLOBAL
end



local sel_font =  type(GetModConfigData("font")) ~= "number" and GetModConfigData("font") or HEADERFONT



AddClassPostConstruct("screens/redux/multiplayermainscreen",
    function(self, ...)
        local Menu = require "widgets/menu"
        local Button = require "widgets/button"
        local AnimButton = require "widgets/animbutton"
        local Text = require "widgets/text"
        local Image = require "widgets/image"
        local UIAnim = require "widgets/uianim"
        local Widget = require "widgets/widget"
        local TEMPLATES = require "widgets/redux/templates"
        local NineSlice = require "widgets/nineslice"
        local PopupDialogScreenRedux = require "screens/redux/popupdialog"


        function self.CustomIconButton2(iconAtlas, iconTexture, labelText, sideLabel, alwaysShowLabel, onclick, textinfo, defaultTexture)
            local btn = TEMPLATES.StandardButton(onclick, nil, {70,70}, {iconAtlas, iconTexture})
        
            if not textinfo then
                textinfo = {}
            end
        
            if sideLabel then
                -- A label to the left of the button.
                btn.label = btn:AddChild(Text(textinfo.font or NEWFONT, textinfo.size or 25, labelText, textinfo.colour or _G.UICOLOURS.GOLD_CLICKABLE))
                btn.label:SetRegionSize(150,70)
                btn.label:EnableWordWrap(true)
                btn.label:SetHAlign(ANCHOR_RIGHT)
                btn.label:SetPosition(-115, 2)
        
            elseif alwaysShowLabel then
                -- A label below the button.
                btn:SetTextSize(textinfo.size or 25)
                btn:SetText(labelText, true)
                btn.text:SetPosition(1, -38)
                btn.text_shadow:SetPosition(-1, -40)
                btn:SetFont(textinfo.font or NEWFONT)
                btn:SetDisabledFont(textinfo.font or NEWFONT)
                btn:SetTextColour(textinfo.colour or _G.UICOLOURS.GOLD_CLICKABLE)
                btn:SetTextFocusColour(textinfo.focus_colour or _G.UICOLOURS.GOLD_FOCUS)
        
            else
                -- Only show hovertext.
                btn:SetHoverText(labelText, {
                        font = textinfo.font or NEWFONT_OUTLINE,
                        offset_x = textinfo.offset_x or 2,
                        offset_y = textinfo.offset_y or -45,
                        colour = textinfo.colour or _G.UICOLOURS.WHITE,
                        bg = textinfo.bg
                    })
            end
        
            return btn
        end

        

        TheSim:GetPersistentString("BetterCrashScreen_tutorial", function(load_success, data)
            if load_success and data ~= nil then
                local status, bettercrashscr = pcall(function() return json.decode(data) end)
                if status and bettercrashscr then
                    self.bettercrashscr_seentutorial = bettercrashscr.bettercrashscr_tutorial
                    self.loaded = true
                end
            end
        end)


        if GetModConfigData("RewatchTutorial") == 1 then
            local locationData = { bettercrashscr_tutorial = false }
            local jsonString = json.encode(locationData)
            self.rewatchbutton = self.fixed_root:AddChild(self.CustomIconButton2("images/button_icons.xml", "undo.tex",
            STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.REWATCH, false, true, function() 
            
            
                TheSim:SetPersistentString("BetterCrashScreen_tutorial", jsonString, false)

                TheSim:ResetError()
                c_reset()
            end,
            { font = NEWFONT_OUTLINE, size = 24 }))

            self.rewatchbutton:SetScale(0.85)
            self.rewatchbutton:SetPosition( 550, -280)
        end
        
        
        local locationData = { bettercrashscr_tutorial = true }
        local jsonString = json.encode(locationData)


        function AttachToMouse(widget)
            local x, y
            local followhandler
        
            local function UpdatePosition(self, x, y)
                widget:SetPosition(Vector3(x, y, 0))
            end
        
            followhandler = TheInput:AddMoveHandler(function(mx, my)
                UpdatePosition(widget, mx, my)
            end)
        
            widget.FollowMouse = function(self)
                if followhandler == nil then
                    followhandler = TheInput:AddMoveHandler(function(mx, my)
                        UpdatePosition(self, mx, my)
                    end)
                    self:SetPosition(TheInput:GetScreenPosition())
                end
            end
        
            widget:FollowMouse()
        
        
        end




        

        

    if not self.bettercrashscr_seentutorial then


        



        self.crashbg = self.fixed_root:AddChild(UIAnim())

        local crashbg = self.crashbg
        local crashbg_anim = self.crashbg:GetAnimState()

        self.skipbutton = self.fixed_root:AddChild(self.CustomIconButton2("images/button_icons.xml", "undo.tex",
        STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN.SKIP, false, true, function() 
        
        
            TheSim:SetPersistentString("BetterCrashScreen_tutorial", jsonString, false)

            TheSim:ResetError()
            c_reset()
        end,
        { font = NEWFONT_OUTLINE, size = 24 }))


        self.skipbutton:SetPosition( 450, -250)

        





        crashbg_anim:SetBank("detectivehayseed_hint")
        crashbg_anim:SetBuild("detectivehayseed_hint")
        crashbg_anim:PlayAnimation("bg", true)
        crashbg:SetScale(0.68)
        crashbg:Hide()

        self.help_arrow = self.fixed_root:AddChild(UIAnim())
        self.help_circle = self.help_arrow:AddChild(UIAnim())

        local helparrow = self.help_arrow
        local helparrow_anim = self.help_arrow:GetAnimState()





        helparrow_anim:SetBank("detectivehayseed_hint")
        helparrow_anim:SetBuild("detectivehayseed_hint")
        helparrow_anim:SetDeltaTimeMultiplier(0)
        helparrow_anim:PlayAnimation("show_arrow", true)
        helparrow:SetScale(0.25)


        local helpcircle = self.help_circle
        local helpcircle_anim = self.help_circle:GetAnimState()

        helpcircle_anim:SetBank("detectivehayseed_hint")
        helpcircle_anim:SetBuild("detectivehayseed_hint")
        helpcircle_anim:PlayAnimation("show_circle", true)
        helpcircle:SetScale(1)

        helpcircle:MoveToBack()
        helpcircle:Hide()

        helparrow_anim:SetDeltaTimeMultiplier(0.85)
        helpcircle_anim:SetDeltaTimeMultiplier(0.85)

        helparrow:Hide()
        

        for k,v in pairs(self.menu.items) do
            v:Disable()
        end

        for k,v in pairs(self.submenu.items) do
            v:Disable()
        end
        self.motd_panel:Disable()


        local vol = 0.75
        require "defs.sound.bcs_fmodtable"

        --This is a stupid thing but i dont have the brain for better one
        local _sound = TheFrontEnd:GetSound()
        cw_PlayFMODEvent("helping_arrow_bg", 0.45)
        helparrow.inst:DoPeriodicTask(FRAMES, function()
            if not _sound:PlayingSound("helparrow") then
                cw_PlayFMODEvent("helping_arrow", 0.75)
                
            end


            if helparrow.shown then
                _sound:SetVolume("helparrow", vol)

            else
                _sound:SetVolume("helparrow", 0)
                
            end
        end)

        self.inst:DoTaskInTime(0.5, function()
            _sound:SetVolume("FEMusic", 0)
            cw_PlayFMODEvent("helping_arrow_bg", 0.45)
            cw_PlayFMODEvent("voiceover", 0.29)
            crashbg:Show()
        end)


        
        local x = -420
        local x_big = -225


        self.inst:DoTaskInTime(0, function()
            


            
            --Reload
            self.inst:DoTaskInTime(22.5, function()
                helparrow:Show()
                helparrow:SetPosition(x_big, -235)
            end)

            --Reload Save
            self.inst:DoTaskInTime(25.2, function()
                helparrow:SetPosition(x_big + 225, -235)
            end)

            --Reconnect
            self.inst:DoTaskInTime(33.8, function()
                helparrow:Show()
                helparrow:SetPosition(x_big + 225 + 225, -235)
                
            end)

            --Reconnect
            self.inst:DoTaskInTime(45.1, function()
                helparrow:Hide()
                
            end)


            --Folder
            self.inst:DoTaskInTime(49.25, function()
                helparrow:Show()
                helparrow:SetPosition(-420, 180)

            end)

            --Save
            self.inst:DoTaskInTime(56.4, function()
                helparrow:SetPosition(x + 50, 180)
            end)
            
            --GLobe
            self.inst:DoTaskInTime(72.2, function()
                helparrow:SetPosition(x + 50 +  50, 180)
            end)


            --Globe
            self.inst:DoTaskInTime(79.4, function()
                helparrow:SetPosition(x_big + 230, -180)
            end)
            
            







 


            self.inst:DoTaskInTime(86.4, function()
                helparrow:Hide()
               
            end)

            self.inst:DoTaskInTime(86.9, function()
                helparrow:Kill()
                
               
            end)


            self.inst:DoTaskInTime(99, function()
                cw_StopFMODEvent("helping_arrow_bg")
                TheSim:SetPersistentString("BetterCrashScreen_tutorial", jsonString, false)

                
               
            end)




            


            self.inst:DoTaskInTime(110.2, function()

                

                self.help_arrow = self:AddChild(UIAnim())
                self.help_circle = self.help_arrow:AddChild(UIAnim())
    
                local helparrow = self.help_arrow
                local helparrow_anim = self.help_arrow:GetAnimState()
    
    
    
    
    
                helparrow_anim:SetBank("detectivehayseed_hint")
                helparrow_anim:SetBuild("detectivehayseed_hint")
                helparrow_anim:SetDeltaTimeMultiplier(0)
                helparrow_anim:PlayAnimation("show_arrow", true)
                helparrow:SetScale(0.25)
    
    
                local helpcircle = self.help_circle
                local helpcircle_anim = self.help_circle:GetAnimState()
    
                helpcircle_anim:SetBank("detectivehayseed_hint")
                helpcircle_anim:SetBuild("detectivehayseed_hint")
                helpcircle_anim:PlayAnimation("show_circle", true)
                helpcircle:SetScale(1)
    
                helpcircle:MoveToBack()
                helpcircle:Hide()
    
                helparrow_anim:SetDeltaTimeMultiplier(0.85)
                helpcircle_anim:SetDeltaTimeMultiplier(0.85)
    
                helparrow:Hide()

                local vol = 0.75

                --This is a stupid thing but i dont have the brain for better one
                local _sound = TheFrontEnd:GetSound()
                helparrow.inst:DoPeriodicTask(FRAMES, function()
                    if not _sound:PlayingSound("helparrow") then
                        cw_PlayFMODEvent("helping_arrow", 0.75)
                    end
        
        
                    if helparrow.shown then
                        _sound:SetVolume("helparrow", vol)
        
                    else
                        _sound:SetVolume("helparrow", 0)
                        
                    end
                end)

                AttachToMouse(helparrow)
                helparrow:SetPosition(0, 0)
                helparrow:Show()
                helpcircle:SetScale(0.45, 0.45)
                helpcircle:SetPosition(10,-25)
                helpcircle:Show()
            end)

            self.inst:DoTaskInTime(25, function()
                

                    
            end)


            self.inst:DoTaskInTime(116, function()
                self.help_arrow:Hide()
                TheFrontEnd:Fade(FADE_IN, 2)
                _sound:SetVolume("FEMusic", 1)
                
            end)

            self.inst:DoTaskInTime(116.25, function()
                self.help_arrow:Kill()
                crashbg:Kill()

                if self.skipbutton then
                    self.skipbutton:Kill()
                end

                for k,v in pairs(self.menu.items) do
                    v:Enable()
                end
        
                for k,v in pairs(self.submenu.items) do
                    v:Enable()
                end
                self.motd_panel:Enable()
                
            end)


        end)


        helparrow:SetScale(0.1)
    end


        

    end)



 