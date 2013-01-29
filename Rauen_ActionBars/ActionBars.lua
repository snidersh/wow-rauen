BINDING_HEADER_ACTIONBARS = "Rauen's ActionBars";

BINDING_NAME_BARACTION_LEFT1 = "Left Button 1";
BINDING_NAME_BARACTION_LEFT2 = "Left Button 2";
BINDING_NAME_BARACTION_LEFT3 = "Left Button 3";
BINDING_NAME_BARACTION_LEFT4 = "Left Button 4";
BINDING_NAME_BARACTION_LEFT5 = "Left Button 5";
BINDING_NAME_BARACTION_LEFT6 = "Left Button 6";
BINDING_NAME_BARACTION_LEFT7 = "Left Button 7";
BINDING_NAME_BARACTION_LEFT8 = "Left Button 8";
BINDING_NAME_BARACTION_LEFT9 = "Left Button 9";
BINDING_NAME_BARACTION_LEFT10 = "Left Button 10";
BINDING_NAME_BARACTION_LEFT11 = "Left Button 11";
BINDING_NAME_BARACTION_LEFT12 = "Left Button 12";

BINDING_NAME_BARACTION_RIGHT1 = "Right Button 1";
BINDING_NAME_BARACTION_RIGHT2 = "Right Button 2";
BINDING_NAME_BARACTION_RIGHT3 = "Right Button 3";
BINDING_NAME_BARACTION_RIGHT4 = "Right Button 4";
BINDING_NAME_BARACTION_RIGHT5 = "Right Button 5";
BINDING_NAME_BARACTION_RIGHT6 = "Right Button 6";
BINDING_NAME_BARACTION_RIGHT7 = "Right Button 7";
BINDING_NAME_BARACTION_RIGHT8 = "Right Button 8";
BINDING_NAME_BARACTION_RIGHT9 = "Right Button 9";
BINDING_NAME_BARACTION_RIGHT10 = "Right Button 10";
BINDING_NAME_BARACTION_RIGHT11 = "Right Button 11";
BINDING_NAME_BARACTION_RIGHT12 = "Right Button 12";

-- Configuration
Bars_Config = { };
Bars_Config.RightX = 0;
Bars_Config.RightY = -200;
Bars_Config.LeftHidden = false;
Bars_Config.NumRightButtons = 12;
Bars_Config.LeftX = 0;
Bars_Config.LeftY = -120;
Bars_Config.LeftHidden = false;
Bars_Config.NumLeftButtons = 12;
Bars_Config.MaxButtons = 12;

function Bars_OnLoad(side)

	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");

	-- Register Slash Commands
	if ( side == "Left" ) then
		SLASH_LEFTBAR1 = "/leftbar";
		SLASH_LEFTBAR2 = "/lb";
		SlashCmdList["LEFTBAR"] = function(msg)
			Bars_LeftChatCommandHandler(msg);
		end
	elseif ( side == "Right" ) then
		SLASH_RIGHTBAR1 = "/rightbar";
		SLASH_RIGHTBAR2 = "/rb";
		SlashCmdList["RIGHTBAR"] = function(msg)
			Bars_RightChatCommandHandler(msg);
		end
	end
	
	if ( side == "Right" ) then
		ChatMessage("Rauen's ActionBars Loaded.");
	end

end

