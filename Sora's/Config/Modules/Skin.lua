-- Engines
local S, C, L, DB = unpack(select(2, ...))

DB.OptModules.Skin = {}

-- LoadSettings
function DB.OptModules.Skin.LoadSettings()
	local Default = {
		["EnableDBMSkin"] = true,		-- 启用DBM皮肤
	}
	if not SkinDB then SkinDB = {} end
	for key, value in pairs(Default) do
		if SkinDB[key] == nil then SkinDB[key] = value end
	end
end

-- ResetToDefault
function DB.OptModules.Skin.ResetToDefault()
	wipe(SkinDB)
	C.Skin.LoadSettings()
end

-- BuildGUI
function DB.OptModules.Skin.BuildGUI()
	DB.OptTable["Skin"] =  {
		type = "group",
		name = "皮肤",
		args = {
			EnableDBMSkin = {
				type = "toggle",
				name = "启用DBM皮肤",
				order = 2,
				get = function() return SkinDB.EnableDBMSkin end,
				set = function(_, value) SkinDB.EnableDBMSkin = value end,
			},
		},
	}
end

