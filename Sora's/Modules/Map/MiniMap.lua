-- Engines
local S, C, L, DB = unpack(select(2, ...))
local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("MiniMap")

Minimap:SetMaskTexture("Interface\\ChatFrame\\ChatFrameBackground")
Minimap:SetFrameStrata("BACKGROUND")
Minimap:ClearAllPoints()
Minimap:SetSize(120, 120)
Minimap.Shadow = S.MakeShadow(Minimap, 4)

function Module:OnInitialize()
	MoveHandle.Minimap = S.MakeMoveHandle(Minimap, "小地图", "Minimap")
end

LFGSearchStatus:SetClampedToScreen(true)
LFGDungeonReadyStatus:SetClampedToScreen(true)

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
	"MiniMapBattlefieldBorder",
}

for i in pairs(frames) do
	_G[frames[i]]:Hide()
	_G[frames[i]].Show = function() end
end
MinimapCluster:EnableMouse(false)

--BG icon
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("BOTTOMLEFT", Minimap, 0, -4)

--LFG icon
MiniMapLFGFrame:ClearAllPoints()
MiniMapLFGFrameBorder:SetAlpha(0)
MiniMapLFGFrame:SetPoint("TOPLEFT", Minimap, 0, 4)

MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, 0, 4)
MiniMapInstanceDifficulty:SetScale(0.8)

GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, 0, 4)
GuildInstanceDifficulty:SetScale(0.8)

MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, 0, -4)
MiniMapMailIcon:SetTexture("Interface\\AddOns\\Sora's\\Media\\Mail")
MiniMapMailBorder:Hide()

-- Enable mouse scrolling
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
	{text = CHARACTER_BUTTON,
	func = function() ToggleCharacter("PaperDollFrame") end},
	{text = SPELLBOOK_ABILITIES_BUTTON,
	func = function()
		if not SpellBookFrame:IsShown() then
			ShowUIPanel(SpellBookFrame)
		else
			HideUIPanel(SpellBookFrame)
		end
	end},
	{text = TALENTS_BUTTON,
	func = function()
		if not PlayerTalentFrame then
			LoadAddOn("Blizzard_TalentUI")
		end
		if not GlyphFrame then
			LoadAddOn("Blizzard_GlyphUI")
		end
		PlayerTalentFrame_Toggle()
	end},
	{text = TIMEMANAGER_TITLE,
	func = function() ToggleFrame(TimeManagerFrame) end},		
	{text = ACHIEVEMENT_BUTTON,
	func = function() ToggleAchievementFrame() end},
	{text = QUESTLOG_BUTTON,
	func = function() ToggleFrame(QuestLogFrame) end},
	{text = SOCIAL_BUTTON,
	func = function() ToggleFriendsFrame(1) end},
	{text = calendar_string,
	func = function() GameTimeFrame:Click() end},
	{text = PLAYER_V_PLAYER,
	func = function() ToggleFrame(PVPFrame) end},
	{text = ACHIEVEMENTS_GUILD_TAB,
	func = function()
		if IsInGuild() then
			if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end
			GuildFrame_Toggle()
		end
	end},
	{text = "地下城查找器",
	func = function() ToggleFrame(LFDParentFrame) end},
	{text = RAID_FINDER,
	func = function() RaidMicroButton:Click() end},
	{text = ENCOUNTER_JOURNAL, 
	func = function()
		if not IsAddOnLoaded("Blizzard_EncounterJournal") then
			LoadAddOn("Blizzard_EncounterJournal")
		end
		ToggleFrame(EncounterJournal)
	end},		
	{text = HELP_BUTTON,
	func = function() ToggleHelpFrame() end},
	{text = "打开背包",
	func = function() ToggleBackpack() end}, 
}

Minimap:SetScript("OnMouseUp", function(self, button)
	if button == "RightButton" then
		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	else
		Minimap_OnClick(self)
	end
end)
