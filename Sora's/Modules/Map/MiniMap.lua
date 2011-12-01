-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("MiniMap")

function Module:OnInitialize()
	local NewMail = false
	Minimap:SetMaskTexture("Interface\\ChatFrame\\ChatFrameBackground")
	Minimap:SetFrameStrata("BACKGROUND")
	Minimap:ClearAllPoints()
	Minimap:SetSize(120, 120)
	MoveHandle.Minimap = S.MakeMoveHandle(Minimap, "小地图", "Minimap")
	
	LFDSearchStatus:SetClampedToScreen(true)
	DropDownList1:SetClampedToScreen(true)

	Minimap.Shadow = S.MakeShadow(Minimap, 4)
	Minimap.Shadow.Timer = 0
	Minimap.Shadow:SetScript("OnUpdate",function(self,elapsed)
		self.Timer = self.Timer + elapsed
		if self.Timer > 1.2 then
			self.Timer = 0
			if HasNewMail() then
				self:SetBackdropBorderColor(120/255, 255/255, 120/255, 1)
				UIFrameFadeOut(self, 1.2, 1, 0)
			else
				self:SetAlpha(1)
				self:SetBackdropBorderColor(0, 0, 0, 1)
			end
		end
	end)

	local frames = {
		"GameTimeFrame",
		"MinimapBorderTop",
		"MinimapNorthTag",
		"MinimapBorder",
		"MinimapZoneTextButton",
		"MinimapZoomOut",
		"MinimapZoomIn",
		"MiniMapVoiceChatFrame",
		"MiniMapWorldMapButton",
		"MiniMapMailBorder",
		"GuildInstanceDifficulty",
		"MiniMapBattlefieldBorder",
	}

	for i in pairs(frames) do
		_G[frames[i]]:Hide()
		_G[frames[i]].Show = function() end
	end
	MinimapCluster:EnableMouse(false)

	--BG icon
	MiniMapBattlefieldFrame:ClearAllPoints()
	MiniMapBattlefieldFrame:SetPoint("BOTTOMLEFT", Minimap, 0, 0)

	--LFG icon
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrameBorder:SetAlpha(0)
	MiniMapLFGFrame:SetPoint("TOPLEFT", Minimap, 0, 0)

	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap, 0, 0)
	MiniMapMailFrame:SetFrameStrata("LOW")
	MiniMapMailIcon:SetTexture("Interface\\AddOns\\Sora's\Media\\mail.tga")
	MiniMapMailBorder:Hide()

	---Hide Instance Difficulty flag
	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:Hide()

	-- Enable mouse scrolling
	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", function(self, d)
		if d > 0 then
			_G.MinimapZoomIn:Click()
		elseif d < 0 then
			_G.MinimapZoomOut:Click()
		end
	end)
	
	local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{text = ENCOUNTER_JOURNAL, 
		func = function() if not IsAddOnLoaded('Blizzard_EncounterJournal') then LoadAddOn('Blizzard_EncounterJournal'); end ToggleFrame(EncounterJournal) end},	
		{text = CHARACTER_BUTTON,
		func = function() ToggleCharacter("PaperDollFrame") end},
		{text = SPELLBOOK_ABILITIES_BUTTON,
		func = function() ToggleFrame(SpellBookFrame) end},
		{text = TALENTS_BUTTON,
		func = function() ToggleTalentFrame() end},
		{text = ACHIEVEMENT_BUTTON,
		func = function() ToggleAchievementFrame() end},
		{text = QUESTLOG_BUTTON,
		func = function() ToggleFrame(QuestLogFrame) end},
		{text = SOCIAL_BUTTON,
		func = function() ToggleFriendsFrame(1) end},
		{text = PLAYER_V_PLAYER,
		func = function() ToggleFrame(PVPFrame) end},
		{text = LFG_TITLE,
		func = function() ToggleFrame(LFDParentFrame) end},
		{text = L_LFRAID,
		func = function() ToggleFrame(LFRParentFrame) end},
		{text = HELP_BUTTON,
		func = function() ToggleHelpFrame() end},
		{text = SLASH_CALENDAR1:gsub("/(.*)","%1"), 
		func = function()
		if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
			Calendar_Toggle()
		end},
		{text = "打开背包", func = function() ToggleBackpack() end}, 
	}

	Minimap:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
		else
			Minimap_OnClick(self)
		end
	end)
	
end
