--  Configuration
AutoDefend_Config = { };
AutoDefend_Config.Enabled = true;

-- Variables
AutoDefend_Var = { };
AutoDefend_Var.InCombat = false;

function AutoDefend_OnLoad()

	-- Register for Events
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_COMBAT");
	this:RegisterEvent("PLAYER_ENTER_COMBAT");
	this:RegisterEvent("PLAYER_LEAVE_COMBAT");

	-- Register Slash Commands
	SLASH_AUTODEFEND1 = "/autodefend";
	SLASH_AUTODEFEND2 = "/ad";
	SlashCmdList["AUTODEFEND"] = function(msg)
		AutoDefend_ChatCommandHandler(msg);
	end
	
	ChatMessage("Rauen's AutoDefend Loaded.");

end

function AutoDefend_ChatCommandHandler(msg)
	
	-- Print Help
	if ( msg == "help" ) or ( msg == "" ) then
		ChatMessage("Rauen's AutoDefend:");
		ChatMessage("/autodefend /ad <command>");
		ChatMessage("- help - Print this helplist.");
		ChatMessage("- on|off - Turn AutoDefend on or off.");
		ChatMessage("- status - Check current settings.");
		ChatMessage("- reset - Reset to default settings.");
		return;
	end
	
	-- Turn AutoDefend On
	if ( msg == "on" ) then
		AutoDefend_Config.Enabled = true;
		ChatMessage("AutoDefend is enabled.");
		return;
	end
	
	-- Turn AutoDefend Off
	if ( msg == "off" ) then
		AutoDefend_Config.Enabled = false;
		ChatMessage("AutoDefend is disabled.");
		return;
	end
	
	-- Check Status
	if ( msg == "status" ) then
		if not ( AutoDefend_Config.Enabled ) then
			ChatMessage("AutoDefend is disabled.");
		else
			ChatMessage("AutoDefend is enabled.");
		end
		return;
	end

	-- Reset Variables
	if ( msg == "reset" ) then
		AutoDefend_Config.Enabled = true;
		ChatMessage("AutoDefend configuration reset.");
		ChatMessage("AutoDefend is enabled.");
		return;
	end

end

function AutoDefend_OnEvent(event, arg1, arg2)

	-- Save Variables
	if ( event == "VARIABLES_LOADED") then
		RegisterForSave("AutoDefend_Config");
	end
	
	-- Check if Enabled
	if not ( AutoDefend_Config.Enabled ) then
		return;
	end
	
	if ( event == "PLAYER_ENTER_COMBAT" ) then
	
		-- Set Flag
		AutoDefend_Var.InCombat = true;
	
	elseif ( event == "PLAYER_LEAVE_COMBAT" ) then
	
		-- Remove Flag
		AutoDefend_Var.InCombat = false;

	elseif ( event == "UNIT_COMBAT" ) then

		-- Assign Variables
		local member = arg1;
		local damage = arg2;
		
		-- Check Event Type
		if not ( damage == "WOUND" ) then
			return;
		end

		-- Check Player
		if not ( member == "player" ) then
			return;
		end

		-- Check InCombat
		if ( AutoDefend_Var.InCombat ) then
			return;
		end
		
		-- Attack Target
		if ( UnitExists("target") ) then
			if ( UnitCanAttack("player", "target") ) and not ( UnitIsDead("target") ) then
				AttackTarget();
			end
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