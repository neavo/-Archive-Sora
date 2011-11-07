-- Engines
local S, C, _, _ = unpack(select(2, ...))

-- Init
C.Reminder = {}

-- LoadSettings
function C.Reminder.LoadSettings()
	local Default = {
		["ShowRaidBuff"] = true,
		["ShowOnlyInParty"] = true,
		["RaidBuffSize"] = 18,
		["RaidBuffDirection"] = 1,
		["ShowClassBuff"] = true,
		["ClassBuffSize"] = 32,
		["ClassBuffSpace"] = 64,
		["ClassBuffSound"] = true,
	}
	if not ReminderDB then ReminderDB = {} end
	for key, value in pairs(Default) do
		if ReminderDB[key] == nil then ReminderDB[key] = value end
	end
	wipe(Default)
end

-- ResetToDefault
function C.Reminder.ResetToDefault()
	wipe(ReminderDB)
end

-- BuildGUI
function C.Reminder.BuildGUI()
	if Modules then
		Modules["Reminder"] =  {
			type = "group", order = 7,
			name = "缺失提醒",
			args = {
				ShowRaidBuff = {
					type = "toggle", order = 1,
					name = "显示团队增益缺失提醒",
					get = function() return ReminderDB.ShowRaidBuff end,
					set = function(_, value) ReminderDB.ShowRaidBuff = value end,
				},
				Gruop_1 = {
					type = "group", order = 2,
					name = " ", guiInline = true,
					args = {
						ShowOnlyInParty = {
							type = "toggle", order = 1,
							name = "只在队伍中显示",
							get = function() return ReminderDB.ShowOnlyInParty end,
							set = function(_, value) ReminderDB.ShowOnlyInParty = value end,
						},
						RaidBuffSize = {
							type = "input", order = 2,
							name = "团队增益图标大小：", desc = "请输入团队增益图标大小",
							get = function() return tostring(ReminderDB.RaidBuffSize) end,
							set = function(_, value) ReminderDB.RaidBuffSize = tonumber(value) end,
						},
						RaidBuffDirection = {
							type = "select", order = 5,
							name = "团队增益图标排列方式：", desc = "请选择团队增益图标排列方式",
							values = {[1] = "横排", [2] = "竖排"},
							get = function() return ReminderDB.RaidBuffDirection end,
							set = function(_, value) ReminderDB.RaidBuffDirection = value end,
						},
					},
				},
				ShowClassBuff = {
					type = "toggle", order = 3,
					name = "显示职业增益缺失提醒",
					get = function() return ReminderDB.ShowClassBuff end,
					set = function(_, value) ReminderDB.ShowClassBuff = value end,
				},
				Gruop_2 = {
					type = "group", order = 4,
					name = " ", guiInline = true,
					args = {
						ClassBuffSound = {
							type = "toggle", order = 1,
							name = "开启声音警报",
							get = function() return ReminderDB.ClassBuffSound end,
							set = function(_, value) ReminderDB.ClassBuffSound = value end,
						},
						ClassBuffSize = {
							type = "input", order = 2,
							name = "职业增益图标大小：", desc = "请输入职业增益图标大小",
							get = function() return tostring(ReminderDB.ClassBuffSize) end,
							set = function(_, value) ReminderDB.ClassBuffSize = tonumber(value) end,
						},
						ClassBuffSpace = {
							type = "input", order = 3,
							name = "职业增益图标间距：", desc = "请输入职业增益图标间距",
							get = function() return tostring(ReminderDB.ClassBuffSpace) end,
							set = function(_, value) ReminderDB.ClassBuffSpace = tonumber(value) end,
						},
					},
				},
			},
		}
	end
end