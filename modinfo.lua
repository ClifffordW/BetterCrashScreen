local function en_zh(en, zh)  -- Other languages don't work
    return (locale == "zh" or locale == "zhr" or locale == "zht" or locale == "ch" or locale == "chs") and zh or en
end

--Beta, Final, or leave for no name
versiontype = ""
name = en_zh("Better Crash Screen","更好的崩溃提示")

author = "Niko"

version = "2.4.3"

config = true
-- Language = "en"

contributors = "Cliffford W. and 冰冰羊"
write_contributors = true
credits_only = false

main_icon = "bettercs"

priority = -100

api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

all_clients_require_mod = false
client_only_mod = true
server_only_mod = false

local scales = {}

for i = 1, 20 do
	scales[i] = { description = "x" .. i / 10, data = i / 10 }
end

local pos = {
	[1] = { description = en_zh("Default","默认"), data = 0 },
}

for i = 2, 15 do
	pos[i] = { description = "+" .. i .. "0", data = i * 10 }
end

local opt_Empty = { { description = "", data = 0 } }
local function Title(title, hover)
	return {
		name = title,
		hover = hover,
		options = opt_Empty,
		default = 0,
	}
end

local SEPARATOR = Title("")

modinfo_ver = "2.1"
if config == true then
	--Config
	configuration_options = {

		Title(en_zh("Mod Saving","保存模组"), "Saved Mod settings"),
		{
			name = "autoapply",
			label = en_zh("Auto Enable Mods","自动启用Mod"),
			hover = en_zh("Auto Enables Mods\n(Instead of Popup Dialog)","自动启用mod\n(而不是弹出对话框)"),
			options = {
				{ description = en_zh("Enabled","启用"), data = 1 },
				{ description = en_zh("Disabled","禁用"), data = 0 },
			},
			default = 0,
		},

		{
			name = "autoapply_mim",
			label = en_zh("Auto Enable MiM Mods","自动启用MiM模组"),
			hover = "Auto Enables Mods in Menu Mods\n(Instead of Popup Dialog)",
			options = {
				{ description = en_zh("Enabled","启用"), data = 1 },
				{ description = en_zh("Disabled","禁用"), data = 0 },
			},
			default = 0,
		},

		{
			name = "savemodspos",
			label = en_zh("Save Mods Button Position","\"保存已启用的mod\"按钮位置"),
			hover = en_zh("Changes position of Save Mods","设置\"保存已启用的mod\"的位置"),
			options = {
				{ description = en_zh("Top Left","左上角"), data = 1 },
				{ description = en_zh("Next to Apply","\"应用\"按钮的左边"), data = 0 },
			},
			default = 0,
		},

		Title(en_zh("Language","语言"), en_zh("Pick langauge","选择语言")),
		{
			name = "language",
			label = en_zh("Language","语言"),
			hover = "",
			options = {
				{ description = "English", data = "en" },
				{ description = "Portuguese", data = "pt" },
				{ description = "中文", data = "zh"}
			},
			default = en_zh("en","zh"),
		},

		Title(en_zh("Crashscreen","崩溃页面"), en_zh("General Crashscreen Settings","崩溃页面设置")),
		{
			name = "ReduxCrashScreen",
			label = en_zh("Crash Screen Style","崩溃提示样式"),
			hover = "",
			options = {
				{ description = en_zh("Classic","经典"), data = "classic", hover = en_zh("Pre-Forge Look","锻造前外观") },
				{ description = en_zh("Modern","新版"), data = "redux", hover = en_zh("Post-Forge Look (Redux)","锻造后外观（重制版）") },
			},
			default = "redux",
		},

		{
			name = "ClassicFrame",
			label = en_zh("Classic with Frame","经典样式边框"),
			hover = en_zh("Adds Frame to Classic crash screen","将边框添加到经典样式的崩溃提示页面"),
			options = {
				{ description = en_zh("Enabled","启用"), data = true },
				{ description = en_zh("Disabled","禁用"), data = false },
			},
			default = false,
		},

		{
			name = "reduxscale",
			label = en_zh("Modern Crashscreen Scale","新版崩溃提示页面比例"),
			hover = "",
			options = {
				{ description = en_zh("Default","默认"), data = 1.08 },
				{ description = "1.15", data = 1.15 },
				{ description = "1.25", data = 1.25 },
				{ description = "1.4", data = 1.4 },
			},
			default = 1.4,
		},

		{
			name = "font",
			label = en_zh("Font Override","字体覆盖"),
			hover = en_zh("This does not apply to the bottom buttons","这不适用于底部按钮"),
			options = {
				{ description = en_zh("Default","默认"), data = 0 },
				--[[             { description = "Default Crash Screen Font", data = "NEWFONT"}, -- Scrapped
            { description = "Hammerhead", data = "HEADERFONT"}, ]]
				{ description = en_zh("Talking font","聊天字体"), data = "TALKINGFONT" },
				{ description = en_zh("Wormwood's font","沃姆伍德字体"), data = "TALKINGFONT_WORMWOOD" },
				{ description = en_zh("Tradein guy font","交易小店字体"), data = "TALKINGFONT_TRADEIN" },
				{ description = en_zh("Hermit's font","寄居蟹隐士字体"), data = "TALKINGFONT_HERMIT" },
				{ description = "PT Mono", data = "PTMONO" },
			},
			default = 0,
		},

		{
			name = "nostalgia",
			label = en_zh("Nostalgia","怀旧"),
			hover = "",
			options = {
				{ description = en_zh("Enabled","启用"), data = 1 },
				{ description = en_zh("Disabled","禁用"), data = 0 },
			},
			default = 0,
		},

		Title(en_zh("Tutorial","教程")),

		{
			name = "RewatchTutorial",
			label = en_zh("Rewatch BCS Button","重新查看BCS教程按钮"),
			hover = "",
			options = {
				{ description = en_zh("Enabled","启用"), data = 1 },
				{ description = en_zh("Disabled","禁用"), data = 0 },
			},
			default = 1,
		},

		Title(en_zh("Top Buttons","顶部按钮"), en_zh("Pick what mini buttons you want","选择你想要的小按钮")),

		{
			name = "SaveLog",
			label = en_zh("Save Log Button","保存日志按钮"),
			hover = en_zh("Saves log into DST's data folder","将日志保存到DST的数据文件夹中"),
			options = {
				{ description = en_zh("Enabled","启用"), data = 1 },
				{ description = en_zh("Disabled","禁用"), data = 0 },
			},
			default = 1,
		},

		{
			name = "AutoSaveLog",
			label = en_zh("Auto-Save Quicklog","自动保存精简日志"),
			hover = en_zh(
				"Automatically Saves log into DST's data folder\n Doesnt create the Save button",
				"自动将日志保存到 DST 的数据文件夹中\n 不创建保存按钮"),
			options = {
				{ description = en_zh("Enabled","启用"), data = 1 },
				{ description = en_zh("Disabled","禁用"), data = 0 },
			},
			default = 1,
		},

		{
			name = "HideSensationalInfo",
			label = en_zh("Hide SteamID/KUID from Quicklog","隐藏精简日志中的SteamID/科雷ID"),
			hover = en_zh("Hides sensitive user info","隐藏敏感用户信息"),
			options = {
				{ description = en_zh("Enabled","启用"), data = 1 },
				{ description = en_zh("Disabled","禁用"), data = 0 },
			},
			default = 0,
		},

		{
			name = "OpenSaveFolder",
			label = en_zh("Auto Open Save folder","自动打开保存文件夹"),
			hover = en_zh("Automatically Opens the folder containing quicklog","自动打开包含精简日志的文件夹"),
			options = {
				{ description = en_zh("Enabled","启用"), data = 1 },
				{ description = en_zh("Disabled","禁用"), data = 0 },
			},
			default = 1,
		},

		{
			name = "DocumentsButton",
			label = en_zh("Clientlog Folder Button","客户端日志文件夹按钮"),
			hover = en_zh(
				"Opens your DST documents folder. \nGo back by one folder to find client log",
				"打开DST文档文件夹。 \n退回到上级目录文件夹以查找客户端日志"),
			options = {
				{ description = en_zh("Enabled","启用"), data = 1 },
				{ description = en_zh("Disabled","禁用"), data = 0 },
			},
			default = 0,
		},

		{
			name = "CombinedButtons",
			label = en_zh("Combined Buttons","组合按钮"),
			hover = en_zh("Combines both buttons \nThis hides the text!","将两个按钮组合在一起 \n这会隐藏文本！"),
			options = {
				{ description = en_zh("Enabled","启用"), data = true },
				{ description = en_zh("Disabled","禁用"), data = false },
			},
			default = true,
		},

		{
			name = "ButtonsCloserToLog",
			label = en_zh("Closer Buttons","更紧密的按钮"),
			hover = en_zh(
				"Puts the small buttons closer to the log \nOnly when combined!",
				"使小按钮更靠近日志 \n只有在启用组合按钮时！"),
			options = {
				{ description = en_zh("Enabled","启用"), data = true },
				{ description = en_zh("Disabled","禁用"), data = false },
			},
			default = true,
		},

		Title(en_zh("󰀔 Mod Version","󰀔 Mod 版本") .. ":" .. " " .. version),
		Title(en_zh("󰀩 Modinfo Version:","󰀩 Modinfo 版本:") .. " " .. modinfo_ver),
	}
