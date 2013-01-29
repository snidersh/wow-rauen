StaticPopupDialogs["ITEMWATCH_CONFIRM_RESET"] = {
	text = TEXT("Are you sure you would like to reset all recorded ItemWatch statistics?"),
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		ItemWatch_ResetStats();
		iwUI:Show();
	end,
	OnCancel = function()
		iwUI:Show();
	end,
	timeout = 0,
};

function iwUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"iwUI");
	this:SetHeight("375");
	this:SetWidth("400");

end

function iwUI_OnShow()

	local frame;
	local button;
	local text;
	local swatch, color;
	
	-- Title
	text = getglobal("iwUI_TitleText");
	text:SetText("Rauen's ItemWatch v"..ItemWatch_Config.Version);
	frame = getglobal("iwUI_Title");
	frame:SetWidth(text:GetWidth()+250);
	
	-- ItemWatch_Config.Enabled
	button = getglobal("iwUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("iwUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( ItemWatch_Config.Enabled );
	
	-- Value Panel
	text = getglobal("iwUI_ValueBoxTitle");
	text:SetText("Merchant Value");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( ItemWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- ItemWatch_Config.ShowValue
	button = getglobal("iwUI_CheckShowValue");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("iwUI_CheckShowValueText");
	text:SetText("Show Merchant Values");
	button:SetChecked( ItemWatch_Config.ShowValue );
	if not ( ItemWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Craft Panel
	text = getglobal("iwUI_CraftBoxTitle");
	text:SetText("TradeSkills");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( ItemWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- ItemWatch_Config.ShowCraft
	swatch = getglobal("iwUI_ShowCraft_ColorSwatchNormalTexture");
	color = ItemWatch_Config.Color["ShowCraft"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("iwUI_ShowCraft");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) iwUI_SetColor("ShowCraft") end;
	frame.cancelFunc = function(x) iwUI_CancelColor("ShowCraft", x) end;
	button = getglobal("iwUI_ShowCraft_ColorSwatch");
	button:Enable();
	if not ( ItemWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("iwUI_ShowCraft_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("iwUI_ShowCraft_CheckButtonText");
	text:SetText("Show Tradeskills");
	button:SetChecked( ItemWatch_Config.ShowCraft );
	if not ( ItemWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- ItemWatch_Config.ShowProduct
	button = getglobal("iwUI_CheckShowProduct");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("iwUI_CheckShowProductText");
	text:SetText("Show Products");
	button:SetChecked( ItemWatch_Config.ShowProduct );
	if not ( ItemWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- ItemWatch_Config.ShowNum
	button = getglobal("iwUI_CheckShowNum");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("iwUI_CheckShowNumText");
	text:SetText("Show Number Available");
	button:SetChecked( ItemWatch_Config.ShowNum );
	if not ( ItemWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( ItemWatch_Config.ShowProduct ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Effect Panel
	text = getglobal("iwUI_EffectBoxTitle");
	text:SetText("Effects");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( ItemWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- ItemWatch_Config.ShowEffect
	swatch = getglobal("iwUI_ShowEffect_ColorSwatchNormalTexture");
	color = ItemWatch_Config.Color["ShowEffect"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("iwUI_ShowEffect");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) iwUI_SetColor("ShowEffect") end;
	frame.cancelFunc = function(x) iwUI_CancelColor("ShowEffect", x) end;
	button = getglobal("iwUI_ShowEffect_ColorSwatch");
	button:Enable();
	if not ( ItemWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	button = getglobal("iwUI_ShowEffect_CheckButton");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("iwUI_ShowEffect_CheckButtonText");
	text:SetText("Show Item Effects on "..UnitName("player"));
	button:SetChecked( ItemWatch_Config.ShowEffect );
	if not ( ItemWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Defaults
	button = getglobal("iwUI_ResetStatsButton");
	button:Enable();
	if not ( ItemWatch_Config.Enabled ) then
		button:Disable();
	end
	button = getglobal("iwUI_ResetButton");
	button:Enable();
	if not ( ItemWatch_Config.Enabled ) then
		button:Disable();
	end

end

function iwUI_Close()
	PlaySound("igMainMenuClose");
	HideUIPanel(iwUI);
end

function iwUI_Reset()
	PlaySound("igMainMenuOptionCheckBoxOn");
	ItemWatch_Reset();
	iwUI_OnShow();
end

function iwUI_ResetStats()
	iwUI_Close();
	StaticPopup_Show("ITEMWATCH_CONFIRM_RESET");
end

function iwUI_OpenColorPicker(button)
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

function iwUI_SetColor(key)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal("iwUI_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("iwUI_"..key);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	ItemWatch_Config.Color[key].r = r;
	ItemWatch_Config.Color[key].g = g;
	ItemWatch_Config.Color[key].b = b;
end

function iwUI_CancelColor(key, prev)
	local r = prev.r;
	local g = prev.g;
	local b = prev.b;
	local swatch, frame;
	swatch = getglobal("iwUI_"..key.."_ColorSwatchNormalTexture");
	frame = getglobal("iwUI_"..key);
	swatch:SetVertexColor(r, g, b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	ItemWatch_Config.Color[key].r = r;
	ItemWatch_Config.Color[key].g = g;
	ItemWatch_Config.Color[key].b = b;
end

function iwUI_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "iwUI_CheckEnable" ) then
		if ( checked ) then
			ItemWatch_Config.Enabled = true;
		else
			ItemWatch_Config.Enabled = false;
		end
	end
	
	if ( name == "iwUI_CheckShowValue" ) then
		if ( checked ) then
			ItemWatch_Config.ShowValue = true;
		else
			ItemWatch_Config.ShowValue = false;
		end
	end
	
	if ( name == "iwUI_ShowCraft_CheckButton" ) then
		if ( checked ) then
			ItemWatch_Config.ShowCraft = true;
		else
			ItemWatch_Config.ShowCraft = false;
		end
	end
	
	if ( name == "iwUI_CheckShowProduct" ) then
		if ( checked ) then
			ItemWatch_Config.ShowProduct = true;
		else
			ItemWatch_Config.ShowProduct = false;
		end
	end
	
	if ( name == "iwUI_CheckShowNum" ) then
		if ( checked ) then
			ItemWatch_Config.ShowNum = true;
		else
			ItemWatch_Config.ShowNum = false;
		end
	end
	
	if ( name == "iwUI_ShowEffect_CheckButton" ) then
		if ( checked ) then
			ItemWatch_Config.ShowEffect = true;
		else
			ItemWatch_Config.ShowEffect = false;
		end
	end
	
	iwUI_OnShow();
	
end
