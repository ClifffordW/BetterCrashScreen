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



TUNING.BETTECRASHSCREEN_LANGUAGE = GetModConfigData("language")

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


        TITLE_MIMMODSDISABLED = "MiM mods are disabled!",
        MIMMODSDISABLED = "MiM mods are disabled would you like to re-enable them?.",

        TITLE_NORMALMODSDISABLED = "Mods are disabled!",
        NORMALMODSDISABLED = "Your mods are disabled would you like to re-enable them?.",

        SAVEPERISTENTMODS_SAVE = "Save Mods",
        SAVEPERISTENTMODS_CLEAR = "Clear Saved Mods"
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


        TITLE_MIMMODSDISABLED = "Mods MiM estão desativados!",
        MIMMODSDISABLED = "Os mods MiM estão desativados, você gostaria de reativá-los?",

        TITLE_NORMALMODSDISABLED = "Mods estão desativados!",
        NORMALMODSDISABLED = "Seus mods estão desativados, você gostaria de reativá-los?",
    },

    zh = {
        MODCRASH = "%s 崩溃!",
        SUSPECTEDMODS = "可能的原因:\n",
        SUSPECTEDCONFLICTS = "可能的Mod冲突:\n",
        MODALLQUIT = "禁用所有模组",
        MODONEQUIT = "关闭模组",
        RETURNTOMENU = "返回到菜单页面",
        GAMERELOAD = "重新加载游戏",
        RECONNECT = "重新连接",
        CLIENTLOG_LOC = "客户端日志位置\n(返回到上级目录)",
        SAVEQUICKLOG = "保存精简日志\n(保存在DST的数据文件夹中)",
        SAVEDQUICKLOG = "已在DST的数据文件夹中创建精简日志",
        MODPAGE = "创意工坊页面",
        SKIP = "跳过",
        REWATCH = "重新观看BCS教程",
        SCRIPTERRORQUIT = "退出游戏",
        SCRIPTERRORMODWARNING = "此错误可能是由于您启用的模块导致的！",
        MODFORUMS = "模组论坛",
        MODQUIT = "关闭模组",
        SCRIPTERRORRESTART = "保存并重新加载",


        TITLE_MIMMODSDISABLED = "MiM模组被禁用！",
        MIMMODSDISABLED = "MiM模组被禁用，您想重新启用它吗？",

        TITLE_NORMALMODSDISABLED = "MOD被禁用！",
        NORMALMODSDISABLED = "你的MOD被禁用了，你想重新启用它们吗？",

        SAVEPERISTENTMODS_SAVE = "保存已启用的mod",
        SAVEPERISTENTMODS_CLEAR = "清除保存的mod"
    },

}