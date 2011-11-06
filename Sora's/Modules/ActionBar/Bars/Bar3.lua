-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("Bar3")

function Module:OnEnable()
	MultiBarBottomRight:SetParent(DB.ActionBar)
	MultiBarBottomRight:ClearAllPoints()
	MultiBarBottomRight.SetPoint = function() end
	for i = 1, 12 do
		local Button = _G["MultiBarBottomRightButton"..i]
		Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
		Button:ClearAllPoints()
		if ActionBarDB.MainBarLayout == 1 then
			if i == 1 then
				Button:SetPoint("BOTTOMLEFT", DB.ActionBar)
			elseif i <= 3 then
				Button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", 3, 0)
			elseif i == 4 then
				Button:SetPoint("BOTTOMLEFT", DB.ActionBar, 0, ActionBarDB.ButtonSize+5)
			elseif i <= 6 then
				Button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", 3, 0)	
			elseif i == 7 then
				Button:SetPoint("BOTTOMRIGHT", DB.ActionBar)
			elseif i <= 9 then
				Button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -3, 0)
			elseif i == 10 then
				Button:SetPoint("BOTTOMRIGHT", DB.ActionBar, 0, ActionBarDB.ButtonSize+5)
			elseif i <= 12 then
				Button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -3, 0)	
			end
		elseif ActionBarDB.MainBarLayout == 2 then
			if i == 1 then
				Button:SetPoint("BOTTOM", MultiBarBottomLeftButton1, "TOP", 0, 5)
			else
				Button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", 3, 0)
			end
		end
	end
end

