----------------
-- Engines
local _, _, _, DB = unpack(select(2, ...))

CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18}

--other variables
local tscol = "64C2F5"						-- Timestamp coloring
local TimeStampsCopy = true					-- Enables special time stamps in chat allowing you to copy the specific line from your chat window by clicking the stamp
local LinkHover = {}; LinkHover.show = {	-- enable (true) or disable (false) LinkHover functionality for different things in chat
	["achievement"] = true, 
	["enchant"]     = true, 
	["glyph"]       = true, 
	["item"]        = true, 
	["quest"]       = true, 
	["spell"]       = true, 
	["talent"]      = true, 
	["unit"]        = true, }

-- 打开输入框回到上次对话
ChatTypeInfo["SAY"].sticky        = 1 -- 说
ChatTypeInfo["PARTY"].sticky 	  = 1 -- 小队
ChatTypeInfo["GUILD"].sticky 	  = 1 -- 公会
ChatTypeInfo["WHISPER"].sticky 	  = 0 -- 密语
ChatTypeInfo["BN_WHISPER"].sticky = 0 -- 实名密语
ChatTypeInfo["RAID"].sticky 	  = 1 -- 团队
ChatTypeInfo["OFFICER"].sticky    = 1 -- 官员
ChatTypeInfo["CHANNEL"].sticky 	  = 0 -- 频道

do
	local function kill(frame)
		if frame.UnregisterAllEvents then frame:UnregisterAllEvents()
		end
		frame.Show = function() end
		frame:Hide()
	end

	-- Buttons Hiding/moving 
	ChatFrameMenuButton:Hide()
	ChatFrameMenuButton:SetScript("OnShow", kill)
	FriendsMicroButton:Hide()
	FriendsMicroButton:SetScript("OnShow", kill)

	for i=1, 10 do
		local cf = _G[format("%s%d", "ChatFrame", i)]
		
		-- 渐隐
		cf:SetFading(false)
		-- 间距
		cf:SetSpacing(2)
	
		-- Hide chat textures
		for j = 1, #CHAT_FRAME_TEXTURES do _G["ChatFrame"..i..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil) end
		--Unlimited chatframes resizing
		cf:SetMinResize(0, 0)
		cf:SetMaxResize(0, 0)
	
		--Allow the chat frame to move to the end of the screen
		cf:SetClampedToScreen(false)
		cf:SetClampRectInsets(0, 0, 0, 0)
		
		-- 聊天框体标签
		_G["ChatFrame"..i.."TabText"].SetTextColor = function() end
		_G["ChatFrame"..i.."TabText"]:SetFont(DB.Font, 10, "THINOUTLINE")
		
		kill(_G["ChatFrame"..i.."TabLeft"])
		kill(_G["ChatFrame"..i.."TabMiddle"])
		kill(_G["ChatFrame"..i.."TabRight"])
		kill(_G["ChatFrame"..i.."TabSelectedLeft"])
		kill(_G["ChatFrame"..i.."TabSelectedMiddle"])
		kill(_G["ChatFrame"..i.."TabSelectedRight"])
		kill(_G["ChatFrame"..i.."TabHighlightLeft"])
		kill(_G["ChatFrame"..i.."TabHighlightMiddle"])
		kill(_G["ChatFrame"..i.."TabHighlightRight"])
		kill(_G["ChatFrame"..i.."TabSelectedLeft"])
		kill(_G["ChatFrame"..i.."TabSelectedMiddle"])
		kill(_G["ChatFrame"..i.."TabSelectedRight"])
		kill(_G["ChatFrame"..i.."TabGlow"])
		
		local Tab = _G["ChatFrame"..i.."Tab"]
		Tab.leftSelectedTexture:Hide()
		Tab.middleSelectedTexture:Hide()
		Tab.rightSelectedTexture:Hide()
		Tab.leftSelectedTexture.Show = Tab.leftSelectedTexture.Hide
		Tab.middleSelectedTexture.Show = Tab.middleSelectedTexture.Hide
		Tab.rightSelectedTexture.Show = Tab.rightSelectedTexture.Hide
		
		--EditBox Module
		local ebParts = {"Left", "Mid", "Right"}
		local EditBox = _G["ChatFrame"..i.."EditBox"]
		for _, ebPart in ipairs(ebParts) do
			_G["ChatFrame"..i.."EditBox"..ebPart]:SetTexture(nil)
			local ebed = _G["ChatFrame"..i.."EditBoxFocus"..ebPart]
			ebed:SetTexture(nil)
		end
		_G["ChatFrame"..i.."EditBoxLanguage"]:ClearAllPoints()
		EditBox:SetAltArrowKeyMode(false)
		EditBox:ClearAllPoints()
		EditBox:SetFont(DB.Font, 12, "THINOUTLINE")
		EditBox:SetPoint("TOPLEFT", cf, "BOTTOMLEFT", -8, -6)
		EditBox:SetPoint("BOTTOMRIGHT", cf, "BOTTOMRIGHT", 8, -22)
		EditBox:EnableMouse(false)
		
		-- 聊天框缩放按钮
		local resize = _G["ChatFrame"..i.."ResizeButton"]
		resize:SetPoint("BOTTOMRIGHT", cf, "BOTTOMRIGHT", 5, -9) 
	
		--Remove scroll buttons
		local bf = _G["ChatFrame"..i.."ButtonFrame"]
		bf:Hide()
		bf:SetScript("OnShow",  kill)
	
		--Scroll to the bottom button
		local bb = _G["ChatFrame"..i.."ButtonFrameBottomButton"]
		bb:Hide()
	end
end

