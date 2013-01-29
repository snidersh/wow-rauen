function pfUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"pfUI");
	this:SetHeight("390");
	this:SetWidth("400");

end

function pfUI_OnShow()

	local frame;
	local button;
	local text;
	
	-- Title
	text = getglobal("pfUI_TitleText");
	text:SetText("Rauen's PetFeed v"..PetFeed_Config.Version);
	frame = getglobal("pfUI_Title");
	frame:SetWidth(text:GetWidth()+250);
	
	-- PetFeed_Config.Enabled
	button = getglobal("pfUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pfUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( PetFeed_Config.Enabled );
	
	-- Config Panel
	text = getglobal("pfUI_ConfigBoxTitle");
	text:SetText("Configuration");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetFeed_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetFeed_Config.Color
	button = getglobal("pfUI_CheckSilent");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("pfUI_CheckSilentText");
	text:SetText("Silent Mode");
	button:SetChecked( PetFeed_Config.Silent );
	if not ( PetFeed_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetFeed_Config.Level
	button = getglobal("pfUI_LevelDropDown");
	OptionsFrame_EnableDropDown(button);
	text = getglobal("pfUI_LevelDropDownLabel");
	text:SetText("Pet Happiness Threshold");
	if not ( PetFeed_Config.Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	
	-- Commands Panel
	text = getglobal("pfUI_CommandsBoxTitle");
	text:SetText("Slash Commands");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetFeed_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	text = getglobal("pfUI_FontAddText");
	text:SetText("Add a Food Item to a Diet Category");
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if not ( PetFeed_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	text = getglobal("pfUI_FontAddSubText");
	text:SetText("/pf add <diet> <food name or link>");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetFeed_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	text = getglobal("pfUI_FontRemoveText");
	text:SetText("Remove a Food Item from a Diet Category");
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if not ( PetFeed_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	text = getglobal("pfUI_FontRemoveSubText");
	text:SetText("/pf remove <diet> <food name or link>");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetFeed_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	text = getglobal("pfUI_FontShowText");
	text:SetText("Show Current Food Items in a Diet Category");
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if not ( PetFeed_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	text = getglobal("pfUI_FontShowSubText");
	text:SetText("/pf show <diet>");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetFeed_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	text = getglobal("pfUI_FontDietText");
	text:SetText("Diet Categories");
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if not ( PetFeed_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	text = getglobal("pfUI_FontDietSubText");
	text:SetText("meat  fish  bread  cheese  fruit  fungus");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetFeed_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Defaults
	button = getglobal("pfUI_ResetButton");
	button:Enable();
	if not ( PetFeed_Config.Enabled ) then
		button:Disable();
	end
	
	-- DropDowns
	pfUI_DropDownRefresh();

end

function pfUI_DropDownOnShow()
	local button = this;
	local name = button:GetName();
	if ( name == "pfUI_LevelDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, PetFeed_Config.Level);
		UIDropDownMenu_Initialize(button, pfUI_DropDownInit);
		UIDropDownMenu_SetWidth(100, button);
	end
end

function pfUI_DropDownRefresh()
	UIDropDownMenu_SetSelectedValue(pfUI_LevelDropDown, PetFeed_Config.Level);
	UIDropDownMenu_Refresh(pfUI_LevelDropDown);
end

function pfUI_DropDownInit()

	local func;
	local name = this:GetName();
	if ( string.find(name, "pfUI_LevelDropDown") ) then
		func = pfUI_LevelDropDownOnClick;
	end
	
	local info = { };
	
	info.text = "Content";
	info.value = "content";
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
	
	info.text = "Happy";
	info.value = "happy";
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
	
end

function pfUI_LevelDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(pfUI_LevelDropDown, this.value);
	PetFeed_Config.Level = UIDropDownMenu_GetSelectedValue(pfUI_LevelDropDown);
end

function pfUI_Close()
	PlaySound("igMainMenuClose");
	HideUIPanel(pfUI);
end

function pfUI_Reset()
	PlaySound("igMainMenuOptionCheckBoxOn");
	PetFeed_Reset();
	pfUI_OnShow();
end

function pfUI_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "pfUI_CheckEnable" ) then
		if ( checked ) then
			PetFeed_Config.Enabled = true;
		else
			PetFeed_Config.Enabled = false;
		end
	end
	
	if ( name == "pfUI_CheckSilent" ) then
		if ( checked ) then
			PetFeed_Config.Silent = true;
		else
			PetFeed_Config.Silent = false;
		end
	end
	
	pfUI_OnShow();
	
end