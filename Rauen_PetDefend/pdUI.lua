function pdUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"pdUI");
	this:SetHeight("535");
	this:SetWidth("400");
	
	 pdUI_ResetVars();

end

function pdUI_ResetVars()
	pdUI_Var = { };
	pdUI_Var.Type = "Assist";
end

function pdUI_OnShow()

	local frame;
	local button;
	local text;
	local slider, low, high;
	local swatch, color;
	
	-- Title
	text = getglobal("pdUI_TitleText");
	text:SetText("Rauen's PetDefend v"..PetDefend_Config.Version);
	frame = getglobal("pdUI_Title");
	frame:SetWidth(text:GetWidth()+250);
	
	-- PetDefend_Config[UnitName("player")].Enabled
	button = getglobal("pdUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( PetDefend_Config[UnitName("player")].Enabled );
	
	-- Defense Panel
	text = getglobal("pdUI_DefendBoxTitle");
	text:SetText("Defending");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetDefend_Config[UnitName("player")].DefendAll
	button = getglobal("pdUI_CheckParty");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckPartyText");
	text:SetText("Defend Party");
	button:SetChecked( PetDefend_Config[UnitName("player")].DefendAll );
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config[UnitName("player")].DefendHealers
	button = getglobal("pdUI_CheckHealers");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckHealersText");
	text:SetText("Defend Healers");
	button:SetChecked( PetDefend_Config[UnitName("player")].DefendHealers );
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config[UnitName("player")].DefendAll
	button = getglobal("pdUI_CheckMember");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckMemberText");
	text:SetText("Defend Member");
	button:SetChecked( PetDefend_Config[UnitName("player")].DefendMember );
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config[UnitName("player")].Member
	text = getglobal("pdUI_MemberEdit");
	text:SetText(PetDefend_Config[UnitName("player")].DefendMemberName);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( PetDefend_Config[UnitName("player")].DefendMember ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- PetDefend_Config[UnitName("player")].AssistInCombat
	button = getglobal("pdUI_CheckAlways");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckAlwaysText");
	text:SetText("Always Defend");
	button:SetChecked( PetDefend_Config[UnitName("player")].AssistInCombat );
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config[UnitName("player")].LowHealth
	button = getglobal("pdUI_CheckLowHealth");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckLowHealthText");
	text:SetText("Defend on Low Health");
	button:SetChecked( PetDefend_Config[UnitName("player")].LowHealth );
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config[UnitName("player")].HealthMin
	slider = getglobal("pdUI_HealthSlider");
	OptionsFrame_EnableSlider(slider);
	text = getglobal("pdUI_HealthSliderText");
	low = getglobal("pdUI_HealthSliderLow");
	high = getglobal("pdUI_HealthSliderHigh");
	slider:SetMinMaxValues(0, 100);
	slider:SetValueStep(5);
	slider:SetValue( PetDefend_Config[UnitName("player")].HealthMin );
	text:SetText(PetDefend_Config[UnitName("player")].HealthMin.."% Minimum Member Health");
	low:SetText("0%");
	high:SetText("100%");
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableSlider(slider);
	end
	if not ( PetDefend_Config[UnitName("player")].LowHealth ) then
		OptionsFrame_DisableSlider(slider);
	end
	
	-- Taunt Panel
	text = getglobal("pdUI_TauntBoxTitle");
	text:SetText("Taunting");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetDefend_Config[UnitName("player")].CheckGrowl
	button = getglobal("pdUI_CheckGrowl");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckGrowlText");
	text:SetText("Taunt");
	button:SetChecked( PetDefend_Config[UnitName("player")].Growl );
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config[UnitName("player")].GrowlName
	text = getglobal("pdUI_GrowlEdit");
	text:SetText(PetDefend_Config[UnitName("player")].GrowlName);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( PetDefend_Config[UnitName("player")].Growl ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- PetDefend_Config[UnitName("player")].CheckCower
	button = getglobal("pdUI_CheckCower");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckCowerText");
	text:SetText("Detaunt");
	button:SetChecked( PetDefend_Config[UnitName("player")].Cower );
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config[UnitName("player")].CowerName
	text = getglobal("pdUI_CowerEdit");
	text:SetText(PetDefend_Config[UnitName("player")].CowerName);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( PetDefend_Config[UnitName("player")].Cower ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- PetDefend_Config[UnitName("player")].HealthMin
	slider = getglobal("pdUI_CowerSlider");
	OptionsFrame_EnableSlider(slider);
	text = getglobal("pdUI_CowerSliderText");
	low = getglobal("pdUI_CowerSliderLow");
	high = getglobal("pdUI_CowerSliderHigh");
	slider:SetMinMaxValues(0, 100);
	slider:SetValueStep(5);
	slider:SetValue( PetDefend_Config[UnitName("player")].CowerMin );
	text:SetText(PetDefend_Config[UnitName("player")].CowerMin.."% Minimum Pet Health");
	low:SetText("0%");
	high:SetText("100%");
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableSlider(slider);
	end
	if not ( PetDefend_Config[UnitName("player")].Cower ) then
		OptionsFrame_DisableSlider(slider);
	end
	
	-- Assist Tab
	button = getglobal("pdUI_AssistTab");
	text = getglobal("pdUI_AssistTabText");
	button:Enable();
	if ( pdUI_Var.Type == "Assist" ) then
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	else
		text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	end
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		button:Disable();
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Cower Tab
	button = getglobal("pdUI_CowerTab");
	text = getglobal("pdUI_CowerTabText");
	button:Enable();
	if ( pdUI_Var.Type == "Cower" ) then
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	else
		text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	end
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		button:Disable();
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetDefend_Config[UnitName("player")].AssistAlert
	button = getglobal("pdUI_CheckAssistAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckAssistAlertText");
	text:SetText("Assist Alert");
	button:SetChecked( PetDefend_Config[UnitName("player")].AssistAlert );
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	button:Hide();
	if ( pdUI_Var.Type == "Assist" ) then
		button:Show();
	end
	
	-- PetDefend_Config[UnitName("player")].AssistChannel
	button = getglobal("pdUI_AssistAlertDropDown");
	OptionsFrame_EnableDropDown(button);
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( PetDefend_Config[UnitName("player")].AssistAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	button:Hide();
	if ( pdUI_Var.Type == "Assist" ) then
		button:Show();
	end
	
	-- PetDefend_Config[UnitName("player")].AssistMessage
	text = getglobal("pdUI_AssistAlertEdit");
	text:SetWidth(300);
	text:SetText(PetDefend_Config[UnitName("player")].AssistMessage);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( PetDefend_Config[UnitName("player")].AssistAlert ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	text:Hide();
	if ( pdUI_Var.Type == "Assist" ) then
		text:Show();
	end
	
	-- PetDefend_Config[UnitName("player")].CowerAlert
	button = getglobal("pdUI_CheckCowerAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckCowerAlertText");
	text:SetText("Cower Alert");
	button:SetChecked( PetDefend_Config[UnitName("player")].CowerAlert );
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	button:Hide();
	if ( pdUI_Var.Type == "Cower" ) then
		button:Show();
	end
	
	-- PetDefend_Config[UnitName("player")].CowerChannel
	button = getglobal("pdUI_CowerAlertDropDown");
	OptionsFrame_EnableDropDown(button);
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( PetDefend_Config[UnitName("player")].CowerAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	button:Hide();
	if ( pdUI_Var.Type == "Cower" ) then
		button:Show();
	end
	
	-- PetDefend_Config[UnitName("player")].CowerMessage
	text = getglobal("pdUI_CowerAlertEdit");
	text:SetWidth(300);
	text:SetText(PetDefend_Config[UnitName("player")].CowerMessage);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( PetDefend_Config[UnitName("player")].CowerAlert ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	text:Hide();
	if ( pdUI_Var.Type == "Cower" ) then
		text:Show();
	end
	
	-- Defaults
	button = getglobal("pdUI_ResetButton");
	button:Enable();
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		button:Disable();
	end
	
	-- DropDowns
	pdUI_DropDownRefresh();

end

function pdUI_DropDownOnShow()
	local button = this;
	local name = button:GetName();
	if ( name == "pdUI_AssistAlertDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, PetDefend_Config[UnitName("player")].AssistChannel);
		UIDropDownMenu_Initialize(button, pdUI_DropDownInit);
		UIDropDownMenu_SetWidth(60, button);
	end
	if ( name == "pdUI_CowerAlertDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, PetDefend_Config[UnitName("player")].CowerChannel);
		UIDropDownMenu_Initialize(button, pdUI_DropDownInit);
		UIDropDownMenu_SetWidth(60, button);
	end
end

function pdUI_DropDownRefresh()
	UIDropDownMenu_SetSelectedValue(pdUI_AssistAlertDropDown, PetDefend_Config[UnitName("player")].AssistChannel);
	UIDropDownMenu_Refresh(pdUI_AssistAlertDropDown);
	UIDropDownMenu_SetSelectedValue(pdUI_CowerAlertDropDown, PetDefend_Config[UnitName("player")].CowerChannel);
	UIDropDownMenu_Refresh(pdUI_CowerAlertDropDown);
end

function pdUI_DropDownInit()

	local func;
	local name = this:GetName();
	if ( string.find(name, "pdUI_AssistAlertDropDown") ) then
		func = pdUI_AssistAlertDropDownOnClick;
	end
	if ( string.find(name, "pdUI_CowerAlertDropDown") ) then
		func = pdUI_CowerAlertDropDownOnClick;
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
	info.text = "Chat";
	info.value = "CHAT";
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

function pdUI_AssistAlertDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(pdUI_AssistAlertDropDown, this.value);
	PetDefend_Config[UnitName("player")].AssistChannel = UIDropDownMenu_GetSelectedValue(pdUI_AssistAlertDropDown);
end

function pdUI_CowerAlertDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(pdUI_CowerAlertDropDown, this.value);
	PetDefend_Config[UnitName("player")].CowerChannel = UIDropDownMenu_GetSelectedValue(pdUI_CowerAlertDropDown);
end

function pdUI_Close()
	PlaySound("igMainMenuClose");
	pdUI_SaveText();
	HideUIPanel(pdUI);
end

function pdUI_Reset()
	PlaySound("igMainMenuOptionCheckBoxOn");
	PetDefend_Reset();
	pdUI_OnShow();
	pdUI_DropDownRefresh();
end

function pdUI_TabOnClick(tab)
	pdUI_Var.Type = tab;
	pdUI_OnShow();
end

function pdUI_SaveText()
	local text;
	text = getglobal("pdUI_MemberEdit");
	PetDefend_Config[UnitName("player")].DefendMemberName = text:GetText();
	text = getglobal("pdUI_GrowlEdit");
	PetDefend_Config[UnitName("player")].GrowlName = text:GetText();
	text = getglobal("pdUI_AssistAlertEdit");
	PetDefend_Config[UnitName("player")].AssistMessage = text:GetText();
	text = getglobal("pdUI_CowerAlertEdit");
	PetDefend_Config[UnitName("player")].CowerMessage = text:GetText();
end

function pdUI_OpenColorPicker(button)
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

function pdUI_SetColor(key)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal("pdUI_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("pdUI_"..key);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	PetDefend_Config[UnitName("player")].Color[key].r = r;
	PetDefend_Config[UnitName("player")].Color[key].g = g;
	PetDefend_Config[UnitName("player")].Color[key].b = b;
end

function pdUI_CancelColor(key, prev)
	local r = prev.r;
	local g = prev.g;
	local b = prev.b;
	local swatch, frame;
	swatch = getglobal("pdUI_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("pdUI_"..key);
	swatch:SetVertexColor(r, g, b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	PetDefend_Config[UnitName("player")].Color[key].r = r;
	PetDefend_Config[UnitName("player")].Color[key].g = g;
	PetDefend_Config[UnitName("player")].Color[key].b = b;
end

function pdUI_SliderOnValueChanged()

	PlaySound("igMainMenuOptionCheckBoxOn");

	local slider = this;
	local name = slider:GetName();
	
	if ( name == "pdUI_HealthSlider" ) then
		PetDefend_Config[UnitName("player")].HealthMin = slider:GetValue();
		text = getglobal("pdUI_HealthSliderText");
		text:SetText(PetDefend_Config[UnitName("player")].HealthMin.."% Minimum Member Health");
	end
	if ( name == "pdUI_CowerSlider" ) then
		PetDefend_Config[UnitName("player")].CowerMin = slider:GetValue();
		text = getglobal("pdUI_CowerSliderText");
		text:SetText(PetDefend_Config[UnitName("player")].CowerMin.."% Minimum Pet Health");
	end
	
end

function pdUI_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "pdUI_CheckEnable" ) then
		if ( checked ) then
			PetDefend_Config[UnitName("player")].Enabled = true;
		else
			PetDefend_Config[UnitName("player")].Enabled = false;
		end
	end
	
	if ( name == "pdUI_CheckParty" ) then
		if ( checked ) then
			PetDefend_Config[UnitName("player")].DefendAll = true;
			PetDefend_Config[UnitName("player")].DefendHealers = false;
			PetDefend_Config[UnitName("player")].DefendMember = false;
		else
			PetDefend_Config[UnitName("player")].DefendAll = false;
		end
	end
	
	if ( name == "pdUI_CheckHealers" ) then
		if ( checked ) then
			PetDefend_Config[UnitName("player")].DefendHealers = true;
			PetDefend_Config[UnitName("player")].DefendAll = false;
			PetDefend_Config[UnitName("player")].DefendMember = false;
		else
			PetDefend_Config[UnitName("player")].DefendHealers = false;
		end
	end
	
	if ( name == "pdUI_CheckMember" ) then
		if ( checked ) then
			PetDefend_Config[UnitName("player")].DefendMember = true;
			PetDefend_Config[UnitName("player")].DefendAll = false;
			PetDefend_Config[UnitName("player")].DefendHealers = false;
		else
			PetDefend_Config[UnitName("player")].DefendMember = false;
		end
	end
	
	if ( name == "pdUI_CheckAlways" ) then
		if ( checked ) then
			PetDefend_Config[UnitName("player")].AssistInCombat = true;
		else
			PetDefend_Config[UnitName("player")].AssistInCombat = false;
		end
	end
	
	if ( name == "pdUI_CheckLowHealth" ) then
		if ( checked ) then
			PetDefend_Config[UnitName("player")].LowHealth = true;
		else
			PetDefend_Config[UnitName("player")].LowHealth = false;
		end
	end
	
	if ( name == "pdUI_CheckGrowl" ) then
		if ( checked ) then
			PetDefend_Config[UnitName("player")].Growl = true;
		else
			PetDefend_Config[UnitName("player")].Growl = false;
		end
	end
	
	if ( name == "pdUI_CheckCower" ) then
		if ( checked ) then
			PetDefend_Config[UnitName("player")].Cower = true;
		else
			PetDefend_Config[UnitName("player")].Cower = false;
		end
	end
	
	if ( name == "pdUI_CheckAssistAlert" ) then
		if ( checked ) then
			PetDefend_Config[UnitName("player")].AssistAlert = true;
		else
			PetDefend_Config[UnitName("player")].AssistAlert = false;
		end
	end
	
	if ( name == "pdUI_CheckCowerAlert" ) then
		if ( checked ) then
			PetDefend_Config[UnitName("player")].CowerAlert = true;
		else
			PetDefend_Config[UnitName("player")].CowerAlert = false;
		end
	end
	
	pdUI_SaveText();
	pdUI_OnShow();
	
end
