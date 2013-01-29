function boUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"boUI");
	this:SetHeight("380");
	this:SetWidth("400");

end

function boUI_OnShow()

	local frame;
	local button;
	local text;
	
	-- Title
	text = getglobal("boUI_TitleText");
	text:SetText("Rauen's BagsOpen v"..BagsOpen_Config.Version);
	frame = getglobal("boUI_Title");
	frame:SetWidth(text:GetWidth()+250);
	
	-- BagsOpen_Config.Enabled
	button = getglobal("boUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("boUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( BagsOpen_Config.Enabled );
	
	-- Binding Panel
	text = getglobal("boUI_BindingBoxTitle");
	text:SetText("KeyBinding");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( BagsOpen_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- KeyBinding
	label = getglobal("boUI_KeyBindLabel");
	label:SetText("Open All Bags");
	label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	button = getglobal("boUI_KeyBindButton");
	button:Enable();
	if ( GetBindingKey("OPENALLBAGS") ) then
		button:SetText(GetBindingKey("OPENALLBAGS"));
		button:SetAlpha(1);
	else
		button:SetText(NORMAL_FONT_COLOR_CODE..NOT_BOUND..FONT_COLOR_CODE_CLOSE);
		button:SetAlpha(0.8);
	end
	button.command = "OPENALLBAGS";
	button.desc = "Open All Bags";
	if ( boUI_BindingBox.selected == "OPENALLBAGS" ) then
		button:LockHighlight();
	end
	if not ( BagsOpen_Config.Enabled ) then
		button:Disable();
		label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if ( boUI_BindingBox.selected ) then
		boUI:EnableKeyboard(true);
	else
		boUI:EnableKeyboard(false);
	end
	
	-- Bags Panel
	text = getglobal("boUI_BagsBoxTitle");
	text:SetText("AutoOpen Bags");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( BagsOpen_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- BagsOpen_Config.One
	button = getglobal("boUI_CheckBagOne");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("boUI_CheckBagOneText");
	text:SetText("1st Bag:  "..GetContainerNumSlots(1).."-slot "..GetBagName(1));
	button:SetChecked( BagsOpen_Config.One );
	if not ( BagsOpen_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- BagsOpen_Config.Two
	button = getglobal("boUI_CheckBagTwo");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("boUI_CheckBagTwoText");
	text:SetText("2nd Bag:  "..GetContainerNumSlots(1).."-slot "..GetBagName(2));
	button:SetChecked( BagsOpen_Config.Two );
	if not ( BagsOpen_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- BagsOpen_Config.Three
	button = getglobal("boUI_CheckBagThree");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("boUI_CheckBagThreeText");
	text:SetText("3rd Bag:  "..GetContainerNumSlots(1).."-slot "..GetBagName(3));
	button:SetChecked( BagsOpen_Config.Three );
	if not ( BagsOpen_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- BagsOpen_Config.Four
	button = getglobal("boUI_CheckBagFour");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("boUI_CheckBagFourText");
	text:SetText("4th Bag:  "..GetContainerNumSlots(1).."-slot "..GetBagName(4));
	button:SetChecked( BagsOpen_Config.Four );
	if not ( BagsOpen_Config.Enabled ) then
		OptionsFrame_DisableCheckBox(button);
	end
	
	-- Defaults
	button = getglobal("boUI_ResetKeysButton");
	button:Enable();
	if not ( BagsOpen_Config.Enabled ) then
		button:Disable();
	end
	button = getglobal("boUI_ResetButton");
	button:Enable();
	if not ( BagsOpen_Config.Enabled ) then
		button:Disable();
	end

end

function boUI_Close()
	PlaySound("igMainMenuClose");
	boUI_BindingBox.selected = nil;
	SaveBindings();
	HideUIPanel(boUI);
end

function boUI_Reset()
	PlaySound("igMainMenuOptionCheckBoxOn");
	BagsOpen_Reset();
	boUI_OnShow();
end

function boUI_ResetKeys()
	local key1, key2 = GetBindingKey("OPENALLBAGS");
	if ( key1 ~= nil ) then
		SetBinding(key1, nil);
	end
	SaveBindings();
	boUI_OnShow();
end

function boUI_BindingButtonOnClick()
	if ( boUI_BindingBox.selected ) then
		if ( button == "LeftButton" or button == "RightButton" ) then
			if (boUIBindingBox.buttonPressed == this) then
				boUI_BindingBox.selected = nil;
			else
				boUI_BindingBox.buttonPressed = this;
				boUI_BindingBox.selected = "OPENALLBAGS";
				boUI_BindingBox.keyID = 1;
				ErrorMessage(format(BIND_KEY_TO_COMMAND, "Open All Bags"));
			end
			boUI_OnShow();
			return;
		end
		boUI_OnKeyDown(button);
	else
		if (boUI_BindingBox.buttonPressed) then
			boUI_BindingBox.buttonPressed:UnlockHighlight();
		end
		boUI_BindingBox.buttonPressed = this;
		boUI_BindingBox.selected = "OPENALLBAGS";
		boUI_BindingBox.keyID = 1;
		ErrorMessage(format(BIND_KEY_TO_COMMAND, "Open All Bags"));
		boUI_OnShow();
	end
end

function boUI_OnKeyDown(button)

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
	
	if ( boUI_BindingBox.selected ) then
		local keyPressed = arg1;
		if ( arg1 == "ESCAPE" ) then
			local key1, key2 = GetBindingKey(boUI_BindingBox.selected);
			SetBinding(key1);
			boUI_SetBinding(key1, nil, key1);
			boUI_BindingBox.selected = nil;
			boUI_BindingBox.buttonPressed:UnlockHighlight();
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
			if ( oldAction ~= "" and oldAction ~= boUI_BindingBox.selected ) then
				local key1, key2 = GetBindingKey(oldAction);
				if ( (not key1 or key1 == keyPressed) and (not key2 or key2 == keyPressed) ) then
					ErrorMessage(format(KEY_UNBOUND_ERROR, oldAction));
				end
			else
				ErrorMessage(KEY_BOUND);
			end
			local key1, key2 = GetBindingKey(boUI_BindingBox.selected);
			if ( key1 ) then
				SetBinding(key1);
			end
			if ( key2 ) then
				SetBinding(key2);
			end
			if ( boUI_BindingBox.keyID == 1 ) then
				boUI_SetBinding(keyPressed, boUI_BindingBox.selected, key1);
				if ( key2 ) then
					SetBinding(key2, boUI_BindingBox.selected);
				end
			end
			boUI_BindingBox.selected = nil;
			boUI_BindingBox.buttonPressed:UnlockHighlight();
			boUI_OnShow();
		end
	end
	
end

function boUI_SetBinding(key, selectedBinding, oldKey)
	if ( SetBinding(key, selectedBinding) ) then
		return;
	else
		if ( oldKey ) then
			SetBinding(oldKey, selectedBinding);
		end
		ErrorMessage("Can't bind mousewheel to actions with up and down states");
	end
end

function boUI_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "boUI_CheckEnable" ) then
		if ( checked ) then
			BagsOpen_Config.Enabled = true;
		else
			BagsOpen_Config.Enabled = false;
		end
	end
	
	if ( name == "boUI_CheckBagOne" ) then
		if ( checked ) then
			BagsOpen_Config.One = true;
		else
			BagsOpen_Config.One = false;
		end
	end
	
	if ( name == "boUI_CheckBagTwo" ) then
		if ( checked ) then
			BagsOpen_Config.Two = true;
		else
			BagsOpen_Config.Two = false;
		end
	end
	
	if ( name == "boUI_CheckBagThree" ) then
		if ( checked ) then
			BagsOpen_Config.Three = true;
		else
			BagsOpen_Config.Three = false;
		end
	end
	
	if ( name == "boUI_CheckBagFour" ) then
		if ( checked ) then
			BagsOpen_Config.Four = true;
		else
			BagsOpen_Config.Four = false;
		end
	end
	
	boUI_OnShow();
	
end