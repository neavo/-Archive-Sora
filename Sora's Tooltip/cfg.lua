----------------
--  命名空间  --
----------------
local _, ns = ...
local Media = "Interface\\AddOns\\Sora's Tooltip\\Media\\"
ns.cfg = CreateFrame("Frame")
ns.cfg.Font = GetLocale() == "zhCN" and "Fonts\\ZYKai_T.ttf" or "Fonts\\bLEI00D.ttf"
ns.cfg.Solid = Media.."Solid"
ns.cfg.Statusbar = Media.."Statusbar"
ns.cfg.Position = {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -50, 201}		-- 如果不跟随鼠标,那提示框体的位置


----------------------
--  公用变量和函数  --
----------------------

local Default = {
	["Cursor"] = true,
	["HideInCombat"] = true,
}

----------------
--  程序主体  --
----------------

-- LoadSettings
local function LoadSettings()
	if not TooltipDB then TooltipDB = {} end
	for key, value in pairs(Default) do
		if TooltipDB[key] == nil then
			TooltipDB[key] = value
		end
	end
end

-- ResetToDefault
local function ResetToDefault()
	TooltipDB = {}
	LoadSettings()
end

-- BuildGUI
local function BuildGUI()
	if Modules then
		Modules["Tooltip"] =  {
			type = "group",
			name = "|cff70C0F5Sora's|r Tooltip",
			args = {
				Cursor = {
					type = "toggle",
					name = "提示框体跟随鼠标",
					order = 1,
					get = function() return TooltipDB.Cursor end,
					set = function(_, value) TooltipDB.Cursor = value end,
				},
				HideInCombat = {
					type = "toggle",
					name = "进入战斗自动隐藏",
					order = 2,
					get = function() return TooltipDB.HideInCombat end,
					set = function(_, value) TooltipDB.HideInCombat = value end,
				},
				SpaceLine_1 = {
					type = "description",
					name = "\n\n\n",
					order = 3,
				},
				Apply = {
					type = "execute",
					name = "重载UI",
					order = 4,
					func  = function() ReloadUI() end,
				},
				Hided = {
					type = "execute",
					name = "",
					disabled  = true,
					order = 5,
				},
				ResetToDefault = {
					type = "execute",
					name = "恢复到默认设置",
					order = 6,
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
	if event == "ADDON_LOADED" and addon == "Sora's Tooltip" then
		LoadSettings(TooltipDB)
		BuildGUI()
	end
end)


