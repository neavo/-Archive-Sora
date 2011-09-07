-- 隐藏小队框体
function HideParty()

	for i = 1, MAX_PARTY_MEMBERS do
		local party = _G['PartyMemberFrame'..i]
		party:UnregisterAllEvents()
		party:Hide()
		party.Show = function() end
	end
	UIParent:UnregisterEvent('RAID_ROSTER_UPDATE')
end
HideParty()

-- 隐藏BOSS框体 --

function hideBossFrames()
	for i = 1, 4 do
		local frame = _G["Boss"..i.."TargetFrame"]
		frame:UnregisterAllEvents()
		frame.Show = function () end
		frame:Hide()
	end
end
hideBossFrames()

-- 移动任务追踪框体 --

local function WatchFrameMove()
	local Temp = _G['WatchFrame']
    Temp:ClearAllPoints()	
    Temp.ClearAllPoints = function() end
    Temp:SetPoint("RIGHT","UIParent","RIGHT",-5,30)
    Temp.SetPoint = function() end
	Temp:SetHeight(400)  
end
WatchFrameMove() 


-- 屏蔽系统红字提示 --

local event = CreateFrame("Frame")
local dummy = function() end

UIErrorsFrame:UnregisterEvent"UI_ERROR_MESSAGE"
event.UI_ERROR_MESSAGE = function(self, event, error)
	if not stuff[error] then
		UIErrorsFrame:AddMessage(error, 1, .1, .1)
	end
end	
event:RegisterEvent"UI_ERROR_MESSAGE"

--  UI缩放修正  --
SlashCmdList["AutoSet"] = function()
	if not InCombatLockdown() then
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
	
