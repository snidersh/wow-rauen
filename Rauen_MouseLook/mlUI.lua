function mlUI_OnLoad()

	-- Init
	tinsert(UISpecialFrames,"mlUI");
	this:SetHeight("185");
	this:SetWidth("400");

end

function mlUI_OnShow()

	local frame;
	local button;
	local text;
	
	-- Title
	text = getglobal("mlUI_TitleText");
	text:SetText("Rauen's MouseLook v"..MouseLook_Config.Version);
	frame = getglobal("mlUI_Title");
	frame:SetWidth(text:GetWidth()+250);
	
	-- MouseLook_Config.Enabled
	button = getglobal("mlUI_CheckEnable");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("mlUI_CheckEnableText");
	text:SetText("Enabled");
	button:SetChecked( MouseLook_Config.Enabled );
	
	-- Binding Panel
	text = getglobal("mlUI_BindingBoxTitle");
	text:SetText("KeyBinding");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if not ( MouseLook_Config.Enabled ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- KeyBinding
	label = getglobal("mlUI_KeyBindLabel");
	label:SetText("MouseLook");
	label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	button = getglobal("mlUI_KeyBindButton");
	button:Enable();
	if ( GetBindingKey("MOUSELOOK") ) then
		button:SetText(GetBindingKey("MOUSELOOK"));
		button:SetAlpha(1);
	else
		button:SetText(NORMAL_FONT_COLOR_CODE..NOT_BOUND..FONT_COLOR_CODE_CLOSE);
		button:SetAlpha(0.8);
	end
	button.command = "MOUSELOOK";
	button.desc = "MouseLook";
	if ( mlUI_BindingBox.selected == "MOUSELOOK" ) then
		button:LockHighlight();
	end
	if not ( MouseLook_Config.Enabled ) then
		button:Disable();
		label:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	if ( mlUI_BindingBox.selected ) then
		mlUI:EnableKeyboard(true);
	else
		mlUI:EnableKeyboard(false);
	end
	
	-- Defaults
	button = getglobal("mlUI_ResetKeysButton");
	button:Enable();
	if not ( MouseLook_Config.Enabled ) then
		button:Disable();
	end
	button = getglobal("mlUI_ResetButton");
	button:Enable();
	if not ( MouseLook_Config.Enabled ) then
		button:Disable();
	end

end

function mlUI_Close()
	PlaySound("igMainMenuClose");
	mlUI_BindingBox.selected = nil;
	SaveBindings();
	HideUIPanel(mlUI);
end

function mlUI_Reset()
	PlaySound("igMainMenuOptionCheckBoxOn");
	MouseLook_Reset();
	mlUI_OnShow();
end

function mlUI_ResetKeys()
	local key1, key2 = GetBindingKey("MOUSELOOK");
	if ( key1 ~= nil ) then
		SetBinding(key1, nil);
	end
	SaveBindings();
	mlUI_OnShow();
end

function mlUI_BindingButtonOnClick()
	if ( mlUI_BindingBox.selected ) then
		if ( button == "LeftButton" or button == "RightButton" ) then
			if (mlUIBindingBox.buttonPressed == this) then
				mlUI_BindingBox.selected = nil;
			else
				mlUI_BindingBox.buttonPressed = this;
				mlUI_BindingBox.selected = "MOUSELOOK";
				mlUI_BindingBox.keyID = 1;
				ErrorMessage(format(BIND_KEY_TO_COMMAND, "MouseLook"));
			end
			mlUI_OnShow();
			return;
		end
		mlUI_OnKeyDown(button);
	else
		if (mlUI_BindingBox.buttonPressed) then
			mlUI_BindingBox.buttonPressed:UnlockHighlight();
		end
		mlUI_BindingBox.buttonPressed = this;
		mlUI_BindingBox.selected = "MOUSELOOK";
		mlUI_BindingBox.keyID = 1;
		ErrorMessage(format(BIND_KEY_TO_COMMAND, "MouseLook"));
		mlUI_OnShow();
	end
end

function mlUI_OnKeyDown(button)

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
	
	if ( mlUI_BindingBox.selected ) then
		local keyPressed = arg1;
		if ( arg1 == "ESCAPE" ) then
			local key1, key2 = GetBindingKey(mlUI_BindingBox.selected);
			SetBinding(key1);
			mlUI_SetBinding(key1, nil, key1);
			mlUI_BindingBox.selected = nil;
			mlUI_BindingBox.buttonPressed:UnlockHighlight();
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
			if ( oldAction ~= "" and oldAction ~= mlUI_BindingBox.selected ) then
				local key1, key2 = GetBindingKey(oldAction);
				if ( (not key1 or key1 == keyPressed) and (not key2 or key2 == keyPressed) ) then
					ErrorMessage(format(KEY_UNBOUND_ERROR, oldAction));
				end
			else
				ErrorMessage(KEY_BOUND);
			end
			local key1, key2 = GetBindingKey(mlUI_BindingBox.selected);
			if ( key1 ) then
				SetBinding(key1);
			end
			if ( key2 ) then
				SetBinding(key2);
			end
			if ( mlUI_BindingBox.keyID == 1 ) then
				mlUI_SetBinding(keyPressed, mlUI_BindingBox.selected, key1);
				if ( key2 ) then
					SetBinding(key2, mlUI_BindingBox.selected);
				end
			end
			mlUI_BindingBox.selected = nil;
			mlUI_BindingBox.buttonPressed:UnlockHighlight();
			mlUI_OnShow();
		end
	end
	
end

function mlUI_SetBinding(key, selectedBinding, oldKey)
	if ( SetBinding(key, selectedBinding) ) then
		return;
	else
		if ( oldKey ) then
			SetBinding(oldKey, selectedBinding);
		end
		ErrorMessage("Can't bind mousewheel to actions with up and down states");
	end
end

function mlUI_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "mlUI_CheckEnable" ) then
		if ( checked ) then
			MouseLook_Config.Enabled = true;
		else
			MouseLook_Config.Enabled = false;
		end
	end
	
	mlUI_OnShow();
	
end