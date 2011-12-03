-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")

-- Init
DB["Modules"]["Ratings"] = {}
local Module = DB["Modules"]["Ratings"]

-- LoadSettings
function Module.LoadSettings()
	local Default = {
		["Open"] = false,
	}
	if not RatingsDB then RatingsDB = {} end
	for key, value in pairs(Default) do
		if RatingsDB[key] == nil then RatingsDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function Module.ResetToDefault()
	wipe(RatingsDB)
end

-- BuildGUI

function Module.BuildGUI()
	if DB["Config"] then
		DB["Config"]["Ratings"] =  {
			type = "group", order = 17,
			name = "属性转换", 
			args = {
				Gruop_1 = {
					type = "group", order = 1, 
					name = " ", guiInline = true, 
					args = {
						Open = {
							type = "toggle", order = 1,
							name = "是否开启属性转换",
							get = function() return RatingsDB.Open end,
							set = function(_, value) RatingsDB.Open = value end,
						},
					},	
				},	
			},
		}			
	end
end