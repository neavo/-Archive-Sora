----------------
--  命名空间  --
----------------

local _, ns = ...
local Media = "Interface\\AddOns\\Sora's ActionBar\\Media\\"
ns.cfg = CreateFrame("Frame")
ns.cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
ns.cfg.bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"
ns.cfg.Texture = Media.."icon"
ns.cfg.GlowTex = Media.."glowTex"
ns.cfg.Solid = Media.."solid"
ns.cfg.colors = {
	normal		= {r =   0, g =   0, b =    0},
	pushed 		= {r =   1, g =   1, b =    1},
	highlight 	= {r = 0.9, g = 0.8, b =  0.6},
	checked 	= {r = 0.9, g = 0.8, b =  0.6},
	outofrange 	= {r = 0.8, g = 0.3, b =  0.2},
	outofmana 	= {r = 0.3, g = 0.3, b =  0.7},
	usable 		= {r =   1, g =   1, b =    1},
	unusable 	= {r = 0.4, g = 0.4, b =  0.4},
}

----------------------
--  公用变量和函数  --
----------------------

local Default = {
	["HideHotKey"] = false,
	["HideMacroName"] = true,
	["ShowExtraBar"] = true,
	["CountFontSize"] = 10,
	["HotkeyFontSize"] = 10,
	["NameFontSize"] = 10,
}

----------------
--  程序主体  --
----------------

-- LoadSettings
local function LoadSettings()
	if not ActionBarDB then ActionBarDB = {} end
	for key, value in pairs(Default) do
		if ActionBarDB[key] == nil then
			ActionBarDB[key] = value
		end
	end
end

-- ResetToDefault
local function ResetToDefault()
	ActionBarDB = {}
	LoadSettings()
end

-- BuildGUI
local function BuildGUI()
	if Modules then
		Modules["ActionBar"] =  {
			type = "group",
			name = "|cff70C0F5Sora's|r ActionBar",
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
				SpaceLine_1 = {
					type = "description",
					name = "\n\n\n",
					order = 7,
				},
				Apply = {
					type = "execute",
					name = "重载UI",
					order = 8,
					func  = function() ReloadUI() end,
				},
				Hided = {
					type = "execute",
					name = "",
					disabled  = true,
					order = 9,
				},
				ResetToDefault = {
					type = "execute",
					name = "恢复到默认设置",
					order = 10,
					func  = function() ResetToDefault() ReloadUI() end,
				},
			},
		}
	end
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("ADDON_LOADED")
Event:SetScript("OnEvent", function(slef, event, addon, ...)
	if event == "ADDON_LOADED" and addon == "Sora's ActionBar" then
		LoadSettings(ActionBarDB)
		BuildGUI()
	end
end)