---------------- > Enable/Disable mouse for editbox
hooksecurefunc("ChatFrame_OpenChat", function()
	for i =1, 10 do
		local eb = _G["ChatFrame"..i.."EditBox"]
		eb:EnableMouse(true)
	end
end)
hooksecurefunc("ChatEdit_SendText", function()
	for i =1, 10 do
		local eb = _G["ChatFrame"..i.."EditBox"]
		eb:EnableMouse(false)
	end
end)

--  快速翻页
FloatingChatFrame_OnMouseScroll = function(self, dir)
	if dir > 0 then
		if IsControlKeyDown()then
			self:ScrollToTop()
		elseif IsShiftKeyDown() then
		self:ScrollUp()
		self:ScrollUp()
		self:ScrollUp()
		else
		self:ScrollUp()
		end
	else
		if IsControlKeyDown() then
			self:ScrollToBottom()
		elseif IsShiftKeyDown() then
			self:ScrollDown()
			self:ScrollDown()
			self:ScrollDown()
		else
			self:ScrollDown()
		end
	end
end


---------------- > afk/dnd msg filter
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function(msg) return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function(msg) return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function(msg) return true end)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function(msg) return true end)


--  聊天复制
local _AddMessage = ChatFrame1.AddMessage
local _SetItemRef = SetItemRef
local blacklist = {
	[ChatFrame2] = true, 
}

local ts = "|cff68ccef|HyCopy|h%s|h|r %s"
local AddMessage = function(self, text, ...)
	if(type(text) == "string") then
        if showtime then
          text = format(ts, date"%H:%M", text)  --text = format(ts, date"%H:%M:%S", text)
        else
	  text = format(ts, "★", text)
       end
end

	return _AddMessage(self, text, ...)
end

for i=1, NUM_CHAT_WINDOWS do
	local cf = _G["ChatFrame"..i]
	if(not blacklist[cf]) then
		cf.AddMessage = AddMessage
	end
end

local MouseIsOver = function(frame)
	local s = frame:GetParent():GetEffectiveScale()
	local x, y = GetCursorPosition()
	x = x / s
	y = y / s

	local left = frame:GetLeft()
	local right = frame:GetRight()
	local top = frame:GetTop()
	local bottom = frame:GetBottom()

	if(not left) then
		return
	end

	if((x > left and x < right) and (y > bottom and y < top)) then
		return 1
	else
		return
	end
end

local borderManipulation = function(...)
	for l = 1, select("#", ...) do
		local obj = select(l, ...)
		if(obj:GetObjectType() == "FontString" and MouseIsOver(obj)) then
			return obj:GetText()
		end
	end
end

local eb = ChatFrame1EditBox
SetItemRef = function(link, text, button, ...)
	if(link:sub(1, 5) ~= "yCopy") then return _SetItemRef(link, text, button, ...) end

	local text = borderManipulation(SELECTED_CHAT_FRAME:GetRegions())
	if(text) then
		text = text:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
		text = text:gsub("|H.-|h(.-)|h", "%1")

		eb:Insert(text)
		eb:Show()
		eb:HighlightText()
		eb:SetFocus()
	end
end

--  屏蔽系统错误输出框中: 能量不足，技能未准备好等信息

local hooks = {}
local blacklist = {
	SPELL_FAILED_NO_COMBO_POINTS,   -- That ability requires combo points
	SPELL_FAILED_TARGETS_DEAD,      -- Your target is dead
	SPELL_FAILED_SPELL_IN_PROGRESS, -- Another action is in progress
	SPELL_FAILED_TARGET_AURASTATE,  -- You can"t do that yet. (TargetAura)
	SPELL_FAILED_CASTER_AURASTATE,  -- You can"t do that yet. (CasterAura)
	SPELL_FAILED_NO_ENDURANCE,      -- Not enough endurance
	SPELL_FAILED_BAD_TARGETS,       -- Invalid target
	SPELL_FAILED_NOT_MOUNTED,       -- You are mounted
	SPELL_FAILED_NOT_ON_TAXI,       -- You are in flight
	SPELL_FAILED_NOT_INFRONT,       -- You must be in front of your target
	SPELL_FAILED_NOT_IN_CONTROL,    -- You are not in control of your actions
	SPELL_FAILED_MOVING,            -- Can"t do that while moving
	ERR_ATTACK_FLEEING, 			-- Can"t attack while fleeing.
	ERR_ITEM_COOLDOWN, 				-- Item is not ready yet.
	ERR_GENERIC_NO_TARGET,          -- You have no target.
	ERR_ABILITY_COOLDOWN,           -- Ability is not ready yet.
	ERR_OUT_OF_ENERGY,              -- Not enough energy
	ERR_NO_ATTACK_TARGET,           -- There is nothing to attack.
	ERR_SPELL_COOLDOWN,             -- Spell is not ready yet. (Spell)
	ERR_OUT_OF_RAGE,                -- Not enough rage.
	ERR_INVALID_ATTACK_TARGET,      -- You cannot attack that target.
	ERR_OUT_OF_MANA,                -- Not enough mana
	ERR_NOEMOTEWHILERUNNING,        -- You can"t do that while moving!
	OUT_OF_ENERGY,                  -- Not enough energy.
}

hooks["UIErrorsFrame_AddMessage"] = UIErrorsFrame.AddMessage
UIErrorsFrame.AddMessage = function(...)
	for k, v in ipairs(blacklist) do
		if v==arg1 then return end
	end
	hooks["UIErrorsFrame_AddMessage"](...)
end

SlashCmdList["ReloadUI"] = function() ReloadUI() end
SLASH_ReloadUI1 = "/rl"