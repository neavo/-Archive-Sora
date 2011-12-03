-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["Quest"] = {}
local Module = DB["Modules"]["Quest"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["Open1"] = false,
		["Open2"] = false,
	}
	if not QuestDB then QuestDB = {} end
	for key, value in pairs(Default) do
		if QuestDB[key] == nil then QuestDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(QuestDB)
end

-- BuildGUI

function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Quest"] =  {
			type = "group", order = 16,
			name = "任务增强", 
			args = {
				Gruop_1 = {
					type = "group", order = 1, 
					name = " ", guiInline = true, 
					args = {
						Open1 = {
							type = "toggle", order = 1,
							name = "是否开启快速接任务",
							get = function() return IcicleDB.Open1 end,
							set = function(_, value) IcicleDB.Open1 = value end,
						},
					},	
				},	
				Gruop_2 = {
					type = "group", order = 2, 
					name = " ", guiInline = true, 
					args = {
						Open2 = {
							type = "toggle", order = 1,
							name = "是否开启任务物品售价显示",
							get = function() return IcicleDB.Open2 end,
							set = function(_, value) IcicleDB.Open2 = value end,
						},
					},	
				}
			},
		}			
	end
end