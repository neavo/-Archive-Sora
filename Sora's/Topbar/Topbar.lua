----------------
--  命名空间  --
----------------

local _, SR = ...
local cfg = SR.TopBarConfig


local R = unpack(select(2, ...))
local topinfo= {}
local botinfo= {}
local LastUpdate = 1
for i = 1,4 do
	if i == 1 then
		topinfo[i] = CreateFrame("Frame", "TopInfoBar"..i-1, UIParent)
		topinfo[i]:CreatePanel("Transparent", 80, 10, "TOP", UIParent, "TOP", -175, -10)
	elseif i == 2 or i == 4 then
		topinfo[i] = CreateFrame("Frame", "TopInfoBar"..i-1, UIParent)
		topinfo[i]:CreatePanel("Transparent", 80, 10, "LEFT", topinfo[i-1], "RIGHT", 10, 0)
	elseif i == 3 then
		topinfo[i] = CreateFrame("Frame", "TopInfoBar"..i-1, UIParent)
		topinfo[i]:CreatePanel("Transparent", 80, 10, "LEFT", topinfo[i-1], "RIGHT", 100, 0)
	end
	
	topinfo[i].Status = CreateFrame("StatusBar", "TopInfoBarStatus"..i, topinfo[i])
	topinfo[i].Status:SetFrameLevel(12)
	topinfo[i].Status:SetStatusBarTexture(cfg.Statusbar)
	topinfo[i].Status:SetMinMaxValues(0, 100)
	topinfo[i].Status:SetStatusBarColor(0, 0.4, 1, 0.6)
	topinfo[i].Status:Point("TOPLEFT", topinfo[i], "TOPLEFT", 2, -2)
	topinfo[i].Status:Point("BOTTOMRIGHT", topinfo[i], "BOTTOMRIGHT", -2, 2)
	topinfo[i].Status:SetValue(100)
	
	topinfo[i].Text = topinfo[i].Status:CreateFontString(nil, "OVERLAY")
	topinfo[i].Text:SetFont(cfg.Font, 10, "THINOUTLINE")
	topinfo[i].Text:Point("CENTER", topinfo[i], "CENTER", 0, -8)
	topinfo[i].Text:SetShadowColor(0, 0, 0, 0.4)
	topinfo[i].Text:SetShadowOffset(1.25, -1.25)
	
	topinfo[i].showed = false
	topinfo[i].timer = 0
	topinfo[i]:SetScript("OnShow", function(self)
		self.timer = 0
		self.showed = false
		self:SetAlpha(0)
		self:SetScript("OnUpdate", function(self, elasped)
			self.timer = self.timer + elasped
			self:SetAlpha(self.timer)
			if self.timer>0.5 then self.showed = true end
		end)
	end)
	topinfo[i]:Hide()
end

-- Ping 
topinfo[1].Text:SetText("Ping: 0")
topinfo[1].Status:SetScript("OnUpdate", function(self, elapsed)
	LastUpdate = LastUpdate - elapsed
	
	if LastUpdate < 0 then
		self:SetMinMaxValues(0, 999)
		local value = (select(3, GetNetStats()))
		self:SetValue(value)
		topinfo[1].Text:SetText("Ping: "..value)			
		if value>499 then
			self:SetStatusBarColor(1, 0, 0, 0.6)
		elseif value>249 then
			self:SetStatusBarColor(1, 1, 0, 0.6)
		else
			self:SetStatusBarColor(0, 0.4, 1, 0.6)
		end
		
		LastUpdate = 1
	end
end)

-- MEMORY
local f = topinfo[2]

local Stat = CreateFrame("Frame", nil, f)
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(4)
Stat:ClearAllPoints()
Stat:SetAllPoints(f)

local int = 10
local StatusBar = f.Status
local Text = f.Text
local bandwidthString = "%.2f Mbps"
local percentageString = "%.2f%%"
local homeLatencyString = "%d ms"
local kiloByteString = "%d KB"
local megaByteString = "%.2f MB"

local function formatMem(memory)
	local mult = 10^1
	if memory > 999 then
		local mem = ((memory/1024) * mult) / mult
		return string.format(megaByteString, mem)
	else
		local mem = (memory * mult) / mult
		return string.format(kiloByteString, mem)
	end
