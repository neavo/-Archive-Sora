-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["Molinari"] = {}
local Module = DB["Modules"]["Molinari"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["Open"] = false,
	}
	if not MolinariDB then MolinariDB = {} end
	for key, value in pairs(Default) do
		if MolinariDB[key] == nil then MolinariDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(MolinariDB)
end

-- BuildGUI

function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Molinari"] =  {
			type = "group", order = 19,
			name = "简繁转换", 
			args = {
				Gruop_1 = {
					type = "group", order = 1, 
					name = " ", guiInline = true, 
					args = {
						Open = {
							type = "toggle", order = 1,
							name = "是否开启一件分解",
							get = function() return MolinariDB.Open end,
							set = function(_, value) MolinariDB.Open = value end,
						},
					},	
				},	
			},
		}			
	end
end