function Bars_LeftChatCommandHandler(msg)

	-- Reset Configuration
	if ( msg == "reset" ) then
		Bars_Config.LeftHidden = false;
		Bars_Config.NumLeftButtons = 12;
		Bars_Config.LeftX = 0;
		Bars_Config.LeftY = -120;
		Bars_Draw("Left");
		ChatMessage("Left ActionBar Configuration Reset.");
		ChatMessage("Left ActionBar is at ("..Bars_Config.LeftX..", "..Bars_Config.LeftY..").");
	end
	
	-- Status
	if ( msg == "status" ) then
		if ( Bars_Config.LeftHidden ) then
			ChatMessage("Left Bar is Hidden.");
		else
			ChatMessage("Left ActionBar is at ("..Bars_Config.LeftX..", "..Bars_Config.LeftY..").");
		end
	end

	-- Set Buttons
	if ( string.sub(msg, 1, 7) == "buttons" ) then
		local numButtons;
		if not ( string.find( msg, "%d%d" ) == nil ) then
			numButtons = tonumber( string.sub( msg, string.find( msg, "%d%d" ) ) );
		elseif not ( string.find( msg, "%d" ) == nil ) then
			numButtons = tonumber( string.sub( msg, string.find( msg, "%d" ) ) );
		end
		if ( numButtons == 0 ) then
			Bars_Config.LeftHidden = true;
			Bars_Config.NumLeftButtons = 0;
		elseif ( numButtons > 0 ) and ( numButtons < 13 ) then
			Bars_Config.LeftHidden = false;
			Bars_Config.NumLeftButtons = numButtons;
		else
			ChatMessage("Please choose a number between 0 and 12.");
		end
		ChatMessage("Left Bar set to "..numButtons.." Buttons.");
		Bars_Draw("Left");
		return;
	end

	-- Set x-Position
	if ( string.sub(msg, 1, 1) == "x" ) then
		local newPos;
		if not ( string.find( msg, "%d%d%d" ) == nil ) then
			newPos = tonumber( string.sub( msg, string.find( msg, "%d%d%d" ) ) );
		elseif not ( string.find( msg, "%d%d" ) == nil ) then
			newPos = tonumber( string.sub( msg, string.find( msg, "%d%d" ) ) );
		elseif not ( string.find( msg, "%d" ) == nil ) then
			newPos = tonumber( string.sub( msg, string.find( msg, "%d" ) ) );
		end
		if not ( newPos == nil ) then
			Bars_Config.LeftX = newPos;
			Bars_Draw("Left");
			ChatMessage("Left Bar x-Position set to "..newPos..".");
		end
		return;
	end

	-- Set y-Position
	if ( string.sub(msg, 1, 1) == "y" ) then
		local newPos;
		if not ( string.find( msg, "%d%d%d" ) == nil ) then
			newPos = tonumber( string.sub( msg, string.find( msg, "%d%d%d" ) ) );
		elseif not ( string.find( msg, "%d%d" ) == nil ) then
			newPos = tonumber( string.sub( msg, string.find( msg, "%d%d" ) ) );
		elseif not ( string.find( msg, "%d" ) == nil ) then
			newPos = tonumber( string.sub( msg, string.find( msg, "%d" ) ) );
		end
		if not ( newPos == nil ) then
			Bars_Config.LeftY = -newPos;
			Bars_Draw("Left");
			ChatMessage("Left Bar y-Position set to "..newPos..".");
		end
		return;
	end

end

function Bars_RightChatCommandHandler(msg)

	-- Reset Configuration
	if ( msg == "reset" ) then
		Bars_Config.RightHidden = false;
		Bars_Config.NumRightButtons = 12;
		Bars_Config.LeftX = 0;
		Bars_Config.LeftY = -200;
		Bars_Draw("Right");
		ChatMessage("Right ActionBar Configuration Reset.");
		ChatMessage("Right ActionBar is at ("..Bars_Config.RightX..", "..Bars_Config.RightY..").");
	end

		-- Status
	if ( msg == "status" ) then
		if ( Bars_Config.LeftHidden ) then
			ChatMessage("Right ActionBar is Hidden.");
		else
			ChatMessage("Right ActionBar is at ("..Bars_Config.RightX..", "..Bars_Config.RightY..").");
		end
	end
	
	-- Set Buttons
	if ( string.sub(msg, 1, 7) == "buttons" ) then
		local numButtons;
		if not ( string.find( msg, "%d%d" ) == nil ) then
			numButtons = tonumber( string.sub( msg, string.find( msg, "%d%d" ) ) );
		elseif not ( string.find( msg, "%d" ) == nil ) then
			numButtons = tonumber( string.sub( msg, string.find( msg, "%d" ) ) );
		end
		if ( numButtons == 0 ) then
			Bars_Config.RightHidden = true;
			Bars_Config.NumRightButtons = 0;
		elseif ( numButtons > 0 ) and ( numButtons < 13 ) then
			Bars_Config.RightHidden = false;
			Bars_Config.NumRightButtons = numButtons;
		else
			ChatMessage("Please choose a number between 0 and 12.");
		end
		ChatMessage("Right Bar set to "..numButtons.." Buttons.");
		Bars_Draw("Right");
		return;
	end

	-- Set y-Position
	if ( string.sub(msg, 1, 1) == "x" ) then
		local newPos;
		if not ( string.find( msg, "%d%d%d" ) == nil ) then
			newPos = tonumber( string.sub( msg, string.find( msg, "%d%d%d" ) ) );
		elseif not ( string.find( msg, "%d%d" ) == nil ) then
			newPos = tonumber( string.sub( msg, string.find( msg, "%d%d" ) ) );
		elseif not ( string.find( msg, "%d" ) == nil ) then
			newPos = tonumber( string.sub( msg, string.find( msg, "%d" ) ) );
		end
		if not ( newPos == nil ) then
			Bars_Config.RightX = -newPos;
			Bars_Draw("Right");
			ChatMessage("Right Bar x-Position set to "..newPos..".");
		end
		return;
	end

	-- Set x-Position
	if ( string.sub(msg, 1, 1) == "y" ) then
		local newPos;
		if not ( string.find( msg, "%d%d%d" ) == nil ) then
			newPos = tonumber( string.sub( msg, string.find( msg, "%d%d%d" ) ) );
		elseif not ( string.find( msg, "%d%d" ) == nil ) then
			newPos = tonumber( string.sub( msg, string.find( msg, "%d%d" ) ) );
		elseif not ( string.find( msg, "%d" ) == nil ) then
			newPos = tonumber( string.sub( msg, string.find( msg, "%d" ) ) );
		end
		if not ( newPos == nil ) then
			Bars_Config.RightY = -newPos;
			Bars_Draw("Right");
			ChatMessage("Right Bar y-Position set to "..newPos..".");
		end
		return;
	end
	
