--[[
	-- Engines
	local S, C, L, DB = unpack(select(2, ...))
	local Module = LibStub("AceAddon-3.0"):GetAddon("Sora"):NewModule("ModuleName")
	function Module:OnInitialize() end
	function Module:OnEnable() end
]]

local Sora = LibStub("AceAddon-3.0"):NewAddon("Sora")
local _, ns = ...
ns[1] = {} -- S, Misc
ns[2] = {} -- C, Config
ns[3] = {} -- L, Locale
ns[4] = {} -- DB, DataBase