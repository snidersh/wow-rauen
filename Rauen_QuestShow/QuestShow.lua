-- Constants
QuestShow_ButtonTitle = "Show to Party";
QuestShow_Tooltip = "List quests in Party chat.";

function QuestShow_OnLoad()
	
	ChatMessage("Rauen's QuestShow Loaded.");
	
end

function QuestShow_Show()

	if ( GetNumPartyMembers() == 0 ) then
		ChatMessage("You are not in a party.");
		return;
	end
	
	local msg, header;
	local numEntries, numQuests = GetNumQuestLogEntries();
	ChannelMessage("My current quests are:", "PARTY");
	for i=1, numEntries, 1 do
		local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(i);
		if ( isHeader ) then
			header = questLogTitleText;
		else
			ChannelMessage(header..": "..questLogTitleText..".", "PARTY");
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