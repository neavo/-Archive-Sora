-- 隐藏小队框体
for i = 1, MAX_PARTY_MEMBERS do
	local party = _G['PartyMemberFrame'..i]
	party:UnregisterAllEvents()
	party:Hide()
	party.Show = function() end
end
UIParent:UnregisterEvent('RAID_ROSTER_UPDATE')


-- 隐藏BOSS框体
for i = 1, 4 do
	local frame = _G["Boss"..i.."TargetFrame"]
	frame:UnregisterAllEvents()
	frame.Show = function () end
	frame:Hide()
end

-- 移动任务追踪框体
local function WatchFrameMove()
	local Temp = _G['WatchFrame']
    Temp:ClearAllPoints()	
    Temp.ClearAllPoints = function() end
    Temp:SetPoint("RIGHT", UIParent, "RIGHT", -5, -10)
    Temp.SetPoint = function() end
	Temp:SetHeight(400)  
end
WatchFrameMove() 


-- 屏蔽系统红字提示 --
local Event = CreateFrame("Frame")
UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
Event.UI_ERROR_MESSAGE = function(self, event, error)
	if not stuff[error] then
		UIErrorsFrame:AddMessage(error, 1, .1, .1)
	end
end	
Event:RegisterEvent("UI_ERROR_MESSAGE")

--  UI缩放修正  --
SlashCmdList["AutoSet"] = function()
	if not UnitAffectingCombat("player") then
		FCF_SetLocked(ChatFrame1, nil)
		FCF_SetChatWindowFontSize(self, ChatFrame1, 11) 
		ChatFrame1:ClearAllPoints()
		ChatFrame1:SetPoint("BOTTOMLEFT", 5, 23)
		ChatFrame1:SetWidth(320)
		ChatFrame1:SetHeight(100)
		ChatFrame1:SetUserPlaced(true)
		for i=1,10 do FCF_SetWindowAlpha(_G["ChatFrame"..i], 0) end
		FCF_SavePositionAndDimensions(ChatFrame1)
		FCF_SetLocked(ChatFrame1, 1)
		SetCVar("useUiScale", 1)
		local scale = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
		if scale < .64 then
			UIParent:SetScale(scale)
		else
			SetCVar("uiScale", scale)
		end
		ReloadUI()
	end
end
SLASH_AutoSet1 = "/AutoSet"
	
