----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.MapConfig

local NBBVisible

-- 顶部(区域信息)
local TMFrame = CreateFrame("Frame", nil, Minimap)
TMFrame:SetHeight(16)
TMFrame:SetWidth(Minimap:GetWidth())
TMFrame:SetPoint("BOTTOM", Minimap, "TOP", 0, 3)
TMFrame:SetBackdrop( { 
	edgeFile = cfg.Solid, edgeSize = 1, 
})
TMFrame:SetBackdropBorderColor(0, 0, 0, 1)
TMFrame:SetAlpha(0.2)
TMFrame:SetScript("OnEnter", function(self)
	self:SetAlpha(1)
end)
TMFrame:SetScript("OnLeave", function(self)
	self:SetAlpha(0.2)
end)
TMFrame.Text = TMFrame:CreateFontString(nil, "OVERLAY")
TMFrame.Text:SetPoint("CENTER", TMFrame, "CENTER", 0, 0)
TMFrame.Text:SetFont(cfg.Font, 10, "THINOUTLINE")

MiniMapTrackingBackground:Hide()
MiniMapTrackingButton:SetAlpha(0)
MiniMapTracking:SetParent(TMFrame)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetFrameStrata("HIGH")
MiniMapTracking:SetFrameLevel("0")
MiniMapTracking:SetPoint("LEFT", TMFrame, "LEFT" , 3, 0)
MiniMapTracking:SetScale(0.7)

-- 底部中央(坐标)
local BMFrame = CreateFrame("Frame", "BMFrame", Minimap)
BMFrame:SetHeight(16)
BMFrame:SetWidth(Minimap:GetWidth())
BMFrame:SetPoint("TOP", Minimap, "BOTTOM", 0, -3)
BMFrame:SetBackdrop({edgeFile = cfg.Solid, edgeSize = 1})
BMFrame:SetBackdropBorderColor(0, 0, 0, 1)
BMFrame:SetAlpha(0.2)
BMFrame:SetScript("OnEnter", function(self)
	self:SetAlpha(1)
end)
BMFrame:SetScript("OnLeave", function(self)
	self:SetAlpha(0.2)
end)
BMFrame.Text = BMFrame:CreateFontString(nil, "OVERLAY")
BMFrame.Text:SetPoint("CENTER", BMFrame, "CENTER", 0, 0)
BMFrame.Text:SetFont(cfg.Font, 10, "THINOUTLINE")

-- 底部左边(团队菜单)
local BLFrame = CreateFrame("Button", nil, BMFrame, "SecureActionButtonTemplate")
BLFrame:SetSize(16, 16)
BLFrame:SetAttribute("type", "macro")
BLFrame:SetAttribute("macrotext1", "/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton")
BLFrame:SetPoint("LEFT", BMFrame, "LEFT", 0, 0)
BLFrame:SetScript("OnEnter", function(self)
	BMFrame:SetAlpha(1)
	BLFrame.Text:SetTextColor(1, 0, 0)
end)
BLFrame:SetScript("OnLeave", function(self)
	BMFrame:SetAlpha(0.2)
	BLFrame.Text:SetTextColor(1, 1, 1)
end)
BLFrame.Text = BLFrame:CreateFontString(nil, "OVERLAY")
BLFrame.Text:SetPoint("CENTER", BLFrame, "CENTER", 0, 0)
BLFrame.Text:SetFont(cfg.Font, 9, "THINOUTLINE")
BLFrame.Text:SetText("G")
BLFrame.RaidMenuFrame = CreateFrame("Frame", "RaidMenu", UIParent, "UIDropDownMenuTemplate")
BLFrame:SetScript("OnMouseDown", function(self, button)
	if button == "RightButton" then
		EasyMenu({
			{text = "就位确认", func = function() DoReadyCheck() end}, 
			{text = "角色检查", func = function() InitiateRolePoll() end}, 
			{text = "转化为团队", func = function() ConvertToRaid() end}, 
			{text = "转化为小队", func = function() ConvertToParty() end}},
		self.RaidMenuFrame, "cursor", 0, 0, "MENU", 2)
	end
	PlaySound("igMiniMapOpen")
end)
DropDownList1:SetClampedToScreen(true)

-- 底部右边(NBB)
local BRFrame = CreateFrame("Frame", nil, BMFrame)
BRFrame:SetHeight(16)
BRFrame:SetWidth(16)
BRFrame:SetPoint("RIGHT", BMFrame, "RIGHT", 0, 0)
BRFrame:SetScript("OnEnter", function(self)
	BMFrame:SetAlpha(1)
	BRFrame.Text:SetTextColor(1, 0, 0)
end)
BRFrame:SetScript("OnLeave", function(self)
	BMFrame:SetAlpha(0.2)
	BRFrame.Text:SetTextColor(1, 1, 1)
end)
BRFrame:SetScript("OnMouseDown", function(self)
		if NBBVisible then
			NBB:Hide()
		else
			NBB:Show()
		end
		PlaySound("igMiniMapOpen")
end)
BRFrame.Text = BRFrame:CreateFontString(nil, "OVERLAY")
BRFrame.Text:SetPoint("CENTER", BRFrame, "CENTER", 0, 0)
BRFrame.Text:SetFont(cfg.Font, 9, "THINOUTLINE")
BRFrame.Text:SetText("B")

-- Updater
local Timer = 0
local Updater = CreateFrame("Frame")
Updater:SetScript("OnUpdate", function(self, elapsed)
    Timer = Timer + elapsed
    if Timer > 1 then
        Timer = 0
		
		-- 区域信息
		local zone = GetMinimapZoneText()		
        TMFrame.Text:SetText(zone)
		
		-- 坐标
		local x, y = GetPlayerMapPosition("player")
		BMFrame.Text:SetText(format("|　%.2d  :  %.2d　|", 100*x, 100*y))
		
		-- NBB
		if NBB:IsVisible() then
			NBBVisible = true
		else
			NBBVisible = false
		end

    end
end)





