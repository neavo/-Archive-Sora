-- Engines
local _, _, _, DB = unpack(select(2, ...))
ShapeshiftBarFrame:SetParent(DB.ActionBar)

for i = 1, NUM_SHAPESHIFT_SLOTS do
	local Button = _G["ShapeshiftButton"..i]
	Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
	Button:ClearAllPoints()
	if ActionBarDB.MainBarLayout == 1 then
		if i == 1 then
			Button:SetPoint("BOTTOM", MultiBarBottomRightButton4, "TOP", 0, 5)
		else
			Button:SetPoint("LEFT", _G["ShapeshiftButton"..i-1]  , "RIGHT", 3, 0)
		end
	elseif ActionBarDB.MainBarLayout == 2 then
		if i == 1 then
			Button:SetPoint("RIGHT", MultiBarBottomRightButton1, "LEFT", -3, 0)
		elseif i == 4 then
			Button:SetPoint("RIGHT", ShapeshiftButton1, "LEFT", -3, 0)
		else
			Button:SetPoint("TOP", _G["ShapeshiftButton"..i-1], "BOTTOM", 0, -5)
		end
	end
	Button:SetAlpha(0.3)
	Button:HookScript("OnEnter", function(self) 
		for i = 1, NUM_SHAPESHIFT_SLOTS do _G["ShapeshiftButton"..i]:SetAlpha(1) end
	end)
	Button:HookScript("OnLeave",function(self) 
		for i = 1, NUM_SHAPESHIFT_SLOTS do _G["ShapeshiftButton"..i]:SetAlpha(0.3) end
	end)
end

hooksecurefunc("ShapeshiftBar_Update", function()
	ShapeshiftButton1:ClearAllPoints()
	if ActionBarDB.MainBarLayout == 1 then
		ShapeshiftButton1:SetPoint("BOTTOM", MultiBarBottomRightButton4, "TOP", 0, 5)
	elseif ActionBarDB.MainBarLayout == 2 then
		ShapeshiftButton1:SetPoint("RIGHT", MultiBarBottomRightButton1, "LEFT", -3, 0)
	end
end)