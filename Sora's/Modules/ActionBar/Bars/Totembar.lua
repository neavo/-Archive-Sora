-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("Totembar")

function Module:OnEnable()
	if not select(2, UnitClass("player"))== "SHAMAN" then return end

	if MultiCastActionBarFrame then
		MultiCastActionBarFrame:SetScript("OnUpdate", nil)
		MultiCastActionBarFrame:SetScript("OnShow", nil)
		MultiCastActionBarFrame:SetScript("OnHide", nil)
		MultiCastActionBarFrame:SetParent(DB.ActionBar)
		MultiCastActionBarFrame:ClearAllPoints()
		MultiCastActionBarFrame.ClearAllPoints = function() end
		MultiCastActionBarFrame.SetParent = function() end
		MultiCastActionBarFrame.SetPoint = function() end
	end
	local Color = {
		{0.5, 0.7,   0}, -- earth
		{0.8, 0.4, 0.2}, -- fire
		{0.3, 0.7, 0.8}, -- water
		{0.8, 0.5, 0.9}, -- air
	}
	local TotemTime = {}
	for i = 1, 4 do
		local Button = _G["MultiCastSlotButton"..i]
		local TimeFrame = CreateFrame("Frame", nil, UIParent)
		TimeFrame:SetAllPoints(Button)
		TimeFrame:SetFrameLevel(Button:GetFrameLevel()+1)
		TimeFrame.Text = S.MakeFontString(TimeFrame, 10)
		TimeFrame.Text:SetPoint("BOTTOM", 0, 1)
		TimeFrame.Text:SetTextColor(unpack(Color[i]))
		tinsert(TotemTime, TimeFrame.Text)
	end
	TotemTime[1], TotemTime[2] = TotemTime[2], TotemTime[1]
	local Update = CreateFrame("Frame")
	Update:SetScript("OnUpdate", function(self, elapsed)
		for i = 1, 4 do	
			local haveTotem = GetTotemInfo(i)
			local TimeLeft = GetTotemTimeLeft(i)
			if not haveTotem or TimeLeft <= 0 then
				TotemTime[i]:SetText("")
			else
				TotemTime[i]:SetText(S.FormatTime(TimeLeft, true))
			end
		end
	end)
end
