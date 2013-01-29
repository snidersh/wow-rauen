function cwUI_Warlock_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"cwUI_Warlock");
	this:SetHeight(cwCONFIG_HEIGHT);
	this:SetWidth(cwCONFIG_WIDTH);

	-- Tabs
	PanelTemplates_SetNumTabs(this, 2);
	PanelTemplates_SetTab(this, 2);

end

function cwUI_Warlock_OnShow()

	local frame;
	local button;
	local text;
	local slider, low, high;
	local swatch, color;
	
	-- Title
	text = getglobal("cwUI_Warlock_TitleText");
	text:SetText("Rauen's CombatWatch v"..CombatWatch_Config.Version);
	frame = getglobal("cwUI_Warlock_Title");
	frame:SetWidth(text:GetWidth()+260);
	
	-- CombatWatch_Config.Enabled
	button = getglobal("cwUI_Warlock_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Warlock_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( CombatWatch_Config.Enabled );
	
	-- Warlock Panel
	frame = getglobal("cwUI_Warlock_PetHealthBox");
	frame:SetWidth(cwCONFIG_WIDTH-40);
	frame = getglobal("cwUI_Warlock_AlertsBox");
	frame:SetWidth(cwCONFIG_WIDTH-40);
	text = getglobal("cwUI_Warlock_PetHealthBoxTitle");
	text:SetText("Warlock Alerts");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( CombatWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- CombatWatch_Config.PetHealthAlert
	swatch = getglobal("cwUI_Warlock_PetHealthAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["PetHealthAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_Warlock_PetHealthAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_Warlock_SetColor("PetHealthAlert") end;
	frame.cancelFunc = function(x) cwUI_Warlock_CancelColor("PetHealthAlert", x) end;
	button = getglobal("cwUI_Warlock_PetHealthAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_Warlock_PetHealthAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Warlock_PetHealthAlert_CheckButtonText");
	text:SetText("Low Pet Health");
	button:SetChecked( CombatWatch_Config.PetHealthAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.PetHealthMin
	slider = getglobal("cwUI_Warlock_PetHealthSlider");
	OptionsFrame_EnableSlider(slider);
	text = getglobal("cwUI_Warlock_PetHealthSliderText");
	low = getglobal("cwUI_Warlock_PetHealthSliderLow");
	high = getglobal("cwUI_Warlock_PetHealthSliderHigh");
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
	button = getglobal("cwUI_Warlock_PetHealthPartyAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Warlock_PetHealthPartyAlertText");
	text:SetText("Message");
	button:SetChecked( CombatWatch_Config.PetHealthPartyAlert );
	UIDropDownMenu_Refresh(cwUI_Warlock_PetHealthPartyAlert);
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( CombatWatch_Config.PetHealthAlert ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.PetHealthEdit
	text = getglobal("cwUI_Warlock_PetHealthEdit");
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
	button = getglobal("cwUI_Warlock_PetHealthDropDown");
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
	swatch = getglobal("cwUI_Warlock_PetCritAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["PetCritAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_Warlock_PetCritAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_Warlock_SetColor("PetCritAlert") end;
	frame.cancelFunc = function(x) cwUI_Warlock_CancelColor("PetCritAlert", x) end;
	button = getglobal("cwUI_Warlock_PetCritAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_Warlock_PetCritAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Warlock_PetCritAlert_CheckButtonText");
	text:SetText("Pet Critical Hits");
	button:SetChecked( CombatWatch_Config.PetCritAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.PetWindow
	button = getglobal("cwUI_Warlock_CheckWindow");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Warlock_CheckWindowText");
	text:SetText("Show Pet Window");
	button:SetChecked( CombatWatch_Config.PetWindow );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end

	
	-- DropDowns
	cwUI_Warlock_DropDownRefresh();

end

function cwUI_Warlock_DropDownOnShow()
	local button = this;
	local name = button:GetName();
	if ( name == "cwUI_Warlock_PetHealthDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, CombatWatch_Config.PetHealthPartyAlertChan);
		UIDropDownMenu_Initialize(button, cwUI_Warlock_DropDownInit);
		UIDropDownMenu_SetWidth(60, button);
	end
end

function cwUI_Warlock_DropDownInit()

	local func;
	local name = this:GetName();
	if ( string.find(name, "cwUI_Warlock_PetHealthDropDown") ) then
		func = cwUI_Warlock_PetHealthDropDownOnClick;
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

function cwUI_Warlock_PetHealthDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(cwUI_Warlock_PetHealthDropDown, this.value);
	CombatWatch_Config.PetHealthPartyAlertChan = UIDropDownMenu_GetSelectedValue(cwUI_Warlock_PetHealthDropDown);
end

function cwUI_Warlock_DropDownRefresh()
	UIDropDownMenu_SetSelectedValue(cwUI_Warlock_PetHealthDropDown, CombatWatch_Config.PetHealthPartyAlertChan);
	UIDropDownMenu_Refresh(cwUI_Warlock_PetHealthDropDown);
end

function cwUI_Warlock_Close()
	PlaySound("igMainMenuClose");
	cwUI_Warlock_SaveText();
	HideUIPanel(cwUI_Warlock);
end

function cwUI_Warlock_TabButtonOnClick()

	local text = this:GetText();
	if ( text ~= "Warlock" ) then
		cwUI_Warlock_Close();
	end
	if ( text == "General" ) then
		ShowUIPanel(cwUI_General);
	end

end

function cwUI_Warlock_SaveText()
	local text;
	text = getglobal("cwUI_Warlock_PetHealthEdit");
	CombatWatch_Config.PartyAlert["PetHealthPartyAlert"] = text:GetText();
end

function cwUI_Warlock_OpenColorPicker(button)
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

function cwUI_Warlock_SetColor(key)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal("cwUI_Warlock_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("cwUI_Warlock_"..key);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	CombatWatch_Config.Color[key].r = r;
	CombatWatch_Config.Color[key].g = g;
	CombatWatch_Config.Color[key].b = b;
end

function cwUI_Warlock_CancelColor(key, prev)
	local r = prev.r;
	local g = prev.g;
	local b = prev.b;
	local swatch, frame;
	swatch = getglobal("cwUI_Warlock_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("cwUI_Warlock_"..key);
	swatch:SetVertexColor(r, g, b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	CombatWatch_Config.Color[key].r = r;
	CombatWatch_Config.Color[key].g = g;
	CombatWatch_Config.Color[key].b = b;
end

function cwUI_Warlock_SliderOnValueChanged()

	PlaySound("igMainMenuOptionCheckBoxOn");

	local slider = this;
	local name = slider:GetName();
	
	if ( name == "cwUI_Warlock_PetHealthSlider" ) then
		CombatWatch_Config.PetHealthMin = slider:GetValue();
		text = getglobal("cwUI_Warlock_PetHealthSliderText");
		text:SetText(CombatWatch_Config.PetHealthMin.."% Minimum Pet Health");
	end
	
end

function cwUI_Warlock_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "cwUI_Warlock_CheckEnable" ) then
		if ( checked ) then
			CombatWatch_Config.Enabled = true;
		else
			CombatWatch_Config.Enabled = false;
		end
	end
	
	if ( name == "cwUI_Warlock_PetHealthAlert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.PetHealthAlert = true;
		else
			CombatWatch_Config.PetHealthAlert = false;
		end
	end
	
	if ( name == "cwUI_Warlock_PetHealthPartyAlert" ) then
		if ( checked ) then
			CombatWatch_Config.PetHealthPartyAlert = true;
		else
			CombatWatch_Config.PetHealthPartyAlert = false;
		end
	end
	
	if ( name == "cwUI_Warlock_PetCritAlert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.PetCritAlert = true;
		else
			CombatWatch_Config.PetCritAlert = false;
		end
	end
	
	if ( name == "cwUI_Warlock_CheckWindow" ) then
		if ( checked ) then
			CombatWatch_Config.PetWindow = true;
		else
			CombatWatch_Config.PetWindow = false;
		end
	end
	
	cwUI_Warlock_SaveText();
	cwUI_Warlock_OnShow();
	
end