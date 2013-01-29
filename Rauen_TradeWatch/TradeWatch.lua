-- Data
TradeWatch_Data = { };
TradeWatch_Data.NumFrames = 0;
TradeWatch_Data.ItemID = { };
TradeWatch_Data.ItemType = { };
TradeWatch_Data.ItemSpell = { };
TradeWatch_Data.ItemName = { };
TradeWatch_Data.ItemLevel = { };
TradeWatch_Data.NumReagents = { };
TradeWatch_Data.NumAvailable = { };

TradeWatch_Data.ReagentName = { };
TradeWatch_Data.ReagentName[1] = { };
TradeWatch_Data.ReagentName[2] = { };
TradeWatch_Data.ReagentName[3] = { };
TradeWatch_Data.ReagentName[4] = { };

TradeWatch_Data.ReagentNumBag = { };
TradeWatch_Data.ReagentNumBag[1] = { };
TradeWatch_Data.ReagentNumBag[1][1] = { };
TradeWatch_Data.ReagentNumBag[1][2] = { };
TradeWatch_Data.ReagentNumBag[1][3] = { };
TradeWatch_Data.ReagentNumBag[1][4] = { };
TradeWatch_Data.ReagentNumBag[2] = { };
TradeWatch_Data.ReagentNumBag[2][1] = { };
TradeWatch_Data.ReagentNumBag[2][2] = { };
TradeWatch_Data.ReagentNumBag[2][3] = { };
TradeWatch_Data.ReagentNumBag[2][4] = { };
TradeWatch_Data.ReagentNumBag[3] = { };
TradeWatch_Data.ReagentNumBag[3][1] = { };
TradeWatch_Data.ReagentNumBag[3][2] = { };
TradeWatch_Data.ReagentNumBag[3][3] = { };
TradeWatch_Data.ReagentNumBag[3][4] = { };
TradeWatch_Data.ReagentNumBag[4] = { };
TradeWatch_Data.ReagentNumBag[4][1] = { };
TradeWatch_Data.ReagentNumBag[4][2] = { };
TradeWatch_Data.ReagentNumBag[4][3] = { };
TradeWatch_Data.ReagentNumBag[4][4] = { };
TradeWatch_Data.ReagentNumBag[5] = { };
TradeWatch_Data.ReagentNumBag[5][1] = { };
TradeWatch_Data.ReagentNumBag[5][2] = { };
TradeWatch_Data.ReagentNumBag[5][3] = { };
TradeWatch_Data.ReagentNumBag[5][4] = { };

TradeWatch_Data.ReagentNum = { };
TradeWatch_Data.ReagentNum[1] = { };
TradeWatch_Data.ReagentNum[2] = { };
TradeWatch_Data.ReagentNum[3] = { };
TradeWatch_Data.ReagentNum[4] = { };

TradeWatch_Data.ReagentNumReq = { };
TradeWatch_Data.ReagentNumReq[1] = { };
TradeWatch_Data.ReagentNumReq[2] = { };
TradeWatch_Data.ReagentNumReq[3] = { };
TradeWatch_Data.ReagentNumReq[4] = { };

-- TradeSkills
TradeSkillSpellID = {
	["Alchemy"] = 0,
	["Blacksmithing"] = 0,
	["Cooking"] = 0,
	["Enchanting"] = 0,
	["Engineering"] = 0;
	["First Aid"] = 0,
	["Leatherworking"] = 0,
	["Smelting"] = 0,
	["Poisons"] = 0,
	["Tailoring"] = 0
}

-- Colors
TradeSkillTypeColor = { };
TradeSkillTypeColor["optimal"]	= { r = 1.00, g = 0.50, b = 0.25 };
TradeSkillTypeColor["medium"]	= { r = 1.00, g = 1.00, b = 0.00 };
TradeSkillTypeColor["easy"]		= { r = 0.25, g = 0.75, b = 0.25 };
TradeSkillTypeColor["trivial"]	= { r = 0.50, g = 0.50, b = 0.50 };

-- Variables
TradeWatch_Var = { };
TradeWatch_Var.Player = "";

-- Constants
MAX_REAGENTS = 10;
CUSTOM_REAGENTS_TEXT = "WatchList";

function TradeWatch_OnLoad()

	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("TRADE_SKILL_CLOSE");
	this:RegisterEvent("CRAFT_CLOSE");
	
	-- Register Slash Commands
	SLASH_TRADEWATCH1 = "/tradewatch";
	SLASH_TRADEWATCH2 = "/tw";
	SlashCmdList["TRADEWATCH"] = function(msg)
		TradeWatch_ChatCommandHandler(msg);
	end
	
	-- Initialize TradeWatch
	TradeWatch_ResetFrames();
	TradeWatch_GetSpells();
	
	-- Expand Error Frame
	UIErrorsFrame:SetHeight(70);
	
	ChatMessage("Rauen's TradeWatch Loaded.");
	
end