end

local memoryTable = {}

local function RebuildAddonList(self)
	local addOnCount = GetNumAddOns()
	if (addOnCount == #memoryTable) then return end
	memoryTable = {}
	for i = 1, addOnCount do
		memoryTable[i] = { i, select(2, GetAddOnInfo(i)), 0, IsAddOnLoaded(i) }
	end
	self:SetAllPoints(f)
end

local function UpdateMemory()
	UpdateAddOnMemoryUsage()
	local addOnMem = 0
	local totalMemory = 0
	for i = 1, #memoryTable do
		addOnMem = GetAddOnMemoryUsage(memoryTable[i][1])
		memoryTable[i][3] = addOnMem
		totalMemory = totalMemory + addOnMem
	end
	table.sort(memoryTable, function(a, b)
		if a and b then
			return a[3] > b[3]
		end
	end)
	return totalMemory
end

local function UpdateMem(self, t)
	int = int - t
	
	if int < 0 then
		RebuildAddonList(self)
		local total = UpdateMemory()
		Text:SetText(formatMem(total))
		StatusBar:SetMinMaxValues(0,15000)
		StatusBar:SetValue(total)
		if total>12000 then
			StatusBar:SetStatusBarColor(1, 0, 0, 0.6)
		elseif total>8000 then
			StatusBar:SetStatusBarColor(1, 1, 0, 0.6)
		else
			StatusBar:SetStatusBarColor(0, 0.4, 1, 0.6)
		end
		int = 10
	end
end

Stat:EnableMouse(true)
Stat:SetScript("OnMouseDown", function(self) collectgarbage("collect") end)
Stat:SetScript("OnUpdate", UpdateMem)
Stat:SetScript("OnEnter", function(self)
	local bandwidth = GetAvailableBandwidth()
	local anchor, panel, xoff, yoff = "ANCHOR_BOTTOMRIGHT", self, 0, 0
	GameTooltip:SetOwner(panel, anchor, xoff, yoff)
	GameTooltip:ClearLines()
	
	if bandwidth ~= 0 then
		GameTooltip:AddDoubleLine("带宽: " , string.format(bandwidthString, bandwidth),0.69, 0.31, 0.31,0.84, 0.75, 0.65)
		GameTooltip:AddDoubleLine("下载: " , string.format(percentageString, GetDownloadedPercentage() *100),0.69, 0.31, 0.31, 0.84, 0.75, 0.65)
		GameTooltip:AddLine(" ")
	end
	local totalMemory = UpdateMemory()
	GameTooltip:AddDoubleLine("总共内存使用: ", formatMem(totalMemory), 0.69, 0.31, 0.31,0.84, 0.75, 0.65)
	GameTooltip:AddLine(" ")
	for i = 1, #memoryTable do
		if (memoryTable[i][4]) then
			local red = memoryTable[i][3] / totalMemory
			local green = 1 - red
			GameTooltip:AddDoubleLine(memoryTable[i][2], formatMem(memoryTable[i][3]), 1, 1, 1, red, green + .5, 0)
		end						
	end
	GameTooltip:Show()
end)
Stat:SetScript("OnLeave", function() GameTooltip:Hide() end)
UpdateMem(Stat, 10)

-- DURABILITY
local Slots = {
		[1] = {1, "头部", 1000},
		[2] = {3, "肩部", 1000},
		[3] = {5, "胸部", 1000},
		[4] = {6, "腰部", 1000},
		[5] = {9, "手腕", 1000},
		[6] = {10, "手", 1000},
		[7] = {7, "腿部", 1000},
		[8] = {8, "脚", 1000},
		[9] = {16, "主手", 1000},
		[10] = {17, "副手", 1000},
		[11] = {18, "远程", 1000}
	}
local tooltipString = "%d %%"
topinfo[3].Status:SetScript("OnEvent", function(self)
	local Total = 0
	local current, max
	
	for i = 1, 11 do
		if GetInventoryItemLink("player", Slots[i][1]) ~= nil then
			current, max = GetInventoryItemDurability(Slots[i][1])
			if current then 
				Slots[i][3] = current/max
				Total = Total + 1
			end
		end
	end
	table.sort(Slots, function(a, b) return a[3] < b[3] end)
	local value = floor(Slots[1][3]*100)

	self:SetMinMaxValues(0, 100)
	self:SetValue(value)
	topinfo[3].Text:SetText("D: "..value.."%")
	if value<10 then
		self:SetStatusBarColor(1, 0, 0, 0.6)
	elseif value<30 then
		self:SetStatusBarColor(1, 1, 0, 0.6)
	else
		self:SetStatusBarColor(0, 0.4, 1, 0.6)
	end
end)
topinfo[3].Status:SetScript("OnEnter", function(self)
	if not InCombatLockdown() then
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, 0)
		GameTooltip:ClearLines()
		for i = 1, 11 do
			if Slots[i][3] ~= 1000 then
				green = Slots[i][3]*2
				red = 1 - green
				GameTooltip:AddDoubleLine(Slots[i][2], format(tooltipString, floor(Slots[i][3]*100)), 1 ,1 , 1, red + 1, green, 0)
			end
		end
		GameTooltip:Show()
	end
end)
topinfo[3].Status:SetScript("OnLeave", function() GameTooltip:Hide() end)
topinfo[3].Status:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
topinfo[3].Status:RegisterEvent("MERCHANT_SHOW")
topinfo[3].Status:RegisterEvent("PLAYER_ENTERING_WORLD")

