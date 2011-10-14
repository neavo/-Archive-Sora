-- Engines
local S, _, _, DB = unpack(select(2, ...))
local ChatbarTable = {}
local IsChatFrameInScreen, NewWhisper = true, false
local MainBar = CreateFrame("Frame", nil, UIParent)

-- InitChatFramePanel
local function InitChatFramePanel()
	MainBar:SetPoint("TOPLEFT", ChatFrame1, "BOTTOMLEFT", 0, -6)
	MainBar:SetPoint("BOTTOMRIGHT", ChatFrame1, "BOTTOMRIGHT", 0, -24)
	MainBar:SetBackdrop({
		bgFile = DB.bgFile, insets = {left = 4, right = 4, top = 4, bottom = 4},
		edgeFile = DB.GlowTex, edgeSize = 3, 
	})
	MainBar:SetBackdropColor(0, 0, 0, 0.2)
	MainBar:SetBackdropBorderColor(0, 0, 0, 0.8)
	MainBar.Right = CreateFrame("Button", nil, MainBar)
	MainBar.Right:SetPoint("TOPLEFT", MainBar, "TOPRIGHT", 2, -1)
	MainBar.Right:SetPoint("BOTTOMRIGHT", MainBar, "BOTTOMRIGHT", 10, 1)
	S.Reskin(MainBar.Right)
	MainBar.Right:SetScript("OnMouseDown", function(self)
		if not UnitAffectingCombat("player") then
			if IsChatFrameInScreen then
				local Anchor, _, _, OriginalX, OriginalY = ChatFrame1:GetPoint()
				local Step, MaxStep = 0, 60
				local Length = ChatFrame1:GetWidth() + ChatFrame1:GetLeft()
				local Updater = CreateFrame("Frame")
				Updater:SetScript("OnUpdate", function(self, elapsed)
					Step = Step + 1
					ChatFrame1:SetPoint(Anchor, OriginalX - (Step/MaxStep)*Length, OriginalY)
					if Step >= MaxStep then
						self:SetScript("OnUpdate", nil)
						IsChatFrameInScreen = UnitAffectingCombat("player") and true or false
					end
				end)			
			else
				local Anchor, _, _, OriginalX, OriginalY = ChatFrame1:GetPoint()
				local Step, MaxStep = 0, 60
				local Length = ChatFrame1:GetWidth() + ChatFrame1:GetRight() + 5
				local Updater = CreateFrame("Frame")
				Updater:SetScript("OnUpdate", function(self, elapsed)
					Step = Step + 1
					ChatFrame1:SetPoint(Anchor, OriginalX + (Step/MaxStep)*Length, OriginalY)
					if Step >= MaxStep then
						self:SetScript("OnUpdate", nil)
						IsChatFrameInScreen = UnitAffectingCombat("player") and false or true
					end
				end)		
			end
		end
	end)
	MainBar.Right.Text = MainBar.Right:CreateFontString(nil, "ARTWORK")
	MainBar.Right.Text:SetFont(DB.Font, 11, "THINOUTLINE")
	MainBar.Right.Text:SetText("您有新的密语~")
	MainBar.Right.Text:SetTextColor(1, 0.5, 1, 1)
	MainBar.Right.Text:SetPoint("LEFT", MainBar.Right, "RIGHT", 5, 0)
	MainBar.Right.Text:SetAlpha(0)
end

