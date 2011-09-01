----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.MapConfig


-----------
-- style --
-----------
local _, class = UnitClass('player')
local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]			

Minimap:SetMaskTexture("Interface\\Buttons\\WHITE8x8")
Minimap:SetFrameStrata("BACKGROUND")
Minimap:ClearAllPoints()
Minimap:SetPoint(unpack(cfg.MinimapPos))
Minimap:SetWidth(112)
Minimap:SetHeight(112)

LFDSearchStatus:SetClampedToScreen(true)

local BorderFrame = CreateFrame("Frame", nil, Minimap)
BorderFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -5, 5)
BorderFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 5, -5)	
BorderFrame:SetFrameLevel(0)
BorderFrame:SetBackdrop({ 
	edgeFile = cfg.GlowTex, edgeSize = 5, 
})
BorderFrame:SetBackdropBorderColor(0,0,0,1)		

---------------------
-- hide some stuff --
---------------------
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

---------------------
-- move some stuff --
---------------------

-- Tracking
MiniMapTrackingBackground:SetAlpha(0)
MiniMapTrackingButton:SetAlpha(0)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetFrameStrata("HIGH")
MiniMapTracking:SetFrameLevel("0")
MiniMapTracking:SetPoint("BOTTOMLEFT", Minimap,"TOPLEFT" ,-6, 5)
MiniMapTracking:SetScale(0.7)

-- BG icon
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("TOP", Minimap, "TOP", 2, 8)

-- Random Group icon
MiniMapLFGFrame:ClearAllPoints()
MiniMapLFGFrameBorder:SetAlpha(0)
MiniMapLFGFrame:SetPoint("TOP", Minimap, "TOP", 1, 8)
MiniMapLFGFrame:SetFrameStrata("MEDIUM")

-- Instance Difficulty flag
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
MiniMapInstanceDifficulty:SetScale(0.75)
MiniMapInstanceDifficulty:SetFrameStrata("LOW")

-- Guild Instance Difficulty flag
GuildInstanceDifficulty:ClearAllPoints()
GuildInstanceDifficulty:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 2, 2)
GuildInstanceDifficulty:SetScale(0.75)
GuildInstanceDifficulty:SetFrameStrata("LOW")

-- Invites Icon
GameTimeCalendarInvitesTexture:ClearAllPoints()
GameTimeCalendarInvitesTexture:SetParent("Minimap")
GameTimeCalendarInvitesTexture:SetPoint("TOPRIGHT")

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

---------------------
--   鼠标滚轮缩放  --
---------------------
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, z)
	local c = Minimap:GetZoom()
	if(z > 0 and c < 5) then
		Minimap:SetZoom(c + 1)
	elseif(z < 0 and c > 0) then
		Minimap:SetZoom(c - 1)
	end
end)

---------------------
-- 小地图右键菜单  --
---------------------

local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
    {text = "角色",
    func = function() ToggleCharacter("PaperDollFrame") end},
    {text = "技能",
    func = function() if InCombatLockdown() then return end ToggleFrame(SpellBookFrame) end},
    {text = "天赋",
    func = function() if not PlayerTalentFrame then LoadAddOn("Blizzard_TalentUI") end if not GlyphFrame then LoadAddOn("Blizzard_GlyphUI") end PlayerTalentFrame_Toggle() end},
    {text = "成就",
    func = function() ToggleAchievementFrame() end},
    {text = "任务",
    func = function() ToggleFrame(QuestLogFrame) end},
    {text = "社交",
    func = function() ToggleFriendsFrame(1) end},
    {text = "PVP",
    func = function() ToggleFrame(PVPFrame) end},
    {text = "公会",
    func = function() if IsInGuild() then if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end GuildFrame_Toggle() end end},
    {text = "帮助",
    func = function() ToggleHelpFrame() end},
    {text = "日历",
    func = function()
    if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
        Calendar_Toggle()
    end},
    {text = "寻求组队",
    func = function() ToggleFrame(LFDParentFrame) end},
	{text = "系统菜单",
	func = function() ToggleFrame(GameMenuFrame) end},
	{text = "宏命令设置",
    func = function() ToggleFrame(MacroFrame) end},
}

