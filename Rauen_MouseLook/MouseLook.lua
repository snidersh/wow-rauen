BINDING_HEADER_MOUSELOOK = "Rauen's MouseLook";
BINDING_NAME_MOUSELOOK = "Toggle MouseLook";

MouseLook_Var = { };
MouseLook_Var.Locked = false;

function MouseLook_Toggle()
	if ( MouseLook_Var.Locked ) then
		TurnOrActionStop(arg1);
		MouseLook_Var.Locked = false;
		LookLockOn = nil;
	else
		TurnOrActionStart(arg1);
		MouseLook_Var.Locked = true;
		LookLockOn = 1;
	end
end

function MouseLook_OnLoad()

	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");

	ChatMessage("Rauen's MouseLook Loaded.");
	
end

function MouseLook_Reset()

	MouseLook_Config = { };
	MouseLook_Config.Enabled = true;
	MouseLook_Config.Version = MOUSELOOK_VERSION;
	
	ChatMessage("MouseLook configuration reset.");
	
end

function MouseLook_OnEvent()

	if ( event == "VARIABLES_LOADED") then
		if ( MouseLook_Config ) then
			if ( MouseLook_Config.Version ~= MOUSELOOK_VERSION ) then
				ChatMessage("MouseLook updated to v"..MOUSELOOK_VERSION..".");
				MouseLook_Reset();
			end
		else
			ChatMessage("MouseLook updated to v"..MOUSELOOK_VERSION..".");
			MouseLook_Reset();
		end
		return;
	end

end