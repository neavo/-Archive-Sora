----------------
--  命名空间  --
----------------
local _, ns = ...
ns.cfg = CreateFrame("Frame")
local Media = "Interface\\AddOns\\Sora's Threat\\Media\\"
ns.cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
ns.cfg.Statusbar = Media.."statusbar"
ns.cfg.GlowTex = Media.."glowTex"
ns.cfg.Solid = Media.."solid"
ns.cfg.ArrowT = Media.."ArrowT"
ns.cfg.Arrow = Media.."Arrow"

----------------------
--  公用变量和函数  --
----------------------

local Default = {
	["Pos"] = {"TOP", "oUF_SoraPlayer", "BOTTOM", 0, -60},	-- 仇恨条位置(已修正, 可以锚在任意框体上, 包括oUF头像)
	["ThreatBarWidth"] = 230,								-- 仇恨条宽度
	["NameTextL"] = 3,										-- 姓名长度(单位:字)
	["ThreatLimited"] = 2,									-- 显示仇恨人数(不包括Tank)
}

----------------
--  程序主体  --
----------------

-- LoadSettings
local function LoadSettings()
	if not ThreatDB then ThreatDB = {} end
	for key, value in pairs(Default) do
		if ThreatDB[key] == nil then
			ThreatDB[key] = value
		end
	end
end

-- ResetToDefault
local function ResetToDefault()
	ThreatDB = {}
	LoadSettings()
end

-- BuildGUI
local function BuildGUI()
	if Modules then
		Modules["Threat"] =  {
			type = "group",
			name = "|cff70C0F5Sora's|r Threat",
			args = {
				ThreatBarWidth = {
					type = "input",
					name = "仇恨条宽度：",
					desc = "请输入仇恨条宽度",
					order = 1,
					get = function() return tostring(ThreatDB.ThreatBarWidth) end,
					set = function(_, value) ThreatDB.ThreatBarWidth = tonumber(value) end,
				},
				NameTextL = {
					type = "input",
					name = "仇恨条姓名长度：",
					desc = "请输入仇恨条姓名长度",
					order = 2,
					get = function() return tostring(ThreatDB.NameTextL) end,
					set = function(_, value) ThreatDB.NameTextL = tonumber(value) end,
				},
				ThreatLimited = {
					type = "input",
					name = "显示仇恨人数(不包括Tank)：",
					desc = "请输入显示仇恨人数(不包括Tank)",
					order = 3,
					get = function() return tostring(ThreatDB.ThreatLimited) end,
					set = function(_, value) ThreatDB.ThreatLimited = tonumber(value) end,
				},
				SpaceLine_1 = {
					type = "description",
					name = "\n\n\n",
					order = 4,
				},
				Apply = {
					type = "execute",
					name = "重载UI",
					order = 5,
					func  = function() ReloadUI() end,
				},
				Hided = {
					type = "execute",
					name = "",
					disabled  = true,
					order = 6,
				},
				ResetToDefault = {
					type = "execute",
					name = "恢复到默认设置",
					order = 7,
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
	if event == "ADDON_LOADED" and addon == "Sora's Threat" then
		LoadSettings(ThreatDB)
		BuildGUI()
	end
end)


