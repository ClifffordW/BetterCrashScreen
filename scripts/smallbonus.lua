local env = env
GLOBAL.setfenv(1, GLOBAL)

local nostalgia_enabled = env.GetModConfigData("nostalgia") == 1

local Mixer = require("mixer")

local amb = "set_ambience/ambience"
local cloud = "set_ambience/cloud"
local music = "set_music/soundtrack"
local voice = "set_sfx/voice"
local movement ="set_sfx/movement"
local creature ="set_sfx/creature"
local player ="set_sfx/player"
local HUD ="set_sfx/HUD"
local sfx ="set_sfx/sfx"
local slurp ="set_sfx/everything_else_muted"

TheMixer:AddNewMix("pause_bettercrashscr", 1, 4,
{
    [amb] = .1,
    [cloud] = .1,
    [music] = .75,
    [voice] = 0,
    [movement] = 0,
    [creature] = 0,
    [player] = 0,
    [HUD] = .15,
    [sfx] = 0,
    [slurp] = 0,
})





env.AddClassPostConstruct("widgets/scripterrorwidget", function(self, ...)
    local UIAnim = require "widgets/uianim"
    local Image = require "widgets/image"
    local TEMPLATES = require "widgets/templates"

    if nostalgia_enabled then

		self.bg = self:AddChild(TEMPLATES.BackgroundSpiral())
        self.black:MoveToBack()
        self.bg:MoveToBack()

        TheMixer:PopMix("pause")
        TheMixer:PushMix("pause_bettercrashscr")
        --TriggerCrashBG()





        if TheFocalPoint and InGamePlay() then
            TheFocalPoint.SoundEmitter:KillAllSounds()
        end


        if TheFrontEnd then
            TheFrontEnd:GetSound():KillAllSounds()

            TheFrontEnd:GetSound():PlaySound("dontstarve/together_FE/DST_theme_portaled", "crashmusic")
            TheFrontEnd:GetSound():PlaySound("dontstarve/together_FE/portal_swirl", "portalfx")

    

        end
        
        if self.frame then 
            self.frame:Hide()
        end

        if self.classic_frame then
            self.classic_frame:Hide()

        end

        self.root:SetScale(1.5)

    end



end)