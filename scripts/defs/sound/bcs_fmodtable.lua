

local fmodtable = {
    helping_arrow = {
        event = "arrow/sfx/arrow",
        handle = "helparrow"
    },

    helping_arrow_bg = {
        event = "arrow/sfx/arrow_bgmusic",
        handle = "helparrow_bg"
    },

    
    voiceover = {
        event = "arrow/sfx/voiceover",
        handle = "voiceover"
    },

    voiceover_pt = {
        event = "tutorial/sfx/voiceover_pt",
        handle = "voiceover"
    },

    
}


function fmod_playevent(event, volume, inst)
    if not fmodtable[event] then return end

    local _sound = InGamePlay() and (inst and inst.SoundEmitter or TheFocalPoint.SoundEmitter) or TheFrontEnd:GetSound()
    _sound:PlaySound(fmodtable[event].event, fmodtable[event].handle, volume or 1)
end




function fmod_stopevent(event, inst)
    local _sound = InGamePlay() and (inst and inst.SoundEmitter or TheFocalPoint.SoundEmitter) or TheFrontEnd:GetSound()
    _sound:KillSound(fmodtable[event].handle)
end




cw_PlayFMODEvent = fmod_playevent
cw_StopFMODEvent = fmod_stopevent


return fmodtable
    
