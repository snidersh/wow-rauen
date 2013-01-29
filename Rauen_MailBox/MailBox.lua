--  Configuration
MailBox_Config = { };
MailBox_Config.Enabled = true;

function MailBox_OnLoad()

	-- Register for Events
	this:RegisterEvent("VARIABLES_LOADED");
	
	-- Register Slash Commands
	SLASH_MAILBOX1 = "/mailbox";
	SLASH_MAILBOX2 = "/mb";
	SlashCmdList["MAILBOX"] = function(msg)
		MailBox_ChatCommandHandler(msg);
	end
	
	ChatMessage("Rauen's MailBox Loaded.");
	
end

function MailBox_ChatCommandHandler(msg)
	
	-- Print Help
	if ( msg == "help" ) or ( msg == "" ) then
		ChatMessage("Rauen's MailBox:");
		ChatMessage("/mailbox /mb <command>");
		ChatMessage("- help - Print this helplist.");
		ChatMessage("- on/off - Turn MailBox on or off.");
		ChatMessage("- status - MailBox status.");
		return;
	end
	
	-- Show Headers
	if ( msg == "show" ) then
		MailBox_ShowHeaders();
	end

end

function MailBox_OnEvent(event)

	if (event == "VARIABLES_LOADED") then
	
		RegisterForSave("MailBox_Config");
		
	end

end

function MailBox_ShowHeaders()

	local numItems = GetInboxNumItems();
	ChatMessage(numItems);
	local index = ((InboxFrame.pageNum - 1) * INBOXITEMS_TO_DISPLAY) + 1;
	local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, hasItem, wasRead;
	for i=1, INBOXITEMS_TO_DISPLAY do
		if ( index <= numItems ) then
			-- Setup mail item
			packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, hasItem, wasRead = GetInboxHeaderInfo(index);

			-- If no sender set it to "Unknown"
			if ( not sender ) then
				sender = UNKNOWN;
			end
			
			ChatMessage(sender..": "..subject);
		end
		index = index + 1;
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