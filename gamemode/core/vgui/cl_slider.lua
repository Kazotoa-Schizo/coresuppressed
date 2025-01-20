
local PANEL = {}

function PANEL:Init()
	self:SetText("")
	self.__SetText = self.SetText
	self.SetText = function(self,text)
		self.m_Label = text
	end
	-- Setup internal values
	self.m_Value = 0
	self.m_Min = 0
	self.m_Max = 1
	self.m_LerpRateMultiplier = 0
	self.m_DisplayValue = 0
	self.m_Decimals = -1
	self.m_Label = "Label"
	self:DockPadding(25,50,25,25)
end

function PANEL:PaintSlider(w,h)
	surface.SetDrawColor(impulse.Config.MainColour)
	local x, y = self:GetX(), self:GetY()
	surface.DrawRect(0,0,w,h)
end
	
function PANEL:PaintBackground(w,h)
	surface.SetDrawColor(40,40,40,160)
	surface.DrawRect(0,0,w,h)
end

local math,floor,ceil,clamp = math,math.floor,math.ceil,math.Clamp

function PANEL:GetValue()
	if self.m_Decimals != -1 then
		local dec = 10 ^ self.m_Decimals
		return floor((self.m_Value * dec) / dec)
	end
	return self.m_Value
end

function PANEL:OnValueChanged(value)
end

function PANEL:SetValue(v)
	if self.m_Value != v then
		self.OnValueChanged(self,v)
	end
	self.m_Value = v
end

function PANEL:GetMin()
	return self.m_Min
end

function PANEL:SetMin(v)
	self.m_Min = v
end

function PANEL:GetMax()
	return self.m_Max
end

function PANEL:SetMax(v)
	self.m_Max = v
end

function PANEL:SetDecimals(v)
	self.m_Decimals = v
end

function PANEL:Paint(w,h)
	-- paint bg
	self:PaintBackground(w,h)
	
	-- call the paint slider function
	local val = (self:GetValue())
	local min = self:GetMin() == 0 and self:GetMax() or self:GetMin()
	self.m_DisplayValue = math.Approach(self.m_DisplayValue,self:GetValue(),((self:GetMax()-self:GetMin())*((FrameTime()*32)*(math.abs(self:GetValue()-self.m_DisplayValue)/(self:GetMax()-self:GetMin())))))
	local m_SliderWidth = (((self:GetMin()-self.m_DisplayValue)/(self:GetMin()-self:GetMax()))) * w
	--m_SliderWidth = m_SliderWidth + ((self:GetMin()/(self:GetMax()-self:GetMin()))*w)
	self:PaintSlider(m_SliderWidth,h)

	--draw.RoundedBox(0,0,0,w,20,Color(20,20,20,200)) -- dont like how it looks
	draw.SimpleText(self.m_Label,"Impulse-Elements18-Shadow",2,2,color_white)
	draw.SimpleText(self:GetValue(),"Impulse-Elements18-Shadow",2,h-2,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)
end

function PANEL:Think()
	if self.Depressed then
		local mousex,mousey = self:CursorPos()
		local width,height = self:GetSize()
		self:SetValue(clamp((((mousex/width) * (self:GetMax()-self:GetMin()))+self:GetMin()),self:GetMin(),self:GetMax()))
	end 
end

vgui.Register("impulseSlider",PANEL,"DButton")

concommand.Add("impulse_slider_test",function()
	local f = vgui.Create("DFrame")
	f:SetSize(400,400)
	f:SetTitle("Slider Test")
	f:Center()
	f:MakePopup()

	local s = vgui.Create("impulseSlider",f)
	s:SetSize(300,50)
	s:SetDecimals(0)
	s:SetMax(100)
	s:SetMin(20)
	s:Center()
end)