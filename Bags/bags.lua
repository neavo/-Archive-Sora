----------------
--  命名空间  --
----------------

local _, ns = ...
local cargBags = ns.cargBags

local _, SR = ...
local cfg = SR.BagConfig


----------------
--  主程序  --
----------------

local Bags = cargBags:NewImplementation("Bags")
Bags:RegisterBlizzard() 

local function highlightFunction(button, match)
	button:SetAlpha(match and 1 or 0.3)
end

local f = {}
function Bags:OnInit()

	local onlyBags = function(item) return item.bagID >= 0 and item.bagID <= 4 end
	local onlyBank = function(item) return item.bagID == -1 or item.bagID >= 5 and item.bagID <= 11 end
	
	local MyContainer = Bags:GetContainerClass()
	
	-- 玩家背包
	f.main = MyContainer:New("Main", {
			Columns = 10,
			Scale = cfg.Scale,
			Bags = "bags",
			Movable = true,
	})
	f.main:SetFilter(onlyBags, true)
	f.main:SetPoint("RIGHT", -20, 0)

	-- 银行
	f.bank = MyContainer:New("Bank", {
			Columns = 13,
			Scale = cfg.Scale,
			Bags = "bank",
			Movable = true,
	})
	f.bank:SetFilter(onlyBank, true) 
	f.bank:SetPoint("CENTER", -100, 0)
	f.bank:Hide()

end

function Bags:OnBankOpened()
	self:GetContainer("Bank"):Show()
end

function Bags:OnBankClosed()
	self:GetContainer("Bank"):Hide()
end


local MyButton = Bags:GetItemButtonClass()
MyButton:Scaffold("Default")
function MyButton:OnUpdate(item)
	self.Border:SetVertexColor(.7, .7, .7, .9);
end

--	背包图标模板
local BagButton = Bags:GetClass("BagButton", true, "BagButton")
function BagButton:OnCreate()
	self:GetCheckedTexture():SetVertexColor(0.3, 0.9, 0.9, 0.5)
end

-- 更新背包栏
local UpdateDimensions = function(self)
	local width, height = self:LayoutButtons("grid", self.Settings.Columns, 5, 10, -10)
	local margin = 40
	if self.BagBar and self.BagBar:IsShown() then
		margin = margin + 45
	end
	self:SetHeight(height + margin)
end

local MyContainer = Bags:GetContainerClass()
function MyContainer:OnContentsChanged()
	self:SortButtons("bagSlot")
	-- ("grid", columns, spacing, xOffset, yOffset) or ("circle", radius (optional), xOffset, yOffset)
	local width, height = self:LayoutButtons("grid", self.Settings.Columns, 5, 10, -10)
	self:SetSize(width + 20, height + 10)
	if self.UpdateDimensions then
		self:UpdateDimensions()
	end
end

-- 创建框体
function MyContainer:OnCreate(name, settings)
    self.Settings = settings
	self.UpdateDimensions = UpdateDimensions

	self:SetBackdrop({ 
		bgFile = cfg.bgFile,
		edgeFile = cfg.edgeFile, edgeSize = 4, 
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	self:SetBackdropColor(0,0,0,0.8)
	self:SetBackdropBorderColor(0,0,0,1)

	self:SetParent(settings.Parent or Bags)
	self:SetFrameStrata("HIGH")

	if settings.Movable then
		self:SetMovable(true)
		self:RegisterForClicks("LeftButton")
	    self:SetScript("OnMouseDown", function()
			self:ClearAllPoints() 
			self:StartMoving()
	    end)
		self:SetScript("OnMouseUp", self.StopMovingOrSizing)
	end

	settings.Columns = settings.Columns
	self:SetScale(settings.Scale)
	
	-- 信息条
	local infoFrame = CreateFrame("Button", nil, self)
	infoFrame:SetPoint("BOTTOM", -20, 0)
	infoFrame:SetWidth(220)
	infoFrame:SetHeight(32)
	
	-- 信息条插件:金币
	local tagDisplay = self:SpawnPlugin("TagDisplay", "[money]", infoFrame)
	tagDisplay:SetFontObject("NumberFontNormal")
	tagDisplay:SetFont(cfg.Font, 14)
	tagDisplay:SetPoint("RIGHT", infoFrame,"RIGHT",0,0)	
	-- 信息条插件:搜索栏
	local searchText = infoFrame:CreateFontString(nil, "OVERLAY")
	searchText:SetPoint("LEFT", infoFrame, "LEFT", 0, 1)
	searchText:SetFont(cfg.Font, 12, "THINOUTLINE")
	searchText:SetText("搜索")	
	local search = self:SpawnPlugin("SearchBar", infoFrame)
	search.highlightFunction = highlightFunction
	search.isGlobal = true
	search:SetPoint("LEFT", infoFrame,"LEFT", 0, 5)
	
	-- 信息条插件:背包栏
	local bagBar = self:SpawnPlugin("BagBar", settings.Bags)
	bagBar:SetSize(bagBar:LayoutButtons("grid", 7))
	bagBar:SetScale(0.8)
	bagBar.highlightFunction = highlightFunction
	bagBar.isGlobal = true
	bagBar:Hide()
	self.BagBar = bagBar
	bagBar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 10, 46)
	
	-- 背包栏开关按钮
	self:UpdateDimensions()
	local bagToggle = CreateFrame("CheckButton", nil, self)
	bagToggle:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	bagToggle:SetWidth(40)
	bagToggle:SetHeight(20)
	bagToggle:SetPoint("BOTTOMLEFT",3,7)
	bagToggle:SetScript("OnClick", function()
		if(self.BagBar:IsShown()) then
			self.BagBar:Hide()
		else
			self.BagBar:Show()
		end
			self:UpdateDimensions()
	end)
	bagToggle.Text = bagToggle:CreateFontString(nil, "OVERLAY")
	bagToggle.Text:SetPoint("CENTER", bagToggle)
	bagToggle.Text:SetFont(cfg.Font, 12 , "THINOUTLINE")
	bagToggle.Text:SetText("背包")
	
	-- 背包整理按钮
	local SortButton = CreateFrame("Button", nil, self)
	SortButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	SortButton:SetWidth(70)
	SortButton:SetHeight(20)
	SortButton:SetPoint("BOTTOMRIGHT",-40,7)
	SortButton:SetScript("OnClick", function() JPack:Pack() end)
	SortButton.Text = SortButton:CreateFontString(nil, "OVERLAY")
	SortButton.Text:SetPoint("CENTER", SortButton)
	SortButton.Text:SetFont(cfg.Font, 12, "THINOUTLINE")
	SortButton.Text:SetText("整理背包")

	-- 关闭按钮
	local closebutton = CreateFrame("Button", nil, self)
	closebutton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	closebutton:SetFrameLevel(30)
	closebutton:SetPoint("BOTTOMRIGHT", -5, 9)
	closebutton:SetSize(20,14)
	closebutton.Texture = closebutton:CreateFontString(nil, "OVERLAY")
	closebutton.Texture:SetPoint("CENTER", closebutton, "CENTER",1,0)
	closebutton.Texture:SetFont(cfg.Font, 15, "THINOUTLINE")
	closebutton.Texture:SetText("x")
	closebutton:SetScript( "OnClick", function(self) 
		CloseAllBags() 
	end)
end

