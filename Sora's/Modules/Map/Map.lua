-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("Map")

local function SmallSkin()
	WorldMapFrame.BG:ClearAllPoints()
	WorldMapFrame.BG:SetPoint("TOPLEFT", -4, 4)
	WorldMapFrame.BG:SetPoint("BOTTOMRIGHT", 4, -4)
	WorldMapFrameSizeUpButton:Show()
	WorldMapFrameSizeDownButton:Hide()
	WorldMapLevelDropDown:ClearAllPoints()
	WorldMapLevelDropDown:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -17, 27)
end
local function LargeSkin()
	if not InCombatLockdown() then
		WorldMapFrame:EnableMouse(false)
		WorldMapFrame:EnableKeyboard(false)
		SetUIPanelAttribute(WorldMapFrame, "area", "center")
		SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)	
	end
	WorldMapFrameSizeUpButton:Hide()
	WorldMapFrameSizeDownButton:Show()
	WorldMapFrame.BG:ClearAllPoints()
	WorldMapFrame.BG:SetPoint("TOPLEFT", WorldMapDetailFrame, -25, 70)
	WorldMapFrame.BG:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, 25, -30)
end
local function QuestSkin()
	if not InCombatLockdown() then
		WorldMapFrame:EnableMouse(false)
		WorldMapFrame:EnableKeyboard(false)
		SetUIPanelAttribute(WorldMapFrame, "area", "center")
		SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)
	end
	WorldMapFrameSizeUpButton:Hide()
	WorldMapFrameSizeDownButton:Show()
	WorldMapFrame.BG:ClearAllPoints()
	WorldMapFrame.BG:SetPoint("TOPLEFT", WorldMapDetailFrame, -25, 70)
	WorldMapFrame.BG:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, 330, -240)  
end			
local function FixSkin()
	for i = 1, WorldMapFrame:GetNumRegions() do
		local region = select(i, WorldMapFrame:GetRegions())
		if region:GetObjectType() == "Texture" then region:SetTexture(nil) end
	end	
	
	if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
		LargeSkin()
	elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then
		SmallSkin()
	elseif WORLDMAP_SETTINGS.size == WORLDMAP_QUESTLIST_SIZE then
		QuestSkin()
	end

	if InCombatLockdown() then
		WorldMapFrameSizeDownButton:Disable()
		WorldMapFrameSizeUpButton:Disable()
	end	
end

function Module:OnEnable()
	WorldMapFrame:SetFrameStrata("HIGH")
	WorldMapFrame.BG = CreateFrame("Frame", nil, WorldMapFrame)
	WorldMapFrame.BG:SetFrameLevel(0)
	WorldMapFrame.BG:SetPoint("TOPLEFT", -4, 4)
	WorldMapFrame.BG:SetPoint("BOTTOMRIGHT", 4, -4)
	WorldMapFrame.BG:SetBackdrop({
		bgFile = DB.bgFile, insets = {left = 5, right = 5, top = 5, bottom = 5},
		edgeFile = DB.GlowTex, edgeSize = 4
	})
	WorldMapFrame.BG:SetBackdropColor(0, 0, 0, 0.8)
	WorldMapFrame.BG:SetBackdropBorderColor(0, 0, 0, 1)

	WorldMapZoomOutButton:SetPoint("LEFT", WorldMapZoneDropDown, "RIGHT", 0, 4)
	WorldMapLevelUpButton:SetPoint("TOPLEFT", WorldMapLevelDropDown, "TOPRIGHT", -2, 8)
	WorldMapLevelDownButton:SetPoint("BOTTOMLEFT", WorldMapLevelDropDown, "BOTTOMRIGHT", -2, 2)

	WorldMapFrame:HookScript("OnShow", FixSkin)
	hooksecurefunc("WorldMapFrame_SetFullMapView", LargeSkin)
	hooksecurefunc("WorldMapFrame_SetQuestMapView", QuestSkin)
	hooksecurefunc("WorldMap_ToggleSizeUp", FixSkin)

	if not GetCVarBool("miniWorldMap") then ToggleFrame(WorldMapFrame) end
end