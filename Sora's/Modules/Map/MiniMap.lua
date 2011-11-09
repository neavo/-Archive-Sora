-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Sora = LibStub("AceAddon-3.0"):GetAddon("Sora")
local Module = Sora:NewModule("MiniMap")

function Module:OnEnable()
	local NewMail = false
	Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8x8")
	Minimap:SetFrameStrata("BACKGROUND")
	Minimap:ClearAllPoints()
	Minimap:SetSize(105, 105)
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

	MinimapBorder:Hide()
	MinimapBorderTop:Hide()
	MinimapZoomIn:Hide()
	MinimapZoomOut:Hide()
	MiniMapVoiceChatFrame:Hide()
	GameTimeFrame:Hide()
	MinimapZoneTextButton:Hide()
	MiniMapMailFrame:Hide()
	MiniMapMailIcon:Hide()
	MiniMapMailBorder:Hide()
	MiniMapBattlefieldBorder:Hide()
	MiniMapWorldMapButton:Hide()
	MinimapNorthTag:SetAlpha(0)
	MiniMapBattlefieldFrame:ClearAllPoints()
	MiniMapBattlefieldFrame:SetScale(0.8)
	MiniMapBattlefieldFrame:SetPoint("TOP", Minimap, "TOP", 0, 4)
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrameBorder:SetAlpha(0)
	MiniMapLFGFrame:SetPoint("TOP", Minimap, "TOP", 0, 4)
	MiniMapInstanceDifficulty:ClearAllPoints()
	MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 4)
	MiniMapInstanceDifficulty:SetScale(0.8)
	GuildInstanceDifficulty:ClearAllPoints()
	GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 4)
	GuildInstanceDifficulty:SetScale(0.8)
	GameTimeCalendarInvitesTexture:ClearAllPoints()
	GameTimeCalendarInvitesTexture:SetParent("Minimap")
	GameTimeCalendarInvitesTexture:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 0, 4)
	if FeedbackUIButton then
		FeedbackUIButton:ClearAllPoints()
		FeedbackUIButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 6, -6)
		FeedbackUIButton:SetScale(0.8)
	end
	if StreamingIcon then
		StreamingIcon:ClearAllPoints()
		StreamingIcon:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 8, 8)
		StreamingIcon:SetScale(0.8)
	end

	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", function(self, z)
		local c = Minimap:GetZoom()
		if z > 0 and c < 5 then
			Minimap:SetZoom(c+1)
		elseif z < 0 and c > 0 then
			Minimap:SetZoom(c-1)
		end
	end)

	local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
	local menuList = {
		{text = CHARACTER_BUTTON, func = function() ToggleCharacter("PaperDollFrame") end}, 
		{text = SPELLBOOK_ABILITIES_BUTTON, func = function() ToggleSpellBook("spell") end}, 
		{text = TALENTS_BUTTON, func = function() ToggleTalentFrame() end}, 
		{text = ACHIEVEMENT_BUTTON, func = function() ToggleAchievementFrame() end}, 
		{text = QUESTLOG_BUTTON, func = function() ToggleFrame(QuestLogFrame) end}, 
		{text = SOCIAL_BUTTON, func = function() ToggleFriendsFrame(1) end}, 
		{text = GUILD, func = function() ToggleGuildFrame(1) end}, 
		{text = PLAYER_V_PLAYER, func = function() ToggleFrame(PVPFrame) end}, 
		{text = HELP_BUTTON, func = function() ToggleHelpFrame() end}, 
		{text = "打开背包", func = function() ToggleBackpack() end}, 
		{text = "日历", func = function()
			if not CalendarFrame then LoadAddOn("Blizzard_Calendar") end
			Calendar_Toggle()
		end}, 
		{text = LFG_TITLE, func = function() ToggleFrame(LFDParentFrame) end},
		{text = LOOKING_FOR_RAID, func = function() ToggleFrame(LFRParentFrame) end},		
		{text = "系统菜单", func = function() ToggleFrame(GameMenuFrame) end}, 
		{text = ENCOUNTER_JOURNAL, func = function() ToggleFrame(EncounterJournal) end},
	}
	Minimap:SetScript("OnMouseUp", function(self, button)
		if button == "RightButton" then
			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU")
		else
			Minimap_OnClick(self)
		end
	end)
end
