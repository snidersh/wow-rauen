function cwUI_Hunter_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"cwUI_Hunter");
	this:SetHeight(cwCONFIG_HEIGHT);
	this:SetWidth(cwCONFIG_WIDTH);

	-- Tabs
	PanelTemplates_SetNumTabs(this, 2);
	PanelTemplates_SetTab(this, 2);

end

function cwUI_Hunter_OnShow()

	local frame;
	local button;
	local text;
	local slider, low, high;
	local swatch, color;
	
	-- Title
	text = getglobal("cwUI_Hunter_TitleText");
	text:SetText("Rauen's CombatWatch v"..CombatWatch_Config.Version);
	frame = getglobal("cwUI_Hunter_Title");
	frame:SetWidth(text:GetWidth()+260);
	
	-- CombatWatch_Config.Enabled
	button = getglobal("cwUI_Hunter_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Hunter_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( CombatWatch_Config.Enabled );
	
	-- Hunter Panel
	frame = getglobal("cwUI_Hunter_PetHealthBox");
	frame:SetWidth(cwCONFIG_WIDTH-40);
	frame = getglobal("cwUI_Hunter_AlertsBox");
	frame:SetWidth(cwCONFIG_WIDTH-40);
	text = getglobal("cwUI_Hunter_PetHealthBoxTitle");
	text:SetText("Hunter Alerts");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( CombatWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- CombatWatch_Config.PetHealthAlert
	swatch = getglobal("cwUI_Hunter_PetHealthAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["PetHealthAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_Hunter_PetHealthAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_Hunter_SetColor("PetHealthAlert") end;
	frame.cancelFunc = function(x) cwUI_Hunter_CancelColor("PetHealthAlert", x) end;
	button = getglobal("cwUI_Hunter_PetHealthAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_Hunter_PetHealthAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Hunter_PetHealthAlert_CheckButtonText");
	text:SetText("Low Pet Health");
	button:SetChecked( CombatWatch_Config.PetHealthAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.PetHealthMin
	slider = getglobal("cwUI_Hunter_PetHealthSlider");
	OptionsFrame_EnableSlider(slider);
	text = getglobal("cwUI_Hunter_PetHealthSliderText");
	low = getglobal("cwUI_Hunter_PetHealthSliderLow");
	high = getglobal("cwUI_Hunter_PetHealthSliderHigh");
	slider:SetMinMaxValues(0, 100);
	slider:SetValueStep(5);
	slider:SetValue( CombatWatch_Config.PetHealthMin );
	text:SetText(CombatWatch_Config.PetHealthMin.."% Minimum Pet Health");
	low:SetText("0%");
	high:SetText("100%");
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableSlider(slider);
	end
	if not ( CombatWatch_Config.PetHealthAlert ) then
		OptionsFrame_DisableSlider(slider);
	end
	
	-- CombatWatch_Config.PetHealthPartyAlert
	button = getglobal("cwUI_Hunter_PetHealthPartyAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Hunter_PetHealthPartyAlertText");
	text:SetText("Message");
	button:SetChecked( CombatWatch_Config.PetHealthPartyAlert );
	UIDropDownMenu_Refresh(cwUI_Hunter_PetHealthPartyAlert);
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( CombatWatch_Config.PetHealthAlert ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.PetHealthEdit
	text = getglobal("cwUI_Hunter_PetHealthEdit");
	text:SetText(CombatWatch_Config.PartyAlert["PetHealthPartyAlert"]);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( CombatWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( CombatWatch_Config.PetHealthAlert ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	if not ( CombatWatch_Config.PetHealthPartyAlert ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- CombatWatch_Config.PetHealthDropDown
	button = getglobal("cwUI_Hunter_PetHealthDropDown");
	OptionsFrame_EnableDropDown(button);
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( CombatWatch_Config.PetHealthAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( CombatWatch_Config.PetHealthPartyAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	
	-- CombatWatch_Config.PetCritAlert
	swatch = getglobal("cwUI_Hunter_PetCritAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["PetCritAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_Hunter_PetCritAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_Hunter_SetColor("PetCritAlert") end;
	frame.cancelFunc = function(x) cwUI_Hunter_CancelColor("PetCritAlert", x) end;
	button = getglobal("cwUI_Hunter_PetCritAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_Hunter_PetCritAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Hunter_PetCritAlert_CheckButtonText");
	text:SetText("Pet Critical Hits");
	button:SetChecked( CombatWatch_Config.PetCritAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.PetWindow
	button = getglobal("cwUI_Hunter_CheckWindow");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Hunter_CheckWindowText");
	text:SetText("Show Pet Window");
	button:SetChecked( CombatWatch_Config.PetWindow );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- DropDowns
	cwUI_Hunter_DropDownRefresh();

end

function cwUI_Hunter_DropDownOnShow()
	local button = this;
	local name = button:GetName();
	if ( name == "cwUI_Hunter_PetHealthDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, CombatWatch_Config.PetHealthPartyAlertChan);
		UIDropDownMenu_Initialize(button, cwUI_Hunter_DropDownInit);
		UIDropDownMenu_SetWidth(60, button);
	end
end

function cwUI_Hunter_DropDownInit()

	local func;
	local name = this:GetName();
	if ( string.find(name, "cwUI_Hunter_PetHealthDropDown") ) then
		func = cwUI_Hunter_PetHealthDropDownOnClick;
	end
	
	local info = { };
	info.text = "Say";
	info.value = "SAY";
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
	info.text = "Party";
	info.value = "PARTY";
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
	info.text = "Emote";
	info.value = "EMOTE";
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
end

function cwUI_Hunter_PetHealthDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(cwUI_Hunter_PetHealthDropDown, this.value);
	CombatWatch_Config.PetHealthPartyAlertChan = UIDropDownMenu_GetSelectedValue(cwUI_Hunter_PetHealthDropDown);
end

function cwUI_Hunter_DropDownRefresh()
	UIDropDownMenu_SetSelectedValue(cwUI_Hunter_PetHealthDropDown, CombatWatch_Config.PetHealthPartyAlertChan);
	UIDropDownMenu_Refresh(cwUI_Hunter_PetHealthDropDown);
end

function cwUI_Hunter_Close()
	PlaySound("igMainMenuClose");
	cwUI_Hunter_SaveText();
	HideUIPanel(cwUI_Hunter);
end

function cwUI_Hunter_TabButtonOnClick()

	local text = this:GetText();
	if ( text ~= "Hunter" ) then
		cwUI_Hunter_Close();
	end
	if ( text == "General" ) then
		ShowUIPanel(cwUI_General);
	end

end

function cwUI_Hunter_SaveText()
	local text;
	text = getglobal("cwUI_Hunter_PetHealthEdit");
	CombatWatch_Config.PartyAlert["PetHealthPartyAlert"] = text:GetText();
end

function cwUI_Hunter_OpenColorPicker(button)
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

function cwUI_Hunter_SetColor(key)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal("cwUI_Hunter_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("cwUI_Hunter_"..key);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	CombatWatch_Config.Color[key].r = r;
	CombatWatch_Config.Color[key].g = g;
	CombatWatch_Config.Color[key].b = b;
end

function cwUI_Hunter_CancelColor(key, prev)
	local r = prev.r;
	local g = prev.g;
	local b = prev.b;
	local swatch, frame;
	swatch = getglobal("cwUI_Hunter_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("cwUI_Hunter_"..key);
	swatch:SetVertexColor(r, g, b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	CombatWatch_Config.Color[key].r = r;
	CombatWatch_Config.Color[key].g = g;
	CombatWatch_Config.Color[key].b = b;
end

function cwUI_Hunter_SliderOnValueChanged()

	PlaySound("igMainMenuOptionCheckBoxOn");

	local slider = this;
	local name = slider:GetName();
	
	if ( name == "cwUI_Hunter_PetHealthSlider" ) then
		CombatWatch_Config.PetHealthMin = slider:GetValue();
		text = getglobal("cwUI_Hunter_PetHealthSliderText");
		text:SetText(CombatWatch_Config.PetHealthMin.."% Minimum Pet Health");
	end
	
end

function cwUI_Hunter_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "cwUI_Hunter_CheckEnable" ) then
		if ( checked ) then
			CombatWatch_Config.Enabled = true;
		else
			CombatWatch_Config.Enabled = false;
		end
	end
	
	if ( name == "cwUI_Hunter_PetHealthAlert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.PetHealthAlert = true;
		else
			CombatWatch_Config.PetHealthAlert = false;
		end
	end
	
	if ( name == "cwUI_Hunter_PetHealthPartyAlert" ) then
		if ( checked ) then
			CombatWatch_Config.PetHealthPartyAlert = true;
		else
			CombatWatch_Config.PetHealthPartyAlert = false;
		end
	end
	
	if ( name == "cwUI_Hunter_PetCritAlert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.PetCritAlert = true;
		else
			CombatWatch_Config.PetCritAlert = false;
		end
	end
	
	if ( name == "cwUI_Hunter_CheckWindow" ) then
		if ( checked ) then
			CombatWatch_Config.PetWindow = true;
		else
			CombatWatch_Config.PetWindow = false;
		end
	end
	
	cwUI_Hunter_SaveText();
	cwUI_Hunter_OnShow();
	
end
