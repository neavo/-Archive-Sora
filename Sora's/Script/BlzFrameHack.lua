-- 隐藏小队框体
for i = 1, MAX_PARTY_MEMBERS do
	local PartyMemberFrame = _G["PartyMemberFrame"..i]
	PartyMemberFrame:UnregisterAllEvents()
	PartyMemberFrame:Hide()
	PartyMemberFrame.Show = function() end
end
UIParent:UnregisterEvent("RAID_ROSTER_UPDATE")

-- 隐藏BOSS框体
for i = 1, 4 do
	local BossFrame = _G["Boss"..i.."TargetFrame"]
	BossFrame:UnregisterAllEvents()
	BossFrame.Show = function () end
	BossFrame:Hide()
end

-- 移动任务追踪框体
local WatchFrame = _G["WatchFrame"]
WatchFrame:ClearAllPoints()	
WatchFrame.ClearAllPoints = function() end
WatchFrame:SetPoint("RIGHT", UIParent, -20, -10)
WatchFrame.SetPoint = function() end
WatchFrame:SetHeight(400)  


-- 屏蔽系统红字提示
local Event = CreateFrame("Frame")
UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
Event.UI_ERROR_MESSAGE = function(self, event, error)
	if not stuff[error] then
		UIErrorsFrame:AddMessage(error, 1, .1, .1)
	end
end	
Event:RegisterEvent("UI_ERROR_MESSAGE")

-- 实名好友弹窗位置修正
BNToastFrame:HookScript("OnShow", function(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "TOPLEFT", 0, 0)
end)