-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["Sh"] = {}
local Module = DB["Modules"]["Sh"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["Open"] = false,
	}
	if not ShDB then ShDB = {} end
	for key, value in pairs(Default) do
		if ShDB[key] == nil then ShDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(ShDB)
end

-- BuildGUI

function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Sh"] =  {
			type = "group", order = 18,
			name = "暗牧斩杀提示等等", 
			args = {
				Gruop_1 = {
					type = "group", order = 1, 
					name = " ", guiInline = true, 
					args = {
						Open = {
							type = "toggle", order = 1,
							name = "是否开启",
							get = function() return ShDB.Open end,
							set = function(_, value) ShDB.Open = value end,
						},
					},	
				},	
			},
		}			
	end
end