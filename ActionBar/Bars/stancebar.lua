local bar = CreateFrame("Frame","rABS_StanceBar",UIParent, "SecureHandlerStateTemplate")
bar:SetWidth(24*NUM_SHAPESHIFT_SLOTS+1*(NUM_SHAPESHIFT_SLOTS-1))
bar:SetHeight(24)
bar:SetPoint("BOTTOM", UIParent, "BOTTOM", -92, 113)
ShapeshiftBarFrame:SetParent(bar)
ShapeshiftBarFrame:EnableMouse(false)

for i=1, NUM_SHAPESHIFT_SLOTS do
	local Button = _G["ShapeshiftButton"..i]
	Button:SetSize(24, 24)
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