--  Configuration
QuestNotes_Config = { };
QuestNotes_Config.Enabled = true;

function QuestNotes_OnLoad()

	-- Register for Events
	this:RegisterEvent("VARIABLES_LOADED");
	
	-- Register Slash Commands
	SLASH_QUESTNOTES1 = "/questnotes";
	SLASH_QUESTNOTES2 = "/qn";
	SlashCmdList["QUESTNOTES"] = function(msg)
		QuestNotes_ChatCommandHandler(msg);
	end
	
	ChatMessage("Rauen's QuestNotes Loaded.");
	
end

function QuestNotes_ChatCommandHandler(msg)
	
	-- Print Help
	if ( msg == "help" ) or ( msg == "" ) then
		ChatMessage("Rauen's QuestNotes:");
		ChatMessage("/questnotes /qn <command>");
		ChatMessage("- help - Print this helplist.");
		ChatMessage("- on|off - Turn QuestNotes on or off.");
		ChatMessage("- status - QuestNotes status.");
		return;
	end
	
	-- Turn QuestNotes On
	if ( msg == "on" ) then
		QuestNotes_Config.Enabled = true;
		ChatMessage("QuestNotes is enabled.");
		return;
	end
	
	-- Turn QuestNotes Off
	if ( msg == "off" ) then
		QuestNotes_Config.Enabled = false;
		ChatMessage("QuestNotes is disabled.");
		return;
	end
	
	-- Status
	if ( msg == "status" ) then
		if ( QuestNotes_Config.Enabled ) then
			ChatMessage("QuestNotes is Enabled.");
		else
			ChatMessage("QuestNotes is Disabled.");
		end
	end

end

-- Quest Frame Accept
Default_QuestDetailAcceptButton_OnClick = QuestDetailAcceptButton_OnClick;
function QuestDetailAcceptButton_OnClick()
	Default_QuestDetailAcceptButton_OnClick();
	if ( QuestNotes_Config.Enabled ) then
		QuestNotes_CreateNote( QuestFrameNpcNameText:GetText(), QuestTitleText:GetText() );
	end
end

-- Quest Frame Complete
Default_QuestRewardCompleteButton_OnClick = QuestRewardCompleteButton_OnClick;
function QuestRewardCompleteButton_OnClick()
	Default_QuestRewardCompleteButton_OnClick();
	if ( QuestNotes_Config.Enabled ) then
		QuestNotes_DeleteNote( QuestRewardTitleText:GetText()) ;
	end
end

-- QuestLog Frame Abandon
Default_SetAbandonQuest = SetAbandonQuest;
function SetAbandonQuest()
	Default_SetAbandonQuest();
	QuestNotes_DeleteNote( GetAbandonQuestName() );
end

-- Event Handling
function QuestNotes_OnEvent(event)
	if (event == "VARIABLES_LOADED") then
		RegisterForSave("QuestNotes_Config");
	end
end

-- Create a QuestNote
function QuestNotes_CreateNote(npc, quest)

	local continent, zone = MapNotes_GetZone();
	local x, y = GetPlayerMapPosition("player");
	local i = 0;
	i = table.getn(MapNotes_Data[continent][zone]);
	if not ( QuestNotes_FindNote(quest) ) then
		if (i < MapNotes_NotesPerZone) then
			MapNotes_TempData_Id = i + 1;
			MapNotes_Data[continent][zone][MapNotes_TempData_Id] = {};
			MapNotes_Data[continent][zone][MapNotes_TempData_Id].name = "Quest";
			MapNotes_Data[continent][zone][MapNotes_TempData_Id].ncol = 1;
			MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf1 = quest;
			MapNotes_Data[continent][zone][MapNotes_TempData_Id].in1c = 8;
			MapNotes_Data[continent][zone][MapNotes_TempData_Id].inf2 = npc;
			MapNotes_Data[continent][zone][MapNotes_TempData_Id].in2c = 9;
			MapNotes_Data[continent][zone][MapNotes_TempData_Id].creator = "QuestNotes";
			MapNotes_Data[continent][zone][MapNotes_TempData_Id].icon = 6;
			MapNotes_Data[continent][zone][MapNotes_TempData_Id].xPos = x;
			MapNotes_Data[continent][zone][MapNotes_TempData_Id].yPos = y;
			MapNotes_StatusPrint(format(MAPNOTES_QUICKNOTE_OK, MapNotes_ZoneNames[continent][zone]));
		else
			MapNotes_StatusPrint(format(MAPNOTES_QUICKNOTE_TOOMANY, MapNotes_ZoneNames[continent][zone]));
		end
	end
	