local infoshow = CreateFrame("Frame")
infoshow:RegisterEvent("PLAYER_ENTERING_WORLD")
infoshow:SetScript("OnEvent", function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		local timer = 0
		self:SetScript("OnUpdate", function(self, elasped)
			timer = timer + elasped
			if timer > 2 then 
				topinfo[1]:Show() 
			end
			for i=1,3 do
				if topinfo[i].showed then topinfo[i+1]:Show() end
			end
		end)
end)

-- CURRENCY DATA BARS
local CurrencyData = {}
local tokens = {
	{61, 250},	 -- Dalaran Jewelcrafter's Token
	{81, 250},	 -- Dalaran Cooking Award
	{241, 250},	 -- Champion Seal
	{361, 200},  -- Illustrious Jewelcrafter's Token
	{390, 3000}, -- Conquest Points
	{391, 2000},  -- Tol Barad Commendation
	{392, 4000}, -- Honor Points
	{395, 4000}, -- Justice Points
	{396, 4000}, -- Valor Points
	{402, 10},	 -- Chef's Award 
	{416, 300}, -- Mark of the World Tree
}

local function updateCurrency()
	if CurrencyData[1] then
		for i = 1, getn(CurrencyData) do
			CurrencyData[i]:Kill()
		end
		wipe(CurrencyData) 
	end

	for i, v in ipairs(tokens) do
		local id, max = unpack(v)
		local name, amount, icon = GetCurrencyInfo(id)

		if name and amount > 0 then
			local frame = CreateFrame("Frame", "CurrencyData"..id, UIParent)
			frame:CreatePanel("Transparent", 120, 10, "CENTER", UIParent, "CENTER", 0, 0)
			frame:EnableMouse(true)
			frame:Hide()

			frame.Status = CreateFrame("StatusBar", "CurrencyDataStatus"..id, frame)
			frame.Status:SetFrameLevel(12)
			frame.Status:SetStatusBarTexture(cfg.Statusbar)
			frame.Status:SetMinMaxValues(0, max)
			frame.Status:SetValue(amount)
			frame.Status:SetStatusBarColor(0, 0.4, 1, 0.6)
			frame.Status:Point("TOPLEFT", frame, "TOPLEFT", 2, -2)
			frame.Status:Point("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)

			frame.Text = frame.Status:CreateFontString(nil, "OVERLAY")
			frame.Text:SetFont(cfg.Font, 12, "THINOUTLINE")
			frame.Text:Point("CENTER", frame, "CENTER", 0, 2)
			frame.Text:Width(frame:GetWidth() - 4)
			frame.Text:SetShadowColor(0, 0, 0)
			frame.Text:SetShadowOffset(1.25, -1.25)
			frame.Text:SetText(format("%s / %s", amount, max))
				
			frame.IconBG = CreateFrame("Frame", "CurrencyDataIconBG"..id, frame)
			frame.IconBG:CreatePanel(nil, 20, 20, "BOTTOMLEFT", frame, "BOTTOMRIGHT", 3, -10)
			frame.Icon = frame.IconBG:CreateTexture(nil, "ARTWORK")
			frame.Icon:Point("TOPLEFT", frame.IconBG, "TOPLEFT", 2, -2)
			frame.Icon:Point("BOTTOMRIGHT", frame.IconBG, "BOTTOMRIGHT", -2, 2)
			frame.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			frame.Icon:SetTexture("Interface\\Icons\\"..icon)

			frame:SetScript("OnEnter", function(self) frame.Text:SetText(format("%s", name)) end)
			frame:SetScript("OnLeave", function(self) frame.Text:SetText(format("%s / %s", amount, max)) end)
			
			tinsert(CurrencyData, frame)
		end
	end
	
	for key, frame in ipairs(CurrencyData) do
		frame:ClearAllPoints()
		if key == 1 then
			frame:Point("TOPRIGHT", topinfo[4], "BOTTOMRIGHT", 0, -13)
		else
			frame:Point("TOP", CurrencyData[key-1], "BOTTOM", 0, -13)
		end
	end
end

local function ModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[R.myclass]
	self:SetBackdropColor(05,.05,.05, .9)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

local function OriginalBackdrop(self)
	self:SetBackdropColor(05,.05,.05, .9)
	self:SetBackdropBorderColor(0, 0, 0, 1)
end

local toggle = CreateFrame("Frame", nil, topinfo[4])
toggle:EnableMouse(true)
toggle:SetFrameStrata("BACKGROUND")
toggle:SetFrameLevel(4)
toggle:ClearAllPoints()
toggle:SetAllPoints(topinfo[4])
toggle:EnableMouse(true)

toggle:SetScript("OnMouseDown", function(self)
	for _, frame in pairs(CurrencyData) do
		if frame and frame:IsShown() then
			frame:Hide()
		else
			frame:Show()
		end
	end
end)

topinfo[4].Status:SetMinMaxValues(0,99999)

-- Time
local Clock = UIParent:CreateFontString(nil, "OVERLAY")
Clock:SetPoint("TOP", UIParent, "TOP", 0, -10)
Clock:SetFont(cfg.Font,14,"THINOUTLINE")	

-- NewMail
local NewMail = UIParent:CreateFontString(nil, "OVERLAY")
NewMail:SetPoint("TOP", Clock, "BOTTOM", 4, -5)
NewMail:SetFont(cfg.Font,14,"THINOUTLINE")	
NewMail:SetText("|cff55FF55新邮件！|r")

-- OnEnterWorld
local OnEnterWorld = CreateFrame("Frame")
OnEnterWorld:RegisterEvent("PLAYER_ENTERING_WORLD")
OnEnterWorld:SetScript("OnEvent",function(self,event,addon)
	if event == "PLAYER_ENTERING_WORLD" then
		TimeManagerClockButton:Hide()
	end
end)

-- Updater
local UpdaterTimer = 0
local Updater = CreateFrame("Frame")
Updater:RegisterEvent("PLAYER_HONOR_GAIN")	
Updater:SetScript("OnEvent", updateCurrency)
Updater:SetScript("OnUpdate",function(self,elapsed)
	UpdaterTimer = UpdaterTimer + elapsed
	if UpdaterTimer > 3 then
		UpdaterTimer = 0
		
		-- Gold
		local Gold = GetMoney()
		topinfo[4].Text:SetText(("%d |cffffd700G|r %d |cffc7c7cfS|r"):format(Gold/100/100, (Gold/100)%100))	
		topinfo[4].Status:SetValue(Gold/100/100)
		
		-- Clock
		local hour,minute = GetGameTime()
		Clock:SetText(("%.2d : %.2d"):format(hour,minute))
		
		-- NewMail
		if HasNewMail() then
			NewMail:Show()
		else
			NewMail:Hide()
		end
	end
end)


hooksecurefunc("BackpackTokenFrame_Update", updateCurrency)

UIParent:SetScript("OnShow", function(self)
		UIFrameFadeIn(UIParent, 1, 0, 1)
end)

