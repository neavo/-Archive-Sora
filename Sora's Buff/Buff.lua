----------------
--  命名空间  --
----------------
local _, ns = ...
local cfg = ns.cfg

----------------------
--  公用变量和函数  --
----------------------

local IconsPerRow = 12
local i = 0

----------------
--  程序主体  --
----------------

-- BUFF/DEBUFF样式
local function Style(buttonName, i)

	local Button	= _G[buttonName..i]
	local Icon		= _G[buttonName..i.."Icon"]
	local Duration	= _G[buttonName..i.."Duration"]
	local Count 	= _G[buttonName..i.."Count"]

	if Button then
		Button:SetSize(BuffDB.IconSize, BuffDB.IconSize)
		if not Button.Shadow then
			Button.Shadow = CreateFrame("Frame", nil, Button)
			Button.Shadow:SetFrameLevel(0)
			Button.Shadow:SetPoint("TOPLEFT", -3, 3)
			Button.Shadow:SetPoint("BOTTOMRIGHT", 3, -3)
			Button.Shadow:SetBackdrop({ 
				edgeFile = cfg.GlowTex, edgeSize = 3, 
			})
			Button.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
		end
		Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		Duration:ClearAllPoints()
		Duration:SetParent(Button)
		Duration:SetPoint("TOP", Button, "BOTTOM", 1, -3)
		Duration:SetFont(cfg.Font, 9, "THINOUTLINE")
		Count:ClearAllPoints()
		Count:SetParent(Button)
		Count:SetPoint("BOTTOMRIGHT", Button, 3, -1)
		Count:SetFont(cfg.Font, 8, "THINOUTLINE")
	end
end

-- BUFF框体
local function MakeBuffFrame()

	-- 排序算法
	local Temp = {[1]={}, [2]={}}
	for i=1, BUFF_ACTUAL_DISPLAY do	
		local Duration = select(6, UnitBuff("player", i))
		if Duration == 0 then
			table.insert(Temp[1], _G["BuffButton"..i])
		else
			table.insert(Temp[2], _G["BuffButton"..i])		
		end
	end
	for i=1, #Temp[2]-1 do
		for t=i+1, #Temp[2] do
			if Temp[2][t].timeLeft > Temp[2][i].timeLeft then
				Temp[2][t], Temp[2][i] = Temp[2][i], Temp[2][t]
			end
		end
	end	
	local BuffSort = {}
	local Num = 0
	hasMainHandEnchant, _, _, hasOffHandEnchant, _, _, hasThrownEnchant = GetWeaponEnchantInfo()
	if hasMainHandEnchant then
		Num = Num + 1
	end
	if hasOffHandEnchant then
		Num = Num + 1
	end
	if hasThrownEnchant then
		Num = Num + 1
	end
	
	for i = 1, Num do
		Style("TempEnchant", i)
		table.insert(BuffSort, _G["TempEnchant"..i])
	end
	for i=1, 2 do
		for t=1, #Temp[i] do
			table.insert(BuffSort, Temp[i][t])
		end
	end
	
	-- 生成BUFF框体
	for i=1, BUFF_ACTUAL_DISPLAY + Num do
		Style("BuffButton", i)
		local Buff = BuffSort[i]
		Buff:ClearAllPoints()
		if BuffDB.BuffDirection == 1 then
			if i == 1 then
				Buff:SetPoint(unpack(cfg.BUFFPos))
			elseif i == IconsPerRow + 1 then
				Buff:SetPoint("TOP", BuffSort[1], "BOTTOM", 0, -15)
			elseif i == IconsPerRow*2 + 1 then
				Buff:SetPoint("TOP", BuffSort[IconsPerRow + 1], "BOTTOM", 0, -15)		
			elseif i < IconsPerRow*3 + 1 then
				Buff:SetPoint("RIGHT", BuffSort[i-1], "LEFT", -BuffDB.Spacing, 0)
			end
		elseif BuffDB.BuffDirection == 2 then
			if i == 1 then
				Buff:SetPoint(unpack(cfg.BUFFPos))
			elseif i == IconsPerRow + 1 then
				Buff:SetPoint("TOP", BuffSort[1], "BOTTOM", 0, -15)
			elseif i == IconsPerRow*2 + 1 then
				Buff:SetPoint("TOP", BuffSort[IconsPerRow + 1], "BOTTOM", 0, -15)		
			elseif i < IconsPerRow*3 + 1 then
				Buff:SetPoint("LEFT", BuffSort[i-1], "RIGHT", BuffDB.Spacing, 0)
			end
		end
	end
end
hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", MakeBuffFrame)

-- DEBUFF框体
local function MakeDebuffFrame(buttonName, i)
	Style(buttonName, i)
	local Debuff = _G[buttonName..i]
	local Border = _G[buttonName..i.."Border"]
	local Pre = _G[buttonName..(i-1)]
	Debuff:ClearAllPoints()
	Border:Hide()
	if BuffDB.DebuffDirection == 1 then
		if i == 1 then
			Debuff:SetPoint(unpack(cfg.DEUFFPos))
		elseif i == IconsPerRow + 1 then
			Debuff:SetPoint("TOP", DebuffButton1, "BOTTOM", 0, -15)
		elseif i < IconsPerRow*2 + 1 then
			Debuff:SetPoint("RIGHT", Pre, "LEFT", -BuffDB.Spacing, 0)
		end
	elseif BuffDB.DebuffDirection == 2 then
		if i == 1 then
			Debuff:SetPoint(unpack(cfg.DEUFFPos))
		elseif i == IconsPerRow + 1 then
			Debuff:SetPoint("TOP", DebuffButton1, "BOTTOM", 0, -15)
		elseif i < IconsPerRow*2 + 1 then
			Debuff:SetPoint("LEFT", Pre, "RIGHT", BuffDB.Spacing, 0)
		end
	end
end
hooksecurefunc("DebuffButton_UpdateAnchors", MakeDebuffFrame)

-- BUFF即将结束时的提示
local function FlashOnEnd(self, elapsed)
	if self.timeLeft > BuffDB.WarningTime then
		self.duration:SetTextColor(1, 1, 1)
		self:SetAlpha(1)
	elseif self.timeLeft < BuffDB.WarningTime then
		self.duration:SetTextColor(1, 0, 0)
		self:SetAlpha(BuffFrame.BuffAlphaValue)
	else
		self:SetAlpha(1)
	end
end
hooksecurefunc("AuraButton_OnUpdate", FlashOnEnd)

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("OnEvent", function(slef)
	SetCVar("consolidateBuffs", 0)
	SetCVar("buffDurations", 1)
end)

