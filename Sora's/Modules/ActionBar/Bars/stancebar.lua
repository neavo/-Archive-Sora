-- Engines
local _, _, _, DB = unpack(select(2, ...))
ShapeshiftBarFrame:SetParent(DB.ActionBar)

for i = 1, 6 do
	local Button = _G["ShapeshiftButton"..i]
	Button:SetSize(26, 26)
	Button:ClearAllPoints()
	if i == 1 then
		Button:SetPoint("BOTTOM", MultiBarBottomRightButton4, "TOP", 0, 5)
	else
		local Pre = _G["ShapeshiftButton"..i-1]      
		Button:SetPoint("LEFT", Pre, "RIGHT", 3, 0)
	end
end

hooksecurefunc("ShapeshiftBar_Update", function()
	ShapeshiftButton1:ClearAllPoints()
	ShapeshiftButton1:SetPoint("BOTTOM", MultiBarBottomRightButton4, "TOP", 0, 5)
end)

for i=1, 6 do
	local Button = _G["ShapeshiftButton"..i]
	Button:SetAlpha(0.3)
	Button:HookScript("OnEnter", function(self) 
		for i = 1, 6 do
			local Button = _G["ShapeshiftButton"..i]
			Button:SetAlpha(1)
		end
	end)
	Button:HookScript("OnLeave",function(self) 
		for i = 1, 6 do
			local Button = _G["ShapeshiftButton"..i]
			Button:SetAlpha(0.3)
		end
	end)
end