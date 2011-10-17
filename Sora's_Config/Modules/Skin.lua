-- Engines
local _, C, _, DB = unpack(select(2, ...))

-- BuildClass
C.Skin = CreateFrame("Frame")

-- LoadSettings
function C.Skin.LoadSettings()
	local Default = {
		["EnableAurora"] = true,		-- 启用Aurora全局美化
	}
	if not SkinDB then SkinDB = {} end
	for key, value in pairs(Default) do
		if SkinDB[key] == nil then
			SkinDB[key] = value
		end
	end
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
				EnableAurora = {
					type = "toggle",
					name = "启用Aurora全局美化：",
					order = 1,
					get = function() return SkinDB.EnableAurora end,
					set = function(_, value) SkinDB.EnableAurora = value end,
				},
			},
		}
	end
end

