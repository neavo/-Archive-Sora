-- Engines
local S, _, _, DB = unpack(select(2, ...))
local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b

function S.MakeShadow(Parent, Size)
	local Shadow = CreateFrame("Frame", nil, Parent)
	Shadow:SetFrameLevel(0)
	Shadow:SetPoint("TOPLEFT", -Size, Size)
	Shadow:SetPoint("BOTTOMRIGHT", Size, -Size)
	Shadow:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = Size})
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	return Shadow
end

function S.MakeTexShadow(Parent, Anchor, Size)
	local Shadow = CreateFrame("Frame", nil, Parent)
	Shadow:SetPoint("TOPLEFT", Anchor, -Size, Size)
	Shadow:SetPoint("BOTTOMRIGHT", Anchor, Size, -Size)
	Shadow:SetFrameLevel(1)
	Shadow:SetBackdrop({edgeFile = DB.GlowTex, edgeSize = Size})
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	return Shadow
end

function S.MakeFontString(Parent, FontSize)
	local Text = Parent:CreateFontString(nil, "OVERLAY")
	Text:SetFont(DB.Font, FontSize, "THINOUTLINE")
	return Text
end

function S.SVal(Val)
    if Val >= 1e6 then
        return ("%.1fm"):format(Val/1e6):gsub("%.?0+([km])$", "%1")
    elseif Val >= 1e4 then
        return ("%.1fk"):format(Val/1e3):gsub("%.?0+([km])$", "%1")
    else
        return Val
    end
end

function S.ToHex(r, g, b)
	if r then
		if type(r) == "table" then
			if r.r then
				r, g, b = r.r, r.g, r.b
			else
				r, g, b = unpack(r)
			end
		end
		return ("|cff%02x%02x%02x"):format(r*255, g*255, b*255)
	end
end

function S.FormatTime(Time, Short)
	local Day = floor(Time/86400)
	local Hour = floor((Time-Day*86400)/3600)
	local Minute = floor((Time-Day*86400-Hour*3600)/60)
	local Second = floor(Time-Day*86400-Hour*3600-Minute*60)
	if not Short then
		if Time > 86400 then
			return Day.."d "..Hour.."m"		
		elseif Time > 3600 then
			return Hour.."h "..Minute.."m"
		elseif Time < 3600 and Time > 60 then
			return Minute.."m "..Second.."s"
		elseif Time < 60 and Time > 0 then	
			return Second.."s"
		else
			return "N/A"
		end
	else
		if Time > 86400 then
			return Day.."d"		
		elseif Time > 3600 then
			return Hour.."h"
		elseif Time < 3600 and Time > 60 then
			return Minute.."m"
		elseif Time < 60 and Time > 0 then	
			return Second.."s"
		else
			return "N/A"
		end
	end
end

function S.FormatMemory(Memory)
	local M = format("%.2f", Memory/1024)
	local K = floor(Memory-floor(Memory/1024))
	if Memory > 1024 then
		return M.."m "	
	elseif Memory > 0 and Memory < 1024 then
		return K.."k"
	else
		return "N/A"
	end	
end

local function CreateBD(f, a)
	f:SetBackdrop({
		bgFile = DB.bgFile, 
		edgeFile = DB.bgFile, 
		edgeSize = 1, 
	})
	f:SetBackdropColor(0, 0, 0, a or alpha)
	f:SetBackdropBorderColor(0, 0, 0)
end
local function CreatePulse(frame, speed, mult, alpha)
	frame.speed = speed or .05
	frame.mult = mult or 1
	frame.alpha = alpha or 1
	frame.tslu = 0
	frame:SetScript("OnUpdate", function(self, elapsed)
		self.tslu = self.tslu + elapsed
		if self.tslu > self.speed then
			self.tslu = 0
			self:SetAlpha(self.alpha)
		end
		self.alpha = self.alpha - elapsed*self.mult
		if self.alpha < 0 and self.mult > 0 then
			self.mult = self.mult*-1
			self.alpha = 0
		elseif self.alpha > 1 and self.mult < 0 then
			self.mult = self.mult*-1
		end
	end)
end
local function StartGlow(f)
	f:SetBackdropColor(r, g, b, .1)
	f:SetBackdropBorderColor(r, g, b)
	CreatePulse(f.glow)
end
local function StopGlow(f)
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetBackdropBorderColor(0, 0, 0)
	f.glow:SetScript("OnUpdate", nil)
	f.glow:SetAlpha(0)
end
local function Reskin(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	if f:GetName() then
		local left = _G[f:GetName().."Left"]
		local middle = _G[f:GetName().."Middle"]
		local right = _G[f:GetName().."Right"]

		if left then left:SetAlpha(0) end
		if middle then middle:SetAlpha(0) end
		if right then right:SetAlpha(0) end
	end

	CreateBD(f, .0)

	local tex = f:CreateTexture(nil, "BACKGROUND")
	tex:SetPoint("TOPLEFT")
	tex:SetPoint("BOTTOMRIGHT")
	tex:SetTexture(DB.bgFile)
	tex:SetGradientAlpha("VERTICAL", 0, 0, 0, .3, .35, .35, .35, .35)

	f.glow = CreateFrame("Frame", nil, f)
	f.glow:SetBackdrop({
		edgeFile = DB.GlowTex,
		edgeSize = 5,
	})
	f.glow:SetPoint("TOPLEFT", -6, 6)
	f.glow:SetPoint("BOTTOMRIGHT", 6, -6)
	f.glow:SetBackdropBorderColor(r, g, b)
	f.glow:SetAlpha(0)

	f:HookScript("OnEnter", StartGlow)
 	f:HookScript("OnLeave", StopGlow)
end
function S.MakeButton(Parent)
	local Button = CreateFrame("Button", nil, Parent)
	Reskin(Button)
	return Button
end

function S.MakeMoveHandle(Frame, Text, key)
	local MoveHandle = CreateFrame("Frame", nil, UIParent)
	MoveHandle:SetWidth(Frame:GetWidth())
	MoveHandle:SetHeight(Frame:GetHeight())
	MoveHandle:SetFrameStrata("HIGH")
	MoveHandle:SetBackdrop({bgFile = DB.Solid})
	MoveHandle:SetBackdropColor(0, 0, 0, 0.9)
	MoveHandle.Text = S.MakeFontString(MoveHandle, 10)
	MoveHandle.Text:SetPoint("CENTER")
	MoveHandle.Text:SetText(Text)
	MoveHandle:SetPoint(unpack(MoveHandleDB[key]))
	MoveHandle:EnableMouse(true)
	MoveHandle:SetMovable(true)
	MoveHandle:RegisterForDrag("LeftButton")
	MoveHandle:SetScript("OnDragStart", function(self) MoveHandle:StartMoving() end)
	MoveHandle:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local AnchorF, _, AnchorT, X, Y = self:GetPoint()
		MoveHandleDB[key] = {AnchorF, "UIParent", AnchorT, X, Y}
	end)
	MoveHandle:Hide()
	Frame:SetPoint("CENTER", MoveHandle)
	return MoveHandle
end







