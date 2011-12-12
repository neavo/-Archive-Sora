-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("Bar3")

function Module:OnInitialize()
	C = ActionBarDB
	MultiBarBottomRight:SetParent(DB.ActionBar)
end

function Module:OnEnable()
	local Button = nil
	for i = 1, 12 do
		Button = _G["MultiBarBottomRightButton"..i]
		Button:SetSize(C["ButtonSize"], C["ButtonSize"])
		Button:ClearAllPoints()
		if C["MainBarLayout"] == 1 then
			if i == 1 then
				Button:SetPoint("BOTTOMLEFT", DB.ActionBar)
			elseif i <= 3 then
				Button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", 3, 0)
			elseif i == 4 then
				Button:SetPoint("BOTTOMLEFT", DB.ActionBar, 0, C["ButtonSize"]+5)
			elseif i <= 6 then
				Button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", 3, 0)	
			elseif i == 7 then
				Button:SetPoint("BOTTOMRIGHT", DB.ActionBar)
			elseif i <= 9 then
				Button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -3, 0)
			elseif i == 10 then
				Button:SetPoint("BOTTOMRIGHT", DB.ActionBar, 0, C["ButtonSize"]+5)
			elseif i <= 12 then
				Button:SetPoint("RIGHT", _G["MultiBarBottomRightButton"..i-1], "LEFT", -3, 0)	
			end
		elseif C["MainBarLayout"] == 2 then
			if i == 1 then
				Button:SetPoint("BOTTOM", MultiBarBottomLeftButton1, "TOP", 0, 5)
			else
				Button:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", 3, 0)
			end
		end
	end
end