end

icon_atlas = main_icon .. ".xml"
icon = main_icon .. ".tex"

versiontypes = {
	final = "[Final]",
	beta = "[Beta]",
	disc = "[Discontinued]",
	redux = "[Redux]",
}
versiontype = versiontypes[versiontype] or ""

modinfo_ver = modinfo_ver

if versiontype == "" then
	name = name
else
	name = name .. " \n" .. versiontype .. ""
end

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
	name = name .. " - GitHub Ver."
end

old_author = author
if contributors == "" or contributors == nil then
	author = author
elseif write_contributors == true then
	author = author .. " and " .. " " .. contributors
end

--Description Components 描述组件
	desc = en_zh(
		"Added Log sender.",
		"新增日志发送器。")

	changelog = en_zh(

-- English translation
[[󰀏 What's New:

󰀈 Removed Default URL webhook due to someone exploiting it.
󰀈 Webhooks are now in tables instead.


]],

-- Chinese translation
[[󰀏 更新内容:

󰀈 由于有人利用默认URL webhook，因此已将其删除。
󰀈 现在webhook在表中。
]])

	--copyright = "Copyright © 2020 "..old_author
credits = en_zh("󰀭 Credits:","󰀭 致谢") .. " " .. contributors
mark2 = en_zh("󰀩 Modinfo Version:","󰀩 Modinfo 版本:") .. " " .. modinfo_ver

if write_contributors == true or credits_only == true and contributors ~= "" then
	descfill = desc .. en_zh("\n\n󰀝 Mod Version: ","\n\n󰀝 Mod 版本: ") .. version .. "\n" .. changelog .. "\n\n" .. credits .. "\n\n" .. mark2
elseif
	write_contributors == false
	or write_contributors == nil
	or credits_only == false
	or credits_only == nil and contributors == nil
	or contributors == ""
then
	descfill = desc .. "\n\n" .. changelog .. en_zh("\n 󰀝  Version:","\n 󰀝  版本:") .. " " .. version .. "\n\n" .. mark2
end

description = descfill
description = description
