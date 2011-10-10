----------------
--  命名空间  --
----------------
local _, ns = ...
ns.cfg = CreateFrame("Frame")
local Media = "Interface\\AddOns\\Sora's Reminder\\Media\\"
ns.cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
ns.cfg.Solid = Media.."Solid"
ns.cfg.GlowTex = Media.."GlowTex"
ns.cfg.Warning = Media.."Warning.mp3"
ns.cfg.RaidBuffPos = {"TOPLEFT", Minimap, "BOTTOMLEFT", -5, -35}
ns.cfg.ClassBuffPos = {"CENTER", UIParent, -150, 150}


----------------------
--  公用变量和函数  --
----------------------

local Default = {
	["RaidBuffSize"] = 18,
	["RaidBuffSpace"] = 4,
	["RaidBuffDirection"] = 1,
	["ShowOnlyInParty"] = true,
	["ClassBuffSize"] = 48,
	["ClassBuffSpace"] = 40,
	["ClassBuffSound"] = true,
}

----------------
--  程序主体  --
----------------

-- LoadSettings
local function LoadSettings()
	if not RDDB then RDDB = {} end
	for key, value in pairs(Default) do
		if RDDB[key] == nil then
			RDDB[key] = value
		end
	end
end

-- ResetToDefault
local function ResetToDefault()
	RDDB = {}
	LoadSettings()
end

-- BuildGUI
local function BuildGUI()
	if Modules then
		Modules["Reminder"] =  {
			type = "group",
			name = "|cff70C0F5Sora's|r Reminder",
			args = {
				Header_1 = {
					type = "header",
					name = "RaidBuff设置",
					order = 1,
				},
				ShowOnlyInParty = {
					type = "toggle",
					name = "只在队伍中显示",
					order = 2,
					width = "full",
					get = function() return RDDB.ShowOnlyInParty end,
					set = function(_, value) RDDB.ShowOnlyInParty = value end,
				},
				RaidBuffSize = {
					type = "input",
					name = "RaidBuff图标大小：",
					desc = "请输入RaidBuff图标大小",
					order = 3,
					get = function() return tostring(RDDB.RaidBuffSize) end,
					set = function(_, value) RDDB.RaidBuffSize = tonumber(value) end,
				},
				RaidBuffSpace = {
					type = "input",
					name = "RaidBuff图标间距：",
					desc = "请输入RaidBuff图标间距",
					order = 4,
					get = function() return tostring(RDDB.RaidBuffSpace) end,
					set = function(_, value) RDDB.RaidBuffSpace = tonumber(value) end,
				},
				RaidBuffDirection = {
					type = "select",
					name = "RaidBuff图标排列方式：",
					desc = "请选择RaidBuff图标排列方式",
					order = 5,
					values = {[1] = "横排", [2] = "竖排"},
					get = function() return RDDB.RaidBuffDirection end,
					set = function(_, value) RDDB.RaidBuffDirection = value end,
				},
				SpaceLine_2 = {
					type = "description",
					name = "\n",
					order = 6,
				},
				Header_2 = {
					type = "header",
					name = "ClassBuff设置",
					order = 7,
				},
				ClassBuffSound = {
					type = "toggle",
					name = "开启声音警报",
					order = 8,
					width = "full",
					get = function() return RDDB.ClassBuffSound end,
					set = function(_, value) RDDB.ClassBuffSound = value end,
				},
				ClassBuffSize = {
					type = "input",
					name = "ClassBuff图标大小：",
					desc = "请输入ClassBuff图标大小",
					order = 9,
					get = function() return tostring(RDDB.ClassBuffSize) end,
					set = function(_, value) RDDB.ClassBuffSize = tonumber(value) end,
				},
				ClassBuffSpace = {
					type = "input",
					name = "ClassBuff图标间距：",
					desc = "请输入ClassBuff图标间距",
					order = 10,
					get = function() return tostring(RDDB.ClassBuffSpace) end,
					set = function(_, value) RDDB.ClassBuffSpace = tonumber(value) end,
				},
				SpaceLine_4 = {
					type = "description",
					name = "\n\n\n",
					order = 11,
				},
				Apply = {
					type = "execute",
					name = "重载UI",
					order = 12,
					func  = function() ReloadUI() end,
				},
				Hided = {
					type = "execute",
					name = "",
					disabled  = true,
					order = 13,
				},
				ResetToDefault = {
					type = "execute",
					name = "恢复到默认设置",
					order = 14,
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
	if event == "ADDON_LOADED" and addon == "Sora's Reminder" then
		LoadSettings(RDDB)
		BuildGUI()
	end
end)

