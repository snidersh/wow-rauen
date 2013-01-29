function pdUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"pdUI");
	this:SetHeight("460");
	this:SetWidth("400");

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
	
	-- PetDefend_Config.Enabled
	button = getglobal("pdUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( PetDefend_Config.Enabled );
	
	-- Defense Panel
	text = getglobal("pdUI_DefendBoxTitle");
	text:SetText("Defending");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetDefend_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetDefend_Config.DefendAll
	button = getglobal("pdUI_CheckParty");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckPartyText");
	text:SetText("Defend Party");
	button:SetChecked( PetDefend_Config.DefendAll );
	if not ( PetDefend_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config.DefendAll
	button = getglobal("pdUI_CheckMember");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckMemberText");
	text:SetText("Defend Member");
	if ( PetDefend_Config.DefendAll ) then
		button:SetChecked(0)
	else
		button:SetChecked(1);
	end
	if not ( PetDefend_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config.Member
	text = getglobal("pdUI_MemberEdit");
	text:SetText(PetDefend_Config.DefendMember);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetDefend_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if ( PetDefend_Config.DefendAll ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- PetDefend_Config.AssistInCombat
	button = getglobal("pdUI_CheckAlways");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckAlwaysText");
	text:SetText("Always Defend");
	button:SetChecked( PetDefend_Config.AssistInCombat );
	if not ( PetDefend_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config.LowHealth
	button = getglobal("pdUI_CheckLowHealth");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckLowHealthText");
	text:SetText("Defend on Low Health");
	button:SetChecked( PetDefend_Config.LowHealth );
	if not ( PetDefend_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config.HealthMin
	slider = getglobal("pdUI_HealthSlider");
	OptionsFrame_EnableSlider(slider);
	text = getglobal("pdUI_HealthSliderText");
	low = getglobal("pdUI_HealthSliderLow");
	high = getglobal("pdUI_HealthSliderHigh");
	slider:SetMinMaxValues(0, 100);
	slider:SetValueStep(5);
	slider:SetValue( PetDefend_Config.HealthMin );
	text:SetText(PetDefend_Config.HealthMin.."% Minimum Member Health");
	low:SetText("0%");
	high:SetText("100%");
	if not ( PetDefend_Config.Enabled ) then
		OptionsFrame_DisableSlider(slider);
	end
	if not ( PetDefend_Config.LowHealth ) then
		OptionsFrame_DisableSlider(slider);
	end
	
	-- Taunt Panel
	text = getglobal("pdUI_TauntBoxTitle");
	text:SetText("Taunting");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetDefend_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetDefend_Config.CheckGrowl
	button = getglobal("pdUI_CheckGrowl");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckGrowlText");
	text:SetText("Taunt");
	button:SetChecked( PetDefend_Config.Growl );
	if not ( PetDefend_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config.GrowlName
	text = getglobal("pdUI_GrowlEdit");
	text:SetText(PetDefend_Config.GrowlName);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetDefend_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( PetDefend_Config.Growl ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- PetDefend_Config.CheckCower
	button = getglobal("pdUI_CheckCower");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckCowerText");
	text:SetText("Detaunt");
	button:SetChecked( PetDefend_Config.Cower );
	if not ( PetDefend_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config.CowerName
	text = getglobal("pdUI_CowerEdit");
	text:SetText(PetDefend_Config.CowerName);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetDefend_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( PetDefend_Config.Cower ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- PetDefend_Config.HealthMin
	slider = getglobal("pdUI_CowerSlider");
	OptionsFrame_EnableSlider(slider);
	text = getglobal("pdUI_CowerSliderText");
	low = getglobal("pdUI_CowerSliderLow");
	high = getglobal("pdUI_CowerSliderHigh");
	slider:SetMinMaxValues(0, 100);
	slider:SetValueStep(5);
	slider:SetValue( PetDefend_Config.CowerMin );
	text:SetText(PetDefend_Config.CowerMin.."% Minimum Pet Health");
	low:SetText("0%");
	high:SetText("100%");
	if not ( PetDefend_Config.Enabled ) then
		OptionsFrame_DisableSlider(slider);
	end
	if not ( PetDefend_Config.Cower ) then
		OptionsFrame_DisableSlider(slider);
	end
	
	-- Alert Panel
	text = getglobal("pdUI_AlertBoxTitle");
	text:SetText("Alerts");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetDefend_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetDefend_Config.Alert
	button = getglobal("pdUI_CheckAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pdUI_CheckAlertText");
	text:SetText("Defense Messages");
	button:SetChecked( PetDefend_Config.Alert );
	if not ( PetDefend_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetDefend_Config.Channel
	button = getglobal("pdUI_AlertDropDown");
	OptionsFrame_EnableDropDown(button);
	if not ( PetDefend_Config.Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( PetDefend_Config.Alert ) then
		OptionsFrame_DisableDropDown(button);
	end
	
	-- Defaults
	button = getglobal("pdUI_ResetButton");
	button:Enable();
	if not ( PetDefend_Config.Enabled ) then
		button:Disable();
	end
	
	-- DropDowns
	pdUI_DropDownRefresh();

end

function pdUI_DropDownOnShow()
	local button = this;
	local name = button:GetName();
	if ( name == "pdUI_AlertDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, PetDefend_Config.Channel);
		UIDropDownMenu_Initialize(button, pdUI_DropDownInit);
		UIDropDownMenu_SetWidth(60, button);
	end
end

function pdUI_DropDownRefresh()
	UIDropDownMenu_SetSelectedValue(pdUI_AlertDropDown, PetDefend_Config.Channel);
	UIDropDownMenu_Refresh(pdUI_AlertDropDown);
end

function pdUI_DropDownInit()

	local func;
	local name = this:GetName();
	if ( string.find(name, "pdUI_AlertDropDown") ) then
		func = pdUI_AlertDropDownOnClick;
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
end

function pdUI_AlertDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(pdUI_AlertDropDown, this.value);
	PetDefend_Config.Channel = UIDropDownMenu_GetSelectedValue(pdUI_AlertDropDown);
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

function pdUI_SaveText()
	local text;
	text = getglobal("pdUI_MemberEdit");
	PetDefend_Config.DefendMember = text:GetText();
	text = getglobal("pdUI_GrowlEdit");
	PetDefend_Config.GrowlName = text:GetText();
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
	PetDefend_Config.Color[key].r = r;
	PetDefend_Config.Color[key].g = g;
	PetDefend_Config.Color[key].b = b;
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
	PetDefend_Config.Color[key].r = r;
	PetDefend_Config.Color[key].g = g;
	PetDefend_Config.Color[key].b = b;
end

function pdUI_SliderOnValueChanged()

	PlaySound("igMainMenuOptionCheckBoxOn");

	local slider = this;
	local name = slider:GetName();
	
	if ( name == "pdUI_HealthSlider" ) then
		PetDefend_Config.HealthMin = slider:GetValue();
		text = getglobal("pdUI_HealthSliderText");
		text:SetText(PetDefend_Config.HealthMin.."% Minimum Member Health");
	end
	if ( name == "pdUI_CowerSlider" ) then
		PetDefend_Config.CowerMin = slider:GetValue();
		text = getglobal("pdUI_CowerSliderText");
		text:SetText(PetDefend_Config.CowerMin.."% Minimum Pet Health");
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
			PetDefend_Config.Enabled = true;
		else
			PetDefend_Config.Enabled = false;
		end
	end
	
	if ( name == "pdUI_CheckParty" ) then
		if ( checked ) then
			PetDefend_Config.DefendAll = true;
		else
			PetDefend_Config.DefendAll = false;
		end
	end
	
	if ( name == "pdUI_CheckMember" ) then
		if ( checked ) then
			PetDefend_Config.DefendAll = false;
		else
			PetDefend_Config.DefendAll = true;
		end
	end
	
	if ( name == "pdUI_CheckAlways" ) then
		if ( checked ) then
			PetDefend_Config.AssistInCombat = true;
		else
			PetDefend_Config.AssistInCombat = false;
		end
	end
	
	if ( name == "pdUI_CheckLowHealth" ) then
		if ( checked ) then
			PetDefend_Config.LowHealth = true;
		else
			PetDefend_Config.LowHealth = false;
		end
	end
	
	if ( name == "pdUI_CheckGrowl" ) then
		if ( checked ) then
			PetDefend_Config.Growl = true;
		else
			PetDefend_Config.Growl = false;
		end
	end
	
	if ( name == "pdUI_CheckCower" ) then
		if ( checked ) then
			PetDefend_Config.Cower = true;
		else
			PetDefend_Config.Cower = false;
		end
	end
	
	if ( name == "pdUI_CheckAlert" ) then
		if ( checked ) then
			PetDefend_Config.Alert = true;
		else
			PetDefend_Config.Alert = false;
		end
	end
	
	pdUI_SaveText();
	pdUI_OnShow();
	
end