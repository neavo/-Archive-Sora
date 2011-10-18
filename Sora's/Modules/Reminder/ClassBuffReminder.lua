-- Engines
local S, _, _, DB = unpack(select(2, ...))
local _, Class =  UnitClass("player")
local ClassBuff, BuffFrame = {}, {}

-- BuildBuffFrame
local function BuildBuffFrame()
	ClassBuff = DB.ClassBuffList[Class][GetPrimaryTalentTree() or 1]
	for key, value in pairs(ClassBuff) do
		local Button = CreateFrame("Frame", nil, UIParent)
		Button:SetSize(ReminderDB.ClassBuffSize, ReminderDB.ClassBuffSize)
		Button.Shadow = S.MakeShadow(Button, 3)
		Button.Icon = Button:CreateTexture(nil, "ARTWORK")
		Button.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Button.Icon:SetAllPoints()
		Button.Text = S.MakeFontString(Button, 10)
		Button.Text:SetPoint("TOP", Button, "BOTTOM", 0, -10)
		if key == 1 then
			Button:SetPoint(unpack(DB.ClassBuffPos))
		else
			Button:SetPoint("LEFT", BuffFrame[key-1], "RIGHT", ReminderDB.ClassBuffSpace, 0)
		end
		Button:SetAlpha(0)	
		table.insert(BuffFrame, Button)
	end
end

-- UpdateSound
local function UpdateSound()
	for _, value in pairs(BuffFrame) do
		value:SetAlpha(0)
	end
	local i = 0
	for key, value in pairs(ClassBuff) do
		local flag = 0
		for _, temp in pairs(value) do
			local Name, _, Icon = select(1, GetSpellInfo(temp))
			if UnitAura("player", Name) then flag = 1 end
		end
		if flag == 0 then
			local Name, _, Icon = select(1, GetSpellInfo(value[1]))
			i = i + 1
			BuffFrame[i].Icon:SetTexture(Icon)
			BuffFrame[i].Icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
			BuffFrame[i].Text:SetText(format("缺少：%s", Name))
			BuffFrame[i]:SetAlpha(1)
		end
	end
	if i ~= 0 and ReminderDB.ClassBuffSound then PlaySoundFile(DB.Warning) end
end

-- UpdateBuffFrame
local function UpdateBuffFrame()
	for _, value in pairs(BuffFrame) do
		value:SetAlpha(0)
	end
	local i = 0
	for key, value in pairs(ClassBuff) do
		local flag = 0
		for _, temp in pairs(value) do
			local Name, _, Icon = select(1, GetSpellInfo(temp))
			if UnitAura("player", Name) then
				flag = 1
			end
		end
		if flag == 0 then
			local Name, _, Icon = select(1, GetSpellInfo(value[1]))
			i = i + 1
			BuffFrame[i].Icon:SetTexture(Icon)
			BuffFrame[i].Icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
			BuffFrame[i].Text:SetText(format("缺少：%s", Name))
			BuffFrame[i]:SetAlpha(1)
		end
	end
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("UNIT_AURA")
Event:RegisterEvent("PLAYER_LOGIN")
Event:RegisterEvent("PLAYER_REGEN_DISABLED")
Event:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
Event:SetScript("OnEvent", function(self, event, unit, ...)
	if event == "UNIT_AURA" and unit ~= "player" then return end
	if event == "PLAYER_LOGIN" or event == "ACTIVE_TALENT_GROUP_CHANGED" then BuildBuffFrame() end
	if event == "PLAYER_REGEN_DISABLED" then UpdateSound() end
	UpdateBuffFrame()
end)

