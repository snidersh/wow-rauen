-- Config Menu Constants
cwCONFIG_HEIGHT = "540";
cwCONFIG_WIDTH = "520";

function cwUI_General_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"cwUI_General");
	this:SetHeight(cwCONFIG_HEIGHT);
	this:SetWidth(cwCONFIG_WIDTH);

	-- Tabs
	PanelTemplates_SetNumTabs(this, 2);
	PanelTemplates_SetTab(this, 1);

end

function cwUI_General_OnShow()

	local frame;
	local button;
	local text;
	local slider, low, high;
	local swatch, color;
	
	-- Title
	text = getglobal("cwUI_General_TitleText");
	text:SetText("Rauen's CombatWatch v"..CombatWatch_Config.Version);
	frame = getglobal("cwUI_General_Title");
	frame:SetWidth(text:GetWidth()+260);
	
	-- CombatWatch_Config.Enabled
	button = getglobal("cwUI_General_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_General_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( CombatWatch_Config.Enabled );
	
	-- Statistics Panel
	frame = getglobal("cwUI_General_StatisticsBox");
	frame:SetWidth(cwCONFIG_WIDTH-40);
	text = getglobal("cwUI_General_StatisticsBoxTitle");
	text:SetText("Combat Statistics");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( CombatWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- CombatWatch_Config.Summary
	button = getglobal("cwUI_General_CheckSummary");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_General_CheckSummaryText");
	text:SetText("Show Summary");
	button:SetChecked( CombatWatch_Config.Summary );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.SummaryWindow
	button = getglobal("cwUI_General_CheckSummaryWindow");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_General_CheckSummaryWindowText");
	text:SetText("Show Window");
	button:SetChecked( CombatWatch_Config.SummaryWindow );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.SummaryWindowStyle
	button = getglobal("cwUI_General_CheckSummaryWindowStyle");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_General_CheckSummaryWindowStyleText");
	text:SetText("Vertical Style");
	button:SetChecked( CombatWatch_Config.SummaryWindowStyleV );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( CombatWatch_Config.SummaryWindow ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.SummaryWindowAlpha
	slider = getglobal("cwUI_General_SummaryWindowSlider");
	OptionsFrame_EnableSlider(slider);
	text = getglobal("cwUI_General_SummaryWindowSliderText");
	low = getglobal("cwUI_General_SummaryWindowSliderLow");
	high = getglobal("cwUI_General_SummaryWindowSliderHigh");
	slider:SetMinMaxValues(0, 100);
	slider:SetValueStep(5);
	slider:SetValue( CombatWatch_Config.SummaryWindowAlpha*100 );
	text:SetText( format("%d", 100-CombatWatch_Config.SummaryWindowAlpha*100).."% Window Transparency" );
	low:SetText("100%");
	high:SetText("0%");
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableSlider(slider);
	end
	if not ( CombatWatch_Config.SummaryWindow ) then
		OptionsFrame_DisableSlider(slider);
	end
	
	-- Critical Alerts Panel
	frame = getglobal("cwUI_General_CriticalAlertsBox");
	frame:SetWidth(cwCONFIG_WIDTH-40);
	text = getglobal("cwUI_General_CriticalAlertsBoxTitle");
	text:SetText("Health and Mana Alerts");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( CombatWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- CombatWatch_Config.HealthAlert
	swatch = getglobal("cwUI_General_HealthAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["HealthAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_General_HealthAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_General_SetColor("HealthAlert") end;
	frame.cancelFunc = function(x) cwUI_General_CancelColor("HealthAlert", x) end;
	button = getglobal("cwUI_General_HealthAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_General_HealthAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_General_HealthAlert_CheckButtonText");
	text:SetText("Low Health");
	button:SetChecked( CombatWatch_Config.HealthAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.HealthMin
	slider = getglobal("cwUI_General_HealthSlider");
	OptionsFrame_EnableSlider(slider);
	text = getglobal("cwUI_General_HealthSliderText");
	low = getglobal("cwUI_General_HealthSliderLow");
	high = getglobal("cwUI_General_HealthSliderHigh");
	slider:SetMinMaxValues(0, 100);
	slider:SetValueStep(5);
	slider:SetValue( CombatWatch_Config.HealthMin );
	text:SetText(CombatWatch_Config.HealthMin.."% Minimum Health");
	low:SetText("0%");
	high:SetText("100%");
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableSlider(slider);
	end
	if not ( CombatWatch_Config.HealthAlert ) then
		OptionsFrame_DisableSlider(slider);
	end
	
	-- CombatWatch_Config.HealthEmote
	button = getglobal("cwUI_General_HealthEmote");
	OptionsFrame_EnableCheckBox(button);
	button:SetChecked( CombatWatch_Config.HealthEmote );
	text = getglobal("cwUI_General_HealthEmoteText");
	text:SetText("Do Emote");
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( CombatWatch_Config.HealthAlert ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	text = getglobal("cwUI_General_HealthEmoteToken");
	text:SetText(CombatWatch_Config.HealthEmoteToken);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	text:SetWidth(80);
	if not ( CombatWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( CombatWatch_Config.HealthAlert ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	if not ( CombatWatch_Config.HealthEmote ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- CombatWatch_Config.HealthPartyAlert
	button = getglobal("cwUI_General_HealthPartyAlert");
	OptionsFrame_EnableCheckBox(button);
	button:SetChecked( CombatWatch_Config.HealthPartyAlert );
	text = getglobal("cwUI_General_HealthPartyAlertText");
	text:SetText("Message");
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( CombatWatch_Config.HealthAlert ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	text = getglobal("cwUI_General_HealthEdit");
	text:SetText(CombatWatch_Config.PartyAlert["HealthPartyAlert"]);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( CombatWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( CombatWatch_Config.HealthAlert ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	if not ( CombatWatch_Config.HealthPartyAlert ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- CombatWatch_Config.HealthDropDown
	button = getglobal("cwUI_General_HealthDropDown");
	OptionsFrame_EnableDropDown(button);
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( CombatWatch_Config.HealthAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( CombatWatch_Config.HealthPartyAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	
	-- Critical Alerts Panel
	frame = getglobal("cwUI_General_CriticalAlertsBox1");
	frame:SetWidth(cwCONFIG_WIDTH-40);
	
	-- CombatWatch_Config.ManaAlert
	swatch = getglobal("cwUI_General_ManaAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["ManaAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_General_ManaAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_General_SetColor("ManaAlert") end;
	frame.cancelFunc = function(x) cwUI_General_CancelColor("ManaAlert", x) end;
	button = getglobal("cwUI_General_ManaAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_General_ManaAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_General_ManaAlert_CheckButtonText");
	text:SetText("Low Mana");
	button:SetChecked( CombatWatch_Config.ManaAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.ManaMin
	slider = getglobal("cwUI_General_ManaSlider");
	OptionsFrame_EnableSlider(slider);
	text = getglobal("cwUI_General_ManaSliderText");
	low = getglobal("cwUI_General_ManaSliderLow");
	high = getglobal("cwUI_General_ManaSliderHigh");
	slider:SetMinMaxValues(0, 100);
	slider:SetValueStep(5);
	slider:SetValue( CombatWatch_Config.ManaMin );
	text:SetText(CombatWatch_Config.ManaMin.."% Minimum Mana");
	low:SetText("0%");
	high:SetText("100%");
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableSlider(slider);
	end
	if not ( CombatWatch_Config.ManaAlert ) then
		OptionsFrame_DisableSlider(slider);
	end
	
	-- CombatWatch_Config.ManaEmote
	button = getglobal("cwUI_General_ManaEmote");
	OptionsFrame_EnableCheckBox(button);
	button:SetChecked( CombatWatch_Config.ManaEmote );
	text = getglobal("cwUI_General_ManaEmoteText");
	text:SetText("Do Emote");
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( CombatWatch_Config.ManaAlert ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	text = getglobal("cwUI_General_ManaEmoteToken");
	text:SetText(CombatWatch_Config.ManaEmoteToken);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	text:SetWidth(80);
	if not ( CombatWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( CombatWatch_Config.ManaAlert ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	if not ( CombatWatch_Config.ManaEmote ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- CombatWatch_Config.ManaPartyAlert
	button = getglobal("cwUI_General_ManaPartyAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_General_ManaPartyAlertText");
	text:SetText("Message");
	button:SetChecked( CombatWatch_Config.ManaPartyAlert );
	UIDropDownMenu_Refresh(cwUI_General_ManaPartyAlert);
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( CombatWatch_Config.ManaAlert ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	text = getglobal("cwUI_General_ManaEdit");
	text:SetText(CombatWatch_Config.PartyAlert["ManaPartyAlert"]);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( CombatWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( CombatWatch_Config.ManaAlert ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	if not ( CombatWatch_Config.ManaPartyAlert ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- CombatWatch_Config.ManaDropDown
	button = getglobal("cwUI_General_ManaDropDown");
	OptionsFrame_EnableDropDown(button);
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( CombatWatch_Config.ManaAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( CombatWatch_Config.ManaPartyAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	
	-- Miscellaneous Alerts Panel
	frame = getglobal("cwUI_General_MiscAlertsBox");
	frame:SetWidth(cwCONFIG_WIDTH-40);
	text = getglobal("cwUI_General_MiscAlertsBoxTitle");
	text:SetText("Miscellaneous Alerts");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( CombatWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- CombatWatch_Config.CritAlert
	swatch = getglobal("cwUI_General_CritAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["CritAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_General_CritAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_General_SetColor("CritAlert") end;
	frame.cancelFunc = function(x) cwUI_General_CancelColor("CritAlert", x) end;
	button = getglobal("cwUI_General_CritAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_General_CritAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_General_CritAlert_CheckButtonText");
	text:SetText("Critical Hits");
	button:SetChecked( CombatWatch_Config.CritAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.XPtAlert
	swatch = getglobal("cwUI_General_XPAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["XPAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_General_XPAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_General_SetColor("XPAlert") end;
	frame.cancelFunc = function(x) cwUI_General_CancelColor("XPAlert", x) end;
	button = getglobal("cwUI_General_XPAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_General_XPAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_General_XPAlert_CheckButtonText");
	text:SetText("Experience Gain");
	button:SetChecked( CombatWatch_Config.XPAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.SkillAlert
	swatch = getglobal("cwUI_General_SkillAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["SkillAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_General_SkillAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_General_SetColor("SkillAlert") end;
	frame.cancelFunc = function(x) cwUI_General_CancelColor("SkillAlert", x) end;
	button = getglobal("cwUI_General_SkillAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_General_SkillAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_General_SkillAlert_CheckButtonText");
	text:SetText("Skill Gain");
	button:SetChecked( CombatWatch_Config.SkillAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.HealSelfAlert
	swatch = getglobal("cwUI_General_HealSelfAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["HealSelfAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_General_HealSelfAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_General_SetColor("HealSelfAlert") end;
	frame.cancelFunc = function(x) cwUI_General_CancelColor("HealSelfAlert", x) end;
	button = getglobal("cwUI_General_HealSelfAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_General_HealSelfAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_General_HealSelfAlert_CheckButtonText");
	text:SetText("Health Gain");
	button:SetChecked( CombatWatch_Config.HealSelfAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- CombatWatch_Config.DpsAlert
	swatch = getglobal("cwUI_General_DpsAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["DpsAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_General_DpsAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_General_SetColor("DpsAlert") end;
	frame.cancelFunc = function(x) cwUI_General_CancelColor("DpsAlert", x) end;
	button = getglobal("cwUI_General_DpsAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_General_DpsAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_General_DpsAlert_CheckButtonText");
	text:SetText("DPS");
	button:SetChecked( CombatWatch_Config.DpsAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Defaults
	button = getglobal("cwUI_General_ResetButton");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		button:Disable();
	end
	
	-- DropDowns
	cwUI_General_DropDownRefresh();
	
	-- Tabs
	text = getglobal("cwUI_GeneralTab2Text");
	text:SetText(UnitClass("player"));
	text = getglobal("cwUI_GeneralTab2HighlightText");
	text:SetText(UnitClass("player"));

end

function cwUI_General_DropDownOnShow()
	local button = this;
	local name = button:GetName();
	if ( name == "cwUI_General_HealthDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, CombatWatch_Config.HealthPartyAlertChan);
		UIDropDownMenu_Initialize(button, cwUI_General_DropDownInit);
		UIDropDownMenu_SetWidth(60, button);
	end
	if ( name == "cwUI_General_ManaDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, CombatWatch_Config.ManaPartyAlertChan);
		UIDropDownMenu_Initialize(button, cwUI_General_DropDownInit);
		UIDropDownMenu_SetWidth(60, button);
	end
end

function cwUI_General_DropDownInit()

	local func;
	local name = this:GetName();
	if ( string.find(name, "cwUI_General_HealthDropDown") ) then
		func = cwUI_General_HealthDropDownOnClick;
	end
	if ( string.find(name, "cwUI_General_ManaDropDown") ) then
		func = cwUI_General_ManaDropDownOnClick;
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

function cwUI_General_HealthDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(cwUI_General_HealthDropDown, this.value);
	CombatWatch_Config.HealthPartyAlertChan = UIDropDownMenu_GetSelectedValue(cwUI_General_HealthDropDown);
end

function cwUI_General_ManaDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(cwUI_General_ManaDropDown, this.value);
	CombatWatch_Config.ManaPartyAlertChan = UIDropDownMenu_GetSelectedValue(cwUI_General_ManaDropDown);
end

function cwUI_General_DropDownRefresh()
	UIDropDownMenu_SetSelectedValue(cwUI_General_HealthDropDown, CombatWatch_Config.HealthPartyAlertChan);
	UIDropDownMenu_SetSelectedValue(cwUI_General_ManaDropDown, CombatWatch_Config.ManaPartyAlertChan);
	UIDropDownMenu_Refresh(cwUI_General_HealthDropDown);
	UIDropDownMenu_Refresh(cwUI_General_ManaDropDown);
end

function cwUI_General_Close()
	PlaySound("igMainMenuClose");
	cwUI_General_SaveText();
	HideUIPanel(cwUI_General);
end

function cwUI_General_Reset()
	PlaySound("igMainMenuOptionCheckBoxOn");
	CombatWatch_Reset();
	cwUI_General_OnShow();
	cwUI_General_DropDownRefresh();
end

function cwUI_General_TabButtonOnClick()

	local text = this:GetText();
	if ( text ~= "General" ) then
		cwUI_General_Close();
	end
	ShowUIPanel(getglobal("cwUI_"..text));

end

function cwUI_General_SaveText()
	local text;
	text = getglobal("cwUI_General_HealthEdit");
	CombatWatch_Config.PartyAlert["HealthPartyAlert"] = text:GetText();
	text = getglobal("cwUI_General_ManaEdit");
	CombatWatch_Config.PartyAlert["ManaPartyAlert"] = text:GetText();
	text = getglobal("cwUI_General_HealthEmoteToken");
	CombatWatch_Config.HealthEmoteToken = text:GetText();
	text = getglobal("cwUI_General_ManaEmoteToken");
	CombatWatch_Config.ManaEmoteToken = text:GetText();
end

function cwUI_General_OpenColorPicker(button)
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

function cwUI_General_SetColor(key)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal("cwUI_General_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("cwUI_General_"..key);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	CombatWatch_Config.Color[key].r = r;
	CombatWatch_Config.Color[key].g = g;
	CombatWatch_Config.Color[key].b = b;
end

function cwUI_General_CancelColor(key, prev)
	local r = prev.r;
	local g = prev.g;
	local b = prev.b;
	local swatch, frame;
	swatch = getglobal("cwUI_General_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("cwUI_General_"..key);
	swatch:SetVertexColor(r, g, b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	CombatWatch_Config.Color[key].r = r;
	CombatWatch_Config.Color[key].g = g;
	CombatWatch_Config.Color[key].b = b;
end

function cwUI_General_SliderOnValueChanged()

	PlaySound("igMainMenuOptionCheckBoxOn");

	local slider = this;
	local name = slider:GetName();
	
	if ( name == "cwUI_General_HealthSlider" ) then
		CombatWatch_Config.HealthMin = slider:GetValue();
		text = getglobal("cwUI_General_HealthSliderText");
		text:SetText(CombatWatch_Config.HealthMin.."% Minimum Health");
	end
	if ( name == "cwUI_General_ManaSlider" ) then
		CombatWatch_Config.ManaMin = slider:GetValue();
		text = getglobal("cwUI_General_ManaSliderText");
		text:SetText(CombatWatch_Config.ManaMin.."% Minimum Mana");
	end
	if ( name == "cwUI_General_SummaryWindowSlider" ) then
		CombatWatch_Config.SummaryWindowAlpha = slider:GetValue()/100;
		text = getglobal("cwUI_General_SummaryWindowSliderText");
		text:SetText( format("%d", 100-CombatWatch_Config.SummaryWindowAlpha*100).."% Window Transparency" );
		local panel = getglobal("cwSummary")
		if ( panel:IsVisible() ) then
			cwSummary_OnShow();
		end
	end
	
end

function cwUI_General_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "cwUI_General_CheckEnable" ) then
		if ( checked ) then
			CombatWatch_Config.Enabled = true;
		else
			CombatWatch_Config.Enabled = false;
		end
	end
	
	if ( name == "cwUI_General_CheckSummary" ) then
		if ( checked ) then
			CombatWatch_Config.Summary = true;
		else
			CombatWatch_Config.Summary = false;
		end
	end
	
	if ( name == "cwUI_General_CheckSummaryWindow" ) then
		if ( checked ) then
			CombatWatch_Config.SummaryWindow = true;
		else
			CombatWatch_Config.SummaryWindow = false;
		end
	end
	
	if ( name == "cwUI_General_CheckSummaryWindowStyle" ) then
		if ( checked ) then
			CombatWatch_Config.SummaryWindowStyleV = true;
		else
			CombatWatch_Config.SummaryWindowStyleV = false;
		end
		--cwSummary_ResetPos();
		if ( cwSummary:IsVisible() ) then
			cwSummary_OnShow();
		end
	end
	
	if ( name == "cwUI_General_HealthAlert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.HealthAlert = true;
		else
			CombatWatch_Config.HealthAlert = false;
		end
	end
	
	if ( name == "cwUI_General_HealthPartyAlert" ) then
		if ( checked ) then
			CombatWatch_Config.HealthPartyAlert = true;
		else
			CombatWatch_Config.HealthPartyAlert = false;
		end
	end
	
	if ( name == "cwUI_General_HealthEmote" ) then
		if ( checked ) then
			CombatWatch_Config.HealthEmote = true;
		else
			CombatWatch_Config.HealthEmote = false;
		end
	end
	
	if ( name == "cwUI_General_ManaAlert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.ManaAlert = true;
		else
			CombatWatch_Config.ManaAlert = false;
		end
	end
	
	if ( name == "cwUI_General_ManaPartyAlert" ) then
		if ( checked ) then
			CombatWatch_Config.ManaPartyAlert = true;
		else
			CombatWatch_Config.ManaPartyAlert = false;
		end
	end
	
	if ( name == "cwUI_General_ManaEmote" ) then
		if ( checked ) then
			CombatWatch_Config.ManaEmote = true;
		else
			CombatWatch_Config.ManaEmote = false;
		end
	end
	
	if ( name == "cwUI_General_CritAlert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.CritAlert = true;
		else
			CombatWatch_Config.CritAlert = false;
		end
	end
	
	if ( name == "cwUI_General_XPAlert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.XPAlert = true;
		else
			CombatWatch_Config.XPAlert = false;
		end
	end
	
	if ( name == "cwUI_General_SkillAlert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.SkillAlert = true;
		else
			CombatWatch_Config.SkillAlert = false;
		end
	end
	
	if ( name == "cwUI_General_HealSelfAlert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.HealSelfAlert = true;
		else
			CombatWatch_Config.HealSelfAlert = false;
		end
	end
	
	if ( name == "cwUI_General_DpsAlert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.DpsAlert = true;
		else
			CombatWatch_Config.DpsAlert = false;
		end
	end
	
	cwUI_General_SaveText();
	cwUI_General_OnShow();
	
end
