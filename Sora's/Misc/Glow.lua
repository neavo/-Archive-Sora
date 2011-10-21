-- Engines
local _, _, _, DB = unpack(select(2, ...))

local function UpdateGlow(Button, ItemID)
	local quality, texture
	local Border = _G[Button:GetName().."NormalTexture"]
	
	if Border then Border:SetTexture(nil) end
	
	if ItemID then quality, _, _, _, _, _, _, texture = select(3, GetItemInfo(ItemID)) end

	if not Button.Border then
		Button.Border = CreateFrame("Frame", nil, Button)
		Button.Border:SetPoint("TOPLEFT")
		Button.Border:SetPoint("BOTTOMRIGHT")
		Button.Border:SetBackdrop({edgeFile = DB.Solid, edgeSize = 1})
	end

	if texture then
		local r, g, b
		if quest and quest:IsShown() then
			r, g, b = 1, 0, 0
		else
			r, g, b = GetItemQualityColor(quality)
			if r==1 then
				r, g, b = 0, 0, 0
			end
		end
		Button.Border:SetBackdropBorderColor(r, g, b)
		Button.Border:Show()
	else
		Button.Border:Hide()
	end
end

local Slots = {
	"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
	"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
	"SecondaryHand", "Ranged", "Tabard",
}

local function UpdateChar(self)
	if CharacterFrame:IsShown() then
		for key, value in ipairs(Slots) do
			local slotID = key % 20
			local slotFrame = _G["Character"..value.."Slot"]
			local slotLink = GetInventoryItemLink("player", slotID)
			UpdateGlow(slotFrame, slotLink)
		end
	end
end

local function UpdateInspect(self)
	local unit = InspectFrame.unit
	if InspectFrame:IsShown() and unit then
		for key, value in ipairs(Slots) do
			local slotID = key % 20
			local slotFrame = _G["Inspect"..value.."Slot"]
			local slotLink = GetInventoryItemLink(unit, slotID)
			UpdateGlow(slotFrame, slotLink)
		end
	end	
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("ADDON_LOADED")
Event:RegisterEvent("UNIT_INVENTORY_CHANGED")
Event:SetScript("OnEvent", function(self, event, addon)
	if event == "UNIT_INVENTORY_CHANGED" then
		UpdateChar()
	elseif event == "ADDON_LOADED" then
		if addon == "Blizzard_InspectUI" then
			InspectFrame:HookScript("OnShow", function()
				Event:RegisterEvent("PLAYER_TARGET_CHANGED")
				Event:RegisterEvent("INSPECT_READY")
				Event:SetScript("OnEvent", UpdateInspect)
				UpdateInspect()
			end)
			InspectFrame:HookScript("OnHide", function()
				Event:UnregisterEvent("PLAYER_TARGET_CHANGED")
				Event:UnregisterEvent("INSPECT_READY")
				Event:SetScript("OnEvent", nil)
			end)
		end
	end
end)
CharacterFrame:HookScript("OnShow", UpdateChar)