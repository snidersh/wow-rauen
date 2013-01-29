StaticPopupDialogs["KARMA_CONFIRM_RESET"] = {
	text = TEXT("Are you sure you would like to reset all recorded karma levels?"),
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		Karma_ResetStats();
		kUI:Show();
	end,
	OnCancel = function()
		kUI:Show();
	end,
	timeout = 0,
};

function kUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"kUI");
	this:SetHeight("475");
	this:SetWidth("400");

end

function kUI_OnShow()

	local frame;
	local button;
	local text;
	
	-- Title
	text = getglobal("kUI_TitleText");
	text:SetText("Rauen's Karma v"..Karma_Config.Version);
	frame = getglobal("kUI_Title");
	frame:SetWidth(text:GetWidth()+250);
	
	-- Karma_Config[UnitName("player")].Enabled
	button = getglobal("kUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( Karma_Config[UnitName("player")].Enabled );
	
	-- Config Panel
	text = getglobal("kUI_DisplayBoxTitle");
	text:SetText("Display");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Karma_Config[UnitName("player")].ShowGuild
	button = getglobal("kUI_CheckGuild");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kUI_CheckGuildText");
	text:SetText("Show Guild");
	button:SetChecked( Karma_Config[UnitName("player")].ShowGuild );
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Karma_Config[UnitName("player")].ShowKarma
	button = getglobal("kUI_CheckKarma");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kUI_CheckKarmaText");
	text:SetText("Show Karma");
	button:SetChecked( Karma_Config[UnitName("player")].ShowKarma );
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Karma_Config[UnitName("player")].ShowNote
	button = getglobal("kUI_CheckNote");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kUI_CheckNoteText");
	text:SetText("Show Note");
	button:SetChecked( Karma_Config[UnitName("player")].ShowNote );
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Alert Panel
	text = getglobal("kUI_AlertBoxTitle");
	text:SetText("Messages");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Karma_Config[UnitName("player")].GoodKarmaTell
	button = getglobal("kUI_CheckGoodAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kUI_CheckGoodAlertText");
	text:SetText("Good Messages");
	button:SetChecked( Karma_Config[UnitName("player")].GoodKarmaTell );
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Karma_Config[UnitName("player")].GoodKarmaMessage
	text = getglobal("kUI_GoodEdit");
	text:SetText(Karma_Config[UnitName("player")].GoodKarmaMessage);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( Karma_Config[UnitName("player")].GoodKarmaTell ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- Karma_Config[UnitName("player")].BadKarmaTell
	button = getglobal("kUI_CheckBadAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("kUI_CheckBadAlertText");
	text:SetText("Bad Messages");
	button:SetChecked( Karma_Config[UnitName("player")].BadKarmaTell );
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Karma_Config[UnitName("player")].BadKarmaMessage
	text = getglobal("kUI_BadEdit");
	text:SetText(Karma_Config[UnitName("player")].BadKarmaMessage);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( Karma_Config[UnitName("player")].BadKarmaTell ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- Commands Panel
	text = getglobal("kUI_CommandsBoxTitle");
	text:SetText("Commands");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	text = getglobal("kUI_FontInsText");
	text:SetText("Karma Menu");
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	text = getglobal("kUI_FontInsSubText");
	text:SetText("Right-click on a player's portrait.");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	text = getglobal("kUI_FontKarmaText");
	text:SetText("Bestow Karma on a Player");
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	text = getglobal("kUI_FontKarmaSubText");
	text:SetText("/goodkarma <name> or /badkarma <name>");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	text = getglobal("kUI_FontNoteText");
	text:SetText("Karma Notes for Players");
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	text = getglobal("kUI_FontNoteSubText");
	text:SetText("/karmanote <name> or /karmanote show <name>");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Defaults
	button = getglobal("kUI_ResetButton");
	button:Enable();
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		button:Disable();
	end

end

function kUI_Close()
	PlaySound("igMainMenuClose");
	kUI_SaveText();
	HideUIPanel(kUI);
end

function kUI_SaveText()
	local text;
	text = getglobal("kUI_GoodEdit");
	Karma_Config[UnitName("player")].GoodKarmaMessage = text:GetText();
	text = getglobal("kUI_BadEdit");
	Karma_Config[UnitName("player")].BadKarmaMessage = text:GetText();
end

function kUI_Reset()
	PlaySound("igMainMenuOptionCheckBoxOn");
	Karma_Reset();
	kUI_OnShow();
end

function kUI_ResetStats()
	kUI_Close();
	StaticPopup_Show("KARMA_CONFIRM_RESET");
end

function kUI_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "kUI_CheckEnable" ) then
		if ( checked ) then
			Karma_Config[UnitName("player")].Enabled = true;
		else
			Karma_Config[UnitName("player")].Enabled = false;
		end
	end
	
	if ( name == "kUI_CheckGuild" ) then
		if ( checked ) then
			Karma_Config[UnitName("player")].ShowGuild = true;
		else
			Karma_Config[UnitName("player")].ShowGuild = false;
		end
	end
	
	if ( name == "kUI_CheckKarma" ) then
		if ( checked ) then
			Karma_Config[UnitName("player")].ShowKarma = true;
		else
			Karma_Config[UnitName("player")].ShowKarma = false;
		end
	end
	
	if ( name == "kUI_CheckNote" ) then
		if ( checked ) then
			Karma_Config[UnitName("player")].ShowNote = true;
		else
			Karma_Config[UnitName("player")].ShowNote = false;
		end
	end
	
	if ( name == "kUI_CheckGoodAlert" ) then
		if ( checked ) then
			Karma_Config[UnitName("player")].GoodKarmaTell = true;
		else
			Karma_Config[UnitName("player")].GoodKarmaTell = false;
		end
	end
	
	if ( name == "kUI_CheckBadAlert" ) then
		if ( checked ) then
			Karma_Config[UnitName("player")].BadKarmaTell = true;
		else
			Karma_Config[UnitName("player")].BadKarmaTell = false;
		end
	end
	
	kUI_OnShow();
	
end