end

-- Delete a QuestNote
function QuestNotes_DeleteNote(quest)
	local id, continent, zone = QuestNotes_FindNote(quest);
	if ( id ) then
		local lastEntry = MapNotes_NewNoteSlot() - 1;
		MapNotes_DeleteLines(continent, zone, MapNotes_Data[continent][zone][id].xPos, MapNotes_Data[continent][zone][id].yPos);
		if ((lastEntry ~= 0) and (id <= lastEntry)) then
			MapNotes_Data[continent][zone][id].name = MapNotes_Data[continent][zone][lastEntry].name;
			MapNotes_Data[continent][zone][lastEntry].name = nil;
			MapNotes_Data[continent][zone][id].ncol = MapNotes_Data[continent][zone][lastEntry].ncol;
			MapNotes_Data[continent][zone][lastEntry].ncol = nil;
			MapNotes_Data[continent][zone][id].inf1 = MapNotes_Data[continent][zone][lastEntry].inf1;
			MapNotes_Data[continent][zone][lastEntry].inf1 = nil;
			MapNotes_Data[continent][zone][id].in1c = MapNotes_Data[continent][zone][lastEntry].in1c;
			MapNotes_Data[continent][zone][lastEntry].in1c = nil;
			MapNotes_Data[continent][zone][id].inf2 = MapNotes_Data[continent][zone][lastEntry].inf2;
			MapNotes_Data[continent][zone][lastEntry].inf2 = nil;
			MapNotes_Data[continent][zone][id].in2c = MapNotes_Data[continent][zone][lastEntry].in2c;
			MapNotes_Data[continent][zone][lastEntry].in2c = nil;
			MapNotes_Data[continent][zone][id].creator = MapNotes_Data[continent][zone][lastEntry].creator;
			MapNotes_Data[continent][zone][lastEntry].creator = nil;
			MapNotes_Data[continent][zone][id].icon = MapNotes_Data[continent][zone][lastEntry].icon;
			MapNotes_Data[continent][zone][lastEntry].icon = nil;
			MapNotes_Data[continent][zone][id].xPos = MapNotes_Data[continent][zone][lastEntry].xPos;
			MapNotes_Data[continent][zone][lastEntry].xPos = nil;
			MapNotes_Data[continent][zone][id].yPos = MapNotes_Data[continent][zone][lastEntry].yPos;
			MapNotes_Data[continent][zone][lastEntry].yPos = nil;
			MapNotes_Data[continent][zone][lastEntry] = nil;
		end
		if (continent == MapNotes_MiniNote_Data.continent and zone == MapNotes_MiniNote_Data.zone) then
			if (MapNotes_MiniNote_Data.id > id) then
				MapNotes_MiniNote_Data.id = id - 1;
			elseif (MapNotes_MiniNote_Data.id == id) then
				MapNotes_MiniNote_Data.id = 0;
			end
		end
		MapNotes_StatusPrint(format("Removed note on the map of |cFFFFD100%s|r.", MapNotes_ZoneNames[continent][zone]));
	end
end

-- Find a QuestNote
function QuestNotes_FindNote(quest)
	local i;
	for m=1, 2 do
		for n, value in MapNotes_Data[m] do
			i = 1;
			for j, value in MapNotes_Data[m][n] do
				if ( MapNotes_Data[m][n][i].inf1 == quest ) and ( MapNotes_Data[m][n][i].creator == "QuestNotes" ) then
					return i, m, n;
				end
				i = i + 1;
			end
		end
	end
	return false, false, false;
end

function QuestNotes_GetLevel(quest)
	local numEntries, numQuests = GetNumQuestLogEntries();
	for i=1, numEntries do
		local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete = GetQuestLogTitle(i);
		if ( questLogTitleText == quest ) then
			ChatMessage("["..level.."] "..questLotTitleText);
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