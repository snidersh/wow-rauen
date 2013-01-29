function paUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"paUI");
	this:SetHeight("400");
	this:SetWidth("400");

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
	
	-- PetAttack_Config.Enabled
	button = getglobal("paUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("paUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( PetAttack_Config.Enabled );
	
	-- Binding Panel
	text = getglobal("paUI_BindingBoxTitle");
	text:SetText("KeyBinding");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetAttack_Config.Enabled ) then
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
	if not ( PetAttack_Config.Enabled ) then
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
	if not ( PetAttack_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetAttack_Config.Cast
	button = getglobal("paUI_CheckCast");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("paUI_CheckCastText");
	text:SetText("Cast Spell");
	button:SetChecked( PetAttack_Config.Cast );
	if not ( PetAttack_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetAttack_Config.Spell
	text = getglobal("paUI_SpellEdit");
	text:SetText(PetAttack_Config.Spell);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	text:SetWidth(150);
	if not ( PetAttack_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( PetAttack_Config.Cast ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- PetAttack_Config.Rank
	text = getglobal("paUI_RankEdit");
	text:SetText(PetAttack_Config.Rank);
	text:SetWidth(60);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetAttack_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if not ( PetAttack_Config.Cast ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);		
	end
	
	-- Alert Panel
	text = getglobal("paUI_AlertBoxTitle");
	text:SetText("Alerts");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( PetAttack_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetAttack_Config.AttackAlert
	button = getglobal("paUI_CheckAttackAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("paUI_CheckAttackAlertText");
	text:SetText("Attack");
	button:SetChecked( PetAttack_Config.AttackAlert );
	if not ( PetAttack_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetAttack_Config.AttackChannel
	button = getglobal("paUI_AttackDropDown");
	OptionsFrame_EnableDropDown(button);
	if not ( PetAttack_Config.Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( PetAttack_Config.AttackAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	
	-- PetAttack_Config.AssistMeAlert
	button = getglobal("paUI_CheckAssistMeAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("paUI_CheckAssistMeAlertText");
	text:SetText("Assist Me");
	button:SetChecked( PetAttack_Config.AssistMeAlert );
	if not ( PetAttack_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetAttack_Config.AssistMeChannel
	button = getglobal("paUI_AssistMeDropDown");
	OptionsFrame_EnableDropDown(button);
	if not ( PetAttack_Config.Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( PetAttack_Config.AssistMeAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	
	-- PetAttack_Config.AssistOtherAlert
	button = getglobal("paUI_CheckAssistOtherAlert");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("paUI_CheckAssistOtherAlertText");
	text:SetText("Assist Other");
	button:SetChecked( PetAttack_Config.AssistOtherAlert );
	if not ( PetAttack_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- PetAttack_Config.AssistOtherChannel
	button = getglobal("paUI_AssistOtherDropDown");
	OptionsFrame_EnableDropDown(button);
	if not ( PetAttack_Config.Enabled ) then
		OptionsFrame_DisableDropDown(button);
	end
	if not ( PetAttack_Config.AssistOtherAlert ) then
		OptionsFrame_DisableDropDown(button);
	end
	
	-- Defaults
	button = getglobal("paUI_ResetKeysButton");
	button:Enable();
	if not ( PetAttack_Config.Enabled ) then
		button:Disable();
	end
	button = getglobal("paUI_ResetButton");
	button:Enable();
	if not ( PetAttack_Config.Enabled ) then
		button:Disable();
	end
	
	-- DropDowns
	paUI_DropDownRefresh();

end

function paUI_DropDownOnShow()
	local button = this;
	local name = button:GetName();
	if ( name == "paUI_AttackDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, PetAttack_Config.AttackChannel);
		UIDropDownMenu_Initialize(button, paUI_DropDownInit);
		UIDropDownMenu_SetWidth(60, button);
	end
	if ( name == "paUI_AssistMeDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, PetAttack_Config.AssistMeChannel);
		UIDropDownMenu_Initialize(button, paUI_DropDownInit);
		UIDropDownMenu_SetWidth(60, button);
	end
	if ( name == "paUI_AssistOtherDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, PetAttack_Config.AssistOtherChannel);
		UIDropDownMenu_Initialize(button, paUI_DropDownInit);
		UIDropDownMenu_SetWidth(60, button);
	end
end

function paUI_DropDownRefresh()
	UIDropDownMenu_SetSelectedValue(paUI_AttackDropDown, PetAttack_Config.AttackChannel);
	UIDropDownMenu_Refresh(paUI_AttackDropDown);
	UIDropDownMenu_SetSelectedValue(paUI_AssistMeDropDown, PetAttack_Config.AssistMeChannel);
	UIDropDownMenu_Refresh(paUI_AssistMeDropDown);
	UIDropDownMenu_SetSelectedValue(paUI_AssistOtherDropDown, PetAttack_Config.AssistOtherChannel);
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
end

function paUI_AttackDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(paUI_AttackDropDown, this.value);
	PetAttack_Config.AttackChannel = UIDropDownMenu_GetSelectedValue(paUI_AttackDropDown);
end

function paUI_AssistMeDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(paUI_AssistMeDropDown, this.value);
	PetAssistMe_Config.AssistMeChannel = UIDropDownMenu_GetSelectedValue(paUI_AssistMeDropDown);
end

function paUI_AssistOtherDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(paUI_AssistOtherDropDown, this.value);
	PetAssistOther_Config.AssistOtherChannel = UIDropDownMenu_GetSelectedValue(paUI_AssistOtherDropDown);
end

function paUI_Close()
	PlaySound("igMainMenuClose");
	paUI_SaveText();
	paUI_BindingBox.selected = nil;
	SaveBindings();
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
	SaveBindings();
	paUI_OnShow();
end

function paUI_SaveText()
	local text;
	text = getglobal("paUI_SpellEdit");
	PetAttack_Config.Spell = text:GetText();
	text = getglobal("paUI_RankEdit");
	PetAttack_Config.Rank = text:GetText();
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
			PetAttack_Config.Enabled = true;
		else
			PetAttack_Config.Enabled = false;
		end
	end
	
	if ( name == "paUI_CheckCast" ) then
		if ( checked ) then
			PetAttack_Config.Cast = true;
		else
			PetAttack_Config.Cast = false;
		end
	end
	
	if ( name == "paUI_CheckAlert" ) then
		if ( checked ) then
			PetAttack_Config.Alert = true;
		else
			PetAttack_Config.Alert = false;
		end
	end
	
	paUI_SaveText();
	paUI_OnShow();
	
end