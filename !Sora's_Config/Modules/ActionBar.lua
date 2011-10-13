-- Engines
local S, C, _, DB = unpack(select(2, ...))
local SoraConfig = LibStub("AceAddon-3.0"):GetAddon("SoraConfig")

-- BuildClass
C.ActionBar = CreateFrame("Frame")

-- LoadSettings
function C.ActionBar.LoadSettings()
	local Default = {
		["HideHotKey"] = false,
		["HideMacroName"] = true,
		["ShowExtraBar"] = true,
		["CountFontSize"] = 10,
		["HotkeyFontSize"] = 10,
		["NameFontSize"] = 10,
	}
	if not ActionBarDB then ActionBarDB = {} end
	for key, value in pairs(Default) do
		if ActionBarDB[key] == nil then
			ActionBarDB[key] = value
		end
	end
end

-- ResetToDefault
function C.ActionBar.ResetToDefault()
	ActionBarDB = {}
	LoadSettings()
end

-- BuildGUI
function C.ActionBar.BuildGUI()
	if Modules then
		Modules["ActionBar"] =  {
			type = "group",
			name = "|cff70C0F5动作条|r ",
			args = {
				HideHotKey = {
					type = "toggle",
					name = "隐藏快捷键显示",
					order = 1,
					get = function() return ActionBarDB.HideHotKey end,
					set = function(_, value) ActionBarDB.HideHotKey = value end,
				},
				HideMacroName = {
					type = "toggle",
					name = "隐藏宏名称显示",
					order = 2,
					get = function() return ActionBarDB.HideMacroName end,
					set = function(_, value) ActionBarDB.HideMacroName = value end,
				},
				ShowExtraBar = {
					type = "toggle",
					name = "显示侧边栏",
					order = 3,
					get = function() return ActionBarDB.ShowExtraBar end,
					set = function(_, value) ActionBarDB.ShowExtraBar = value end,
				},
				CountFontSize = {
					type = "input",
					name = "计数字体大小",
					order = 4,
					get = function() return tostring(ActionBarDB.CountFontSize) end,
					set = function(_, value) ActionBarDB.CountFontSize = tonumber(value) end,
				},
				HotkeyFontSize = {
					type = "input",
					name = "快捷键字体大小",
					order = 5,
					get = function() return tostring(ActionBarDB.HotkeyFontSize) end,
					set = function(_, value) ActionBarDB.HotkeyFontSize = tonumber(value) end,
				},
				NameFontSize = {
					type = "input",
					name = "宏名称字体大小",
					order = 6,
					get = function() return tostring(ActionBarDB.NameFontSize) end,
					set = function(_, value) ActionBarDB.NameFontSize = tonumber(value) end,
				},
			},
		}
	end
end


