function miUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"miUI");
	this:SetHeight("215");
	this:SetWidth("400");

end

function miUI_OnShow()

	local frame;
	local button;
	local text;
	
	-- Title
	text = getglobal("miUI_TitleText");
	text:SetText("Rauen's MapInfo v"..MapInfo_Config.Version);
	frame = getglobal("miUI_Title");
	frame:SetWidth(text:GetWidth()+250);
	
	-- MapInfo_Config[UnitName("player")].Enabled
	button = getglobal("miUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("miUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( MapInfo_Config[UnitName("player")].Enabled );
	
	-- Display Panel
	text = getglobal("miUI_ConfigBoxTitle");
	text:SetText("Display");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( MapInfo_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- MapInfo_Config[UnitName("player")].ShowCursor
	button = getglobal("miUI_CheckShowCursor");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("miUI_CheckShowCursorText");
	text:SetText("Show Cursor Coordinates");
	button:SetChecked( MapInfo_Config[UnitName("player")].ShowCursor );
	if not ( MapInfo_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- MapInfo_Config[UnitName("player")].ShowPlayer
	button = getglobal("miUI_CheckShowPlayer");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("miUI_CheckShowPlayerText");
	text:SetText("Show Player Coordinates");
	button:SetChecked( MapInfo_Config[UnitName("player")].ShowPlayer );
	if not ( MapInfo_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Defaults
	button = getglobal("miUI_ResetButton");
	button:Enable();
	if not ( MapInfo_Config[UnitName("player")].Enabled ) then
		button:Disable();
	end

end

function miUI_Close()
	PlaySound("igMainMenuClose");
	HideUIPanel(miUI);
end

function miUI_Reset()
	PlaySound("igMainMenuOptionCheckBoxOn");
	MapInfo_Reset();
	miUI_OnShow();
end

function miUI_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "miUI_CheckEnable" ) then
		if ( checked ) then
			MapInfo_Config[UnitName("player")].Enabled = true;
		else
			MapInfo_Config[UnitName("player")].Enabled = false;
		end
	end
	
	if ( name == "miUI_CheckShowCursor" ) then
		if ( checked ) then
			MapInfo_Config[UnitName("player")].ShowCursor = true;
		else
			MapInfo_Config[UnitName("player")].ShowCursor = false;
		end
	end
	
	if ( name == "miUI_CheckShowPlayer" ) then
		if ( checked ) then
			MapInfo_Config[UnitName("player")].ShowPlayer = true;
		else
			MapInfo_Config[UnitName("player")].ShowPlayer = false;
		end
	end
	
	miUI_OnShow();
	
end