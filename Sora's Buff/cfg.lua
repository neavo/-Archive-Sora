----------------
--  命名空间  --
----------------
local _, ns = ...
ns.cfg = CreateFrame("Frame")
local Media = "Interface\\Addons\\Sora's Buff\\Media\\"
ns.cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
ns.cfg.GlowTex = Media.."GlowTex"
ns.cfg.BUFFPos = {"TOPRIGHT", nil, "TOPRIGHT", -5, -5}
ns.cfg.DEUFFPos = {"TOPRIGHT", nil, "TOPRIGHT", -5, -140}

----------------------
--  公用变量和函数  --
----------------------

local Default = {
	["IconSize"] = 24,
	["Spacing"] = 8,
	["BuffDirection"] = 1,
	["DebuffDirection"] = 1,
	["WarningTime"] = 15,
}

----------------
--  程序主体  --
----------------

-- LoadSettings
local function LoadSettings()
	if not BuffDB then BuffDB = {} end
	for key, value in pairs(Default) do
		if BuffDB[key] == nil then
			BuffDB[key] = value
		end
	end
end

-- ResetToDefault
local function ResetToDefault()
	BuffDB = {}
	LoadSettings()
end

-- BuildGUI
local function BuildGUI()
	if Modules then
		Modules["Buff"] =  {
			type = "group",
			name = "|cff70C0F5Sora's|r Buff",
			args = {
				IconSize = {
					type = "input",
					name = "图标大小：",
					desc = "请输入图标大小",
					order = 1,
					get = function() return tostring(BuffDB.IconSize) end,
					set = function(_, value) BuffDB.IconSize = tonumber(value) end,
				},
				Spacing = {
					type = "input",
					name = "图标间距：",
					desc = "请输入图标间距大小",
					order = 2,
					get = function() return tostring(BuffDB.Spacing) end,
					set = function(_, value) BuffDB.Spacing = tonumber(value) end,
				},
				WarningTime = {
					type = "input",
					name = "闪耀提示的时间(秒)：",
					desc = "请输入图标间距大小",
					order = 3,
					get = function() return tostring(BuffDB.WarningTime) end,
					set = function(_, value) BuffDB.WarningTime = tonumber(value) end,
				},
				BuffDirection = {
					type = "select",
					name = "BUFF增长方向：",
					desc = "请选择BUFF增长方向",
					order = 4,
					values = {[1] = "从右向左", [2] = "从左向右"},
					get = function() return BuffDB.BuffDirection end,
					set = function(_, value) BuffDB.BuffDirection = value end,
				},
				DebuffDirection = {
					type = "select",
					name = "DEBUFF增长方向：",
					desc = "请选择DEBUFF增长方向",
					order = 4,
					values = {[1] = "从右向左", [2] = "从左向右"},
					get = function() return BuffDB.DebuffDirection end,
					set = function(_, value) BuffDB.DebuffDirection = value end,
				},
				SpaceLine_1 = {
					type = "description",
					name = "\n\n\n",
					order = 5,
				},
				Apply = {
					type = "execute",
					name = "重载UI",
					order = 6,
					func  = function() ReloadUI() end,
				},
				Hided = {
					type = "execute",
					name = "",
					disabled  = true,
					order = 7,
				},
				ResetToDefault = {
					type = "execute",
					name = "恢复到默认设置",
					order = 8,
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
	if event == "ADDON_LOADED" and addon == "Sora's Buff" then
		LoadSettings(BuffDB)
		BuildGUI()
	end
end)