-- InitChatbar
local function InitChatbar()
	local Channel = {"SAY", "YELL", "PARTY", "GUILD", "RAID"}
	local Color = {
		{255/255, 255/255, 255/255}, 
		{255/255,  64/255,  64/255}, 
		{170/255, 170/255, 255/255}, 
		{ 64/255, 255/255,  64/255}, 
		{255/255, 127/255,   0/255}, 
		{210/255, 180/255, 140/255}, 
		{160/255, 120/255,  90/255}, 
		{255/255, 255/255,   0/255}, 
	}

	for i=1, 7 do
		local Button = CreateFrame("Button", nil, MainBar)
		Button:SetWidth((MainBar:GetWidth()-10)/8)
		Button:SetHeight(12)
		Button:SetBackdrop({ 
			bgFile = DB.Statusbar, insets = {left = 3, right = 3, top = 3, bottom = 3}, 
			edgeFile = DB.GlowTex, edgeSize = 4, 
		}) 
		Button:SetBackdropColor(unpack(Color[i]))
		Button:SetBackdropBorderColor(0, 0, 0, 1)
		Button:SetAlpha(0.6)
		if i == 1 then
			Button:SetPoint("LEFT", MainBar, "LEFT", 5, 0)
		else
			Button:SetPoint("LEFT", ChatbarTable[i-1], "RIGHT", 0, 0)
		end
		Button:RegisterForClicks("AnyUp")
		Button:SetScript("OnClick", function() 
			EditBox = SELECTED_DOCK_FRAME.editBox
			if i <= 5 then
				ChatEdit_ActivateChat(EditBox)
				EditBox:SetAttribute("chatType", Channel[i]) 
				ChatEdit_UpdateHeader(EditBox)
			else
				ChatEdit_ActivateChat(EditBox)
				EditBox:SetAttribute("channelTarget", i-5)
				EditBox:SetAttribute("chatType", "CHANNEL")
				ChatEdit_UpdateHeader(EditBox) 
			end
		end)
		tinsert(ChatbarTable, Button)
	end

	local Button = CreateFrame("Button", nil, MainBar, "SecureActionButtonTemplate")
	Button:SetWidth((MainBar:GetWidth()-10)/8)
	Button:SetHeight(12)
	Button:SetBackdrop({ 
		bgFile = DB.Statusbar, insets = {left = 3, right = 3, top = 3, bottom = 3}, 
		edgeFile = DB.GlowTex, edgeSize = 4, 
	})
	Button:SetBackdropColor(unpack(Color[8]))
	Button:SetBackdropBorderColor(0, 0, 0, 1)
	Button:SetAlpha(0.6)
	Button:SetPoint("LEFT", ChatbarTable[7], "RIGHT", 0, 0)
	Button:RegisterForClicks("AnyUp")
	Button:SetAttribute("*type*", "macro")
	Button:SetAttribute("macrotext", "/roll")
	tinsert(ChatbarTable, Button)
	
	for i = 1, 10 do
		local EditBox = _G["ChatFrame"..i.."EditBox"]
		EditBox:SetScript("OnShow", function(self)
			for _,value in pairs(ChatbarTable) do
				UIFrameFadeOut(value, 0.5, 0.6, 0)
			end
		end)
		EditBox:SetScript("OnHide", function(self)
			for _,value in pairs(ChatbarTable) do
				UIFrameFadeIn(value, 0.5, 0, 0.6)
			end
		end)
	end
end

-- InitNewWhisper
local function UpdateNewWhisper(self, event, ...)
	if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER" then
		NewWhisper = true
	end
end
local function InitNewWhisper()
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", UpdateNewWhisper)	
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", UpdateNewWhisper)
end

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_LOGIN")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		InitChatFramePanel()
		InitChatbar()
		InitNewWhisper()
	elseif event == "PLAYER_ENTERING_WORLD" then
		SetCVar("chatStyle", "classic")
	end
end)
Event.Timer = 0
Event:SetScript("OnUpdate", function(self, elapsed)
	self.Timer = self.Timer + elapsed
	if self.Timer > 1.5 then
		self.Timer = 0
		if not IsChatFrameInScreen and NewWhisper then
			MainBar.Right:SetBackdropBorderColor(1, 0.5, 1, 1)
			MainBar.Right.Text:SetAlpha(1)
			UIFrameFadeOut(MainBar.Right, 1.2, 1, 0)
		else
			NewWhisper = false
			MainBar.Right:SetAlpha(1)
			MainBar.Right:SetBackdropBorderColor(0, 0, 0, 0.8)
			MainBar.Right.Text:SetAlpha(0)
		end
	end
end)
