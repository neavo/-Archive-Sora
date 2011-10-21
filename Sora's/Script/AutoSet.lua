--  自动设置聊天框体和UI缩放
local function SetChatFrame()
	FCF_SetLocked(ChatFrame1, nil)
	FCF_SetChatWindowFontSize(self, ChatFrame1, 11) 
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT", 5, 25)
	ChatFrame1:SetWidth(360)
	ChatFrame1:SetHeight(100)
	ChatFrame1:SetUserPlaced(true)
	for i=1,10 do FCF_SetWindowAlpha(_G["ChatFrame"..i], 0) end
	FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, 1)
end
local function SetUIScale()
	SetCVar("useUiScale", 1)
	local scale = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
	if scale < 0.64 then
		UIParent:SetScale(scale)
	else
		SetCVar("uiScale", scale)
	end
end
SlashCmdList["AutoSet"] = function()
	if not UnitAffectingCombat("player") then
		SetChatFrame()
		SetUIScale()
		--ReloadUI()
	end
end
SLASH_AutoSet1 = "/AutoSet"