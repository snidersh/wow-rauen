function abUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"abUI");
	this:SetHeight("440");
	this:SetWidth("400");

end

function abUI_OnShow()

	local frame;
	local button;
	local text;
	
	-- Title
	text = getglobal("abUI_TitleText");
	text:SetText("Rauen's ActionBars v"..Bars_Config.Version);
	frame = getglobal("abUI_Title");
	frame:SetWidth(text:GetWidth()+250);
	
	-- ActionBars_Config.Enabled
	button = getglobal("abUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("abUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( Bars_Config.Enabled );
	
	-- Bar Panel
	text = getglobal("abUI_BarBoxTitle");
	text:SetText("ActionBar");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( Bars_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Bars_Config.Hidden
	button = getglobal("abUI_CheckShow");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("abUI_CheckShowText");
	text:SetText("Show Bar");
	button:SetChecked( not Bars_Config.Hidden );
	if not ( Bars_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Bars_Config.ButtonSlider
	slider = getglobal("abUI_ButtonSlider");
	OptionsFrame_EnableSlider(slider);
	text = getglobal("abUI_ButtonSliderText");
	low = getglobal("abUI_ButtonSliderLow");
	high = getglobal("abUI_ButtonSliderHigh");
	slider:SetMinMaxValues(1, 12);
	slider:SetValueStep(1);
	slider:SetValue( Bars_Config.NumButtons );
	text:SetText(Bars_Config.NumButtons.." Button Slots");
	low:SetText("1");
	high:SetText("12");
	if not ( Bars_Config.Enabled ) then
		OptionsFrame_DisableSlider(slider);
	end
	if ( Bars_Config.Hidden ) then
		OptionsFrame_DisableSlider(slider);
	end
	
	-- Binding Panel
	text = getglobal("abUI_BindingBoxTitle");
	text:SetText("KeyBinding");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( Bars_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- KeyBinding
	for i=1, 12 do
		label = getglobal("abUI_KeyBind"..i.."Label");
		label:SetText("Button "..i);
		label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		button = getglobal("abUI_KeyBind"..i.."Button");
		button:Enable();
		if ( GetBindingKey("BARACTION_"..i) ) then
			button:SetText(GetBindingKey("BARACTION_"..i));
			button:SetAlpha(1);
		else
			button:SetText(NORMAL_FONT_COLOR_CODE..NOT_BOUND..FONT_COLOR_CODE_CLOSE);
			button:SetAlpha(0.8);
		end
		button.command = "BARACTION_"..i;
		button.desc = "Button "..i;
		if ( abUI_BindingBox.selected == "BARACTION_"..i ) then
			button:LockHighlight();
		end
		if not ( Bars_Config.Enabled ) then
			button:Disable();
			label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		end
	end
	if ( abUI_BindingBox.selected ) then
		abUI:EnableKeyboard(true);
	else
		abUI:EnableKeyboard(false);
	end
	
	-- Defaults
	button = getglobal("abUI_ResetKeysButton");
	button:Enable();
	if not ( Bars_Config.Enabled ) then
		button:Disable();
	end
	button = getglobal("abUI_ResetButton");
	button:Enable();
	if not ( Bars_Config.Enabled ) then
		button:Disable();
	end

end

function abUI_Close()
	PlaySound("igMainMenuClose");
	abUI_BindingBox.selected = nil;
	SaveBindings();
	abUI_BindingBox.selected = nil;
	HideUIPanel(abUI);
end

function abUI_Reset()
	PlaySound("igMainMenuOptionCheckBoxOn");
	Bars_Reset();
	abUI_OnShow();
end

function abUI_SliderOnValueChanged()

	PlaySound("igMainMenuOptionCheckBoxOn");

	local slider = this;
	local name = slider:GetName();
	
	if ( name == "abUI_ButtonSlider" ) then
		Bars_Config.NumButtons = slider:GetValue();
		text = getglobal("abUI_ButtonSliderText");
		text:SetText(Bars_Config.NumButtons.." Bar Buttons");
		Bars_Update();
	end
	
end

function abUI_ResetKeys()
	local key1, key2;
	for i=1, 12 do
		key1, key2 = GetBindingKey("BARACTION_"..i);
		if ( key1 ~= nil ) then
			SetBinding(key1, nil);
		end
	end
	SaveBindings();
	abUI_OnShow();
end

function abUI_BindingButtonOnClick()
	if ( abUI_BindingBox.selected ) then
		if ( button == "LeftButton" or button == "RightButton" ) then
			if (abUIBindingBox.buttonPressed == this) then
				abUI_BindingBox.selected = nil;
			else
				abUI_BindingBox.buttonPressed = this;
				abUI_BindingBox.selected = this.command;
				abUI_BindingBox.keyID = 1;
				ErrorMessage(format(BIND_KEY_TO_COMMAND, this.desc));
			end
			abUI_OnShow();
			return;
		end
		abUI_OnKeyDown(button);
	else
		if (abUI_BindingBox.buttonPressed) then
			abUI_BindingBox.buttonPressed:UnlockHighlight();
		end
		abUI_BindingBox.buttonPressed = this;
		abUI_BindingBox.selected = this.command;
		abUI_BindingBox.keyID = 1;
		ErrorMessage(format(BIND_KEY_TO_COMMAND, this.desc));
		abUI_OnShow();
	end
end

function abUI_OnKeyDown(button)

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
	
	if ( abUI_BindingBox.selected ) then
		local keyPressed = arg1;
		if ( arg1 == "ESCAPE" ) then
			local key1, key2 = GetBindingKey(abUI_BindingBox.selected);
			SetBinding(key1);
			abUI_SetBinding(key1, nil, key1);
			abUI_BindingBox.selected = nil;
			abUI_BindingBox.buttonPressed:UnlockHighlight();
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
			if ( oldAction ~= "" and oldAction ~= abUI_BindingBox.selected ) then
				local key1, key2 = GetBindingKey(oldAction);
				if ( (not key1 or key1 == keyPressed) and (not key2 or key2 == keyPressed) ) then
					ErrorMessage(format(KEY_UNBOUND_ERROR, oldAction));
				end
			else
				ErrorMessage(KEY_BOUND);
			end
			local key1, key2 = GetBindingKey(abUI_BindingBox.selected);
			if ( key1 ) then
				SetBinding(key1);
			end
			if ( key2 ) then
				SetBinding(key2);
			end
			if ( abUI_BindingBox.keyID == 1 ) then
				abUI_SetBinding(keyPressed, abUI_BindingBox.selected, key1);
				if ( key2 ) then
					SetBinding(key2, abUI_BindingBox.selected);
				end
			end
			abUI_BindingBox.selected = nil;
			abUI_BindingBox.buttonPressed:UnlockHighlight();
		end
		abUI_OnShow();
	end
	
end

function abUI_SetBinding(key, selectedBinding, oldKey)
	if ( SetBinding(key, selectedBinding) ) then
		return;
	else
		if ( oldKey ) then
			SetBinding(oldKey, selectedBinding);
		end
		ErrorMessage("Can't bind mousewheel to actions with up and down states");
	end
end

function abUI_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "abUI_CheckEnable" ) then
		if ( checked ) then
			Bars_Config.Enabled = true;
		else
			Bars_Config.Enabled = false;
		end
	end
	
	if ( name == "abUI_CheckShow" ) then
		if ( checked ) then
			Bars_Config.Hidden = false;
		else
			Bars_Config.Hidden = true;
		end
	end
	
	Bars_Update();
	abUI_OnShow();
	
end