Minimap:SetScript("OnMouseUp", function(self, btn)
	local position = Minimap:GetPoint()
	if btn == "RightButton" then
		if position:match("LEFT") then
			EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
		else
			EasyMenu(menuList, menuFrame, "cursor", -160, 0, "MENU", 2)
		end
	else
		Minimap_OnClick(self)
	end
end)

------------------------
--   小地图图标整合   --
------------------------


local g = getfenv(0)

local notbuttons = {
	['DA_Minimap'] = true,
	['TimeManagerClockButton'] = true,
	['MinimapZoomIn'] = true,
	['MinimapZoomOut'] = true,
	['GameTimeFrame'] = true,
	['MiniMapTrackingButton'] = true,
	['MiniMapTrackingDropDownButton'] = true,
	['MiniMapTracking'] = true,
	['MiniMapBattlefieldFrame'] = true,
	['MiniMapBattlefieldDropDownButton'] = true,
	['MiniMapLFGFrame'] = true,
	['MiniMapLFGFrameDropDownButton'] = true,
	['MiniMapLFGFrameBorder'] = true,
	['MiniMapInstanceDifficulty'] = true,
	['GuildInstanceDifficulty'] = true,
	['MiniMapMailFrame'] = true,
	['MiniMapMailIcon'] = true,
	['GameTimeCalendarInvitesTexture'] = true,
	['FeedbackUIButton'] = true,
	['StreamingIcon'] = true,
}

local addon = CreateFrame('Frame', 'NBB', UIParent)

local isMinimapButton = function(frame)
	if frame and frame:GetObjectType() == 'Button' and frame:GetNumRegions() >= 3 then
		return true
	end
end

function addon:findButtons(frame)
	for i, child in ipairs({frame:GetChildren()}) do
		local name = child:GetName()
		if isMinimapButton(child) and not self.settings.skip[name] and not notbuttons[name] then
			self:addButton(child)
		else
			self:findButtons(child)
		end
	end
end

function addon:findSpecialButtons()
	for button, get in pairs(self.settings.special) do
		if g[button] and get == true then
			self:addButton(g[button])
		end
	end
end

function addon:addButton(button)
	if button:GetParent() ~= self then
		button:SetParent(self)
	end
end

function addon:scan()
	self:findButtons(Minimap)
	self:findSpecialButtons()
	self:updatePositions()
end

-- Delay the scan call with a onupdate handler
local time = 0
local onUpdate = function(self, elapsed)
	time = time + elapsed
	if time > 5 then
		time = 0
		self:scan()
		self:SetScript('OnUpdate', nil)
	end
end

function addon:delayedScan()
	self:SetScript('OnUpdate', onUpdate)
end

function addon:updatePositions()
	self:SetWidth(0)
	self:SetHeight(0)

	local prev = self
	for i, button in ipairs({self:GetChildren()}) do
		if button:IsVisible() then
		
			if prev == self then 
				button:ClearAllPoints()
				button:SetPoint("TOPLEFT",Minimap,"BOTTOMRIGHT",10,0)
			else
				button:ClearAllPoints()
				button:SetPoint("LEFT", prev, "RIGHT", 1, 0)
			end

			-- Stop it from being draggable
			button:SetScript('OnDragStart', nil)
			button:SetScript('OnDragStop', nil)

			-- Update width and height
			if button:GetHeight() > self:GetHeight() then 
				self:SetWidth(self:GetWidth() + button:GetWidth())
				self:SetHeight(button:GetHeight())
			else
				self:SetWidth(self:GetWidth() + button:GetWidth())
				self:SetHeight(self:GetHeight())
			end
			prev = button
		end
	end
	addon:Hide()
end

function addon:enable(settings)
	self.settings = settings
	self:SetScript('OnEvent', self.delayedScan)
	self:RegisterEvent'PLAYER_LOGIN'
	self:RegisterEvent'ADDON_LOADED'
	self:RegisterEvent'UPDATE_BATTLEFIELD_STATUS'
end


NBB:enable({
	-- Let these buttons stay on the minimap
	skip = {
		['MiniMapWorldMapButton'] = true,
		['MiniMapBattlefieldFrame'] = true,
		['Zframe'] = true
	},

	-- If a minimap button is not picked
	-- up automagically, add it here
	special = {
		['OutfitterMinimapButton'] = true,
	}
})
