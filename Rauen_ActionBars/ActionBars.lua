BINDING_HEADER_ACTIONBARS = "Rauen's ActionBars";

BINDING_NAME_BARACTION_1 = "Button 1";
BINDING_NAME_BARACTION_2 = "Button 2";
BINDING_NAME_BARACTION_3 = "Button 3";
BINDING_NAME_BARACTION_4 = "Button 4";
BINDING_NAME_BARACTION_5 = "Button 5";
BINDING_NAME_BARACTION_6 = "Button 6";
BINDING_NAME_BARACTION_7 = "Button 7";
BINDING_NAME_BARACTION_8 = "Button 8";
BINDING_NAME_BARACTION_9 = "Button 9";
BINDING_NAME_BARACTION_10 = "Button 10";
BINDING_NAME_BARACTION_11 = "Button 11";
BINDING_NAME_BARACTION_12 = "Button 12";

function Bars_OnLoad()

	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");

	-- Register Slash Commands
	SLASH_ACTIONBARS1 = "/actionbars";
	SLASH_ACTIONBARS2 = "/ab";
	SlashCmdList["ACTIONBARS"] = function(msg)
		Bars_ChatCommandHandler(msg);
	end
	
	ChatMessage("Rauen's ActionBars Loaded.");

end

function Bars_ChatCommandHandler(msg)

	-- Menu
	if ( abUI:IsVisible() ) then
		PlaySound("igMainMenuClose");
		HideUIPanel(abUI);
	else
		PlaySound("igMainMenuOpen");
		ShowUIPanel(abUI);
	end

end

function Bars_Reset()

	Bars_Config = { };
	Bars_Config.Enabled = true;
	Bars_Config.Version = ACTIONBARS_VERSION;
	Bars_Config.X = 0;
	Bars_Config.Y = -120;
	Bars_Config.Hidden = false;
	Bars_Config.NumButtons = 12;
	
	ChatMessage("ActionBars configuration reset.");
	
end

function Bars_OnEvent(event)

	-- Register Variables
	if ( event == "VARIABLES_LOADED" ) then
		if ( Bars_Config ) then
			if ( Bars_Config.Version ~= ACTIONBARS_VERSION ) then
				ChatMessage("ActionBars updated to v"..ACTIONBARS_VERSION..".");
				Bars_Reset();
			end
		else
			ChatMessage("ActionBars updated to v"..ACTIONBARS_VERSION..".");
			Bars_Reset();
		end
	
		-- Initialize Bars
		Bars_Update();
	
	end

end

function Bars_Update()
	if ( not Bars_Config.Enabled ) or ( Bars_Config.Hidden ) then
		Bars_Hide();
	else
		Bars_Draw();
	end
end

-- Hide Bar
function Bars_Hide()
	for toHide = 1 , 12 do
		getglobal( "BarButton"..toHide ):SetPoint( "TOPLEFT", "UIParent" , "BOTTOMRIGHT", 0, -60 );
	end
end

-- UnHide Buttons
function Bars_UnHideButtons(numButtons)
	for b = 2 , numButtons , 1 do
		Bars_UnHideButton( getglobal( "BarButton"..b ) , b );
	end
end

-- UnHide Button
function Bars_UnHideButton(button, index)
	button:SetPoint( "TOPLEFT", getglobal( "BarButton"..(index-1) ):GetName() , "BOTTOMLEFT", 0, -2 );	
end

-- Draw Bars
function Bars_Draw()
	numButtons = Bars_Config.NumButtons;
	Bars_Hide();
	Bars_SetTopEnd();
	Bars_UnHideButtons(numButtons);
end

-- Set Top
function Bars_SetTopEnd(side)
	getglobal( "BarButton1" ):SetPoint( "TOPLEFT", getglobal( "UIParent" ):GetName() , "TOPLEFT", 0, -120 );
end

-- ButtonDown
function Bars_ActionButtonDown(id)
	local button = getglobal( "BarButton"..id );
	if ( button:GetButtonState() == "NORMAL" ) then
		button:SetButtonState( "PUSHED" );
	end
end

-- ButtonUp
function Bars_ActionButtonUp(id)
	local button = getglobal( "BarButton"..id );
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