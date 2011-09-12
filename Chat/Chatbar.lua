-- A simple quick chatbar,with low memory cost :)
-- Creat Date : July,20,2011
-- Email : Neavo7@gmail.com
-- Version : 0.1

----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.ChatConfig



local Channel = {"/s ","/y ","/p ","/g ","/raid ","/1 ","/2 "}
local Color = {
	{255/255, 255/255, 255/255, 0.8},
	{255/255,  64/255,  64/255, 0.8},
	{170/255, 170/255, 255/255, 0.8},
	{ 64/255, 255/255,  64/255, 0.8},
	{255/255, 127/255,   0/255, 0.8},
	{210/255, 180/255, 140/255, 0.8},
	{160/255, 120/255,  90/255, 0.8},
	{255/255, 255/255,   0/255, 0.8},
}

local Chatbar = CreateFrame("Frame","Chatbar")
Chatbar:SetWidth(320)
Chatbar:SetHeight(13)
Chatbar:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", 10, -9)

for i=1,7 do
	local frame = CreateFrame("Button", "ChatBarButton"..i , Chatbar)
	frame:SetWidth(40)
	frame:SetHeight(Chatbar:GetHeight())
	if i == 1 then
		frame:SetPoint("LEFT",Chatbar,"LEFT",0,0)
	else
		frame:SetPoint("LEFT","ChatBarButton"..i-1,"RIGHT",0,0)
	end
	frame:SetBackdrop( { 
		bgFile = cfg.Statusbar,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
		edgeFile = cfg.GlowTex, edgeSize = 4, 
	}) 
	frame:SetBackdropColor(unpack(Color[i]))
	frame:SetBackdropBorderColor(0,0,0,1)	
	frame:RegisterForClicks("AnyUp")
	frame:SetScript("OnClick", function() 
		ChatFrame_OpenChat(Channel[i], chatFrame)
	end)
end

-- Roll
local roll = CreateFrame("Button",nil, Chatbar, "SecureActionButtonTemplate")
roll:SetAttribute("*type*", "macro")
roll:SetAttribute("macrotext", "/roll")
roll:SetWidth(40)
roll:SetHeight(Chatbar:GetHeight())
roll:SetPoint("RIGHT",Chatbar,"RIGHT",0,0)
roll:SetBackdrop( { 
	bgFile = cfg.Statusbar,
	insets = { left = 3, right = 3, top = 3, bottom = 3 },
	edgeFile = cfg.GlowTex, edgeSize = 4, 
})
roll:SetBackdropColor(unpack(Color[8]))
roll:SetBackdropBorderColor(0,0,0,1)	
roll:RegisterForClicks("AnyUp")

-- Event
local Event = ChatFrame1EditBox
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("OnEvent",function(self, event, ...)
	SetCVar("chatStyle","classic")
end)
Event:SetScript("OnShow",function(self)
	if _G["MainBar"]:GetAlpha() > 0.9 then
		UIFrameFadeOut(Chatbar, 0.5, 0.6, 0)
	end
end)
Event:SetScript("OnHide",function(self)
	if _G["MainBar"]:GetAlpha() > 0.9 then
		UIFrameFadeIn(Chatbar, 0.5, 0, 0.6)
	end
end)




