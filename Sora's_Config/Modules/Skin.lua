-- Engines
local _, C, _, DB = unpack(select(2, ...))

-- Init
C.Skin = {}

-- LoadSettings
function C.Skin.LoadSettings()
	local Default = {
		["EnableDBMSkin"] = true,		-- 启用DBM皮肤
	}
	if not SkinDB then SkinDB = {} end
	for key, value in pairs(Default) do
		if SkinDB[key] == nil then SkinDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function C.Skin.ResetToDefault()
	wipe(SkinDB)
	C.Skin.LoadSettings()
end

-- BuildGUI
function C.Skin.BuildGUI()
	if Modules then
		Modules["Skin"] =  {
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
end

