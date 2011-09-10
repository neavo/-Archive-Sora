--[[
LICENSE
	cargBags: An inventory framework addon for World of Warcraft

	Copyright (C) 2010  Constantin "Cargor" Schomburg <xconstruct@gmail.com>

	cargBags is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	cargBags is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with cargBags; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

DESCRIPTION
	Provides a Scaffold that generates a default Blizz' ContainerButton

DEPENDENCIES
	mixins/api-common.lua
]]

----------------
--  ÃüÃû¿Õ¼ä  --
----------------

local _, SR = ...
local cfg = SR.BagConfig

local addon, ns = ...
local cargBags = ns.cargBags

local function noop() end

local function ItemButton_Scaffold(self)
	self:SetSize(32, 32)

	local name = self:GetName()
	self.Icon = _G[name.."IconTexture"]
	self.Count = _G[name.."Count"]
	self.Cooldown = _G[name.."Cooldown"]
	
end

--[[!
	Update the button with new item-information
	@param item <table> The itemTable holding information, see Implementation:GetItemInfo()
	@callback OnUpdate(item)
]]
local function ItemButton_Update(self, item)
	self.Icon:SetTexture(item.texture or 0.1,0.1,0.1,0.6)
	_G[self:GetName().."NormalTexture"]:Hide()
	_G[self:GetName().."IconQuestTexture"]:Hide()

	if item.count and item.count > 1 then
		self.Count:SetText(item.count >= 1e3 and "*" or item.count)
		self.Count:Show()
	else
		self.Count:Hide()
	end
	self.count = item.count -- Thank you Blizz for not using local variables >.> (BankFrame.lua @ 234 )

	self:UpdateCooldown(item)
	self:UpdateLock(item)
	self:UpdateQuest(item)

	if self.OnUpdate then self:OnUpdate(item) end
end

--[[!
	Updates the buttons cooldown with new item-information
	@param item <table> The itemTable holding information, see Implementation:GetItemInfo()
	@callback OnUpdateCooldown(item)
]]
local function ItemButton_UpdateCooldown(self, item)
	if item.cdEnable == 1 and item.cdStart and item.cdStart > 0 then
		self.Cooldown:SetCooldown(item.cdStart, item.cdFinish)
		self.Cooldown:Show()
	else
		self.Cooldown:Hide()
	end

	if self.OnUpdateCooldown then self:OnUpdateCooldown(item) end
end

--[[!
	Updates the buttons lock with new item-information
	@param item <table> The itemTable holding information, see Implementation:GetItemInfo()
	@callback OnUpdateLock(item)
]]
local function ItemButton_UpdateLock(self, item)
	self.Icon:SetDesaturated(item.locked)

	if self.OnUpdateLock  then self:OnUpdateLock(item) end
end

--[[!
	Updates the buttons quest texture with new item information
	@param item <table> The itemTable holding information, see Implementation:GetItemInfo()
	@callback OnUpdateQuest(item)
]]
local function ItemButton_UpdateQuest(self, item)
	local r,g,b = 0,0,0

	if item.questID and not item.questActive then
		texture = TEXTURE_ITEM_QUEST_BANG
	elseif item.questID or item.isQuestItem then
		texture = TEXTURE_ITEM_QUEST_BORDER
	elseif item.rarity and item.rarity > 1 then
		r,g,b = GetItemQualityColor(item.rarity)
	end
	
	self.Border = CreateFrame("Frame", nil, self)
	self.Border:SetAllPoints(self.Icon)
	self.Border:SetBackdrop({
		edgeFile = cfg.Solid, edgeSize = 1,
	})
	self.Border:SetBackdropBorderColor(r,g,b)
	
	if self.OnUpdateQuest then self:OnUpdateQuest(item) end
end

cargBags:RegisterScaffold("Default", function(self)

	self.CreateFrame = ItemButton_CreateFrame
	self.Scaffold = ItemButton_Scaffold

	self.Update = ItemButton_Update
	self.UpdateCooldown = ItemButton_UpdateCooldown
	self.UpdateLock = ItemButton_UpdateLock
	self.UpdateQuest = ItemButton_UpdateQuest

	self.OnEnter = ItemButton_OnEnter
	self.OnLeave = ItemButton_OnLeave
	
end)
