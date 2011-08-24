----------------
--  命名空间  --
----------------

local _, SR = ...
cfg = SR.ChatConfig





------------------
--  聊天主框体  --
------------------

for i = 1, NUM_CHAT_WINDOWS do

	-- 聊天框体
    _G["ChatFrame"..i]:SetSpacing(3)	
	_G["ChatFrame"..i]:SetClampRectInsets(0,0,0,0)
    _G["ChatFrame"..i]:SetFrameStrata("LOW")
	
	for t = 1, #CHAT_FRAME_TEXTURES do
		_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[t]]:SetTexture(nil)
	end
	
	-- 输入框
	_G["ChatFrame"..i.."EditBox"]:SetFont(cfg.Font, 13, "THINOUTLINE")
    _G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false)
	
	_G["ChatFrame"..i.."EditBox"]:SetPoint("TOPLEFT", _G["ChatFrame"..i], "BOTTOMLEFT", -10, -10)
	_G["ChatFrame"..i.."EditBox"]:SetPoint("TOPRIGHT", _G["ChatFrame"..i], "BOTTOMRIGHT", 10, -10)
	_G["ChatFrame"..i.."EditBox"]:SetPoint("BOTTOMLEFT", _G["ChatFrame"..i], "BOTTOMLEFT", -10, -26)
	_G["ChatFrame"..i.."EditBox"]:SetPoint("BOTTOMRIGHT", _G["ChatFrame"..i], "BOTTOMRIGHT", 10, -26)
	
	_G["ChatFrame"..i.."EditBox"]:SetScale(0.9)
	
	local tex = ({ _G["ChatFrame"..i.."EditBox"]:GetRegions() })
	for t = 6,11 do
		tex[t]:SetAlpha(0)
	end
	
	_G["ChatFrame"..i.."EditBoxLanguage"]:ClearAllPoints()
	
	-- 打开输入框回到上次对话
	ChatTypeInfo["SAY"].sticky        = 1 -- 说
	ChatTypeInfo["PARTY"].sticky 	  = 1 -- 小队
	ChatTypeInfo["GUILD"].sticky 	  = 1 -- 公会
	ChatTypeInfo["WHISPER"].sticky 	  = 0 -- 密语
	ChatTypeInfo["BN_WHISPER"].sticky = 0 -- 实名密语
	ChatTypeInfo["RAID"].sticky 	  = 1 -- 团队
	ChatTypeInfo["OFFICER"].sticky    = 1 -- 官员
	ChatTypeInfo["CHANNEL"].sticky 	  = 0 -- 频道

	-- 聊天框体标签
	_G["ChatFrame"..i.."Tab"]:SetScale(0.9)
	_G["ChatFrame"..i.."TabMiddle"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabRight"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabLeft"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabSelectedMiddle"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabSelectedRight"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabSelectedLeft"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabHighlightMiddle"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabHighlightRight"]:SetTexture(nil)
	_G["ChatFrame"..i.."TabHighlightLeft"]:SetTexture(nil)

	-- 聊天框缩放按钮
    _G["ChatFrame"..i.."ResizeButton"]:SetPoint("BOTTOMRIGHT", _G["ChatFrame"..i], "BOTTOMRIGHT", 5,-9)
    _G["ChatFrame"..i.."ResizeButton"]:SetScale(0.8)
	
end

--隐藏社交按钮和聊天菜单按钮
FriendsMicroButton:Hide()
FriendsMicroButton:ClearAllPoints()
ChatFrameMenuButton:Hide()
ChatFrameMenuButton:ClearAllPoints()
BNToastFrame:SetClampedToScreen(true)

----------------
--  快速翻页  --
----------------

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

----------------
--  聊天复制  --
----------------

local _AddMessage = ChatFrame1.AddMessage
local _SetItemRef = SetItemRef
local blacklist = {
	[ChatFrame2] = true,
}

local ts = "|cff68ccef|HyCopy|h%s|h|r %s"
local AddMessage = function(self, text, ...)
	if type(text) == "string"then
		text = format(ts, "★", text)
	end
	return _AddMessage(self, text, ...)
end

for i=1, NUM_CHAT_WINDOWS do
	local chatframe = _G["ChatFrame"..i]
	if not blacklist[chatframe] then
		chatframe.AddMessage = AddMessage
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

	if not left then
		return
	end

	if ((x > left and x < right) and (y > bottom and y < top)) then
		return 1
	else
		return
	end
end

local borderManipulation = function(...)
	for l = 1, select("#", ...) do
		local obj = select(l, ...)
		if (obj:GetObjectType() == "FontString" and MouseIsOver(obj)) then
			return obj:GetText()
		end
	end
end

local eb = ChatFrame1EditBox
SetItemRef = function(link, text, button, ...)

	if link:sub(1, 5) ~= "yCopy" then
	return _SetItemRef(link, text, button, ...) end

	local text = borderManipulation(SELECTED_CHAT_FRAME:GetRegions())
	if text then
		text = text:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
		text = text:gsub("|H.-|h(.-)|h", "%1")

		eb:Insert(text)
		eb:Show()
		eb:HighlightText()
		eb:SetFocus()
	end
end

----------------------------------------------------------
--  屏蔽系统错误输出框中: 能量不足，技能未准备好等信息  --
----------------------------------------------------------

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
	ERR_ATTACK_FLEEING,				-- Can"t attack while fleeing.
	ERR_ITEM_COOLDOWN,				-- Item is not ready yet.
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
	for k,v in ipairs(blacklist) do
		if v==arg1 then return end
	end
	hooks["UIErrorsFrame_AddMessage"](...)
end

-------------------------------
--  简化重载插件命令为"/rl"  --
-------------------------------

SLASH_RELOAD1 = "/rl"
SlashCmdList.RELOAD = ReloadUI




