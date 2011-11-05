-- Engines
local _, _, _, DB = unpack(select(2, ...))
ShapeshiftBarFrame:SetParent(DB.ActionBar)

for i = 1, NUM_SHAPESHIFT_SLOTS do
	local Button = _G["ShapeshiftButton"..i]
	Button:SetAlpha(0.3)
	Button:SetSize(ActionBarDB.ButtonSize, ActionBarDB.ButtonSize)
	Button:ClearAllPoints()
	if i == 1 then
		Button:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", 0, 5)
	else
		Button:SetPoint("LEFT", _G["ShapeshiftButton"..i-1], "RIGHT", 3, 0)
	end
	Button:HookScript("OnEnter", function(self) 
		for i = 1, NUM_SHAPESHIFT_SLOTS do _G["ShapeshiftButton"..i]:SetAlpha(1) end
	end)
	Button:HookScript("OnLeave",function(self) 
		for i = 1, NUM_SHAPESHIFT_SLOTS do _G["ShapeshiftButton"..i]:SetAlpha(0.3) end
	end)
end

hooksecurefunc("ShapeshiftBar_Update", function()
	ShapeshiftButton1:ClearAllPoints()
	ShapeshiftButton1:SetPoint("BOTTOMLEFT", DB.ActionBar, "TOPLEFT", 0, 5)
end)