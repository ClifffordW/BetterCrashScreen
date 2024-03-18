local STRINGS = GLOBAL.STRINGS

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



TUNING.BETTECRASHSCREEN_LANGUAGE = LOC.GetLocaleCode() or GetModConfigData("language")

STRINGS.UI.MAINSCREEN.BETTERCRASHSCREEN = {
    en = {
        MODCRASH = "%s Crashed!",
        SUSPECTEDMODS = "Likely Causes:\n",
        SUSPECTEDCONFLICTS = "Likely Mod Conflicts:\n",
        MODALLQUIT = "Disable All Mods",
        MODONEQUIT = "Disable Mod",
        RETURNTOMENU = "Return To Menu",
        GAMERELOAD = "Reload Game",
        RECONNECT = "Reconnect",
        CLIENTLOG_LOC = "Clientlog Location\n(Go up by one folder)",
        SAVEQUICKLOG = "Save Quicklog and\nOpens the location",
        SAVEDQUICKLOG = "Quicklog has been created in DST's data folder",
        MODPAGE = "Workshop Page",
        SKIP = "Skip",
        REWATCH = "Re/Watch BCS Tutorial",
        SCRIPTERRORQUIT = "Exit Game",
        SCRIPTERRORMODWARNING = "This error may have occurred due to a mod you have enabled!",
        MODFORUMS = "Mod Forums",
        MODQUIT = "Disable Mods",
        SCRIPTERRORRESTART = "Reload Save",

        
    },

    pt = { -- Portuguese translation
        MODCRASH = "%s Crashou!",
        SUSPECTEDMODS = "Possíveis Causas:\n",
        SUSPECTEDCONFLICTS = "Conflitos de Mods Prováveis:\n",
        MODALLQUIT = "Desabilitar Mods",
        MODONEQUIT = "Desativar Mod",
        RETURNTOMENU = "Voltar ao Menu",
        GAMERELOAD = "Recarregar Jogo",
        RECONNECT = "Reconectar",
        CLIENTLOG_LOC = "Local do Log do Cliente\n(Acessar um nível acima)",
        SAVEQUICKLOG = "Salvar Log Rápido e\nAbrir o local",
        SAVEDQUICKLOG = "O Log Rápido foi criado na pasta de dados do DST",
        MODPAGE = "Página da Oficina",
        SKIP = "Pular",
        REWATCH = "Re/Assistir Tutorial do BCS",
        SCRIPTERRORQUIT = "Sair do Jogo",
        SCRIPTERRORMODWARNING = "Este erro pode ter ocorrido devido a um mod que você ativou!",
        MODFORUMS = "Fóruns do Mod",
        MODQUIT = "Desativar Mods",
        SCRIPTERRORRESTART = "Recarregar Salvar",
    },
    
}

    

    


