function cwUI_Paladin_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"cwUI_Paladin");
	this:SetHeight(cwCONFIG_HEIGHT);
	this:SetWidth(cwCONFIG_WIDTH);

	-- Tabs
	PanelTemplates_SetNumTabs(this, 2);
	PanelTemplates_SetTab(this, 2);

end

function cwUI_Paladin_OnShow()

	local frame;
	local button;
	local text;
	local slider, low, high;
	local swatch, color;
	
	-- Title
	text = getglobal("cwUI_Paladin_TitleText");
	text:SetText("Rauen's CombatWatch v"..CombatWatch_Config.Version);
	frame = getglobal("cwUI_Paladin_Title");
	frame:SetWidth(text:GetWidth()+260);
	
	-- CombatWatch_Config.Enabled
	button = getglobal("cwUI_Paladin_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Paladin_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( CombatWatch_Config.Enabled );
	
	-- Paladin Panel
	frame = getglobal("cwUI_Paladin_AlertsBox");
	frame:SetWidth(cwCONFIG_WIDTH-40);
	text = getglobal("cwUI_Paladin_AlertsBoxTitle");
	text:SetText("Paladin Alerts");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( CombatWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- CombatWatch_Config.HealOtherAlert
	swatch = getglobal("cwUI_Paladin_HealOtherAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["HealOtherAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_Paladin_HealOtherAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_Paladin_SetColor("HealOtherAlert") end;
	frame.cancelFunc = function(x) cwUI_Paladin_CancelColor("HealOtherAlert", x) end;
	button = getglobal("cwUI_Paladin_HealOtherAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_Paladin_HealOtherAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Paladin_HealOtherAlert_CheckButtonText");
	text:SetText("Healing Others");
	button:SetChecked( CombatWatch_Config.HealOtherAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.PartyHealthAlert
	swatch = getglobal("cwUI_Paladin_PartyHealthAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["PartyHealthAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_Paladin_PartyHealthAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_Paladin_SetColor("PartyHealthAlert") end;
	frame.cancelFunc = function(x) cwUI_Paladin_CancelColor("PartyHealthAlert", x) end;
	button = getglobal("cwUI_Paladin_PartyHealthAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_Paladin_PartyHealthAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Paladin_PartyHealthAlert_CheckButtonText");
	text:SetText("Low Party Health");
	button:SetChecked( CombatWatch_Config.PartyHealthAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.PartyHealthMin
	slider = getglobal("cwUI_Paladin_PartyHealthSlider");
	OptionsFrame_EnableSlider(slider);
	text = getglobal("cwUI_Paladin_PartyHealthSliderText");
	low = getglobal("cwUI_Paladin_PartyHealthSliderLow");
	high = getglobal("cwUI_Paladin_PartyHealthSliderHigh");
	slider:SetMinMaxValues(0, 100);
	slider:SetValueStep(5);
	slider:SetValue( CombatWatch_Config.PartyHealthMin );
	text:SetText(CombatWatch_Config.PartyHealthMin.."% Minimum Member Health");
	low:SetText("0%");
	high:SetText("100%");
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableSlider(slider);
	end
	if not ( CombatWatch_Config.PartyHealthAlert ) then
		OptionsFrame_DisableSlider(slider);
	end

end

function cwUI_Paladin_Close()
	PlaySound("igMainMenuClose");
	HideUIPanel(cwUI_Paladin);
end

function cwUI_Paladin_TabButtonOnClick()

	local text = this:GetText();
	if ( text ~= "Paladin" ) then
		cwUI_Paladin_Close();
	end
	if ( text == "General" ) then
		ShowUIPanel(cwUI_General);
	end

end

function cwUI_Paladin_OpenColorPicker(button)
	CloseMenus();
	if ( not button ) then
		button = this;
	end
	ColorPickerFrame.func = button.swatchFunc;
	ColorPickerFrame:SetColorRGB(button.r, button.g, button.b);
	ColorPickerFrame.previousValues = {r = button.r, g = button.g, b = button.b, opacity = button.opacity};
	ColorPickerFrame.cancelFunc = button.cancelFunc;
	ColorPickerFrame:Show();
end

function cwUI_Paladin_SetColor(key)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal("cwUI_Paladin_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("cwUI_Paladin_"..key);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	CombatWatch_Config.Color[key].r = r;
	CombatWatch_Config.Color[key].g = g;
	CombatWatch_Config.Color[key].b = b;
end

function cwUI_Paladin_CancelColor(key, prev)
	local r = prev.r;
	local g = prev.g;
	local b = prev.b;
	local swatch, frame;
	swatch = getglobal("cwUI_Paladin_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("cwUI_Paladin_"..key);
	swatch:SetVertexColor(r, g, b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	CombatWatch_Config.Color[key].r = r;
	CombatWatch_Config.Color[key].g = g;
	CombatWatch_Config.Color[key].b = b;
end

function cwUI_Paladin_SliderOnValueChanged()

	PlaySound("igMainMenuOptionCheckBoxOn");

	local slider = this;
	local name = slider:GetName();
	
	if ( name == "cwUI_Paladin_PartyHealthSlider" ) then
		CombatWatch_Config.PartyHealthMin = slider:GetValue();
		text = getglobal("cwUI_Paladin_PartyHealthSliderText");
		text:SetText(CombatWatch_Config.PartyHealthMin.."% Minimum Member Health");
	end
	
end


function cwUI_Paladin_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "cwUI_Paladin_CheckEnable" ) then
		if ( checked ) then
			CombatWatch_Config.Enabled = true;
		else
			CombatWatch_Config.Enabled = false;
		end
	end
	
	if ( name == "cwUI_Paladin_HealOtherAlert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.HealOtherAlert = true;
		else
			CombatWatch_Config.HealOtherAlert = false;
		end
	end
	
	if ( name == "cwUI_Paladin_PartyHealthAlert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.PartyHealthAlert = true;
		else
			CombatWatch_Config.PartyHealthAlert = false;
		end
	end
	
	cwUI_Paladin_OnShow();
	
end
