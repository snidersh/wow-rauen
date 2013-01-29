function cwUI_Blank_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"cwUI_Blank");
	this:SetHeight(cwCONFIG_HEIGHT);
	this:SetWidth(cwCONFIG_WIDTH);

	-- Tabs
	PanelTemplates_SetNumTabs(this, 2);
	PanelTemplates_SetTab(this, 2);

end

function cwUI_Blank_OnShow()

	local frame;
	local button;
	local text;
	local slider, low, high;
	local swatch, color;
	
	-- Title
	text = getglobal("cwUI_Blank_TitleText");
	text:SetText("Rauen's CombatWatch v"..CombatWatch_Config.Version);
	frame = getglobal("cwUI_Blank_Title");
	frame:SetWidth(text:GetWidth()+260);
	
	-- CombatWatch_Config.Enabled
	button = getglobal("cwUI_Blank_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Blank_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( CombatWatch_Config.Enabled );
	
	-- Blank Panel
	text = getglobal("cwUI_Blank_AlertsBoxTitle");
	text:SetText("Blank Alerts");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( CombatWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- CombatWatch_Config.HealOtherAlert
	swatch = getglobal("cwUI_Blank_HealOtherAlert_ColorSwatchNormalTexture");
	color = CombatWatch_Config.Color["HealOtherAlert"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("cwUI_Blank_HealOtherAlert");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) cwUI_Blank_SetColor("HealOtherAlert") end;
	frame.cancelFunc = function(x) cwUI_Blank_CancelColor("HealOtherAlert", x) end;
	button = getglobal("cwUI_Blank_HealOtherAlert_ColorSwatch");
	button:Enable();
	if not ( CombatWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("cwUI_Blank_HealOtherAlert_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Blank_HealOtherAlert_CheckButtonText");
	text:SetText("Healing Others");
	button:SetChecked( CombatWatch_Config.HealOtherAlert );
	if not ( CombatWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end

end

function cwUI_Blank_Close()
	PlaySound("igMainMenuClose");
	HideUIPanel(cwUI_Blank);
end

function cwUI_Blank_TabButtonOnClick()

	local text = this:GetText();
	if ( text ~= "Blank" ) then
		cwUI_Blank_Close();
	end
	if ( text == "General" ) then
		ShowUIPanel(cwUI_General);
	end

end

function cwUI_Blank_OpenColorPicker(button)
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

function cwUI_Blank_SetColor(key)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal("cwUI_Blank_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("cwUI_Blank_"..key);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	CombatWatch_Config.Color[key].r = r;
	CombatWatch_Config.Color[key].g = g;
	CombatWatch_Config.Color[key].b = b;
end

function cwUI_Blank_CancelColor(key, prev)
	local r = prev.r;
	local g = prev.g;
	local b = prev.b;
	local swatch, frame;
	swatch = getglobal("cwUI_Blank_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("cwUI_Blank_"..key);
	swatch:SetVertexColor(r, g, b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	CombatWatch_Config.Color[key].r = r;
	CombatWatch_Config.Color[key].g = g;
	CombatWatch_Config.Color[key].b = b;
end

function cwUI_Blank_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "cwUI_Blank_CheckEnable" ) then
		if ( checked ) then
			CombatWatch_Config.Enabled = true;
		else
			CombatWatch_Config.Enabled = false;
		end
	end
	
	if ( name == "cwUI_Blank_Alert_CheckButton" ) then
		if ( checked ) then
			CombatWatch_Config.Alert = true;
		else
			CombatWatch_Config.Alert = false;
		end
	end
	
	cwUI_Blank_OnShow();
	
end