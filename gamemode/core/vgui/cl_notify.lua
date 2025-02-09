local PANEL = {}

local baseSizeW, baseSizeH = 300, 20

function PANEL:Init()
	self.message = markup.Parse("")
	self:SetSize(baseSizeW, baseSizeH)
	self.startTime = CurTime()
	self.endTime = CurTime() + 7.5
	self.msgclass = 1
end

function PANEL:SetMessage(...)
	-- Encode message into markup
	local msg = "<font=Impulse-Elements18>"

	for k, v in ipairs({...}) do
		if type(v) == "table" then
			msg = msg.."<color="..v.r..","..v.g..","..v.b..">"
		elseif type(v) == "Player" then
			local col = team.GetColor(v:Team())
			msg= msg.."<color="..col.r..","..col.g..","..col.b..">"..tostring(v:Name()):gsub("<", "&lt;"):gsub(">", "&gt;").."</color>"
		else
			msg = msg..tostring(v):gsub("<", "&lt;"):gsub(">", "&gt;")
		end
	end
	msg = msg.."</font>"

	-- parse
	self.message = markup.Parse(msg, baseSizeW-80)

	-- set frame position and height to suit the markup
	local shiftHeight = self.message:GetHeight()
	local realHeight = math.Clamp(shiftHeight+baseSizeH,50,ScrH())
	self:SetHeight(realHeight)
	surface.PlaySound("buttons/lightswitch2.wav")
end

function PANEL:SetMessageClass(class)
	self.msgclass = class
end

local gradient = Material("vgui/gradient-r")
local darkCol = Color(30, 30, 30, 190)
local lightCol = Color(20,20,20,80)
local hudBlackGrad = Color(40,40,40,120)
local lifetime = 10

local Icon_Class_1 = Material("impulse/icons/info-256.png")
local Icon_Class_2 = Material("impulse/icons/check-mark-128.png")
local Icon_Class_3 = Material("impulse/icons/x-mark-128.png")
local Icon_Class_4 = Material("impulse/icons/sad.png")
local Icon_Class_5 = Material("impulse/icons/clock-128.png")
local Icon_Class_100 = Material("impulse/icons/party-hat-3-256.png")


local ClassColors = {
	[1] = impulse.Config.MainColour,
	[2] = Color(0, 200, 60),
	[3] = Color(255, 0, 0),
	[4] = impulse.Config.MainColour,
	[5] = impulse.Config.MainColour,
	[27] = Color(12, 120, 255)
}

local ClassDrawIcon = {
	[1] = function(panel, class)
		local x = 5
		local y = panel:GetTall()/2-20
		surface.SetMaterial(Icon_Class_1)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(x,y,40,40)
	end,
	[2] = function(panel, class)
		local x = 5
		local y = panel:GetTall()/2-20
		surface.SetMaterial(Icon_Class_2)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(x,y,40,40)
	end,
	[3] = function(panel, class)
		local x = 5
		local y = panel:GetTall()/2-20
		surface.SetMaterial(Icon_Class_3)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(x,y,40,40)
	end,
	[4] = function(panel, class)
		local x = 5
		local y = panel:GetTall()/2-20
		surface.SetMaterial(Icon_Class_4)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(x,y,40,40)
	end,
	[5] = function(panel, class)
		local x = 5
		local y = panel:GetTall()/2-20
		surface.SetMaterial(Icon_Class_5)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(x,y,40,40)
	end,
	[27] = function(panel, class)
		local x = 5
		local y = panel:GetTall()/2-20
		surface.SetMaterial(Icon_Class_100)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(x,y,40,40)
	end
}

local function drawicon(panel,class)
	ClassDrawIcon[class](panel, class)
end

function PANEL:Paint(w,h)
	-- draw frame
	impulse.blur(self, 10, 20, 255)
	surface.SetDrawColor(darkCol)
	surface.DrawRect(0,0,w,h)
	surface.SetDrawColor(darkCol)
	surface.SetMaterial(gradient)
	surface.DrawTexturedRect(0,0,w,h)
	if self.msgclass then
		surface.SetDrawColor(ClassColors[self.msgclass] or impulse.Config.MainColour)
	end
	surface.DrawRect(0, 2, 50, h-4)
	surface.DrawRect(0,0,w,2)
	surface.DrawRect(0,h-2,w,2)
	surface.DrawRect(w-2,0,2,h)
	drawicon(self,self.msgclass)

	-- draw message
	self.message:Draw(60,10, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	-- draw timebar
	local w2 = math.TimeFraction(self.startTime, self.endTime, CurTime()) * w
	surface.SetDrawColor(Color(255,255,255))
	surface.DrawRect(w2, h-2, w - w2, 2)
end

vgui.Register("impulseNotify", PANEL, "DPanel")
