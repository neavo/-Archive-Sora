-- Engines
local S, C, _, _ = unpack(select(2, ...))

-- BuildClass
C.Reminder = CreateFrame("Frame")

-- LoadSettings
function C.Reminder.LoadSettings()
	local Default = {
		["RaidBuffSize"] = 18,
		["RaidBuffSpace"] = 4,
		["RaidBuffDirection"] = 1,
		["ShowOnlyInParty"] = true,
		["ClassBuffSize"] = 48,
		["ClassBuffSpace"] = 40,
		["ClassBuffSound"] = true,
	}
	if not ReminderDB then ReminderDB = {} end
	for key, value in pairs(Default) do
		if ReminderDB[key] == nil then
			ReminderDB[key] = value
		end
	end
end

-- ResetToDefault
function C.Reminder.ResetToDefault()
	wipe(ReminderDB)
	LoadSettings()
end

-- BuildGUI
function C.Reminder.BuildGUI()
	if Modules then
		Modules["Reminder"] =  {
			type = "group",
			name = "|cff70C0F5Reminder|r ",
			args = {
				Header_1 = {
					type = "header",
					name = "RaidBuff设置",
					order = 1,
				},
				ShowOnlyInParty = {
					type = "toggle",
					name = "只在队伍中显示",
					order = 2,
					width = "full",
					get = function() return ReminderDB.ShowOnlyInParty end,
					set = function(_, value) ReminderDB.ShowOnlyInParty = value end,
				},
				RaidBuffSize = {
					type = "input",
					name = "RaidBuff图标大小：",
					desc = "请输入RaidBuff图标大小",
					order = 3,
					get = function() return tostring(ReminderDB.RaidBuffSize) end,
					set = function(_, value) ReminderDB.RaidBuffSize = tonumber(value) end,
				},
				RaidBuffSpace = {
					type = "input",
					name = "RaidBuff图标间距：",
					desc = "请输入RaidBuff图标间距",
					order = 4,
					get = function() return tostring(ReminderDB.RaidBuffSpace) end,
					set = function(_, value) ReminderDB.RaidBuffSpace = tonumber(value) end,
				},
				RaidBuffDirection = {
					type = "select",
					name = "RaidBuff图标排列方式：",
					desc = "请选择RaidBuff图标排列方式",
					order = 5,
					values = {[1] = "横排", [2] = "竖排"},
					get = function() return ReminderDB.RaidBuffDirection end,
					set = function(_, value) ReminderDB.RaidBuffDirection = value end,
				},
				SpaceLine_2 = {
					type = "description",
					name = "\n",
					order = 6,
				},
				Header_2 = {
					type = "header",
					name = "ClassBuff设置",
					order = 7,
				},
				ClassBuffSound = {
					type = "toggle",
					name = "开启声音警报",
					order = 8,
					width = "full",
					get = function() return ReminderDB.ClassBuffSound end,
					set = function(_, value) ReminderDB.ClassBuffSound = value end,
				},
				ClassBuffSize = {
					type = "input",
					name = "ClassBuff图标大小：",
					desc = "请输入ClassBuff图标大小",
					order = 9,
					get = function() return tostring(ReminderDB.ClassBuffSize) end,
					set = function(_, value) ReminderDB.ClassBuffSize = tonumber(value) end,
				},
				ClassBuffSpace = {
					type = "input",
					name = "ClassBuff图标间距：",
					desc = "请输入ClassBuff图标间距",
					order = 10,
					get = function() return tostring(ReminderDB.ClassBuffSpace) end,
					set = function(_, value) ReminderDB.ClassBuffSpace = tonumber(value) end,
				},
			},
		}
	end
end