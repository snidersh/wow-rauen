function cwUI_Shaman_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"cwUI_Shaman");
	this:SetHeight(cwCONFIG_HEIGHT);
	this:SetWidth(cwCONFIG_WIDTH);

	-- Tabs
	PanelTemplates_SetNumTabs(this, 2);
	PanelTemplates_SetTab(this, 2);

end

function cwUI_Shaman_OnShow()

	local frame;
	local button;
	local text;
	local slider, low, high;
	local swatch, color;
	
	-- Title
	text = getglobal("cwUI_Shaman_TitleText");
	text:SetText("Rauen's CombatWatch v"..CombatWatch_Config.Version);
	frame = getglobal("cwUI_Shaman_Title");
	frame:SetWidth(text:GetWidth()+260);
	
	-- CombatWatch_Config.Enabled
	button = getglobal("cwUI_Shaman_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("cwUI_Shaman_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( CombatWatch_Config.Enabled );
	
	-- Shaman Panel
	frame = getglobal("cwUI_Shaman_AlertsBox");
	frame:SetWidth(cwCONFIG_WIDTH-40);
	text = getglobal("cwUI_Shaman_AlertsBoxTitle");
	text:SetText("Shaman Alerts");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( CombatWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end

end

function cwUI_Shaman_Close()
	PlaySound("igMainMenuClose");
	HideUIPanel(cwUI_Shaman);
end

function cwUI_Shaman_TabButtonOnClick()

	local text = this:GetText();
	if ( text ~= "Shaman" ) then
		cwUI_Shaman_Close();
	end
	if ( text == "General" ) then
		ShowUIPanel(cwUI_General);
	end

end

function cwUI_Shaman_OpenColorPicker(button)
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

function cwUI_Shaman_SetColor(key)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal("cwUI_Shaman_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("cwUI_Shaman_"..key);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	CombatWatch_Config.Color[key].r = r;
	CombatWatch_Config.Color[key].g = g;
	CombatWatch_Config.Color[key].b = b;
end

function cwUI_Shaman_CancelColor(key, prev)
	local r = prev.r;
	local g = prev.g;
	local b = prev.b;
	local swatch, frame;
	swatch = getglobal("cwUI_Shaman_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("cwUI_Shaman_"..key);
	swatch:SetVertexColor(r, g, b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	CombatWatch_Config.Color[key].r = r;
	CombatWatch_Config.Color[key].g = g;
	CombatWatch_Config.Color[key].b = b;
end

function cwUI_Shaman_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "cwUI_Shaman_CheckEnable" ) then
		if ( checked ) then
			CombatWatch_Config.Enabled = true;
		else
			CombatWatch_Config.Enabled = false;
		end
	end
	
	cwUI_Shaman_OnShow();
	
end