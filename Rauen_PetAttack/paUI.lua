StaticPopupDialogs["PAUI_CONFIRM_DELETE"] = {
	text = TEXT("Are you sure you would like to delete this message?"),
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		paUI_DeleteSelectedConfirmed();
	end,
	timeout = 0,
};

function paUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"paUI");
	this:SetHeight("530");
	this:SetWidth("400");
	
	paUI_ResetVars();

end

function paUI_ResetVars()
	paUI_Var = { };
	paUI_Var.Type = "Attack";
	paUI_Var.SelectedButton = nil;
	paUI_Var.Pages = 0;
	paUI_Var.CurrentPage = 1;
end

function paUI_OnShow()

	local frame;
	local button;
	local label, text;
	
	-- Title
	text = getglobal("paUI_TitleText");
	text:SetText("Rauen's PetAttack v"..PetAttack_Config.Version);
	frame = getglobal("paUI_Title");
	frame:SetWidth(text:GetWidth()+250);
	
	-- PetAttack_Config[UnitName("player")].Enabled
	button = getglobal("paUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("paUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( PetAttack_Config[UnitName("player")].Enabled );
	
	-- Binding Panel
	text = getglobal("paUI_BindingBoxTitle");
	text:SetText("KeyBinding");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- KeyBinding
	label = getglobal("paUI_KeyBindLabel");
	label:SetText("Pet Attack");
	label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	button = getglobal("paUI_KeyBindButton");
	button:Enable();
	if ( GetBindingKey("PETATTACK_BINDING") ) then
		button:SetText(GetBindingKey("PETATTACK_BINDING"));
		button:SetAlpha(1);
	else
		button:SetText(NORMAL_FONT_COLOR_CODE..NOT_BOUND..FONT_COLOR_CODE_CLOSE);
		button:SetAlpha(0.8);
	end
	button.command = "PETATTACK_BINDING";
	button.desc = "Pet Attack";
	if ( paUI_BindingBox.selected == "PETATTACK_BINDING" ) then
		button:LockHighlight();
	end
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		button:Disable();
		label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if ( paUI_BindingBox.selected ) then
		paUI:EnableKeyboard(true);
	else
		paUI:EnableKeyboard(false);
	end
	
	-- Defense Panel
	text = getglobal("paUI_SpellBoxTitle");
	text:SetText("Spell");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetAttack_Config[UnitName("player")].Cast
	button = getglobal("paUI_CheckCast");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("paUI_CheckCastText");
	text:SetText("Cast Spell");
	button:SetChecked( PetAttack_Config[UnitName("player")].Cast );
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetAttack_Config[UnitName("player")].Spell
	text = getglobal("paUI_SpellEdit");
	text:SetText(PetAttack_Config[UnitName("player")].Spell);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	text:SetWidth(150);
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( PetAttack_Config[UnitName("player")].Cast ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- PetAttack_Config[UnitName("player")].Rank
	text = getglobal("paUI_RankEdit");
	text:SetText(PetAttack_Config[UnitName("player")].Rank);
	text:SetWidth(60);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( PetAttack_Config[UnitName("player")].Cast ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- Attack Tab
	button = getglobal("paUI_AttackTab");
	text = getglobal("paUI_AttackTabText");
	button:Enable();
	if ( paUI_Var.Type == "Attack" ) then
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	else
		text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	end
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		button:Disable();
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- AssistMe Tab
	button = getglobal("paUI_AssistMeTab");
	text = getglobal("paUI_AssistMeTabText");
	button:Enable();
	if ( paUI_Var.Type == "AssistMe" ) then
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	else
		text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	end
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		button:Disable();
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- AssistOther Tab
	button = getglobal("paUI_AssistOtherTab");
	text = getglobal("paUI_AssistOtherTabText");
	button:Enable();
	if ( paUI_Var.Type == "AssistOther" ) then
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	else
		text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	end
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		button:Disable();
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetAttack_Config[UnitName("player")].AttackAlert
	button = getglobal("paUI_CheckAttackAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("paUI_CheckAttackAlertText");
	text:SetText("Attack Alert");
	button:SetChecked( PetAttack_Config[UnitName("player")].AttackAlert );
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	button:Hide();
	if ( paUI_Var.Type == "Attack" ) then
		button:Show();
	end
	
	-- PetAttack_Config[UnitName("player")].AttackChannel
	button = getglobal("paUI_AttackDropDown");
	OptionsFrame_EnableDropDown(button);
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( PetAttack_Config[UnitName("player")].AttackAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	button:Hide();
	if ( paUI_Var.Type == "Attack" ) then
		button:Show();
	end
	
	-- PetAttack_Config[UnitName("player")].AssistMeAlert
	button = getglobal("paUI_CheckAssistMeAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("paUI_CheckAssistMeAlertText");
	text:SetText("Assist Me Alert");
	button:SetChecked( PetAttack_Config[UnitName("player")].AssistMeAlert );
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	button:Hide();
	if ( paUI_Var.Type == "AssistMe" ) then
		button:Show();
	end
	
	-- PetAttack_Config[UnitName("player")].AssistMeChannel
	button = getglobal("paUI_AssistMeDropDown");
	OptionsFrame_EnableDropDown(button);
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( PetAttack_Config[UnitName("player")].AssistMeAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	button:Hide();
	if ( paUI_Var.Type == "AssistMe" ) then
		button:Show();
	end
	
	-- PetAttack_Config[UnitName("player")].AssistOtherAlert
	button = getglobal("paUI_CheckAssistOtherAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("paUI_CheckAssistOtherAlertText");
	text:SetText("Assist Other Alert");
	button:SetChecked( PetAttack_Config[UnitName("player")].AssistOtherAlert );
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	button:Hide();
	if ( paUI_Var.Type == "AssistOther" ) then
		button:Show();
	end
	
	-- PetAttack_Config[UnitName("player")].AssistOtherChannel
	button = getglobal("paUI_AssistOtherDropDown");
	OptionsFrame_EnableDropDown(button);
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( PetAttack_Config[UnitName("player")].AssistOtherAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	button:Hide();
	if ( paUI_Var.Type == "AssistOther" ) then
		button:Show();
	end
	
	-- Inset Box
	frame = getglobal("paUI_InsetBox");
	frame:SetBackdropColor(0.0, 0.0, 0.0);
	
	-- Messages
	local index = ( ( paUI_Var.CurrentPage - 1 ) * 4 ) + 1;
	for i=1, 4 do
		button = getglobal("paUI_MessageButton"..i);
		text = getglobal("paUI_MessageButton"..i.."Text");
		local message;
		if ( paUI_Var.Type == "Attack" ) then
			message = PetAttack_Config[UnitName("player")].Messages.Attack[index];
		end
		if ( paUI_Var.Type == "AssistMe" ) then
			message = PetAttack_Config[UnitName("player")].Messages.AssistMe[index];
		end
		if ( paUI_Var.Type == "AssistOther" ) then
			message = PetAttack_Config[UnitName("player")].Messages.AssistOther[index];
		end
		if ( message ) then
			button.id = i;
			button:Show();
			button:UnlockHighlight();
			if ( paUI_Var.SelectedButton == i ) then
				button:LockHighlight();
			end
			text:SetText(message);
			text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
			if not ( PetAttack_Config[UnitName("player")].Enabled ) then
				text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
				button.id = nil;
			end
			if ( paUI_Var.Type == "Attack" ) then
				if not ( PetAttack_Config[UnitName("player")].AttackAlert ) then
					text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
					button.id = nil;
				end
			end
			if ( paUI_Var.Type == "AssistMe" ) then
				if not ( PetAttack_Config[UnitName("player")].AssistMeAlert ) then
					text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
					button.id = nil;
				end
			end
			if ( paUI_Var.Type == "AssistOther" ) then
				if not ( PetAttack_Config[UnitName("player")].AssistOtherAlert ) then
					text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
					button.id = nil;
				end
			end
		else
			button.id = nil;
			button:Hide();
		end
		index = index + 1;
	end
	
	local num;
	if ( paUI_Var.Type == "Attack" ) then
		num = table.getn(PetAttack_Config[UnitName("player")].Messages.Attack);
	end
	if ( paUI_Var.Type == "AssistMe" ) then
		num = table.getn(PetAttack_Config[UnitName("player")].Messages.AssistMe);
	end
	if ( paUI_Var.Type == "AssistOther" ) then
		num = table.getn(PetAttack_Config[UnitName("player")].Messages.AssistOther);
	end
	paUI_Var.Pages = math.floor(num/4);
	if ( ( num/4 ) > math.floor(num/4) ) then
		paUI_Var.Pages = paUI_Var.Pages + 1;
	end
	
	-- PageLabel
	text = getglobal("paUI_PageLabelText");
	if ( paUI_Var.Pages == 0 ) then
		text:SetText("");
	else
		text:SetText("Page "..paUI_Var.CurrentPage.." of "..paUI_Var.Pages);
	end
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PrevPage
	button = getglobal("paUI_PrevPageButton");
	text = getglobal("paUI_PrevPageButtonText");
	button:Enable();
	if ( paUI_Var.CurrentPage == 1 ) then
		button:Disable();
	end
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		button:Disable();
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- NextPage
	button = getglobal("paUI_NextPageButton");
	text = getglobal("paUI_NextPageButtonText");
	button:Enable();
	if (paUI_Var.CurrentPage == paUI_Var.Pages ) or ( paUI_Var.Pages == 0 ) then
		button:Disable();
	end
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		button:Disable();
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Add Message
	text = getglobal("paUI_AddEdit");
	text:SetWidth(230);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Add Button
	button = getglobal("paUI_AddButton");
	button:SetWidth(100);
	button:Enable();
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		button:Disable();
	end
	
	-- Delete Button
	button = getglobal("paUI_DeleteButton");
	button:SetWidth(100);
	button:Enable();
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		button:Disable();
	end
	if not ( paUI_Var.SelectedButton ) then
		button:Disable();
	end
	
	-- Defaults
	button = getglobal("paUI_ResetKeysButton");
	button:Enable();
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		button:Disable();
	end
	button = getglobal("paUI_ResetButton");
	button:Enable();
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
		button:Disable();
	end
	
	-- DropDowns
	paUI_DropDownRefresh();

end

function paUI_DropDownOnShow()
	local button = this;
	local name = button:GetName();
	if ( name == "paUI_AttackDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, PetAttack_Config[UnitName("player")].AttackChannel);
		UIDropDownMenu_Initialize(button, paUI_DropDownInit);
		UIDropDownMenu_SetWidth(60, button);
	end
	if ( name == "paUI_AssistMeDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, PetAttack_Config[UnitName("player")].AssistMeChannel);
		UIDropDownMenu_Initialize(button, paUI_DropDownInit);
		UIDropDownMenu_SetWidth(60, button);
	end
	if ( name == "paUI_AssistOtherDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, PetAttack_Config[UnitName("player")].AssistOtherChannel);
		UIDropDownMenu_Initialize(button, paUI_DropDownInit);
		UIDropDownMenu_SetWidth(60, button);
	end
end

function paUI_DropDownRefresh()
	UIDropDownMenu_SetSelectedValue(paUI_AttackDropDown, PetAttack_Config[UnitName("player")].AttackChannel);
	UIDropDownMenu_Refresh(paUI_AttackDropDown);
	UIDropDownMenu_SetSelectedValue(paUI_AssistMeDropDown, PetAttack_Config[UnitName("player")].AssistMeChannel);
	UIDropDownMenu_Refresh(paUI_AssistMeDropDown);
	UIDropDownMenu_SetSelectedValue(paUI_AssistOtherDropDown, PetAttack_Config[UnitName("player")].AssistOtherChannel);
	UIDropDownMenu_Refresh(paUI_AssistOtherDropDown);
end

function paUI_DropDownInit()
	local func;
	local name = this:GetName();
	if ( string.find(name, "paUI_AttackDropDown") ) then
		func = paUI_AttackDropDownOnClick;
	end
	if ( string.find(name, "paUI_AssistMeDropDown") ) then
		func = paUI_AssistMeDropDownOnClick;
	end
	if ( string.find(name, "paUI_AssistOtherDropDown") ) then
		func = paUI_AssistOtherDropDownOnClick;
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
	info.text = "Chat";
	info.value = "CHAT";
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

function paUI_AttackDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(paUI_AttackDropDown, this.value);
	PetAttack_Config[UnitName("player")].AttackChannel = UIDropDownMenu_GetSelectedValue(paUI_AttackDropDown);
end

function paUI_AssistMeDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(paUI_AssistMeDropDown, this.value);
	PetAttack_Config[UnitName("player")].AssistMeChannel = UIDropDownMenu_GetSelectedValue(paUI_AssistMeDropDown);
end

function paUI_AssistOtherDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(paUI_AssistOtherDropDown, this.value);
	PetAttack_Config[UnitName("player")].AssistOtherChannel = UIDropDownMenu_GetSelectedValue(paUI_AssistOtherDropDown);
end

function paUI_Close()
	PlaySound("igMainMenuClose");
	paUI_SaveText();
	paUI_BindingBox.selected = nil;
	SaveBindings(GetCurrentBindingSet());
	HideUIPanel(paUI);
end

function paUI_Reset()
	PlaySound("igMainMenuOptionCheckBoxOn");
	PetAttack_Reset();
	paUI_OnShow();
	paUI_DropDownRefresh();
end

function paUI_ResetKeys()
	local key1, key2 = GetBindingKey("PETATTACK_BINDING");
	if ( key1 ~= nil ) then
		SetBinding(key1, nil);
	end
	SaveBindings(GetCurrentBindingSet());
	paUI_OnShow();
end

function paUI_SaveText()
	local text;
	text = getglobal("paUI_SpellEdit");
	PetAttack_Config[UnitName("player")].Spell = text:GetText();
	text = getglobal("paUI_RankEdit");
	PetAttack_Config[UnitName("player")].Rank = text:GetText();
end

function paUI_DeleteSelected()
	PlaySound("UChatScrollButton");
	StaticPopup_Show("PAUI_CONFIRM_DELETE");
end

function paUI_DeleteSelectedConfirmed()
	local message = getglobal("paUI_MessageButton"..paUI_Var.SelectedButton.."Text"):GetText();
	paUI_Delete(message);
	paUI_Var.SelectedButton = nil;
	paUI_OnShow();
end

function paUI_Delete(message)
	local temp = { };
	if ( paUI_Var.Type == "Attack" ) then
		for i=1, table.getn(PetAttack_Config[UnitName("player")].Messages.Attack) do
			if not ( PetAttack_Config[UnitName("player")].Messages.Attack[i] == message ) then
				table.insert(temp, PetAttack_Config[UnitName("player")].Messages.Attack[i]);
			end
		end
		PetAttack_Config[UnitName("player")].Messages.Attack = { };
		PetAttack_Config[UnitName("player")].Messages.Attack = temp;
	end
	if ( paUI_Var.Type == "AssistMe" ) then
		for i=1, table.getn(PetAttack_Config[UnitName("player")].Messages.AssistMe) do
			if not ( PetAttack_Config[UnitName("player")].Messages.AssistMe[i] == message ) then
				table.insert(temp, PetAttack_Config[UnitName("player")].Messages.AssistMe[i]);
			end
		end
		PetAttack_Config[UnitName("player")].Messages.AssistMe = { };
		PetAttack_Config[UnitName("player")].Messages.AssistMe = temp;
	end
	if ( paUI_Var.Type == "AssistOther" ) then
		for i=1, table.getn(PetAttack_Config[UnitName("player")].Messages.AssistOther) do
			if not ( PetAttack_Config[UnitName("player")].Messages.AssistOther[i] == message ) then
				table.insert(temp, PetAttack_Config[UnitName("player")].Messages.AssistOther[i]);
			end
		end
		PetAttack_Config[UnitName("player")].Messages.AssistOther = { };
		PetAttack_Config[UnitName("player")].Messages.AssistOther = temp;
	end
end

function paUI_AddMessage()
	local text =  getglobal("paUI_AddEdit");
	local message = text:GetText();
	if ( message == "" ) then
		return;
	end
	if ( paUI_Var.Type == "Attack" ) then
		table.insert(PetAttack_Config[UnitName("player")].Messages.Attack, message);
	end
	if ( paUI_Var.Type == "AssistMe" ) then
		table.insert(PetAttack_Config[UnitName("player")].Messages.AssistMe, message);
	end
	if ( paUI_Var.Type == "AssistOther" ) then
		table.insert(PetAttack_Config[UnitName("player")].Messages.AssistOther, message);
	end
	text:SetText("");
	paUI_OnShow();
end

function paUI_RowButton_OnClick()
	PlaySound("UChatScrollButton");
	local button = this;
	if (paUI_Var.SelectedButton == button.id ) then
		paUI_Var.SelectedButton = nil;
	else
		paUI_Var.SelectedButton = button.id;
	end
	paUI_OnShow();
end

function paUI_TabOnClick(tab)
	paUI_Var.Type = tab;
	paUI_OnShow();
end

function paUI_PrevPageButton_OnClick()
	PlaySound("UChatScrollButton");
	if ( paUI_Var.CurrentPage > 1 ) then
		paUI_Var.CurrentPage = paUI_Var.CurrentPage - 1;
	end
	paUI_Var.SelectedButton = nil;
	paUI_OnShow();
end

function paUI_NextPageButton_OnClick()
	PlaySound("UChatScrollButton");
	if ( paUI_Var.Pages > paUI_Var.CurrentPage ) then
		paUI_Var.CurrentPage = paUI_Var.CurrentPage + 1;
	end
	paUI_Var.SelectedButton = nil;
	paUI_OnShow();
end

function paUI_BindingButtonOnClick()
	if ( paUI_BindingBox.selected ) then
		if ( button == "LeftButton" or button == "RightButton" ) then
			if (paUIBindingBox.buttonPressed == this) then
				paUI_BindingBox.selected = nil;
			else
				paUI_BindingBox.buttonPressed = this;
				paUI_BindingBox.selected = "PETATTACK_BINDING";
				paUI_BindingBox.keyID = 1;
				ErrorMessage(format(BIND_KEY_TO_COMMAND, "Pet Attack"));
			end
			paUI_OnShow();
			return;
		end
		paUI_OnKeyDown(button);
	else
		if (paUI_BindingBox.buttonPressed) then
			paUI_BindingBox.buttonPressed:UnlockHighlight();
		end
		paUI_BindingBox.buttonPressed = this;
		paUI_BindingBox.selected = "PETATTACK_BINDING";
		paUI_BindingBox.keyID = 1;
		ErrorMessage(format(BIND_KEY_TO_COMMAND, "Pet Attack"));
		paUI_OnShow();
	end
end

function paUI_OnKeyDown(button)

	if ( arg1 == "PRINTSCREEN" ) then
		Screenshot();
		return;
	end

	if ( button == "LeftButton" ) then
		button = "BUTTON1";
	elseif ( button == "RightButton" ) then
		button = "BUTTON2";
	elseif ( button == "MiddleButton" ) then
		button = "BUTTON3";
	elseif ( button == "Button4" ) then
		button = "BUTTON4"
	elseif ( button == "Button5" ) then
		button = "BUTTON5"
	end
	
	if ( paUI_BindingBox.selected ) then
		local keyPressed = arg1;
		if ( arg1 == "ESCAPE" ) then
			local key1, key2 = GetBindingKey(paUI_BindingBox.selected);
			SetBinding(key1);
			paUI_SetBinding(key1, nil, key1);
			paUI_BindingBox.selected = nil;
			paUI_BindingBox.buttonPressed:UnlockHighlight();
		else
			if ( button ) then
				if ( button == "BUTTON1" or button == "BUTTON2" ) then
					return;
				end
				keyPressed = button;
			else
				keyPressed = arg1;
			end
			if ( keyPressed == "UNKNOWN" ) then
				return;
			end
			if ( keyPressed == "SHIFT" or keyPressed == "CTRL" or keyPressed == "ALT") then
				return;
			end
			if ( IsShiftKeyDown() ) then
				keyPressed = "SHIFT-"..keyPressed;
			end
			if ( IsControlKeyDown() ) then
				keyPressed = "CTRL-"..keyPressed;
			end
			if ( IsAltKeyDown() ) then
				keyPressed = "ALT-"..keyPressed;
			end
			local oldAction = GetBindingAction(keyPressed);
			if ( oldAction ~= "" and oldAction ~= paUI_BindingBox.selected ) then
				local key1, key2 = GetBindingKey(oldAction);
				if ( (not key1 or key1 == keyPressed) and (not key2 or key2 == keyPressed) ) then
					ErrorMessage(format(KEY_UNBOUND_ERROR, oldAction));
				end
			else
				ErrorMessage(KEY_BOUND);
			end
			local key1, key2 = GetBindingKey(paUI_BindingBox.selected);
			if ( key1 ) then
				SetBinding(key1);
			end
			if ( key2 ) then
				SetBinding(key2);
			end
			if ( paUI_BindingBox.keyID == 1 ) then
				paUI_SetBinding(keyPressed, paUI_BindingBox.selected, key1);
				if ( key2 ) then
					SetBinding(key2, paUI_BindingBox.selected);
				end
			end
			paUI_BindingBox.selected = nil;
			paUI_BindingBox.buttonPressed:UnlockHighlight();
			paUI_OnShow();
		end
	end
	
end

function paUI_SetBinding(key, selectedBinding, oldKey)
	if ( SetBinding(key, selectedBinding) ) then
		return;
	else
		if ( oldKey ) then
			SetBinding(oldKey, selectedBinding);
		end
		ErrorMessage("Can't bind mousewheel to actions with up and down states");
	end
end

function paUI_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "paUI_CheckEnable" ) then
		if ( checked ) then
			PetAttack_Config[UnitName("player")].Enabled = true;
		else
			PetAttack_Config[UnitName("player")].Enabled = false;
		end
	end
	
	if ( name == "paUI_CheckCast" ) then
		if ( checked ) then
			PetAttack_Config[UnitName("player")].Cast = true;
		else
			PetAttack_Config[UnitName("player")].Cast = false;
		end
	end
	
	if ( name == "paUI_CheckAttackAlert" ) then
		if ( checked ) then
			PetAttack_Config[UnitName("player")].AttackAlert = true;
		else
			PetAttack_Config[UnitName("player")].AttackAlert = false;
		end
	end
	
	if ( name == "paUI_CheckAssistMeAlert" ) then
		if ( checked ) then
			PetAttack_Config[UnitName("player")].AssistMeAlert = true;
		else
			PetAttack_Config[UnitName("player")].AssistMeAlert = false;
		end
	end
	
	if ( name == "paUI_CheckAssistOtherAlert" ) then
		if ( checked ) then
			PetAttack_Config[UnitName("player")].AssistOtherAlert = true;
		else
			PetAttack_Config[UnitName("player")].AssistOtherAlert = false;
		end
	end
	
	paUI_SaveText();
	paUI_OnShow();
	
end
