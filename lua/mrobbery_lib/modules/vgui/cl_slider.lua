-- BASED ON GARRYSMOD DNumSlider
local PANEL = {}

AccessorFunc(PANEL, "m_fDefaultValue", "DefaultValue")

function PANEL:Init()

	self.Slider = self:Add("mrbslider", self)
	self.Slider:SetLockY(0.5)
	self.Slider.TranslateValues = function(slider, x, y) return self:TranslateSliderValues(x, y) end
	self.Slider:SetTrapInside(true)
	self.Slider:Dock(FILL)
	self.Slider:SetHeight(16)
	self.Slider.Knob.OnMousePressed = function(panel, mcode)
		if (mcode == MOUSE_MIDDLE) then
			self:ResetToDefaultValue()
			return
		end
		self.Slider:OnMousePressed(mcode)
	end

	self.Label = vgui.Create ("DLabel", self)
	self.Label:Dock(LEFT)
	self.Label:SetMouseInputEnabled(false)
  self.Label:SetText("")

	self.Scratch = self.Label:Add("DNumberScratch")
	self.Scratch:SetImageVisible(false)
	self.Scratch:Dock(FILL)
	self.Scratch.OnValueChanged = function() self:ValueChanged(self.Scratch:GetFloatValue()) end

	self:SetTall(32)

	self:SetMin(0)
	self:SetMax(1)
	self:SetDecimals(2)
	self:SetText("")
	self:SetValue(0.5)

	--
	-- You really shouldn't be messing with the internals of these controls from outside..
	-- .. but if you are, this might stop your code from fucking us both.
	--
	self.Wang = self.Scratch

end

function PANEL:SetMinMax(min, max)
	self.Scratch:SetMin(tonumber(min))
	self.Scratch:SetMax(tonumber(max))
end

function PANEL:SetDark(b)
	self.Label:SetDark(b)
end

function PANEL:GetMin()
	return self.Scratch:GetMin()
end

function PANEL:GetMax()
	return self.Scratch:GetMax()
end

function PANEL:GetRange()
	return self:GetMax() - self:GetMin()
end

function PANEL:ResetToDefaultValue()
	if (!self:GetDefaultValue()) then return end
	self:SetValue(self:GetDefaultValue())
end

function PANEL:SetMin(min)
	if (!min) then min = 0 end

	self.Scratch:SetMin(tonumber(min))
end

function PANEL:SetMax(max)
	if (!max) then max = 0 end

	self.Scratch:SetMax(tonumber(max))
end

function PANEL:SetValue(val)
	val = math.Clamp(tonumber(val) || 0, self:GetMin(), self:GetMax())

	if (self:GetValue() == val) then return end

	self.Scratch:SetValue(val)
	self:ValueChanged(self:GetValue())
end

function PANEL:GetValue()
	return math.Round(self.Scratch:GetFloatValue(), 0)
end

function PANEL:GetSlideX()
		return self.Slider:GetSlideX()
end

function PANEL:SetDecimals(d)
	self.Scratch:SetDecimals(d)
	self:ValueChanged(self:GetValue())
end

function PANEL:GetDecimals()
	return self.Scratch:GetDecimals()
end

function PANEL:IsEditing()
	return self.Scratch:IsEditing() || self.Slider:IsEditing()
end

function PANEL:IsHovered()
	return self.Scratch:IsHovered() || self.Slider:IsHovered() || vgui.GetHoveredPanel() == self
end

function PANEL:PerformLayout()
	self.Label:SetWide(self:GetWide() / 2.4)
end

function PANEL:SetConVar(cvar)
	self.Scratch:SetConVar(cvar)
end

function PANEL:ValueChanged(val)
	val = math.Clamp(tonumber(val) || 0, self:GetMin(), self:GetMax())
	self.Slider:SetSlideX(self.Scratch:GetFraction(val))
	self:OnValueChanged(val)
end

function PANEL:OnValueChanged()
  -- for override
end

function PANEL:TranslateSliderValues(x, y)
	self:SetValue(self.Scratch:GetMin() + (x * self.Scratch:GetRange()))

	return self.Scratch:GetFraction(), y
end

derma.DefineControl("mrslider", "Custom dnumslider.", PANEL, "Panel")