end

function Bars_OnEvent(event, side)

	-- Register Variables
	if ( event == "VARIABLES_LOADED" ) then
		RegisterForSave("Bars_Config");
	end
	
	-- Initialize Bars
	if ( side == "Left" ) then
		if ( Bars_Config.LeftHidden ) then
			Bars_Hide("Left");
		else
			Bars_Draw("Left");
		end
	elseif ( side == "Right" ) then
		if ( Bars_Config.RightHidden ) then
			Bars_Hide("Right");
		else
			Bars_Draw("Right");
		end
	end

end

-- Hide Bar
function Bars_Hide(side)
	Bars_HideButton( side , getglobal( "Bar"..side.."Button"..1 ) );				
	for toHide = 2 , Bars_Config.MaxButtons , 1 do
		Bars_HideButton( "Left" , getglobal( "Bar"..side.."Button"..toHide ) );				
	end
end

-- Hide Buttons
function Bars_HideButton(side , button)
	if ( side == "Left" ) then
		button:SetPoint( "TOPLEFT", "UIParent" , "BOTTOMRIGHT", 0, -60 );
	elseif ( side == "Right" ) then
		button:SetPoint( "TOPRIGHT", "UIParent" , "BOTTOMLEFT", 0, -60 );	
	end
end

-- UnHide Buttons
function Bars_UnHideButtons(side , numButtons)
	for b = 2 , numButtons , 1 do
		Bars_UnHideButton( getglobal( "Bar"..side.."Button"..b ) , b , side );				
	end
end

-- UnHide Button
function Bars_UnHideButton(button, index , side)
	button:SetPoint( "TOPLEFT", getglobal( "Bar"..side.."Button"..(index-1) ):GetName() , "BOTTOMLEFT", 0, -2 );	
end

-- Draw Bars
function Bars_Draw(side)
	if ( side == "Right" ) then
		numButtons = Bars_Config.NumRightButtons;
	elseif ( side == "Left" ) then
		numButtons = Bars_Config.NumLeftButtons;
	end
	Bars_Hide( side );
	Bars_SetTopEnd( side );
	Bars_UnHideButtons( side , numButtons);
end

-- Set Top
function Bars_SetTopEnd(side)
	if ( side == "Left" ) then
		getglobal( "BarLeftButton1" ):SetPoint( "TOPLEFT", getglobal( "UIParent" ):GetName() , "TOPLEFT", Bars_Config.LeftX, Bars_Config.LeftY );
	elseif ( side == "Right" ) then
		getglobal( "BarRightButton1" ):SetPoint( "TOPRIGHT", getglobal("UIParent"):GetName() , "TOPRIGHT", Bars_Config.RightX, Bars_Config.RightY );
	end
end

-- ButtonDown
function Bars_ActionButtonDown(side , id)
	local button = getglobal( "Bar"..side.."Button"..id );
	if ( button:GetButtonState() == "NORMAL" ) then
		button:SetButtonState( "PUSHED" );
	end
end

-- ButtonUp
function Bars_ActionButtonUp(side , id)
	local button = getglobal( "Bar"..side.."Button"..id );
	if ( button:GetButtonState() == "PUSHED" ) then
		button:SetButtonState( "NORMAL" );
		-- Used to save a macro
		MacroFrame_EditMacro();
		UseAction( ActionButton_GetPagedID(button) );
		if ( IsCurrentAction( ActionButton_GetPagedID(button) ) ) then
			button:SetChecked(1);
		else
			button:SetChecked(0);
		end
	end
end

-- Send Message to Chat Frame
function ChatMessage(message)
	DEFAULT_CHAT_FRAME:AddMessage(message);
end

-- Send Message to Channel
function ChannelMessage(message, channel)
	SendChatMessage(message, channel);
end

-- Send Message to Error Frame
function ErrorMessage(message)
	UIErrorsFrame:AddMessage(message, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
end