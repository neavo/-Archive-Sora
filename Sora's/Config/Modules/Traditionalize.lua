-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["Traditionalize"] = {}
local Module = DB["Modules"]["Traditionalize"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["Open"] = false,
	}
	if not TraditionalizeDB then TraditionalizeDB = {} end
	for key, value in pairs(Default) do
		if TraditionalizeDB[key] == nil then TraditionalizeDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(TraditionalizeDB)
end

-- BuildGUI

function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Traditionalize"] =  {
			type = "group", order = 19,
			name = "¼ò·±×ª»»", 
			args = {
				Gruop_1 = {
					type = "group", order = 1, 
					name = " ", guiInline = true, 
					args = {
						Open = {
							type = "toggle", order = 1,
							name = "ÊÇ·ñ¿ªÆô¼ò·±×ª»»",
							get = function() return TraditionalizeDB.Open end,
							set = function(_, value) TraditionalizeDB.Open = value end,
						},
					},	
				},	
			},
		}			
	end
end