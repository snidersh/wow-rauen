StaticPopupDialogs["KILLWATCH_CONFIRM_RESET"] = {
	text = TEXT("Are you sure you would like to reset all recorded KillWatch statistics?"),
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		KillWatch_ResetStats();
		kwUI:Show();
	end,
	OnCancel = function()
		kwUI:Show();
	end,
	timeout = 0,
};

function kwUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"kwUI");
	this:SetHeight("515");
	this:SetWidth("480");

end

function kwUI_OnShow()

	local frame;
	local button;
	local text;
	local swatch, color;
	
	-- Title
	text = getglobal("kwUI_TitleText");
	text:SetText("Rauen's KillWatch v"..Bars_Config.Version);
	frame = getglobal("kwUI_Title");
	frame:SetWidth(text:GetWidth()+250);
	
	-- KillWatch_Config.Enabled
	button = getglobal("kwUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( KillWatch_Config.Enabled );
	
	-- Display Panel
	text = getglobal("kwUI_DisplayBoxTitle");
	text:SetText("Display");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( KillWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- KillWatch_Config.ShowZone
	button = getglobal("kwUI_CheckZone");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckZoneText");
	text:SetText("Show Zone");
	button:SetChecked( KillWatch_Config.ShowZone );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end	

	-- KillWatch_Config.ShowKills
	button = getglobal("kwUI_CheckKills");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckKillsText");
	text:SetText("Show Kills");
	button:SetChecked( KillWatch_Config.ShowKills );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- KillWatch_Config.ShowDur
	button = getglobal("kwUI_CheckDur");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckDurText");
	text:SetText("Show Combat Duration");
	button:SetChecked( KillWatch_Config.ShowDur );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- KillWatch_Config.ShowXP
	button = getglobal("kwUI_CheckXP");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckXPText");
	text:SetText("Show Experience");
	button:SetChecked( KillWatch_Config.ShowXP );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- KillWatch_Config.ShowCoins
	button = getglobal("kwUI_CheckCoins");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckCoinsText");
	text:SetText("Show Coin");
	button:SetChecked( KillWatch_Config.ShowCoins );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- KillWatch_Config.GraphicCoins
	button = getglobal("kwUI_CheckGraphicCoins");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckGraphicCoinsText");
	text:SetText("Coin Graphics");
	button:SetChecked( KillWatch_Config.GraphicCoins );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( KillWatch_Config.ShowCoins ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- KillWatch_Config.Color["Current"]
	text = getglobal("kwUI_CurrentText");
	text:SetText("Current Information");
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	swatch = getglobal("kwUI_CurrentNormalTexture");
	color = KillWatch_Config.Color["Current"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("kwUI_Current");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) kwUI_SetColor("Current") end;
	frame.cancelFunc = function(x) kwUI_CancelColor("Current", x) end;
	if not ( KillWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	button = getglobal("kwUI_Current");
	button:Enable();
	if not ( KillWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	-- KillWatch_Config.Color["Old"]
	text = getglobal("kwUI_OldText");
	text:SetText("Outdated Information");
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	swatch = getglobal("kwUI_OldNormalTexture");
	color = KillWatch_Config.Color["Old"];
	swatch:SetVertexColor(color.r, color.g , color.b);
	frame = getglobal("kwUI_Old");
	frame.r = color.r;
	frame.g = color.g;
	frame.b = color.b;
	frame.swatchFunc = function(x) kwUI_SetColor("Old") end;
	frame.cancelFunc = function(x) kwUI_CancelColor("Old", x) end;
	if not ( KillWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	button = getglobal("kwUI_Old");
	button:Enable();
	if not ( KillWatch_Config.Enabled ) then
		swatch:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		button:Disable();
	end
	
	-- Loot Panel
	text = getglobal("kwUI_LootBoxTitle");
	text:SetText("Loot");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( KillWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- KillWatch_Config.ShowLoot
	button = getglobal("kwUI_CheckLoot");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckLootText");
	text:SetText("Show Loot");
	button:SetChecked( KillWatch_Config.ShowLoot );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- KillWatch_Config.LootQuality
	button = getglobal("kwUI_LootDropDown");
	OptionsFrame_EnableDropDown(button);
	text = getglobal("kwUI_LootDropDownLabel");
	--text:SetText("Quality Level");
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( KillWatch_Config.ShowLoot ) then
		OptionsFrame_DisableDropDown(button);
	end
	
	-- KillWatch_Config.ShowLootPercent
	button = getglobal("kwUI_CheckLootPercent");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckLootPercentText");
	text:SetText("Show Drop Rate");
	button:SetChecked( KillWatch_Config.ShowLootPercent );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( KillWatch_Config.ShowLoot ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- KillWatch_Config.ShowQuality
	button = getglobal("kwUI_CheckQuality");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckQualityText");
	text:SetText("Show Quality");
	button:SetChecked( KillWatch_Config.ShowQuality );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( KillWatch_Config.ShowLoot ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- KillWatch_Config.ShowValue
	button = getglobal("kwUI_CheckValue");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckValueText");
	text:SetText("Show Value");
	button:SetChecked( KillWatch_Config.ShowValue );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( KillWatch_Config.ShowLoot ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- KillWatch_Config.GraphicCoins
	button = getglobal("kwUI_CheckGraphicValue");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckGraphicValueText");
	text:SetText("Coin Graphics");
	button:SetChecked( KillWatch_Config.GraphicValue );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( KillWatch_Config.ShowValue ) then
		OptionsFrame_DisableCheckBox(button);
	end
	if not ( KillWatch_Config.ShowLoot ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Rating Panel
	text = getglobal("kwUI_RatingsBoxTitle");
	text:SetText("Ratings");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( KillWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- KillWatch_Config.ShowRating
	button = getglobal("kwUI_CheckRating");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckRatingText");
	text:SetText("Show Rating");
	button:SetChecked( KillWatch_Config.ShowRating );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- KillWatch_Config.ShowRatingCoin
	button = getglobal("kwUI_CheckRatingCoin");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckRatingCoinText");
	text:SetText("Show Rating (Coin)");
	button:SetChecked( KillWatch_Config.ShowRatingCoin );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- KillWatch_Config.ShowRatingXP
	button = getglobal("kwUI_CheckRatingXP");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckRatingXPText");
	text:SetText("Show Rating (Exp)");
	button:SetChecked( KillWatch_Config.ShowRatingXP );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- KillWatch_Config.ShowRating
	button = getglobal("kwUI_CheckRatingLoot");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kwUI_CheckRatingLootText");
	text:SetText("Show Rating (Loot)");
	button:SetChecked( KillWatch_Config.ShowRatingLoot );
	if not ( KillWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- KillWatch_ResetStats
	button = getglobal("kwUI_ResetStatsButton");
	button:Enable();
	if not ( KillWatch_Config.Enabled ) then
		button:Disable();
	end
	
	-- Defaults
	button = getglobal("kwUI_ResetButton");
	button:Enable();
	if not ( KillWatch_Config.Enabled ) then
		button:Disable();
	end
	
	-- DropDowns
	kwUI_DropDownRefresh();

end

function kwUI_DropDownOnShow()
	local button = this;
	local name = button:GetName();
	if ( name == "kwUI_LootDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, KillWatch_Config.LootQuality);
		getglobal("kwUI_LootDropDownText"):SetTextColor(ITEM_QUALITY_COLORS[KillWatch_Config.LootQuality].r, ITEM_QUALITY_COLORS[KillWatch_Config.LootQuality].g, ITEM_QUALITY_COLORS[KillWatch_Config.LootQuality].b);
		UIDropDownMenu_Initialize(button, kwUI_DropDownInit);
		UIDropDownMenu_SetWidth(90, button);
	end
end

function kwUI_DropDownRefresh()
	UIDropDownMenu_SetSelectedValue(kwUI_LootDropDown, KillWatch_Config.LootQuality);
	getglobal("kwUI_LootDropDownText"):SetTextColor(ITEM_QUALITY_COLORS[KillWatch_Config.LootQuality].r, ITEM_QUALITY_COLORS[KillWatch_Config.LootQuality].g, ITEM_QUALITY_COLORS[KillWatch_Config.LootQuality].b);
	UIDropDownMenu_Refresh(kwUI_LootDropDown);
end

function kwUI_DropDownInit()

	local func;
	local name = this:GetName();
	if ( string.find(name, "kwUI_LootDropDown") ) then
		func = kwUI_LootDropDownOnClick;
	end
	
	local info = { };
	
	info.text = "Common";
	info.value = 0;
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.textR = ITEM_QUALITY_COLORS[0].r;
	info.textG = ITEM_QUALITY_COLORS[0].g;
	info.textB = ITEM_QUALITY_COLORS[0].b;
	UIDropDownMenu_AddButton(info);
	
	info.text = "Special";
	info.value = 1;
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.textR = ITEM_QUALITY_COLORS[1].r;
	info.textG = ITEM_QUALITY_COLORS[1].g;
	info.textB = ITEM_QUALITY_COLORS[1].b;
	UIDropDownMenu_AddButton(info);
	
	info.text = "Uncommon";
	info.value = 2;
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.textR = ITEM_QUALITY_COLORS[2].r;
	info.textG = ITEM_QUALITY_COLORS[2].g;
	info.textB = ITEM_QUALITY_COLORS[2].b;
	UIDropDownMenu_AddButton(info);
	
	info.text = "Rare";
	info.value = 3;
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.textR = ITEM_QUALITY_COLORS[3].r;
	info.textG = ITEM_QUALITY_COLORS[3].g;
	info.textB = ITEM_QUALITY_COLORS[3].b;
	UIDropDownMenu_AddButton(info);
	
	info.text = "Epic";
	info.value = 4;
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.textR = ITEM_QUALITY_COLORS[4].r;
	info.textG = ITEM_QUALITY_COLORS[4].g;
	info.textB = ITEM_QUALITY_COLORS[4].b;
	UIDropDownMenu_AddButton(info);
	
end

function kwUI_LootDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(kwUI_LootDropDown, this.value);
	KillWatch_Config.LootQuality = UIDropDownMenu_GetSelectedValue(kwUI_LootDropDown);
	getglobal("kwUI_LootDropDownText"):SetTextColor(ITEM_QUALITY_COLORS[KillWatch_Config.LootQuality].r, ITEM_QUALITY_COLORS[KillWatch_Config.LootQuality].g, ITEM_QUALITY_COLORS[KillWatch_Config.LootQuality].b);
end

function kwUI_Close()
	PlaySound("igMainMenuClose");
	HideUIPanel(kwUI);
end

function kwUI_Reset()
	PlaySound("igMainMenuOptionCheckBoxOn");
	KillWatch_Reset();
	kwUI_OnShow();
	kwUI_DropDownRefresh();
end

function kwUI_ResetStats()
	kwUI_Close();
	StaticPopup_Show("KILLWATCH_CONFIRM_RESET");
end

function kwUI_OpenColorPicker(button)
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

function kwUI_SetColor(key)
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	swatch = getglobal("kwUI_"..key.."NormalTexture");
	frame = getglobal("kwUI_"..key);
	swatch:SetVertexColor(r,g,b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	KillWatch_Config.Color[key].r = r;
	KillWatch_Config.Color[key].g = g;
	KillWatch_Config.Color[key].b = b;
end

function kwUI_CancelColor(key, prev)
	local r = prev.r;
	local g = prev.g;
	local b = prev.b;
	local swatch, frame;
	swatch = getglobal("kwUI_"..key.."NormalTexture");
	frame = getglobal("kwUI_"..key);
	swatch:SetVertexColor(r, g, b);
	frame.r = r;
	frame.g = g;
	frame.b = b;
	KillWatch_Config.Color[key].r = r;
	KillWatch_Config.Color[key].g = g;
	KillWatch_Config.Color[key].b = b;
end

function kwUI_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "kwUI_CheckEnable" ) then
		if ( checked ) then
			KillWatch_Config.Enabled = true;
		else
			KillWatch_Config.Enabled = false;
		end
	end
	
	if ( name == "kwUI_CheckZone" ) then
		if ( checked ) then
			KillWatch_Config.ShowZone = true;
		else
			KillWatch_Config.ShowZone = false;
		end
	end
	
	if ( name == "kwUI_CheckKills" ) then
		if ( checked ) then
			KillWatch_Config.ShowKills = true;
		else
			KillWatch_Config.ShowKills = false;
		end
	end
	
	if ( name == "kwUI_CheckDur" ) then
		if ( checked ) then
			KillWatch_Config.ShowDur = true;
		else
			KillWatch_Config.ShowDur = false;
		end
	end
	
	if ( name == "kwUI_CheckXP" ) then
		if ( checked ) then
			KillWatch_Config.ShowXP = true;
		else
			KillWatch_Config.ShowXP = false;
		end
	end
	
	if ( name == "kwUI_CheckCoins" ) then
		if ( checked ) then
			KillWatch_Config.ShowCoins = true;
		else
			KillWatch_Config.ShowCoins = false;
		end
	end
	
	if ( name == "kwUI_CheckGraphicCoins" ) then
		if ( checked ) then
			KillWatch_Config.GraphicCoins = true;
		else
			KillWatch_Config.GraphicCoins = false;
		end
	end
	
	if ( name == "kwUI_CheckLoot" ) then
		if ( checked ) then
			KillWatch_Config.ShowLoot = true;
		else
			KillWatch_Config.ShowLoot = false;
		end
	end
	
	if ( name == "kwUI_CheckLootPercent" ) then
		if ( checked ) then
			KillWatch_Config.ShowLootPercent = true;
		else
			KillWatch_Config.ShowLootPercent = false;
		end
	end
	
	if ( name == "kwUI_CheckQuality" ) then
		if ( checked ) then
			KillWatch_Config.ShowQuality = true;
		else
			KillWatch_Config.ShowQuality = false;
		end
	end
	
	if ( name == "kwUI_CheckValue" ) then
		if ( checked ) then
			KillWatch_Config.ShowValue = true;
		else
			KillWatch_Config.ShowValue = false;
		end
	end
	
	if ( name == "kwUI_CheckGraphicValue" ) then
		if ( checked ) then
			KillWatch_Config.GraphicValue = true;
		else
			KillWatch_Config.GraphicValue = false;
		end
	end
	
	if ( name == "kwUI_CheckRating" ) then
		if ( checked ) then
			KillWatch_Config.ShowRating = true;
		else
			KillWatch_Config.ShowRating = false;
		end
	end
	
	if ( name == "kwUI_CheckRatingCoin" ) then
		if ( checked ) then
			KillWatch_Config.ShowRatingCoin = true;
		else
			KillWatch_Config.ShowRatingCoin = false;
		end
	end
	
	if ( name == "kwUI_CheckRatingXP" ) then
		if ( checked ) then
			KillWatch_Config.ShowRatingXP = true;
		else
			KillWatch_Config.ShowRatingXP = false;
		end
	end
	
	if ( name == "kwUI_CheckRatingLoot" ) then
		if ( checked ) then
			KillWatch_Config.ShowRatingLoot = true;
		else
			KillWatch_Config.ShowRatingLoot = false;
		end
	end
	
	kwUI_OnShow();
	
end
