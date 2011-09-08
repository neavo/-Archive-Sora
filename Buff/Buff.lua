----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.BuffConfig

--------------------------
--  一些公用变量和函数  --
--------------------------

local IconsPerRow = 12
local i = 0

local MakeShadow = function(Frame)
	Frame:SetFrameLevel(0)
	Frame:SetPoint("TOPLEFT", 3, -3)
	Frame:SetPoint("BOTTOMRIGHT", 3, -3)
	Frame:SetBackdrop({ 
		edgeFile = cfg.GlowTex , edgeSize = 5,
	})
	Frame:SetBackdropBorderColor(0,0,0,1)
end

local MakeOverlay = function(Frame)
	Frame:SetFrameLevel(4)
	Frame:SetPoint("TOPLEFT", 1, -1)
	Frame:SetPoint("BOTTOMRIGHT", -1, 1)
	Frame:SetBackdrop({ 
		edgeFile = cfg.Solid, edgeSize = 1
	})
	Frame:SetBackdropBorderColor(0,0,0,1)
end

----------------
--  程序主体  --
----------------

-- BUFF/DEBUFF样式
local function Style(buttonName, i)

	local Button	= _G[buttonName..i]
	local Icon		= _G[buttonName..i.."Icon"]
	local Duration	= _G[buttonName..i.."Duration"]
	local Count 	= _G[buttonName..i.."Count"]
	
	if _G[buttonName..i.."Border"] then
		_G[buttonName..i.."Border"]:Hide()
	end
	
	if Button then
	
		Button:SetSize(cfg.IconSize,cfg.IconSize)
		
		Icon:SetPoint("TOPLEFT", Button, 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", Button, -2, 2)
		Icon:SetTexCoord(.08, .92, .08, .92)
		
		Duration:ClearAllPoints()
		Duration:SetParent(Button)
		Duration:SetPoint("TOP", Button, "BOTTOM", 1, -1)
		Duration:SetFont(cfg.Font, 8, "THINOUTLINE")
		
		Count:ClearAllPoints()
		Count:SetParent(Button)
		Count:SetPoint("BOTTOMRIGHT", Button, 1, 2)
		Count:SetFont(cfg.Font, 8, "THINOUTLINE")
		
		if not _G[buttonName..i.."Shadow"] then
			local Shadow = CreateFrame("Frame", buttonName..i.."Shadow", Button)
			MakeShadow(Shadow)
			local Overlay = CreateFrame("Frame", buttonName..i.."Overlay", Button)
			MakeOverlay(Overlay)
		end
	end
end

-- BUFF框体
local function MakeBuffFrame()

	-- 排序算法
	local Temp = {[1]={},[2]={}}
	for i=1, BUFF_ACTUAL_DISPLAY do	
		local Duration = select(6,UnitBuff("player", i))
		if Duration == 0 then
			table.insert(Temp[1], _G["BuffButton"..i])
		else
			table.insert(Temp[2], _G["BuffButton"..i])		
		end
	end
	for i=1,#Temp[2]-1 do
		for t=i+1,#Temp[2] do
			if Temp[2][t].timeLeft > Temp[2][i].timeLeft then
				Temp[2][t],Temp[2][i] = Temp[2][i],Temp[2][t]
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
	for i=1,2 do
		for t=1,#Temp[i] do
			table.insert(BuffSort,Temp[i][t])
		end
	end
	
	-- 生成BUFF框体
	for i=1, BUFF_ACTUAL_DISPLAY + Num do
		Style("BuffButton", i)
		local Buff = BuffSort[i]
		Buff:ClearAllPoints()
		if cfg.BuffDirection == 1 then
			if i == 1 then
				Buff:SetPoint(unpack(cfg.BUFFpos))
			elseif i == IconsPerRow + 1 then
				Buff:SetPoint("TOP", BuffSort[1], "BOTTOM", 0, -10)
			elseif i == IconsPerRow*2 + 1 then
				Buff:SetPoint("TOP", BuffSort[IconsPerRow + 1], "BOTTOM", 0, -10)		
			elseif i < IconsPerRow*3 + 1 then
				Buff:SetPoint("RIGHT", BuffSort[i-1], "LEFT", -cfg.Spacing, 0)
			end
		elseif cfg.BuffDirection == 2 then
			if i == 1 then
				Buff:SetPoint(unpack(cfg.BUFFpos))
			elseif i == IconsPerRow + 1 then
				Buff:SetPoint("TOP", BuffSort[1], "BOTTOM", 0, -10)
			elseif i == IconsPerRow*2 + 1 then
				Buff:SetPoint("TOP", BuffSort[IconsPerRow + 1], "BOTTOM", 0, -10)		
			elseif i < IconsPerRow*3 + 1 then
				Buff:SetPoint("LEFT", BuffSort[i-1], "RIGHT", cfg.Spacing, 0)
			end
		end
	end
end
hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", MakeBuffFrame)

-- DEBUFF框体
local function MakeDebuffFrame(buttonName,i)
	Style(buttonName, i)
	local Debuff = _G[buttonName..i]
	local Border = _G[buttonName..i.."Border"]
	local Pre = _G[buttonName..(i-1)]
	Debuff:ClearAllPoints()
	Border:Hide()
	if cfg.DebuffDirection == 1 then
		if i == 1 then
			Debuff:SetPoint(unpack(cfg.DEUFFpos))
		elseif i == IconsPerRow + 1 then
			Debuff:SetPoint("TOP", DebuffButton1, "BOTTOM", 0, -10)
		elseif i < IconsPerRow*2 + 1 then
			Debuff:SetPoint("RIGHT", Pre, "LEFT", -cfg.Spacing, 0)
		end
	elseif cfg.DebuffDirection == 2 then
		if i == 1 then
			Debuff:SetPoint(unpack(cfg.DEUFFpos))
		elseif i == IconsPerRow + 1 then
			Debuff:SetPoint("TOP", DebuffButton1, "BOTTOM", 0, -10)
		elseif i < IconsPerRow*2 + 1 then
			Debuff:SetPoint("LEFT", Pre, "RIGHT", cfg.Spacing, 0)
		end
	end
end
hooksecurefunc("DebuffButton_UpdateAnchors", MakeDebuffFrame)

-- BUFF即将结束时的提示
local function FlashOnEnd(self, elapsed)
	if self.timeLeft > cfg.WarningTime then
		self.duration:SetTextColor(1,1,1)
		self:SetAlpha(1)
	elseif self.timeLeft < cfg.WarningTime then
		self.duration:SetTextColor(1,0,0)
		self:SetAlpha(BuffFrame.BuffAlphaValue)
	else
		self:SetAlpha(1)
	end
end
hooksecurefunc("AuraButton_OnUpdate", FlashOnEnd)

-- Event
local Event = CreateFrame("Frame")
Event:RegisterEvent("PLAYER_ENTERING_WORLD")
Event:SetScript("OnEvent",function(slef)
	SetCVar("consolidateBuffs",0)
	SetCVar("buffDurations",1)
end)

