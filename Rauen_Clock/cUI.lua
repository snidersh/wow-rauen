function cUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"cUI");
	this:SetHeight("250");
	this:SetWidth("485");

end

function cUI_OnShow()

	local frame;
	local button;
	local text;
	local label;
	
	-- Title
	text = getglobal("cUI_TitleText");
	text:SetText("Rauen's Clock v"..Clock_Config.Version);
	frame = getglobal("cUI_Title");
	frame:SetWidth(text:GetWidth()+250);
	
	-- Clock_Config.Enabled
	button = getglobal("cUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( Clock_Config.Enabled );
	
	-- Bar Panel
	text = getglobal("cUI_ClockBoxTitle");
	text:SetText("Alarm");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( Clock_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Clock_Var.Set
	button = getglobal("cUI_CheckAlarmSet");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cUI_CheckAlarmSetText");
	text:SetText("  Alarm Set");
	label = getglobal("cUI_CheckAlarmSetLabel");
	if ( Clock_Var.AlarmSet ) and ( Clock_Config.Enabled ) then
		if ( Clock_Var.PM == 1 ) then
			label:SetText(format("  "..TEXT(TIME_TWELVEHOURPM), Clock_Var.AlarmHour, Clock_Var.AlarmMinute));
		else
			label:SetText(format("  "..TEXT(TIME_TWELVEHOURAM), Clock_Var.AlarmHour, Clock_Var.AlarmMinute));
		end
	else
		label:SetText(" ");
	end
	button:SetChecked( Clock_Var.AlarmSet );
	if not ( Clock_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end

	-- Clock_Var.HourSlider
	slider = getglobal("cUI_HourSlider");
	OptionsFrame_EnableSlider(slider);
	text = getglobal("cUI_HourSliderText");
	low = getglobal("cUI_HourSliderLow");
	high = getglobal("cUI_HourSliderHigh");
	slider:SetMinMaxValues(1, 12);
	slider:SetValueStep(1);
	slider:SetValue( Clock_Var.AlarmHour );
	text:SetText("Hour");
	low:SetText("1");
	high:SetText("12");
	slider:SetWidth(200);
	if not ( Clock_Config.Enabled ) then
		OptionsFrame_DisableSlider(slider);
	end
	if not ( Clock_Var.AlarmSet ) then
		OptionsFrame_DisableSlider(slider);
	end
	
	-- Clock_Var.MinuteSlider
	slider = getglobal("cUI_MinuteSlider");
	OptionsFrame_EnableSlider(slider);
	text = getglobal("cUI_MinuteSliderText");
	low = getglobal("cUI_MinuteSliderLow");
	high = getglobal("cUI_MinuteSliderHigh");
	slider:SetMinMaxValues(0, 59);
	slider:SetValueStep(1);
	slider:SetValue( Clock_Var.AlarmMinute );
	text:SetText("Minute");
	low:SetText("00");
	high:SetText("59");
	slider:SetWidth(200);
	if not ( Clock_Config.Enabled ) then
		OptionsFrame_DisableSlider(slider);
	end
	if not ( Clock_Var.AlarmSet ) then
		OptionsFrame_DisableSlider(slider);
	end
	
	-- Hour DropDown
	button = getglobal("cUI_HourDropDown");
	OptionsFrame_EnableDropDown(button);
	if not ( Clock_Config.Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( Clock_Var.AlarmSet ) then
		OptionsFrame_DisableDropDown(button);
	end
	
	-- Clock_Var.AlarmMessage
	text = getglobal("cUI_MessageEdit");
	text:SetText(Clock_Var.AlarmMessage);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( Clock_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( Clock_Var.AlarmSet ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Defaults
	button = getglobal("cUI_ResetButton");
	button:Enable();
	if not ( Clock_Config.Enabled ) then
		button:Disable();
	end
	
	-- DropDowns
	cUI_DropDownRefresh();

end

function cUI_Close()
	PlaySound("igMainMenuClose");
	cUI_SaveText();
	HideUIPanel(cUI);
end

function cUI_Reset()
	PlaySound("igMainMenuOptionCheckBoxOn");
	Clock_Reset();
	Clock_ResetAlarm();
	cUI_OnShow();
end

function cUI_SliderOnValueChanged()

	PlaySound("igMainMenuOptionCheckBoxOn");

	local slider = this;
	local name = slider:GetName();
	
	if ( name == "cUI_HourSlider" ) then
		Clock_Var.AlarmHour = slider:GetValue();
	end
	if ( name == "cUI_MinuteSlider" ) then
		Clock_Var.AlarmMinute = slider:GetValue();
	end
	
	cUI_OnShow();
	
end

function cUI_DropDownOnShow()
	local button = this;
	local name = button:GetName();
	if ( name == "cUI_HourDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, Clock_Var.PM);
		UIDropDownMenu_Initialize(button, cUI_DropDownInit);
		UIDropDownMenu_SetWidth(50, button);
	end
end

function cUI_DropDownRefresh()
	UIDropDownMenu_SetSelectedValue(cUI_HourDropDown, Clock_Var.PM);
	UIDropDownMenu_Refresh(cUI_HourDropDown);
end

function cUI_DropDownInit()

	local func;
	local name = this:GetName();
	if ( string.find(name, "cUI_HourDropDown") ) then
		func = cUI_HourDropDownOnClick;
	end
	
	local info = { };
	info.text = "AM";
	info.value = 0;
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
	info.text = "PM";
	info.value = 1;
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
end

function cUI_HourDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(cUI_HourDropDown, this.value);
	Clock_Var.PM = UIDropDownMenu_GetSelectedValue(cUI_HourDropDown);
	cUI_OnShow();
end

function cUI_SaveText()
	local text;
	text = getglobal("cUI_MessageEdit");
	Clock_Var.AlarmMessage = text:GetText();
end

function cUI_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "cUI_CheckEnable" ) then
		if ( checked ) then
			Clock_Config.Enabled = true;
			Frame_Clock:Show();
		else
			Clock_Config.Enabled = false;
			Frame_Clock:Hide();
		end
	end
	
	if ( name == "cUI_CheckAlarmSet" ) then
		if ( checked ) then
			Clock_Var.AlarmSet = true;
			local hour, minute = GetGameTime();
			if ( hour >= 12 ) then
				Clock_Var.PM =  1;
			else
				Clock_Var.PM = 0;
			end
			Clock_Var.AlarmHour = hour;
			Clock_Var.AlarmMinute = minute + 5;
		else
			Clock_Var.AlarmSet = false;
		end
	end
	
	cUI_SaveText();
	cUI_OnShow();
	
end