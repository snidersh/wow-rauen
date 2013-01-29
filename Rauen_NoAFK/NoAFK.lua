--  Configuration
NoAFK_Config = { };
NoAFK_Config.Enabled = false;

function NoAFK_OnLoad()

	-- Register for Events
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	
	-- Register Slash Commands
	SLASH_NOAFK1 = "/noafk";
	SlashCmdList["NOAFK"] = function(msg)
		NoAFK_ChatCommandHandler(msg);
	end
	
	ChatMessage("Rauen's NoAFK Loaded.");
	
end

function NoAFK_ChatCommandHandler(msg)
	
	-- Toggle NoAFK
	if ( NoAFK_Config.Enabled ) then
		NoAFK_Config.Enabled = false;
		ChatMessage("You will now go AFK when idle.");
	else
		NoAFK_Config.Enabled = true;
		ChatMessage("You will no longer go AFK when idle.");
	end

end

function NoAFK_OnEvent(event)

	local msg = arg1;

	if (event == "VARIABLES_LOADED") then
	
		RegisterForSave("NoAFK_Config");
		
	elseif ( event == "CHAT_MSG_SYSTEM") then
	
		if not ( NoAFK_Config.Enabled ) then
			return;
		end
		
		if ( string.sub(msg, 1, 15) == "You are now AFK" ) then
			ChatMessage("Trying to stand.");
			SitOrStand();
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