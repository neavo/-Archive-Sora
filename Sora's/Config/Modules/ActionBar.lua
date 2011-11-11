-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["ActionBar"] = {}
local Module = DB["Modules"]["ActionBar"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["HideHotKey"] = false,
		["HideMacroName"] = true,
		["MainBarLayout"] = 1,
		["ExtraBarLayout"] = 1,
		["ButtonSize"] = 26,
		["FontSize"] = 10,
	}
	if not ActionBarDB then ActionBarDB = {} end
	for key, value in pairs(Default) do
		if ActionBarDB[key] == nil then ActionBarDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(ActionBarDB)
end

-- BuildGUI
function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["ActionBar"] =  {
			type = "group", order = 1,
			name = "动作条",
			args = {
				MainBarLayout = {
					type = "select", order = 1,
					name = "主动作条布局：", desc = "请选择主动作条布局",
					values = {[1] = "18x2布局", [2] = "12x3布局"},
					get = function() return ActionBarDB.MainBarLayout end,
					set = function(_, value) ActionBarDB.MainBarLayout = value end,
				},
				ExtraBarLayout = {
					type = "select", order = 2,
					name = "侧边栏布局：", desc = "请选择侧边栏布局",
					values = {[1] = "1x12纵向布局", [2] = "6x2横向布局"},
					get = function() return ActionBarDB.ExtraBarLayout end,
					set = function(_, value) ActionBarDB.ExtraBarLayout = value end,
				},
				NewLine = {
					type = "description", order = 3,
					name = "\n",					
				},
				HideHotKey = {
					type = "toggle", order = 4,
					name = "隐藏快捷键显示",			
					get = function() return ActionBarDB.HideHotKey end,
					set = function(_, value) ActionBarDB.HideHotKey = value end,
				},
				HideMacroName = {
					type = "toggle", order = 5,
					name = "隐藏宏名称显示",		
					get = function() return ActionBarDB.HideMacroName end,
					set = function(_, value) ActionBarDB.HideMacroName = value end,
				},
				ButtonSize = {
					type = "range", order = 6,
					name = "动作条按钮大小：", desc = "输入主动作条按钮大小",
					min = 16, max = 64, step = 1,
					get = function() return ActionBarDB.ButtonSize end,
					set = function(_, value) ActionBarDB.ButtonSize = value end,
				},
				FontSize = {
					type = "range", order = 7,
					name = "动作条字体大小：", desc = "输入主动作条动作条字体大小",
					min = 1, max = 36, step = 1,
					get = function() return ActionBarDB.FontSize end,
					set = function(_, value) ActionBarDB.FontSize = value end,
				},
			},
		}
	end
end


