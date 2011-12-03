-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["Icicle"] = {}
local Module = DB["Modules"]["Icicle"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["Open"] = false,
	}
	if not IcicleDB then IcicleDB = {} end
	for key, value in pairs(Default) do
		if IcicleDB[key] == nil then IcicleDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(IcicleDB)
end

-- BuildGUI

function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Icicle"] =  {
			type = "group", order = 15,
			name = "PVP技能计时", 
			args = {
				Gruop_1 = {
					type = "group", order = 1, 
					name = " ", guiInline = true, 
					args = {
						Open = {
							type = "toggle", order = 1,
							name = "是否开启敌对技能监视",
							get = function() return IcicleDB.Open end,
							set = function(_, value) IcicleDB.Open = value end,
						},
					},	
				},	
			},
		}			
	end
end