Clock_Var = { };
Clock_Var.PM = 0;
Clock_Var.AlarmSet = false;
Clock_Var.AlarmHour = 0;
Clock_Var.AlarmMinute = 0;
Clock_Var.AlarmMessage = "Alarm Message";

function Clock_OnLoad()

	-- Register for Events
	this:RegisterEvent("VARIABLES_LOADED");
	
	-- Register Slash Commands
	SLASH_CLOCK1 = "/clock";
	SlashCmdList["CLOCK"] = function(msg)
		Clock_ChatCommandHandler(msg);
	end
	
	-- Set Variables
	Frame_Clock.TimeSinceLastUpdate = 0;

	ChatMessage("Rauen's Clock Loaded.");
	
end

function Clock_ChatCommandHandler(msg)

	-- Menu
	if ( cUI:IsVisible() ) then
		PlaySound("igMainMenuClose");
		HideUIPanel(cUI);
	else
		PlaySound("igMainMenuOpen");
		ShowUIPanel(cUI);
	end
	
end

function Clock_OnEvent()

	if ( event == "VARIABLES_LOADED") then
		if ( Clock_Config ) then
			if ( Clock_Config.Version ~= CLOCK_VERSION ) then
				ChatMessage("Clock updated to v"..CLOCK_VERSION..".");
				Clock_Reset();
			end
		else
			ChatMessage("Clock updated to v"..CLOCK_VERSION..".");
			Clock_Reset();
		end
		local hour, minute = GetGameTime();
		if ( hour >= 12 ) then
			Clock_Var.PM =  1;
		else
			Clock_Var.PM = 0;
		end
		return;
	end

end

function Clock_Reset()

	Clock_Config = { };
	Clock_Config.Enabled = true;
	Clock_Config.Version = CLOCK_VERSION;
	
	Frame_Clock:Show();
	
	ChatMessage("Clock configuration reset.");
	
end

function Clock_ResetAlarm()
	Clock_Var = { };
	Clock_Var.PM = false;
	Clock_Var.AlarmSet = false;
	Clock_Var.AlarmHour = 0;
	Clock_Var.AlarmMinute = 0;
	Clock_Var.AlarmMessage = "Alarm Message";
	local hour, minute = GetGameTime();
	if ( hour >= 12 ) then
		Clock_Var.PM =  1;
	else
		Clock_Var.PM = 0;
	end
	if ( getglobal("cUI"):IsVisible() ) then
		cUI_OnShow();
	end
end

function Clock_OnUpdate(arg1)

	if ( Clock_Config.Enabled ) then
		local TimeText;
		Frame_Clock.TimeSinceLastUpdate = Frame_Clock.TimeSinceLastUpdate + arg1;
		if ( Frame_Clock.TimeSinceLastUpdate > 0.1 ) then
			TimeText = Lib.GetTimeText();
			ClockText:SetText( TimeText );
			Frame_Clock.TimeSinceLastUpdate = 0;
			if ( Clock_Var.AlarmSet ) then
				Clock_CheckAlarm();
			end
		end
	end
	
end

function Clock_CheckAlarm()

	local pm, hour, minute = Lib.GetTime();
	if ( Clock_Var.PM ~= pm ) then
		return;
	end
	if ( hour == Clock_Var.AlarmHour ) then
		if ( minute == Clock_Var.AlarmMinute ) then
			PlaySound("QUESTADDED");
			ChatMessage("[Alarm Clock] "..Clock_Var.AlarmMessage);
			ErrorMessage("[Alarm Clock]\n"..Clock_Var.AlarmMessage);
			Clock_ResetAlarm();
		end
	end

end
