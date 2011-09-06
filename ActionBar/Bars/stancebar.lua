local bar = CreateFrame("Frame","rABS_StanceBar",UIParent, "SecureHandlerStateTemplate")
bar:SetWidth(22*6+1*(6-1))
bar:SetHeight(22)
bar:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 0, 3)
ShapeshiftBarFrame:SetParent(bar)
ShapeshiftBarFrame:EnableMouse(false)

for i=1, 6 do
	local Button = _G["ShapeshiftButton"..i]
	Button:SetSize(22, 22)
	Button:ClearAllPoints()
	if i == 1 then
		Button:SetPoint("BOTTOMLEFT", bar, 0,0)
	else
		local previous = _G["ShapeshiftButton"..i-1]      
		Button:SetPoint("LEFT", previous, "RIGHT", 1, 0)
	end
end

local function rABS_MoveShapeshift()
	ShapeshiftButton1:SetPoint("BOTTOMLEFT", bar, 0,0)
end
hooksecurefunc("ShapeshiftBar_Update", rABS_MoveShapeshift)

local function lighton(alpha)
	if ShapeshiftBarFrame:IsShown() then
		for i=1, 6 do
			local pb = _G["ShapeshiftButton"..i]
			pb:SetAlpha(alpha)
		end
	end
end    
bar:EnableMouse(true)
bar:SetScript("OnEnter", function(self) lighton(1) end)
bar:SetScript("OnLeave", function(self) lighton(0.3) end)  
for i=1, 6 do
	local pb = _G["ShapeshiftButton"..i]
	pb:SetAlpha(0.3)
	pb:HookScript("OnEnter", function(self) lighton(1) end)
	pb:HookScript("OnLeave", function(self) lighton(0.1) end)
end