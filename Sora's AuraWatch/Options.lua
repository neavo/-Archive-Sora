----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.AuraWatchConfig
local AuraList, Aura, NewAura, GruopValueTable = {}, {}, {}, {}
local opt = CreateFrame("Frame")

local function BuildOptTable()

	local GroupTable = {
		type = "group",
		name = "分组属性设置",
		args = {
			GroupSelect = {
				type = "select",
				name = "选择分组:",
				desc = "请选择你想要修改的分组",
				order = 1,
				width = "full",
				values = function()
					opt.GroupTable = {}
					for key, value in pairs(AuraList) do
						if value.Name then
							table.insert(opt.GroupTable, value.Name)
						end
					end
					return opt.GroupTable
				end,
				get = function() return opt.GroupSelectValue or 1 end,
				set = function(_, v)
					wipe(GruopValueTable)
					opt.GroupSelectValue = v
				end,
			},
			
			SpaceLine_1 = {
				type = "description",
				name = "\n",
				order = 2,
			},
			GroupName = {
				type = "input",
				name = "分组名称:",
				desc = "请输入分组名称",
				order = 3,
				get = function()
					if not GruopValueTable.Name then
						GruopValueTable.Name = AuraList[opt.GroupSelectValue].Name
					end
					return tostring(GruopValueTable.Name)
				end,
				set = function(_, v)
					GruopValueTable.Name = v
				end,
			},
			GroupMode = {
				type = "select",
				name = "提示模式:",
				desc = "请选择分组的提示模式",
				order = 4,
				values = {["BAR"] = "计时条模式", ["ICON"] = "图标模式"},
				get = function()
					if not GruopValueTable.Mode then
						GruopValueTable.Mode = AuraList[opt.GroupSelectValue].Mode
					end
					return GruopValueTable.Mode
				end,
				set = function(_, v)
					GruopValueTable.Mode = v
				end,
			},
			GroupDirection = {
				type = "select",
				name = "增长方向:",
				desc = "请选择分组的增长方向",
				order = 5,
				values = { ["RIGHT"] = "向右增长", ["LEFT"] = "向左增长", ["UP"] = "向上增长", ["DOWN"] = "向下增长",},
				get = function()
					if not GruopValueTable.Direction then
						GruopValueTable.Direction = AuraList[opt.GroupSelectValue].Direction
					end
					return GruopValueTable.Direction
				end,
				set = function(_, v)
					GruopValueTable.Direction = v
				end,
			},
			GroupInterval = {
				type = "range",
				name = "间距:",
				desc = "请输入分组各提示间的距离",
				order = 6,
				min = 0,
				max = 20,
				step = 1,
				get = function()
					if not GruopValueTable.Interval then
						GruopValueTable.Interval = AuraList[opt.GroupSelectValue].Interval
					end
					return GruopValueTable.Interval
				end,
				set = function(_, v)
					GruopValueTable.Interval = v
				end,
			},
			GroupiconSize = {
				type = "range",
				name = "提示图标的大小:",
				desc = "请输入分组各提示图标的大小",
				order = 7,
				min = 1,
				max = 200,
				step = 1,
				get = function()
					if not GruopValueTable.iconSize then
						GruopValueTable.iconSize = AuraList[opt.GroupSelectValue].iconSize
					end
					return GruopValueTable.iconSize
				end,
				set = function(_, v)
					GruopValueTable.iconSize = v
				end,
			},
			GroupbarWidth = {
				type = "range",
				name = "提示计时条的宽度:",
				desc = "请输入分组各计时条的宽度",
				order = 8,
				min = 1,
				max = 200,
				step = 1,
				disabled = function()
					return GruopValueTable.Mode == "ICON"
				end,
				get = function()
					if not GruopValueTable.barWidth then
						GruopValueTable.barWidth = AuraList[opt.GroupSelectValue].barWidth and AuraList[opt.GroupSelectValue].barWidth or 20
					end
					return GruopValueTable.barWidth
				end,
				set = function(_, v)
					GruopValueTable.barWidth = v
				end,
			},
			SpaceLine_2 = {
				type = "description",
				name = "\n\n\n",
				order = 9,
			},
			SaveButton = {
				type = "execute",
				name = "保存修改",
				width = "full",
				order = 10,
				func  = function()
					local value = AuraList[opt.GroupSelectValue]
					value.Name = GruopValueTable.Name
					value.Direction = GruopValueTable.Direction
					value.Interval = GruopValueTable.Interval
					value.Mode = GruopValueTable.Mode
					value.iconSize = GruopValueTable.iconSize
					value.barWidth = (GruopValueTable.Mode == "BAR") and GruopValueTable.barWidth or nil
				end,
			},
			DeleteButton = {
				type = "execute",
				name = "删除分组",
				width = "full",
				order = 11,
				func  = function()
					tremove(AuraList,opt.GroupSelectValue)
					opt.GroupSelectValue = 1
				end,
			},
			NewGruopButton = {
				type = "execute",
				name = "添加新的分组",
				width = "full",
				order = 12,
				func  = function()
					table.insert(AuraList, {
						name = GruopValueTable.Name,
						Direction = GruopValueTable.Direction,
						Interval = GruopValueTable.Interval,
						Mode = GruopValueTable.Mode,
						iconSize = GruopValueTable.iconSize,
						barWidth = GruopValueTable.barWidth,
						Pos = {"CENTER"},
						List = {spellID =   118, unitId = "player", Filter = "DEBUFF"},
					})
				end,
			},
		},
	}

	local AuraTable = {
		type = "group",
		name = "Aura属性设置",
		args = {
			GroupSelect = {
				type = "select",
				name = "选择分组:",
				desc = "请选择你想要修改的分组",
				order = 1,
				width = "full",
				values = function()
					opt.GroupTable = {}
					for key, value in pairs(AuraList) do
						if value.Name then
							table.insert(opt.GroupTable, value.Name)
						end
					end
					return opt.GroupTable
				end,
				get = function() return opt.GroupSelectValue or 1 end,
				set = function(_, v)
					opt.GroupSelectValue = v
				end,
			},
			AuraSelect = {
				type = "select",
				name = "选择Aura:",
				desc = "请选择你想要修改的Aura",
				order = 2,
				width = "full",
				values = function()
					opt.AuraSelectTable = {}
					opt.GroupSelectValue = AuraList[opt.GroupSelectValue] and opt.GroupSelectValue or 1
					local VALUE = AuraList[opt.GroupSelectValue]
					for key, value in pairs (VALUE.List) do
						if value.spellID and GetSpellInfo(value.spellID) then
							local idName = GetSpellInfo(value.spellID)
							table.insert(opt.AuraSelectTable, idName.." ( spellID = "..value.spellID.." )")
						elseif value.itemID and GetItemInfo(value.itemID) then
							local idName = GetItemInfo(value.itemID)
							table.insert(opt.AuraSelectTable, idName.." ( itemID = "..value.itemID.." )")
						end
					end
					return opt.AuraSelectTable
				end,
				get = function()
					return AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue] and opt.AuraSelectValue or 1
				end,
				set = function(_, v)
					opt.AuraSelectValue = v
				end,
			},		
			SpaceLine_1 = {
				type = "description",
				name = "\n",
				order = 3,
			},
			AuraIDClass = {
				type = "select",
				name = "类型:",
				desc = "请选择要监视的ID类型",
				order = 4,
				values = { ["spellID"] = "技能", ["itemID"] = "物品"},
				get = function()
					opt.GroupSelectValue = AuraList[opt.GroupSelectValue] and opt.GroupSelectValue or 1
					opt.AuraSelectValue = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue] and opt.AuraSelectValue or 1
					if AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue].spellID then
						return "spellID"
					else
						return "itemID"
					end
				end,
				set = function(_, v)
					local value = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue]
					if v == "spellID" then
						value.spellID = value.itemID
						value.itemID = nil
					elseif v == "itemID" then
						value.itemID = value.spellID
						value.spellID = nil
						value.Filter = "CD"
					end
				end,
			},
			AuraID = {
				type = "input",
				name = "AuraID:",
				desc = "请输入要监视的AuraID",
				order = 5,
				get = function()
					opt.GroupSelectValue = AuraList[opt.GroupSelectValue] and opt.GroupSelectValue or 1
					opt.AuraSelectValue = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue] and opt.AuraSelectValue or 1
					local value = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue]
					if value.itemID then
						return tostring(value.itemID)
					else
						return tostring(value.spellID)
					end
				end,
				set = function(_, v)
					local value = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue]
					if value.itemID then
						if GetItemInfo(v) then
							value.itemID = v
						else
							print("|cffff1010！！ERROR！！|r The spellID |cff70C0F5"..v.."|r has an error")
						end
					elseif value.spellID then
						if GetSpellInfo(v) then
							value.spellID = v
						else
							print("|cffff1010！！ERROR！！|r The itemID |cff70C0F5"..v.."|r has an error")						
						end
					end
				end,
			},
			AuraUnitId = {
				type = "select",
				name = "监视单位:",
				desc = "请选择要监视的单位",
				order = 6,
				values = { ["player"] = "玩家", ["target"] = "目标", ["focus"] = "焦点", ["pet"] = "宠物"},
				get = function()
					opt.GroupSelectValue = AuraList[opt.GroupSelectValue] and opt.GroupSelectValue or 1
					opt.AuraSelectValue = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue] and opt.AuraSelectValue or 1
					return AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue].unitId
				end,
				set = function(_, v)
					AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue].unitId = v
				end,
			},
			AuraFilter = {
				type = "select",
				name = "过滤:",
				desc = "请选择要过滤的类型",
				order = 7,
				values = function()
					opt.GroupSelectValue = AuraList[opt.GroupSelectValue] and opt.GroupSelectValue or 1
					opt.AuraSelectValue = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue] and opt.AuraSelectValue or 1
					local value = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue]
					if value.itemID then
						return {["CD"] = "CD"}
					else
						return {["BUFF"] = "BUFF", ["DEBUFF"] = "DEBUFF", ["CD"] = "CD"}						
					end
				end,
				get = function()
					opt.GroupSelectValue = AuraList[opt.GroupSelectValue] and opt.GroupSelectValue or 1
					opt.AuraSelectValue = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue] and opt.AuraSelectValue or 1
					return AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue].Filter
				end,
				set = function(_, v)
					AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue].Filter = v
				end,
			},
			AuraCaster = {
				type = "select",
				name = "施法者:",
				desc = "请选择要过滤的施法者",
				order = 8,
				values = { ["player"] = "玩家", ["target"] = "目标", ["focus"] = "焦点", ["pet"] = "宠物", ["NONE"] = "不限"},
				get = function()
					opt.GroupSelectValue = AuraList[opt.GroupSelectValue] and opt.GroupSelectValue or 1
					opt.AuraSelectValue = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue] and opt.AuraSelectValue or 1
					local value = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue]
					return value.Caster or "NONE"
				end,
				set = function(_, v)
					local value = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue]
					if v ~= "NONE" then
						value.Caster = v
					else
						value.Caster = nil
					end
				end,
			},
			AuraStack = {
				type = "select",
				name = "层数阈值:",
				desc = "请选择要过滤的层数阈值",
				order = 9,
				values = {[0] = "不限", [1] = "1", [2] = "2", [3] = "3", [4] = "4", [5] = "5", [6] = "6", [7] = "7", [8] = "8", [9] = "9"},
				get = function()
					opt.GroupSelectValue = AuraList[opt.GroupSelectValue] and opt.GroupSelectValue or 1
					opt.AuraSelectValue = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue] and opt.AuraSelectValue or 1
					local value = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue]
					return value.Stack or 0 
				end,
				set = function(_, v)
					local value = AuraList[opt.GroupSelectValue].List[opt.AuraSelectValue]
					if v ~= 0 then
						value.Stack = v
					else
						value.Stack = nil
					end
				end,
			},
			SpaceLine_2 = {
				type = "description",
				name = "\n\n\n",
				order = 10,
			},
			SaveButton = {
				type = "execute",
				name = "保存修改",
				width = "full",
				order = 11,
				func  = function() end,
			},
			DeleteButton = {
				type = "execute",
				name = "删除Aura",
				width = "full",
				order = 12,
				func  = function() end,
			},
			NewAuraButton = {
				type = "execute",
				name = "添加新的Aura",
				width = "full",
				order = 13,
				func  = function() end,
			},
		},
	}

	opt.OptTable = {
		type = "group",
		name = "Sora's AuraWatch 设置",
		args = {
			GroupTable = GroupTable,
			AuraTable = AuraTable,
		},
	}
end

-- initNamespace
local function initNS()
	AuraList = cfg.AuraList
	Aura = cfg.Aura
end

-- initVariables
local function initVariables()
	if not opt.GroupSelectValue then
		opt.GroupSelectValue = 1
	end
end

-- Init
local function Init()
	initNS()
	initVariables()
	BuildOptTable()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("AuraWatchConfig", opt.OptTable)
end

-- Test
SlashCmdList.Test = function()
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("AuraWatchConfig", 750, 500)
	LibStub("AceConfigDialog-3.0"):Open("AuraWatchConfig")
end
SLASH_Test1 = "/Test"


-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:SetScript("OnEvent",function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		Init()
	end
end)