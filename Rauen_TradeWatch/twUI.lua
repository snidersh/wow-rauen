function twUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"twUI");
	this:SetHeight("350");
	this:SetWidth("400");

end

function twUI_OnShow()

	local frame;
	local button;
	local text;
	
	-- Title
	text = getglobal("twUI_TitleText");
	text:SetText("Rauen's TradeWatch v"..TradeWatch_Config.Version);
	frame = getglobal("twUI_Title");
	frame:SetWidth(text:GetWidth()+250);
	
	-- TradeWatch_Config.Enabled
	button = getglobal("twUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("twUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( TradeWatch_Config.Enabled );
	
	-- Color Panel
	text = getglobal("twUI_ConfigBoxTitle");
	text:SetText("Configuration");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( TradeWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- TradeWatch_Config.Color
	button = getglobal("twUI_CheckColor");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("twUI_CheckColorText");
	text:SetText("Color Items by Difficulty");
	button:SetChecked( TradeWatch_Config.Color );
	if not ( TradeWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- TradeWatch_Config.Num
	button = getglobal("twUI_CheckNum");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("twUI_CheckNumText");
	text:SetText("Show Number of Products Available");
	button:SetChecked( TradeWatch_Config.Num );
	if not ( TradeWatch_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Commands Panel
	text = getglobal("twUI_CommandsBoxTitle");
	text:SetText("Slash Commands");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( TradeWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	text = getglobal("twUI_FontAddText");
	text:SetText("Add an Item to "..CUSTOM_REAGENTS_TEXT);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if not ( TradeWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	text = getglobal("twUI_FontAddSubText");
	text:SetText("/tw add <item name or link> [number to watch]");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( TradeWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	text = getglobal("twUI_FontRemoveText");
	text:SetText("Remove an Items from "..CUSTOM_REAGENTS_TEXT);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if not ( TradeWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	text = getglobal("twUI_FontRemoveSubText");
	text:SetText("/tw remove <item name or link>");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( TradeWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	text = getglobal("twUI_FontClearText");
	text:SetText("Clear "..CUSTOM_REAGENTS_TEXT);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if not ( TradeWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	text = getglobal("twUI_FontClearSubText");
	text:SetText("/tw clear");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( TradeWatch_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Defaults
	button = getglobal("twUI_ResetButton");
	button:Enable();
	if not ( TradeWatch_Config.Enabled ) then
		button:Disable();
	end

end

function twUI_Close()
	PlaySound("igMainMenuClose");
	HideUIPanel(twUI);
end

function twUI_Reset()
	PlaySound("igMainMenuOptionCheckBoxOn");
	TradeWatch_Reset();
	twUI_OnShow();
end

function twUI_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "twUI_CheckEnable" ) then
		if ( checked ) then
			TradeWatch_Config.Enabled = true;
		else
			TradeWatch_Config.Enabled = false;
		end
	end
	
	if ( name == "twUI_CheckColor" ) then
		if ( checked ) then
			TradeWatch_Config.Color = true;
		else
			TradeWatch_Config.Color = false;
		end
	end
	
	if ( name == "twUI_CheckNum" ) then
		if ( checked ) then
			TradeWatch_Config.Num = true;
		else
			TradeWatch_Config.Num = false;
		end
	end
	
	twUI_OnShow();
	
end