function TradeWatch_ChatCommandHandler(msg)

	-- Menu
	if ( msg == "" ) then
		if ( twUI:IsVisible() ) then
			PlaySound("igMainMenuClose");
			HideUIPanel(twUI);
		else
			PlaySound("igMainMenuOpen");
			ShowUIPanel(twUI);
		end
		return;
	end
	
	-- Update
	if ( msg == "update" ) then
		TradeWatch_Update();
		ChatMessage("TradeWatch updated.");
		return;
	end
	
	-- Count
	if ( msg == "count" ) then
		for bag=1, 5 do
			TradeWatch_CountReagents(bag, false);
		end
		TradeWatch_CountNumAvailable();
		TradeWatch_Update();
		ChatMessage("TradeWatch reagents counted.");
		return;
	end
	
	-- Add Custom Reagents
	if ( string.sub (msg, 1, 3) == "add" ) then
	
		local reagent = TradeWatch_ParseReagent(msg, "add");
		
		local numRequired = 0;
		if not ( string.find( msg, " %d%d" ) == nil ) then
			numRequired = tonumber( string.sub( msg, string.find( msg, " %d%d" ) ) );
		elseif not ( string.find( msg, " %d" ) == nil ) then
			numRequired = tonumber( string.sub( msg, string.find( msg, " %d" ) ) );
		end
		
		if ( reagent == "" ) then
			return;
		end
	
		-- Find a Frame
		local frame = -1;
		for f=1, 4 do
			if ( TradeWatch_Data.ItemName[f] == CUSTOM_REAGENTS_TEXT ) then
				frame = f;
			end
		end
		if ( frame == -1 ) then
			-- Add Frame
			frame = TradeWatch_GetFrame();
			if ( frame == 0 ) then
				return;
			end
			TradeWatch_ClearFrame(frame);
			TradeWatch_Data.NumFrames = TradeWatch_Data.NumFrames + 1;
			TradeWatch_Data.ItemName[frame] = CUSTOM_REAGENTS_TEXT;
			TradeWatch_Data.ItemID[frame] = 0;
			TradeWatch_Data.ItemType[frame] = "";
			TradeWatch_Data.ItemSpell[frame] = "";
			TradeWatch_Data.ItemLevel[frame] = "";
			TradeWatch_Data.NumAvailable[frame] = 0;
			TradeWatch_Data.NumReagents[frame] = 0;
		end
		-- Add Reagent
		if ( TradeWatch_Data.NumReagents[frame] == MAX_REAGENTS ) then
			UIErrorsFrame:AddMessage("You may only watch "..MAX_REAGENTS.." custom items.", 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
			return;
		end
		TradeWatch_Data.NumReagents[frame] = TradeWatch_Data.NumReagents[frame] + 1;
		TradeWatch_Data.ReagentName[frame][TradeWatch_Data.NumReagents[frame]] = reagent;
		for bag=1, 5 do
			TradeWatch_Data.ReagentNumBag[bag][frame][TradeWatch_Data.NumReagents[frame]] = 0;
		end
		TradeWatch_Data.ReagentNum[frame][TradeWatch_Data.NumReagents[frame]] = 0;
		TradeWatch_Data.ReagentNumReq[frame][TradeWatch_Data.NumReagents[frame]] = numRequired;
		
		for bag=1, 5 do
			TradeWatch_CountReagents(bag, false);
		end
		ChatMessage("Added "..reagent.." to "..CUSTOM_REAGENTS_TEXT..".");
		TradeWatch_Update();
		return;
		
	end
	
	-- Remove Custom Reagents
	if ( string.sub (msg, 1, 6) == "remove" ) then
	
		local reagent = TradeWatch_ParseReagent(msg, "remove");
		if ( reagent == "" ) then
			return;
		end
		
		-- Find a Frame
		local frame = -1;
		for f=1, 4 do
			if ( TradeWatch_Data.ItemName[f] == CUSTOM_REAGENTS_TEXT ) then
				frame = f;
			end
		end
		if ( frame == -1 ) then
			return;
		end
		-- Find Reagent
		for i=1, TradeWatch_Data.NumReagents[frame] do
			if ( TradeWatch_Data.ReagentName[frame][i] == reagent ) then
				TradeWatch_Data.NumReagents[frame] = TradeWatch_Data.NumReagents[frame] - 1;
				TradeWatch_Data.ReagentName[frame][i] = "";
				for bag=1, 5 do
					TradeWatch_Data.ReagentNumBag[bag][frame][i] = 0;
				end
				TradeWatch_Data.ReagentNum[frame][i] = 0;
				TradeWatch_Data.ReagentNumReq[frame][i] = 0;
			end
		end
		if ( TradeWatch_Data.NumReagents[frame] == 0 ) then
			TradeWatch_ClearFrame(frame);
		else
			TradeWatch_OrderReagents(frame);
		end
		ChatMessage("Removed "..reagent.." from "..CUSTOM_REAGENTS_TEXT..".");
		TradeWatch_Update();
		return;
		
	end
	
	if ( msg == "clear" ) then
		-- Find Custom Frame
		local frame = -1;
		for f=1, 4 do
			if ( TradeWatch_Data.ItemName[f] == CUSTOM_REAGENTS_TEXT ) then
				frame = f;
			end
		end
		if ( frame == -1 ) then
			return;
		end
		TradeWatch_Data.NumFrames = TradeWatch_Data.NumFrames - 1;
		TradeWatch_ClearFrame(frame);
		TradeWatch_Update();
		return;
	end
	
end

function TradeWatch_Reset()
	
	TradeWatch_ResetFrames();
	TradeWatch_Config = { };
	TradeWatch_Config.Enabled = true;
	TradeWatch_Config.Version = TRADEWATCH_VERSION;
	TradeWatch_Config.Color = true;
	TradeWatch_Config.Num = true;
	TradeWatch_Update();
	
	ChatMessage("TradeWatch configuration reset");
	
end

function TradeWatch_ResetFrames()
	for f=1, 4 do
		TradeWatch_ClearFrame(f);
	end
	TradeWatch_Data.NumFrames = 0;
end

-- Clear the Current Watchlist
function TradeWatch_ClearFrame(frame)
	TradeWatch_Data.ItemID[frame] = 0;
	TradeWatch_Data.ItemType[frame] = "";
	TradeWatch_Data.ItemSpell[frame] = "";
	TradeWatch_Data.ItemName[frame] = "";
	TradeWatch_Data.ItemLevel[frame] = "";
	TradeWatch_Data.NumReagents[frame] = 0;
	for i=1, MAX_REAGENTS do
		TradeWatch_Data.ReagentName[frame][i] = "";
		for bag=1, 5 do
			TradeWatch_Data.ReagentNumBag[bag][frame][i] = 0;
		end
		TradeWatch_Data.ReagentNum[frame][i] = 0;
		TradeWatch_Data.ReagentNumReq[frame][i] = 0;
	end
	getglobal("Frame_TradeWatchCheck_Trades"..frame):Hide();
	getglobal("Frame_TradeWatchCheck_Crafts"..frame):Hide();
end

function TradeWatch_OnEvent(event) 

	if ( event == "VARIABLES_LOADED") then
		if ( TradeWatch_Config ) then
			if ( TradeWatch_Config.Version ~= TRADEWATCH_VERSION ) then
				ChatMessage("TradeWatch updated to v"..TRADEWATCH_VERSION..".");
				TradeWatch_Reset();
			end
		else
			ChatMessage("TradeWatch updated to v"..TRADEWATCH_VERSION..".");
			TradeWatch_Reset();
		end
		return;
	end
	
	if ( event == "UNIT_NAME_UPDATE" ) then
		if not ( UnitName("player" ) == "Unknown Entity" ) then
			if ( TradeWatch_Var.Player == "" ) then
				if ( UnitName("player") ) then
					TradeWatch_Var.Player = UnitName("player");
					CUSTOM_REAGENTS_TEXT = UnitName("player").."'s "..CUSTOM_REAGENTS_TEXT;
				end
			end
		end
	end
	
	if ( event == "BAG_UPDATE" ) then
		if ( TradeWatch_Data.NumFrames > 0 ) then
			local bag = arg1 + 1;
			if ( bag < 1 ) or ( bag > 5 ) then
				return;
			end
			TradeWatch_CountReagents(bag, true);
			TradeWatch_CountNumAvailable();
			TradeWatch_Update();
		end
	end
	
	if ( event == "TRADE_SKILL_CLOSE" ) or
	  ( event == "CRAFT_CLOSE" ) then
		if ( TradeWatch_Data.NumFrames > 0 ) then
			TradeWatch_Update();
		end
	end
	
end

function TradeWatch_OnClick(id)
	
	if not ( TradeWatch_Data.ItemName[id] == CUSTOM_REAGENTS_TEXT ) then
		local spellID = TradeSkillSpellID[TradeWatch_Data.ItemSpell[id]];
		if ( spellID > 0 ) then
			CastSpell(spellID, SpellBookFrame.bookType);
		else
			TradeWatch_GetSpells();
			return;
		end
		CloseTradeSkill();
		CloseCraft();
	
		skillIndex = TradeWatch_Data.ItemID[id];
		local skillName, skillType, numAvailable = GetTradeSkillInfo(skillIndex);
		if ( TradeWatch_Data.ItemName[id] == skillName ) then
			if ( TradeWatch_Data.ItemType[id] == "craft" ) then
				DoCraft(skillIndex);
			else
				DoTradeSkill(skillIndex, 1);
			end
		else
			UIErrorsFrame:AddMessage("Please open and close your trade or craft menu.", 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
		end
	end
	
end

-- Hook QuestWatch_Update
Default_QuestWatch_Update = QuestWatch_Update;
function QuestWatch_Update()
	Default_QuestWatch_Update();
	TradeWatch_Update();
end

-- Hook TradeSkillFrame_Update
Default_TradeSkillFrame_Update = TradeSkillFrame_Update;
function TradeSkillFrame_Update()
	Default_TradeSkillFrame_Update();
	
	local numSkills, skillName, skillType, numAvailable;
	local SkillID = -1;
	local checkFrame = 0;

	numSkills = GetNumTradeSkills();
	local skillOffset, skillIndex;
	
	local tradeCheck;
	
	for i=1, 4 do
		tradeCheck = getglobal("Frame_TradeWatchCheck_Trades"..i);
		tradeCheck:Hide();
	end
	
	for f=1, TradeWatch_Data.NumFrames do
	
		for i=1, 8 do
			skillOffset = FauxScrollFrame_GetOffset(TradeSkillListScrollFrame);
			skillIndex = i + skillOffset;
			skillName = GetTradeSkillInfo(skillIndex);
			if ( skillName == TradeWatch_Data.ItemName[f] ) then
				SkillID = i;
				checkFrame = f;
			end
		end
	
		if ( SkillID > -1 ) and ( checkFrame > 0 ) then
			tradeCheck = getglobal("Frame_TradeWatchCheck_Trades"..checkFrame);
			tradeCheck:SetPoint("LEFT", "TradeSkillSkill"..SkillID, "LEFT", 5, 0);
			tradeCheck:Show();
		end
	
	end
	
end

-- Hook TradeSkillSkillButton_OnClick
Default_TradeSkillSkillButton_OnClick = TradeSkillSkillButton_OnClick;
function TradeSkillSkillButton_OnClick(button)
	if ( button == "LeftButton" ) then
		
		local skillIndex = this:GetID();
		
		if ( IsShiftKeyDown() ) then
		
			if ( ChatFrameEditBox:IsVisible() ) then
				ChatFrameEditBox:Insert(gsub(this:GetText(), " *(.*)", "%1"));
				return;
			end
			
			local skillName, skillType, numAvailable;
			skillName, skillType, numAvailable = GetTradeSkillInfo(skillIndex);
			
			if ( skillType ~= "header" ) then
			
				for f=1, TradeWatch_Data.NumFrames do
					if ( TradeWatch_Data.ItemName[f] == skillName ) then
						TradeWatch_ClearFrame(f);
						TradeWatch_Data.NumFrames = TradeWatch_Data.NumFrames - 1;
						if ( TradeWatch_Data.NumFrames < 0 ) then
							TradeWatch_Data.NumFrames = 0;
						end
						TradeWatch_OrderFrames();
						TradeWatch_Update();
						return;
					end
				end
				
				if ( TradeWatch_Data.NumFrames == 4 ) then
					UIErrorsFrame:AddMessage("You may only watch four trade items at a time.", 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
					return;
				end
				
				-- Find Available Frame
				local frame = TradeWatch_GetFrame();
				if ( frame == 0 ) then
					return;
				end
				
				TradeWatch_ClearFrame(frame);
				TradeWatch_Data.NumFrames = TradeWatch_Data.NumFrames + 1;
				
				TradeWatch_Data.ItemID[frame] = skillIndex;
				TradeWatch_Data.ItemType[frame] = "trade";
				TradeWatch_Data.ItemSpell[frame] = TradeSkillFrameTitleText:GetText();
				if ( TradeWatch_Data.ItemSpell[frame] == "Mining" ) then
					TradeWatch_Data.ItemSpell[frame] = "Smelting";
				end
				TradeWatch_Data.ItemName[frame] = skillName;
				TradeWatch_Data.ItemLevel[frame] = skillType;
				TradeWatch_Data.NumAvailable[frame] = numAvailable;
		
				TradeWatch_Data.NumReagents[frame] = GetTradeSkillNumReagents(skillIndex);
				local reagentName, reagentTexture, reagentCount, playerReagentCount;
				for i=1, TradeWatch_Data.NumReagents[frame] do
					reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(skillIndex, i);
					TradeWatch_Data.ReagentName[frame][i] = reagentName;
					for bag=1, 5 do
						TradeWatch_Data.ReagentNumBag[bag][frame][i] = 0;
					end
					TradeWatch_Data.ReagentNum[frame][i] = playerReagentCount;
					TradeWatch_Data.ReagentNumReq[frame][i] = reagentCount;
				end
				for bag=1, 5 do
					TradeWatch_CountReagents(bag, false);
				end

			end
				
		end

		TradeWatch_OrderFrames();
		TradeWatch_Update();
		
		TradeSkillFrame_SetSelection(skillIndex);
		TradeSkillFrame_Update();
		
	end
end

-- Hook CraftFrame_Update
Default_CraftFrame_Update = CraftFrame_Update;
function CraftFrame_Update()
	Default_CraftFrame_Update();
	
	local numSkills, skillName, skillType, numAvailable;
	local SkillID = -1;
	local checkFrame = 0;

	numSkills = GetNumCrafts();
	local skillOffset, skillIndex;
	
	local tradeCheck;
	
	for i=1, 4 do
		tradeCheck = getglobal("Frame_TradeWatchCheck_Crafts"..i);
		tradeCheck:Hide();
	end
	
		for f=1, TradeWatch_Data.NumFrames do

		for i=1, 8 do
		
			skillOffset = FauxScrollFrame_GetOffset(CraftListScrollFrame);
			skillIndex = i + skillOffset;
			skillName = GetCraftInfo(skillIndex);
			if ( skillName == TradeWatch_Data.ItemName[f] ) then
				SkillID = i;
				checkFrame = f;
			end
		
		end
		
		if ( SkillID > -1 ) and ( checkFrame > 0 ) then
			tradeCheck = getglobal("Frame_TradeWatchCheck_Crafts"..checkFrame);
			tradeCheck:SetPoint("LEFT", "Craft"..SkillID, "LEFT", -5, 0);
			tradeCheck:Show();
		end
	
	end
	
end

-- Hook CraftButton_OnClick
Default_CraftButton_OnClick = CraftButton_OnClick;
function CraftButton_OnClick(button)
	if ( button == "LeftButton" ) then
		
		local skillIndex = this:GetID();
		
		if ( IsShiftKeyDown() ) then
		
			if ( ChatFrameEditBox:IsVisible() ) then
				ChatFrameEditBox:Insert(gsub(this:GetText(), " *(.*)", "%1"));
				return;
			end
			
			local skillName, skillType, numAvailable;
			skillName, _, skillType, numAvailable = GetCraftInfo(skillIndex);
			
			if ( skillType ~= "header" ) then
			
				for f=1, TradeWatch_Data.NumFrames do
					if ( TradeWatch_Data.ItemName[f] == skillName ) then
						TradeWatch_ClearFrame(f);
						TradeWatch_Data.NumFrames = TradeWatch_Data.NumFrames - 1;
						if ( TradeWatch_Data.NumFrames < 0 ) then
							TradeWatch_Data.NumFrames = 0;
						end
						TradeWatch_OrderFrames();
						TradeWatch_Update();
						return;
					end
				end
				
				if ( TradeWatch_Data.NumFrames == 4 ) then
					UIErrorsFrame:AddMessage("You may only watch four trade items at a time.", 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME);
					return;
				end
				
				-- Find Available Frame
				local frame = TradeWatch_GetFrame();
				if ( frame == 0 ) then
					return;
				end
				
				TradeWatch_ClearFrame(frame);
				TradeWatch_Data.NumFrames = TradeWatch_Data.NumFrames + 1;
				
				TradeWatch_Data.ItemID[frame] = skillIndex;
				TradeWatch_Data.ItemType[frame] = "craft";
				TradeWatch_Data.ItemSpell[frame] = CraftFrameTitleText:GetText();
				TradeWatch_Data.ItemName[frame] = skillName;
				TradeWatch_Data.ItemLevel[frame] = skillType;
				TradeWatch_Data.NumAvailable[frame] = numAvailable;
		
				TradeWatch_Data.NumReagents[frame] = GetCraftNumReagents(skillIndex);
				local reagentName, reagentTexture, reagentCount, playerReagentCount;
				for i=1, TradeWatch_Data.NumReagents[frame] do
					reagentName, reagentTexture, reagentCount, playerReagentCount = GetCraftReagentInfo(skillIndex, i);
					TradeWatch_Data.ReagentName[frame][i] = reagentName;
					for bag=1, 5 do
						TradeWatch_Data.ReagentNumbag[bag][frame][i] = 0;
					end
					TradeWatch_Data.ReagentNum[frame][i] = playerReagentCount;
					TradeWatch_Data.ReagentNumReq[frame][i] = reagentCount;
				end
				for bag=1, 5 do
					TradeWatch_CountReagents(bag, false);
				end

			end
				
		end
		
		TradeWatch_OrderFrames();
		TradeWatch_Update();
		
		CraftFrame_SetSelection(this:GetID());
		CraftFrame_Update();
		
	end
end

-- Update
function TradeWatch_Update()
	
	if ( TradeWatch_Data.NumFrames == 0 ) then
		Frame_TradeWatch:Hide();
		return;
	end
	
	for f=1, 4 do
	
		--if ( f > TradeWatch_Data.NumFrames ) then
		if ( TradeWatch_Data.ItemName[f] == "" ) then
		
			getglobal("TradeWatchItemName"..f):Hide();
			getglobal("TradeWatchButton"..f):Hide();
			for i=1, MAX_REAGENTS do
				getglobal("TradeWatchLine"..f..i):Hide();
			end
		
		else
		
			local tempWidth;
			local watchText;
			local tradeWatchMaxWidth = 0;

			watchText = getglobal("TradeWatchItemName"..f);
			if ( TradeWatch_Config.Num ) and ( TradeWatch_Data.NumAvailable[f] > 0 ) and not ( TradeWatch_Data.ItemName[f] == CUSTOM_REAGENTS_TEXT ) then
				watchText:SetText("["..TradeWatch_Data.NumAvailable[f].."] "..TradeWatch_Data.ItemName[f]);
				getglobal("TradeWatchButton"..f):SetPoint("LEFT", "TradeWatchItemName"..f, "LEFT", 0, 0);
				getglobal("TradeWatchButton"..f):Show();
			else
				watchText:SetText(TradeWatch_Data.ItemName[f]);
				getglobal("TradeWatchButton"..f):Hide();
			end
			
			tempWidth = watchText:GetWidth();
	
			local questIndex;
			local questText;
			local QuestLines = GetNumQuestWatches();
			for i = 1, GetNumQuestWatches() do
				questIndex = GetQuestIndexForWatch(i);
				QuestLines = QuestLines + GetNumQuestLeaderBoards(questIndex);
			end
			if ( f == 1 ) then
				if ( QuestLines > 0 ) then
					watchText:SetPoint("TOPLEFT", "QuestWatchLine"..QuestLines, "BOTTOMLEFT", 0, -12);
				else
					QuestWatchFrame:SetWidth(0);
					watchText:SetPoint("TOPLEFT", "QuestWatchFrame", "TOPLEFT", 0, -12);
					for i=1, 30 do
						questText = getglobal("QuestWatchLine"..i);
						questText:Hide();
					end
				end
			else
				if ( TradeWatch_Data.ItemName[f] == CUSTOM_REAGENTS_TEXT ) then
					watchText:SetPoint("TOPLEFT", "TradeWatchLine"..(f-1)..TradeWatch_Data.NumReagents[f-1], "BOTTOMLEFT", 0, -12);
				else
					watchText:SetPoint("TOPLEFT", "TradeWatchLine"..(f-1)..TradeWatch_Data.NumReagents[f-1], "BOTTOMLEFT", 0, -4);
				end
			end
			watchText:Show();
	
			local ReagentsCompleted = 0;
			for i=1, TradeWatch_Data.NumReagents[f] do
	
				if ( TradeWatch_Data.ReagentName[f][i] == nil ) or
				( TradeWatch_Data.ReagentNum[f][i] == nil ) or
				( TradeWatch_Data.ReagentNumReq[f][i] == nil ) then
					return;
				end
	
				watchText = getglobal("TradeWatchLine"..f..i);
				--if ( TradeWatch_Data.ItemName[f] == CUSTOM_REAGENTS_TEXT ) then
				if ( TradeWatch_Data.ReagentNumReq[f][i] == 0 ) then
					watchText:SetText(" - "..TradeWatch_Data.ReagentName[f][i]..": "..TradeWatch_Data.ReagentNum[f][i]);
				else
					watchText:SetText(" - "..TradeWatch_Data.ReagentName[f][i]..": "..TradeWatch_Data.ReagentNum[f][i].."/"..TradeWatch_Data.ReagentNumReq[f][i]);
				end
				if ( watchText:GetWidth() > tempWidth ) then
					tempWidth = watchText:GetWidth();
				end
				watchText:Show();
				if ( TradeWatch_Data.ItemName[f] == CUSTOM_REAGENTS_TEXT ) then
					if ( TradeWatch_Data.ReagentNum[f][i] > 0 ) then
						watchText:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
					else
						watchText:SetTextColor(0.8, 0.8, 0.8);
					end
				else
					if ( TradeWatch_Data.ReagentNum[f][i] >= TradeWatch_Data.ReagentNumReq[f][i] ) then
						watchText:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
						ReagentsCompleted = ReagentsCompleted + 1;
					else
						watchText:SetTextColor(0.8, 0.8, 0.8);
					end
				end
			end
	
			watchText = getglobal("TradeWatchItemName"..f);
			if ( TradeWatch_Data.ItemName[f] == CUSTOM_REAGENTS_TEXT ) then
				watchText:SetTextColor(0.5, 0.5, 1.0);
			else
				if ( TradeWatch_Config.Color ) then
					local color = TradeSkillTypeColor[TradeWatch_Data.ItemLevel[f]];
					if ( color ) then
						watchText:SetTextColor(color.r, color.g, color.b);
					end
				else
					if ( ReagentsCompleted == TradeWatch_Data.NumReagents[f]) then
						watchText:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
					else
						watchText:SetTextColor(0.75, 0.61, 0);
					end
				end
			end
	
			for i=1, MAX_REAGENTS do
				if ( i > TradeWatch_Data.NumReagents[f] ) then
					getglobal("TradeWatchLine"..f..i):Hide();
				else
					getglobal("TradeWatchLine"..f..i):Show();
				end
			end
	
			if ( tempWidth > tradeWatchMaxWidth ) then
				tradeWatchMaxWidth = tempWidth;
			end
	
			Frame_TradeWatch:Show();
			Frame_TradeWatch:SetHeight(TradeWatch_Data.NumReagents[f] * 13);
			Frame_TradeWatch:SetWidth(tradeWatchMaxWidth + 15);
			QuestWatchFrame:Show();
			if ( QuestWatchFrame:GetWidth() < tradeWatchMaxWidth + 15 ) then
				QuestWatchFrame:SetWidth(tradeWatchMaxWidth + 15);
			end
			
		end
	
	end
	
	UIParent_ManageRightSideFrames();
	
end

-- Clean Up and Order Frames
function TradeWatch_OrderFrames()

	--Temp Variables
	local ItemID = { };
	local ItemType = { };
	local ItemSpell = { };
	local ItemName = { };
	local ItemLevel = { };
	local NumReagents = { };

	local ReagentName = { };
	ReagentName[1] = { };
	ReagentName[2] = { };
	ReagentName[3] = { };
	ReagentName[4] = { };

	local ReagentNumBag = { };
	ReagentNumBag[1] = { };
	ReagentNumBag[1][1] = { };
	ReagentNumBag[1][2] = { };
	ReagentNumBag[1][3] = { };
	ReagentNumBag[1][4] = { };
	ReagentNumBag[2] = { };
	ReagentNumBag[2][1] = { };
	ReagentNumBag[2][2] = { };
	ReagentNumBag[2][3] = { };
	ReagentNumBag[2][4] = { };
	ReagentNumBag[3] = { };
	ReagentNumBag[3][1] = { };
	ReagentNumBag[3][2] = { };
	ReagentNumBag[3][3] = { };
	ReagentNumBag[3][4] = { };
	ReagentNumBag[4] = { };
	ReagentNumBag[4][1] = { };
	ReagentNumBag[4][2] = { };
	ReagentNumBag[4][3] = { };
	ReagentNumBag[4][4] = { };
	ReagentNumBag[5] = { };
	ReagentNumBag[5][1] = { };
	ReagentNumBag[5][2] = { };
	ReagentNumBag[5][3] = { };
	ReagentNumBag[5][4] = { };
	
	local ReagentNum = { };
	ReagentNum[1] = { };
	ReagentNum[2] = { };
	ReagentNum[3] = { };
	ReagentNum[4] = { };

	local ReagentNumReq = { };
	ReagentNumReq[1] = { };
	ReagentNumReq[2] = { };
	ReagentNumReq[3] = { };
	ReagentNumReq[4] = { };

	local tempIndex;
	
	-- Initialize Variables
	tempIndex = 0;
	for f=1, 4 do
		tempIndex = tempIndex + 1;
		ItemID[tempIndex] = 0;
		ItemType[tempIndex] = "";
		ItemSpell[tempIndex] = "";
		ItemName[tempIndex] = "";
		ItemLevel[tempIndex] = "";
		NumReagents[tempIndex] = 0;
		for i=1, MAX_REAGENTS do
			ReagentName[tempIndex][i] = "";
			for bag=1, 5 do
				ReagentNumBag[bag][tempIndex][i] = 0;
			end
			ReagentNum[tempIndex][i] = 0;
			ReagentNumReq[tempIndex][i] = 0;
		end
	end

	-- Move Variables to Temps
	tempIndex = 0;
	for f=1, 4 do
		if (TradeWatch_Data.ItemID[f] > 0) and not ( TradeWatch_Data.ItemName[f] == CUSTOM_REAGENTS_TEXT ) then
			tempIndex = tempIndex + 1;
			ItemID[tempIndex] = TradeWatch_Data.ItemID[f];
			ItemType[tempIndex] = TradeWatch_Data.ItemType[f];
			ItemSpell[tempIndex] = TradeWatch_Data.ItemSpell[f];
			ItemName[tempIndex] = TradeWatch_Data.ItemName[f];
			ItemLevel[tempIndex] = TradeWatch_Data.ItemLevel[f];
			NumReagents[tempIndex] = TradeWatch_Data.NumReagents[f];
			for i=1, MAX_REAGENTS do
				ReagentName[tempIndex][i] = TradeWatch_Data.ReagentName[f][i];
				for bag=1, 5 do
					ReagentNumBag[bag][tempIndex][i] = TradeWatch_Data.ReagentNumBag[bag][f][i];
				end
				ReagentNum[tempIndex][i] = TradeWatch_Data.ReagentNum[f][i];
				ReagentNumReq[tempIndex][i] = TradeWatch_Data.ReagentNumReq[f][i];
			end
		end
	end
	-- Make Sure Custom Reagents are always Last
	for f=1, 4 do
		if ( TradeWatch_Data.ItemName[f] == CUSTOM_REAGENTS_TEXT ) then
			tempIndex = tempIndex + 1;
			ItemID[tempIndex] = TradeWatch_Data.ItemID[f];
			ItemType[tempIndex] = TradeWatch_Data.ItemType[f];
			ItemSpell[tempIndex] = TradeWatch_Data.ItemSpell[f];
			ItemName[tempIndex] = TradeWatch_Data.ItemName[f];
			ItemLevel[tempIndex] = TradeWatch_Data.ItemLevel[f];
			NumReagents[tempIndex] = TradeWatch_Data.NumReagents[f];
			for i=1, MAX_REAGENTS do
				ReagentName[tempIndex][i] = TradeWatch_Data.ReagentName[f][i];
				for bag=1, 5 do
					ReagentNumBag[bag][tempIndex][i] = TradeWatch_Data.ReagentNumBag[bag][f][i];
				end
				ReagentNum[tempIndex][i] = TradeWatch_Data.ReagentNum[f][i];
				ReagentNumReq[tempIndex][i] = TradeWatch_Data.ReagentNumReq[f][i];
			end
		end
	end
	
	-- Move Variables Back
	for f=1, 4 do
		TradeWatch_Data.ItemID[f] = ItemID[f];
		TradeWatch_Data.ItemType[f] = ItemType[f];
		TradeWatch_Data.ItemSpell[f] = ItemSpell[f];
		TradeWatch_Data.ItemName[f] = ItemName[f];
		TradeWatch_Data.ItemLevel[f] = ItemLevel[f];
		TradeWatch_Data.NumReagents[f] = NumReagents[f];
		for i=1, MAX_REAGENTS do
			TradeWatch_Data.ReagentName[f][i] = ReagentName[f][i];
			for bag=1, 5 do
				TradeWatch_Data.ReagentNumBag[bag][f][i] = ReagentNumBag[bag][f][i];
			end
			TradeWatch_Data.ReagentNum[f][i] = ReagentNum[f][i];
			TradeWatch_Data.ReagentNumReq[f][i] = ReagentNumReq[f][i];
		end
	end
	
end

-- Clean Up and Order Reagents
function TradeWatch_OrderReagents(frame)

	--Temp Variables
	local ReagentName = { };
	local ReagentNumBag = { };
	ReagentNumBag[1] = { };
	ReagentNumBag[2] = { };
	ReagentNumBag[3] = { };
	ReagentNumBag[4] = { };
	ReagentNumBag[5] = { };
	local ReagentNum = { };
	local ReagentNumReq = { };

	local tempIndex;
	
	-- Initialize Variables
	for i=1, MAX_REAGENTS do
		ReagentName[i] = "";
		for bag=1, 5 do
			ReagentNumBag[bag][i] = 0;
		end
		ReagentNum[i] = 0;
		ReagentNumReq[i] = 0;
	end

	-- Move Variables to Temps
	tempIndex = 0;
	for i=1, MAX_REAGENTS do
		if not ( TradeWatch_Data.ReagentName[frame][i] == "" ) then
			tempIndex = tempIndex + 1;
			ReagentName[tempIndex] = TradeWatch_Data.ReagentName[frame][i];
			for bag=1, 5 do
				ReagentNumBag[bag][tempIndex] = TradeWatch_Data.ReagentNumBag[bag][frame][i];
			end
			ReagentNum[tempIndex] = TradeWatch_Data.ReagentNum[frame][i];
			ReagentNumReq[tempIndex] = TradeWatch_Data.ReagentNumReq[frame][i];
		end
	end
	
	-- Move Variables Back
	for i=1, MAX_REAGENTS do
		TradeWatch_Data.ReagentName[frame][i] = ReagentName[i];
		for bag=1, 5 do
			TradeWatch_Data.ReagentNumBag[bag][frame][i] = ReagentNumBag[bag][i];
		end
		TradeWatch_Data.ReagentNum[frame][i] = ReagentNum[i];
		TradeWatch_Data.ReagentNumReq[frame][i] = ReagentNumReq[i];
	end
	
end

-- Find Available Frame
function TradeWatch_GetFrame()
	for f=1, 4 do
		if ( TradeWatch_Data.ItemName[f] == "" ) then
			return f;
		end
	end
	return 0;
end

-- Count Reagents in Inventory
function TradeWatch_CountReagents(bag, showalert)
	for f=1, TradeWatch_Data.NumFrames do
		for i=1, TradeWatch_Data.NumReagents[f] do
			TradeWatch_Data.ReagentNumBag[bag][f][i] = Lib.GetNumItems(bag, TradeWatch_Data.ReagentName[f][i]);
			local oldReagentNum = TradeWatch_Data.ReagentNum[f][i];
			TradeWatch_Data.ReagentNum[f][i] = 0;
			for bag=1, 5 do
				TradeWatch_Data.ReagentNum[f][i] = TradeWatch_Data.ReagentNum[f][i] + TradeWatch_Data.ReagentNumBag[bag][f][i];
			end
			--TradeWatch_Data.ReagentNum[f][i] = GetNumItems(TradeWatch_Data.ReagentName[f][i]);
			if ( showalert ) and ( TradeWatch_Data.ReagentNum[f][i] > oldReagentNum ) then
				--if ( TradeWatch_Data.ItemName[f] == CUSTOM_REAGENTS_TEXT ) then
				if ( TradeWatch_Data.ReagentNumReq[f][i] == 0 ) then
					ErrorMessage(TradeWatch_Data.ItemName[f]..":  "..TradeWatch_Data.ReagentName[f][i]..": "..TradeWatch_Data.ReagentNum[f][i]);
				else
					ErrorMessage(TradeWatch_Data.ItemName[f]..":  "..TradeWatch_Data.ReagentName[f][i]..": "..TradeWatch_Data.ReagentNum[f][i].."/"..TradeWatch_Data.ReagentNumReq[f][i]);
				end
			end
		end
	end
end

-- Count Number of Items Available
function TradeWatch_CountNumAvailable()
	for f=1, TradeWatch_Data.NumFrames do
		local limitReagent;
		local numAvailable = -1;
		for i=1, TradeWatch_Data.NumReagents[f] do
			limitReagent = math.floor( TradeWatch_Data.ReagentNum[f][i] / TradeWatch_Data.ReagentNumReq[f][i] );
			if (numAvailable == -1 ) or ( limitReagent < numAvailable ) then
				numAvailable = limitReagent;
			end
		end
		TradeWatch_Data.NumAvailable[f] = numAvailable;
	end
end

function TradeWatch_GetSpells()
	local i = 1;
	while true do
		local spellName, spellRank = GetSpellName(i, SpellBookFrame.bookType)
		if not spellName then
			do break end;
		end

		if ( spellName == "Alchemy" ) then
			TradeSkillSpellID["Alchemy"] = i;
		end
		if ( spellName == "Blacksmithing" ) then
			TradeSkillSpellID["Blacksmithing"] = i;
		end
		if ( spellName == "Cooking" ) then
			TradeSkillSpellID["Cooking"] = i;
		end
		if ( spellName == "Enchanting" ) then
			TradeSkillSpellID["Enchanting"] = i;
		end
		if ( spellName == "Engineering" ) then
			TradeSkillSpellID["Engineering"] = i;
		end
		if ( spellName == "First Aid" ) then
			TradeSkillSpellID["First Aid"] = i;
		end
		if ( spellName == "Leatherworking" ) then
			TradeSkillSpellID["Leatherworking"] = i;
		end
		if ( spellName == "Smelting" ) then
			TradeSkillSpellID["Smelting"] = i;
		end
		if ( spellName == "Poisons" ) then
			TradeSkillSpellID["Poisons"] = i;
		end
		if ( spellName == "Tailoring" ) then
			TradeSkillSpellID["Tailoring"] = i;
		end
		i = i + 1
	end
end

-- Parse Reagent
function TradeWatch_ParseReagent(msg, action)
	local reagent = Lib.ParseLink(msg);
	if not ( reagent ) then
		reagent = string.sub( msg, string.len(action) + 2 );
	end
	return reagent;
end
