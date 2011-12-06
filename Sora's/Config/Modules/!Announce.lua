-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["Announce"] = {}
local Module = DB["Modules"]["Announce"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["Open"] = true,
		["All"] = false,
		["List"] = {
			344775,	-- 误导
			198015,	-- 寧神射擊
			579345,	-- 偷天換日
			204845,	-- 復生
			6335,	-- 聖療術
			100605,  --能量灌注
			332065,   -- 痛苦镇压
			477885,   -- 守護聖靈
			10225, --保護聖禦
			546465, --魔法凝聚
			17,
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
function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Announce"] =  {
			type = "group", order = 13,
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
							type = "toggle", order = 1,
							name = "是否开启全团人员施法通告", desc = "否为仅通告自己释放的法术",
							get = function() return AnnounceDB.All end,
							set = function(_, value) AnnounceDB.All = value end,
						},
						
					},
				}, 
			},
		}
	end
end


