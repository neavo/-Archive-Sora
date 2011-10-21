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
		["ClassBuffSize"] = 32,
		["ClassBuffSpace"] = 64,
		["ClassBuffSound"] = true,
	}
	if not ReminderDB then ReminderDB = {} end
	for key, value in pairs(Default) do
		if ReminderDB[key] == nil then ReminderDB[key] = value end
	end
end

-- ResetToDefault
function C.Reminder.ResetToDefault()
	wipe(ReminderDB)
	C.Reminder.LoadSettings()
end

-- BuildGUI
function C.Reminder.BuildGUI()
	if Modules then
		Modules["Reminder"] =  {
			type = "group",
			name = "增益缺失提醒",
			args = {
				Header_1 = {
					type = "header",
					name = "团队增益",
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
					name = "团队增益图标大小：",
					desc = "请输入团队增益图标大小",
					order = 3,
					get = function() return tostring(ReminderDB.RaidBuffSize) end,
					set = function(_, value) ReminderDB.RaidBuffSize = tonumber(value) end,
				},
				RaidBuffSpace = {
					type = "input",
					name = "团队增益图标间距：",
					desc = "请输入团队增益图标间距",
					order = 4,
					get = function() return tostring(ReminderDB.RaidBuffSpace) end,
					set = function(_, value) ReminderDB.RaidBuffSpace = tonumber(value) end,
				},
				RaidBuffDirection = {
					type = "select",
					name = "团队增益图标排列方式：",
					desc = "请选择团队增益图标排列方式",
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
					name = "职业增益",
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
					name = "职业增益图标大小：",
					desc = "请输入职业增益图标大小",
					order = 9,
					get = function() return tostring(ReminderDB.ClassBuffSize) end,
					set = function(_, value) ReminderDB.ClassBuffSize = tonumber(value) end,
				},
				ClassBuffSpace = {
					type = "input",
					name = "职业增益图标间距：",
					desc = "请输入职业增益图标间距",
					order = 10,
					get = function() return tostring(ReminderDB.ClassBuffSpace) end,
					set = function(_, value) ReminderDB.ClassBuffSpace = tonumber(value) end,
				},
			},
		}
	end
end