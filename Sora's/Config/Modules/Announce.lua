-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["Announce"] = {}
local Module = DB["Modules"]["Announce"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["Open"] = false,
		["All"] = false,
		["SpellList"] = {
		34477,	-- 误导
		19801,	-- 寧神射擊
		57934,	-- 偷天換日
		20484,	-- 復生
		633,	-- 聖療術
		10060,  --能量灌注
		33206,   -- 痛苦镇压
		47788,   -- 守護聖靈
		1022, --保護聖禦
		},
	}
	if not AnnounceDB then AnnounceDB = {} end
	for key, value in pairs(Default) do
		if AnnounceDB[key] == nil then AnnounceDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(AnnounceDB)
end

-- BuildGUI
local AnnounceListTable = {}

local function UpdateAnnounceListTable()
	wipe(AnnounceListTable)
	AnnounceListTable["SpellListNew"] = {
		type = "input", order = 1,
		name = "添加新条目", width = "full",
		get = function() return "无" end,
		set = function(_, value)
			local Name = GetSpellInfo(tonumber(value))
			ClassTimerDB["SpellList"][Name] = true
			UpdateAnnounceListTable()
		end,
	}
	local Order = 1
	for key, value in pairs(AnnounceDB["SpellList"]) do
		if value then
			Order = Order + 1
			BlackListTable[key] = {
				type = "toggle", order = Order,
				name = key, desc = "启用/禁用",
				get = function() return value end,
				set = function(_, val)
					AnnounceDB["SpellList"][key] = val
					UpdateAnnounceListTable()
				end,
			}
		end
	end
end

function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Announce"] =  {
			type = "group", order = 14,
			name = "施法通告", 
			args = {
				Gruop_1 = {
					type = "group", order = 1, 
					name = " ", guiInline = true, 
					args = {
						Open = {
							type = "toggle", order = 1,
							name = "是否开启施法通告",
							get = function() return AnnounceDB.Open end,
							set = function(_, value) AnnounceDB.Open = value end,
						},
						All = {
							type = "toggle", order = 2,
							name = "是否通告全团的法术释放",
							get = function() return AnnounceDB.All end,
							set = function(_, value) AnnounceDB.All = value end,
						},
					},
				},	
				Gruop_2 = {	
					type = "group", order = 2, 
						name = " ", guiInline = true, 
						args = {
							List = {
							type = "group", order = 1, 
							name = "通报法术列表", guiInline = true, 
							args = AnnounceListTable,
						}, 
					},
				},
			},	
		}
	end
end