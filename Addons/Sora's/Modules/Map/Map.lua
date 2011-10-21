-- Engines
local S, _, _, DB = unpack(select(2, ...))

local map_scale = 0.8

---------------- > Moving/removing world map elements
if map_scale == 1 then map_scale = 0.99 end -- dirty hack to prevent "division by zero"!
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:RegisterEvent("WORLD_MAP_UPDATE")
Event:RegisterEvent("PLAYER_REGEN_DISABLED")
Event:RegisterEvent("PLAYER_REGEN_ENABLED")
Event:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		SetCVar("questPOI", 1)
		SetCVar("advancedWorldMap", 1)
		BlackoutWorld:Hide()
		BlackoutWorld.Show = function() end
		BlackoutWorld.Hide = function() end
		WORLDMAP_RATIO_MINI = map_scale
		WORLDMAP_WINDOWED_SIZE = map_scale 
		WORLDMAP_SETTINGS.size = map_scale 
		WorldMapBlobFrame.Show = function() end
		WorldMapBlobFrame.Hide = function() end
		WorldMapQuestPOI_OnLeave = function() WorldMapTooltip:Hide() end
		WorldMap_ToggleSizeDown()
		if FeedbackUIMapTip then 
			FeedbackUIMapTip:Hide()
			FeedbackUIMapTip.Show = function() end
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		WorldMapFrameSizeUpButton:Disable()
		WorldMap_ToggleSizeDown()
		WorldMapBlobFrame:DrawBlob(WORLDMAP_SETTINGS.selectedQuestId, false)
		WorldMapBlobFrame:DrawBlob(WORLDMAP_SETTINGS.selectedQuestId, true)
	elseif event == "PLAYER_REGEN_ENABLED" then
		WorldMapFrameSizeUpButton:Enable()
	elseif event == "WORLD_MAP_UPDATE" then
		if GetNumDungeonMapLevels() == 0 then
			WorldMapLevelUpButton:Hide()
			WorldMapLevelDownButton:Hide()
		else
			WorldMapLevelUpButton:Show()
			WorldMapLevelUpButton:ClearAllPoints()
			WorldMapLevelUpButton:SetPoint("TOPLEFT", WorldMapFrameCloseButton, "BOTTOMLEFT", 8, 8)
			WorldMapLevelUpButton:SetFrameStrata("MEDIUM")
			WorldMapLevelUpButton:SetFrameLevel(100)
			WorldMapLevelUpButton:SetParent("WorldMapFrame")
			WorldMapLevelDownButton:ClearAllPoints()
			WorldMapLevelDownButton:Show()
			WorldMapLevelDownButton:SetPoint("TOP", WorldMapLevelUpButton, "BOTTOM", 0, -2)
			WorldMapLevelDownButton:SetFrameStrata("MEDIUM")
			WorldMapLevelDownButton:SetFrameLevel(100)
			WorldMapLevelDownButton:SetParent("WorldMapFrame")
		end
	end
end)

---------------- > Styling mini World Map

hooksecurefunc("WorldMap_ToggleSizeDown", function()
	if not WorldMapButton.Shadow then WorldMapButton.Shadow = S.MakeShadow(WorldMapButton, 5) end
	WorldMapFrame.scale = map_scale
	WorldMapDetailFrame:SetScale(map_scale)
	WorldMapButton:SetScale(map_scale)
	WorldMapFrameAreaFrame:SetScale(map_scale)
	WorldMapTitleButton:Show()
	WorldMapFrameMiniBorderLeft:Hide()
	WorldMapFrameMiniBorderRight:Hide()
	WorldMapPOIFrame.ratio = map_scale
	WorldMapFrameCloseButton:ClearAllPoints()
	WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapButton)
	WorldMapFrameCloseButton:SetFrameStrata("HIGH")
	WorldMapFrameCloseButton:SetScale(map_scale)
	WorldMapFrameSizeUpButton:Show()
	WorldMapFrameSizeUpButton:ClearAllPoints()
	WorldMapFrameSizeUpButton:SetPoint("RIGHT", WorldMapFrameCloseButton, "LEFT", 10, 0)
	WorldMapFrameSizeUpButton:SetFrameStrata("HIGH")
	WorldMapFrameSizeUpButton:SetScale(map_scale)
	WorldMapFrameTitle:Hide()
	WorldMapTitleButton:SetFrameStrata("TOOLTIP")
	WorldMapTitleButton:ClearAllPoints()
	WorldMapTitleButton:SetPoint("BOTTOM", WorldMapDetailFrame, "TOP", 0, 0)
	WorldMapTooltip:SetFrameStrata("TOOLTIP")
	WorldMapLevelDropDown.Show = function() end
	WorldMapLevelDropDown:Hide()
	WorldMapQuestShowObjectives:SetScale(map_scale)
	WorldMapShowDigSites:SetScale(map_scale)
	WorldMapTrackQuest:SetScale(map_scale)
	WorldMapLevelDownButton:SetScale(map_scale)
	WorldMapLevelUpButton:SetScale(map_scale)
	WorldMapFrame_SetOpacity(WORLDMAP_SETTINGS.opacity)
	WorldMapQuestShowObjectives_AdjustPosition()
end)

hooksecurefunc("WorldMap_ToggleSizeUp", function()
	WorldMapQuestShowObjectives:SetScale(1)
	WorldMapTrackQuest:SetScale(1)
	WorldMapFrameCloseButton:SetScale(1)
	WorldMapShowDigSites:SetScale(1)
	WorldMapLevelDownButton:SetScale(1)
	WorldMapLevelUpButton:SetScale(1)
	WorldMapLevelDropDown.Show = WorldMapLevelDropDown:Show()
	WorldMapFrame:EnableKeyboard(nil)
	WorldMapFrame:EnableMouse(nil)
	UIPanelWindows["WorldMapFrame"].area = "center"
	WorldMapFrame:SetAttribute("UIPanelLayout-defined", nil)
end)