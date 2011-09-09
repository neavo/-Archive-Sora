----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.MiscConfig


local  q, vl
local G = getfenv(0)
local items = {
	"Head 1",
	"Neck",
	"Shoulder 2",
	"Shirt",
	"Chest 3",
	"Waist 4",
	"Legs 5",
	"Feet 6",
	"Wrist 7",
	"Hands 8",
	"Finger0",
	"Finger1",
	"Trinket0",
	"Trinket1",
	"Back",
	"MainHand 9",
	"SecondaryHand 10",
	"Ranged 11",
	"Tabard",}

----------------------------------- Quality Glow --------------------------------------

local function createBorder(Frame)
	local Border = CreateFrame("Frame", nil, Frame)
	Border:SetPoint("TOPLEFT", Frame, "TOPLEFT", 0, 0)
	Border:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT", 0, 0)
	Border:SetBackdrop({
		edgeFile = cfg.Solid, edgeSize = 1,
	})
	Frame.Border = Border
end

local function QualityGlow(Frame, Quality)
	if Quality and Quality > 1 then
		local r, g, b = GetItemQualityColor(Quality)
		if not Frame.Border then
			Frame.Border = CreateFrame("Frame", nil, Frame)
			Frame.Border:SetAllPoints()
			Frame.Border:SetBackdrop({
				edgeFile = cfg.Solid, edgeSize = 1,
			})
			Frame.Border:SetBackdropBorderColor(r, g, b)
		else
			Frame.Border:SetBackdropBorderColor(r, g, b)
		end
	elseif Frame.Border then
		Frame.Border:Hide()
	end
end

local function UpdataCharacterGlow()
	if not CharacterFrame:IsVisible() then return end
	for i, vl in pairs(items) do
		local key, index = string.split(" ", vl)
		Quality = GetInventoryItemQuality("player", i)
		local Frame = G["Character"..key.."Slot"]
		QualityGlow(Frame, Quality)
	end
end

local function UpdataInspectGlow()
	if not InspectFrame:IsVisible() then return end	
	for i, value in pairs(items) do
		local key, index = string.split(" ", value)
		local Item = GetInventoryItemLink("target", i)
		local Frame = G["Inspect"..key.."Slot"]

		if Item then
			Quality = select(3, GetItemInfo(Item))
			QualityGlow(Frame, Quality)
		elseif Frame.Border then
			Frame.Border:Hide()
		end
	end
end

local hookCF = CreateFrame("Frame")
hookCF:SetParent("CharacterFrame")
hookCF:SetScript("OnShow", UpdataCharacterGlow)

InspectFrame_LoadUI()
hooksecurefunc("InspectUnit", UpdataInspectGlow)

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("UNIT_INVENTORY_CHANGED")
Event:RegisterEvent("PLAYER_TARGET_CHANGED")
Event:SetScript("OnEvent", function(self, event, ...)
	if event == "UNIT_INVENTORY_CHANGED" then
		UpdataCharacterGlow()
		UpdataInspectGlow()
	elseif event == "PLAYER_TARGET_CHANGED" then
		UpdataInspectGlow()
	end	
end)