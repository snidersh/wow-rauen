StaticPopupDialogs["DATASEARCH_CONFIRM_DELETE"] = {
	text = TEXT("Are you sure you would like to delete this entry from your saved statistics?"),
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		DataSearch_DeleteSelectedConfirmed();
	end,
	timeout = 0,
};

StaticPopupDialogs["DATASEARCH_CONFIRM_REMOVE"] = {
	text = TEXT("Are you sure you would like to remove this entry?"),
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		DataSearch_RemoveSelectedConfirmed();
	end,
	timeout = 0,
};

-- Constants
DATASEARCH_HEIGHT = 530;
DATASEARCH_WIDTH = 800;
DATASEARCH_NUMBUTTONS = 6;

function DataSearch_OnLoad()
	
	-- Initialize
	tinsert(UISpecialFrames,"DataSearch");
	this:SetHeight(DATASEARCH_HEIGHT);
	this:SetWidth(DATASEARCH_WIDTH);
	
	DataSearch_Reset();
	
end

function DataSearch_ResetVars()

	DataSearch_Var = { };
	DataSearch_Var.SearchType = "Creatures";
	DataSearch_Var.SearchName = "";
	DataSearch_Var.SearchLevelLow = 1;
	DataSearch_Var.SearchLevelHigh = 60;
	DataSearch_Var.SearchZone = "All Zones";
	DataSearch_Var.SearchElite = false;
	DataSearch_Var.SearchItem = "";
	DataSearch_Var.SearchQuality = -1;
	DataSearch_Var.SearchValueLow = nil;
	DataSearch_Var.SearchValueHigh = nil;
	DataSearch_Var.SearchCreature = "";
	
	DataSearch_Var.CreatureResults = -1;
	DataSearch_Var.Pages = 0;
	DataSearch_Var.CurrentPage = 1;
	DataSearch_Var.SelectedButton = nil;
	
	DataSearch_Data = { };
	DataSearch_Data.Creatures = nil;
	DataSearch_Data.Items = nil;
	DataSearch_Data.Players = nil;

end

function DataSearch_OnShow()
	
	local frame;
	local label, text;
	local button, texture;
	
	-- SearchCreature Box
	frame = getglobal("DataSearch_SearchCreatureBox");
	frame:SetWidth(DATASEARCH_WIDTH-40);
	if ( DataSearch_Var.SearchType == "Creatures" ) then
		frame:Show();
	else
		frame:Hide();
	end
	
	-- TypeDropDown
	button = getglobal("DataSearch_TypeDropDown");
	OptionsFrame_EnableDropDown(button);
	
	-- CreatureNameLabel
	text = getglobal("DataSearch_CreatureNameLabelText");
	text:SetText("Name");
	
	-- CreatureNameEdit
	text = getglobal("DataSearch_CreatureNameEdit");
	text:SetText("");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	text:SetWidth(150);
	
	-- CreatureLevelLabel
	text = getglobal("DataSearch_CreatureLevelLabelText");
	text:SetText("Levels");
	
	-- CreatureLevelLowEdit
	text = getglobal("DataSearch_CreatureLevelLowEdit");
	text:SetText(DataSearch_Var.SearchLevelLow);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	text:SetWidth(30);
	
	-- CreatureLevelDashLabel
	text = getglobal("DataSearch_CreatureLevelDashLabelText");
	text:SetText("-");
	
	-- CreatureLevelHighEdit
	text = getglobal("DataSearch_CreatureLevelHighEdit");
	text:SetText(DataSearch_Var.SearchLevelHigh);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	text:SetWidth(30);
	
	-- CheckCreatureElite
	button = getglobal("DataSearch_CheckCreatureElite");
	OptionsFrame_EnableCheckBox(button);
	text = getglobal("DataSearch_CheckCreatureEliteText");
	text:SetText("Elite");
	button:SetChecked( DataSearch_Var.SearchElite );
	
	-- CreatureZonesDropDown
	button = getglobal("DataSearch_CreatureZonesDropDown");
	OptionsFrame_EnableDropDown(button);
	
	-- CreatureItemLabel
	text = getglobal("DataSearch_CreatureItemLabelText");
	text:SetText("Loot Item");
	
	-- CreatureItemEdit
	text = getglobal("DataSearch_CreatureItemEdit");
	text:SetText(DataSearch_Var.SearchItem);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	text:SetWidth(130);
	
	-- SearchItem Box
	frame = getglobal("DataSearch_SearchItemBox");
	frame:SetWidth(DATASEARCH_WIDTH-40);
	if ( DataSearch_Var.SearchType == "Items" ) then
		frame:Show();
	else
		frame:Hide();
	end
	
	-- ItemNameLabel
	text = getglobal("DataSearch_ItemNameLabelText");
	text:SetText("Name");
	
	-- ItemNameEdit
	text = getglobal("DataSearch_ItemNameEdit");
	text:SetText("");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	text:SetWidth(150);
	
	-- ItemValueLabel
	text = getglobal("DataSearch_ItemValueLabelText");
	text:SetText("Value");
	
	-- ItemValueLowEdit
	text = getglobal("DataSearch_ItemValueLowEdit");
	if ( DataSearch_Var.SearchValueLow ) then
		text:SetText(DataSearch_Var.SearchValueLow);
	else
		text:SetText("");
	end
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	text:SetWidth(60);
	
	-- ItemValueDashLabel
	text = getglobal("DataSearch_ItemValueDashLabelText");
	text:SetText("-");
	
	-- ItemValueHighEdit
	text = getglobal("DataSearch_ItemValueHighEdit");
	if ( DataSearch_Var.SearchValueHigh ) then
		text:SetText(DataSearch_Var.SearchValueHigh);
	else
		text:SetText("");
	end
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	text:SetWidth(60);
	
	-- ItemQualityDropDown
	button = getglobal("DataSearch_ItemQualityDropDown");
	OptionsFrame_EnableDropDown(button);
	
	-- ItemCreatureLabel
	text = getglobal("DataSearch_ItemCreatureLabelText");
	text:SetText("Creature");
	
	-- ItemCreatureEdit
	text = getglobal("DataSearch_ItemCreatureEdit");
	text:SetText(DataSearch_Var.SearchCreature);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	text:SetWidth(130);
	
	-- SearchPlayer Box
	frame = getglobal("DataSearch_SearchPlayerBox");
	frame:SetWidth(DATASEARCH_WIDTH-40);
	if ( DataSearch_Var.SearchType == "Players" ) then
		frame:Show();
	else
		frame:Hide();
	end
	
	-- PlayerNameLabel
	text = getglobal("DataSearch_PlayerNameLabelText");
	text:SetText("Name");
	
	-- PlayerNameEdit
	text = getglobal("DataSearch_PlayerNameEdit");
	text:SetText("");
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	text:SetWidth(150);
	
	-- Results Box
	frame = getglobal("DataSearch_ResultsBox");
	frame:SetWidth(DATASEARCH_WIDTH-40);
	
	-- Delete Selected
	button = getglobal("DataSearch_DeleteButton");
	if ( DataSearch_Var.SelectedButton ) then
		button:Enable();
	else
		button:Disable();
	end
	
	-- Remove Selected
	button = getglobal("DataSearch_RemoveButton");
	if ( DataSearch_Var.SelectedButton ) and ( (DataSearch_Var.SearchCreature ~= "") or (DataSearch_Var.SearchItem ~= "")  ) then
		button:Enable();
	else
		button:Disable();
	end
	
	-- PageLabel
	text = getglobal("DataSearch_PageLabelText");
	if ( DataSearch_Var.Pages == 0 ) then
		text:SetText("");
	else
		text:SetText("Page "..DataSearch_Var.CurrentPage.." of "..DataSearch_Var.Pages);
	end
	
	-- PrevPage
	button = getglobal("DataSearch_PrevPageButton");
	button:Enable();
	if ( DataSearch_Var.CurrentPage == 1 ) then
		button:Disable();
	end
	
	-- NextPage
	button = getglobal("DataSearch_NextPageButton");
	button:Enable();
	if ( DataSearch_Var.CurrentPage == DataSearch_Var.Pages ) or ( DataSearch_Var.Pages == 0 ) then
		button:Disable();
	end
	
	-- DropDowns
	DataSearch_DropDownRefresh();
	
	-- Sort Buttons
	getglobal("DataSearch_CreatureSortLevel"):Hide();
	getglobal("DataSearch_CreatureSortName"):Hide();
	getglobal("DataSearch_CreatureSortKills"):Hide();
	getglobal("DataSearch_CreatureSortType"):Hide();
	getglobal("DataSearch_CreatureSortValue"):Hide();
	getglobal("DataSearch_CreatureSortLoot"):Hide();
	getglobal("DataSearch_ItemSortName"):Hide();
	getglobal("DataSearch_ItemSortValue"):Hide();
	getglobal("DataSearch_ItemSortCreature"):Hide();
	getglobal("DataSearch_PlayerSortRank"):Hide();
	getglobal("DataSearch_PlayerSortLevel"):Hide();
	getglobal("DataSearch_PlayerSortName"):Hide();
	getglobal("DataSearch_PlayerSortKills"):Hide();
	
	if ( DataSearch_Var.SearchType == "Creatures" ) then
		
		if not ( DataSearch_Data.Creatures ) then
			return;
		end
		
		getglobal("DataSearch_CreatureSortLevel"):Show();
		getglobal("DataSearch_CreatureSortName"):Show();
		getglobal("DataSearch_CreatureSortKills"):Show();
		getglobal("DataSearch_CreatureSortType"):Show();
		getglobal("DataSearch_CreatureSortValue"):Show();
		getglobal("DataSearch_CreatureSortLoot"):Show();

		local index = ( ( DataSearch_Var.CurrentPage - 1 ) * 6 ) + 1;
		for i=1, DATASEARCH_NUMBUTTONS do
			
			button = getglobal("DataSearch_CreatureResultsButton"..i);
			if ( DataSearch_Data.Creatures[index] ) then
			
				button:Show();
				button:UnlockHighlight();
				if ( DataSearch_Var.SelectedButton == button.id ) then
					button:LockHighlight();
				end
			
				text = getglobal("DataSearch_CreatureResultsButton"..i.."Level");
				text:SetText(DataSearch_Data.Creatures[index].Level);
				text:SetTextColor(0.75, 0.75, 1.0);
				
				text = getglobal("DataSearch_CreatureResultsButton"..i.."Elite");
				if ( DataSearch_Data.Creatures[index].Elite ) then
					text:SetText("Elite");
					text:SetTextColor(1.0, 1.0, 0.0);
				else
					text:SetText("");
				end
				
				text = getglobal("DataSearch_CreatureResultsButton"..i.."Name");
				text:SetText(DataSearch_Data.Creatures[index].Name);
				text:SetTextColor(1.0, 1.0, 1.0);
				
				text = getglobal("DataSearch_CreatureResultsButton"..i.."Zone");
				text:SetText(DataSearch_Data.Creatures[index].Zone);
				text:SetTextColor(0.75, 0.75, 1.0);
				
				text = getglobal("DataSearch_CreatureResultsButton"..i.."Kills");
				if ( DataSearch_Data.Creatures[index].Kills > 0 ) then
					text:SetText(DataSearch_Data.Creatures[index].Kills.." Kills");
					text:SetTextColor(0.75, 0.75, 1.0);
				else
					if ( DataSearch_Data.Creatures[index].Loots > 0 ) then
						text:SetText(DataSearch_Data.Creatures[index].Loots.." Kills");
						text:SetTextColor(0.5, 0.5, 0.5);
					else
						text:SetText("No Kills");
						text:SetTextColor(0.5, 0.5, 0.5);
					end
				end
				
				text = getglobal("DataSearch_CreatureResultsButton"..i.."XP");
				if ( DataSearch_Data.Creatures[index].XP > 0 ) then
					text:SetText(DataSearch_Data.Creatures[index].XP.." Exp");
					text:SetTextColor(0.75, 0.75, 1.0);
				else
					text:SetText("No Exp");
					text:SetTextColor(0.5, 0.5, 0.5);
				end
				
				text = getglobal("DataSearch_CreatureResultsButton"..i.."Type");
				text:SetText(DataSearch_Data.Creatures[index].Type);
				text:SetTextColor(0.75, 0.75, 1.0);
				
				text = getglobal("DataSearch_CreatureResultsButton"..i.."Family");
				text:SetText(DataSearch_Data.Creatures[index].Family);
				text:SetTextColor(0.75, 0.75, 1.0);
				
				local value = DataSearch_Data.Creatures[index].Value;
				if ( value > 0 ) then
					getglobal("DataSearch_CreatureResultsButton"..i.."MoneyFrame"):Show();
					MoneyFrame_Update("DataSearch_CreatureResultsButton"..i.."MoneyFrame", value);
				else
					getglobal("DataSearch_CreatureResultsButton"..i.."MoneyFrame"):Hide();
				end
				
				button = getglobal("DataSearch_CreatureResultsButton"..i.."ItemsButton");
				button.name = DataSearch_Data.Creatures[index].Name;
				button:SetAlpha(0.8);
				if ( DataSearch_Data.Creatures[index].LootItems > 0 ) then
					button:Enable();
					button:SetText(DataSearch_Data.Creatures[index].LootItems.." Loot Items");
				else
					button:SetText("No Loot Items");
					button:Disable();
				end
				
			else
				button:Hide();
			end
			index = index + 1;
			
		end
		
	end
	
	if ( DataSearch_Var.SearchType == "Items" ) then
		
		if not ( DataSearch_Data.Items ) then
			return;
		end
		
		getglobal("DataSearch_ItemSortName"):Show();
		getglobal("DataSearch_ItemSortValue"):Show();
		getglobal("DataSearch_ItemSortCreature"):Show();

		local index = ( ( DataSearch_Var.CurrentPage - 1 ) * 6 ) + 1;
		for i=1, DATASEARCH_NUMBUTTONS do
			
			button = getglobal("DataSearch_ItemResultsButton"..i);
			if ( DataSearch_Data.Items[index] ) then
			
				button:Show();
				button:UnlockHighlight();
				if ( DataSearch_Var.SelectedButton == button.id ) then
					button:LockHighlight();
				end
				
				button = getglobal("DataSearch_ItemResultsButton"..i.."Item");
				local _, _, link = string.find(DataSearch_Data.Items[index].Link, "|H(item:%d+:%d+:%d+:%d+)|");
				button.link = link;
				button = getglobal("DataSearch_ItemResultsButton"..i.."ItemIconTexture");
				button:SetTexture(DataSearch_Data.Items[index].Texture);
				
				text = getglobal("DataSearch_ItemResultsButton"..i.."ItemCount");
				if ( DataSearch_Var.SearchCreature ~= "" ) then
					local num =  Data_KillStats_GetNumItems(DataSearch_Var.SearchCreature, DataSearch_Data.Items[index].Name);
					if ( num > 0 ) then
						text:SetText(num);
						text:Show();
					else
						text:SetText("");
						text:Hide();
					end
				else
					text:SetText("");
					text:Hide();
				end
				
				text = getglobal("DataSearch_ItemResultsButton"..i.."Name");
				text:SetText(DataSearch_Data.Items[index].Name);
				text:SetTextColor(ITEM_QUALITY_COLORS[DataSearch_Data.Items[index].Quality].r, ITEM_QUALITY_COLORS[DataSearch_Data.Items[index].Quality].g, ITEM_QUALITY_COLORS[DataSearch_Data.Items[index].Quality].b);
				
				text = getglobal("DataSearch_ItemResultsButton"..i.."DropRate");
				if ( DataSearch_Var.SearchCreature ~= "" ) then
					local droprate = Data_KillStats_GetDropRate(DataSearch_Var.SearchCreature, DataSearch_Data.Items[index].Name);
					if ( droprate > 0 ) then
						text:SetText(droprate.."% Drop Rate");
						text:SetTextColor(0.75, 0.75, 1.0);
					else
						text:SetText("");
					end
				else
					text:SetText("");
				end
				
				local value = DataSearch_Data.Items[index].Value;
				if ( value > 0 ) then
					text = getglobal("DataSearch_ItemResultsButton"..i.."Money");
					text:SetText("");
					getglobal("DataSearch_ItemResultsButton"..i.."MoneyFrame"):Show();
					MoneyFrame_Update("DataSearch_ItemResultsButton"..i.."MoneyFrame", value);
				else
					if ( value == 0 ) then
						text = getglobal("DataSearch_ItemResultsButton"..i.."Money");
						text:SetText("No Merchant Value");
						text:SetTextColor(0.5, 0.5, 0.5);
					end
					getglobal("DataSearch_ItemResultsButton"..i.."MoneyFrame"):Hide();
				end
				
				button = getglobal("DataSearch_ItemResultsButton"..i.."CreaturesButton");
				button:SetAlpha(0.8);
				button.item = DataSearch_Data.Items[index].Name;
				if ( DataSearch_Data.Items[index].Creatures > 0 ) then
					button:Enable();
					button:SetText(DataSearch_Data.Items[index].Creatures.." Creatures");
				else
					button:SetText("No Creatures");
					button:Disable();
				end
				
			else
				button:Hide();
			end
			index = index + 1;
			
		end
		
	end
	
	if ( DataSearch_Var.SearchType == "Players" ) then
		
		if not ( DataSearch_Data.Players ) then
			return;
		end
		
		getglobal("DataSearch_PlayerSortRank"):Show();
		getglobal("DataSearch_PlayerSortLevel"):Show();
		getglobal("DataSearch_PlayerSortName"):Show();
		getglobal("DataSearch_PlayerSortKills"):Show();
		
		local index = ( ( DataSearch_Var.CurrentPage - 1 ) * 6 ) + 1;
		for i=1, DATASEARCH_NUMBUTTONS do
			
			button = getglobal("DataSearch_PlayerResultsButton"..i);
			if ( DataSearch_Data.Players[index] ) then
			
				button:Show();
				button:UnlockHighlight();
				if ( DataSearch_Var.SelectedButton == button.id ) then
					button:LockHighlight();
				end
				
				button = getglobal("DataSearch_PlayerResultsButton"..i.."Rank");
				if ( DataSearch_Data.Players[index].RankNum ) then
					if ( DataSearch_Data.Players[index].RankNum > 0 ) then
						texture = getglobal("DataSearch_PlayerResultsButton"..i.."RankTexture");
						texture:SetTexture(format("%s%02d","Interface\\PvPRankBadges\\PvPRank", DataSearch_Data.Players[index].RankNum));
						if ( DataSearch_Data.Players[index].Rank ~= "" ) then
							button.rank = DataSearch_Data.Players[index].Rank;
						end
						button:Show();
					else
						button:Hide();
					end
				else
					button:Hide();
				end
				
				text = getglobal("DataSearch_PlayerResultsButton"..i.."Level");
				if ( DataSearch_Data.Players[index].Level > 0 ) then
					text:SetText( DataSearch_Data.Players[index].Level);
					text:SetTextColor(0.75, 0.75, 1.0);
				else
					text:SetText("");
				end
				
				text = getglobal("DataSearch_PlayerResultsButton"..i.."Class");
				if ( DataSearch_Data.Players[index].Class ) then
					text:SetText( DataSearch_Data.Players[index].Class);
					text:SetTextColor(0.75, 0.75, 1.0);
				else
					text:SetText("");
				end
				
				text = getglobal("DataSearch_PlayerResultsButton"..i.."Name");
				text:SetText(DataSearch_Data.Players[index].Name);
				text:SetTextColor(1.0, 1.0, 1.0);
				
				text = getglobal("DataSearch_PlayerResultsButton"..i.."Zone");
				text:SetText(DataSearch_Data.Players[index].Zone);
				text:SetTextColor(0.75, 0.75, 1.0);
				
				text = getglobal("DataSearch_PlayerResultsButton"..i.."Kills");
				if ( DataSearch_Data.Players[index].Kills > 0 ) then
					text:SetText(DataSearch_Data.Players[index].Kills.." Kills");
					text:SetTextColor(0.75, 0.75, 1.0);
				else
					text:SetText("No Kills");
					text:SetTextColor(0.5, 0.5, 0.5);
				end
				
			else
				button:Hide();
			end
			index = index + 1;
			
		end
		
	end
	
end

function DataSearch_Close()
	DataSearch_Reset();
	PlaySound("igMainMenuClose");
	HideUIPanel(DataSearch);
end

function DataSearch_Reset()
	DataSearch_ResetVars();
	DataSearch_ResetButtons();
	DataSearch_DropDownRefresh();
	DataSearch_OnShow();
end

function DataSearch_ResetButtons()
	local button;
	for i=1, DATASEARCH_NUMBUTTONS do
		button = getglobal("DataSearch_CreatureResultsButton"..i);
		button.id = i;
		button:UnlockHighlight();
		button:Hide();
		button = getglobal("DataSearch_ItemResultsButton"..i);
		button.id = i;
		button:UnlockHighlight();
		button:Hide();
		button = getglobal("DataSearch_PlayerResultsButton"..i);
		button.id = i;
		button:UnlockHighlight();
		button:Hide();
	end
	DataSearch_Var.SelectedButton = nil;
end

function DataSearch_DeleteSelected()
	PlaySound("UChatScrollButton");
	StaticPopup_Show("DATASEARCH_CONFIRM_DELETE");
end

function DataSearch_DeleteSelectedConfirmed()
	local name;
	if ( DataSearch_Var.SearchType == "Creatures" ) then
		name = getglobal("DataSearch_CreatureResultsButton"..DataSearch_Var.SelectedButton.."Name"):GetText();
		Data_KillStats_RemoveEntry(name);
	end
	if ( DataSearch_Var.SearchType == "Items" ) then
		name = getglobal("DataSearch_ItemResultsButton"..DataSearch_Var.SelectedButton.."Name"):GetText();
		Data_ItemStats_RemoveItem(name);
	end
	if ( DataSearch_Var.SearchType == "Players" ) then
		name = getglobal("DataSearch_PlayerResultsButton"..DataSearch_Var.SelectedButton.."Name"):GetText();
		Data_KillStats_RemoveEntry(name);
	end
	DataSearch_Var.SelectedButton = nil;
	DataSearch_Search();
end

function DataSearch_RemoveSelected()
	PlaySound("UChatScrollButton");
	StaticPopup_Show("DATASEARCH_CONFIRM_REMOVE");
end

function DataSearch_RemoveSelectedConfirmed()
	local name, item;
	if ( DataSearch_Var.SearchType == "Creatures" ) then
		name = getglobal("DataSearch_CreatureResultsButton"..DataSearch_Var.SelectedButton.."Name"):GetText();
		item = DataSearch_Var.SearchItem;
		Data_KillStats_RemoveLoot(name, item);
	end
	if ( DataSearch_Var.SearchType == "Items" ) then
		name = DataSearch_Var.SearchCreature;
		item = getglobal("DataSearch_ItemResultsButton"..DataSearch_Var.SelectedButton.."Name"):GetText();
		Data_KillStats_RemoveLoot(name, item);
	end
	DataSearch_Var.SelectedButton = nil;
	DataSearch_Search();
end

function DataSearch_RowButton_OnClick()
	PlaySound("UChatScrollButton");
	local button = this;
	if ( DataSearch_Var.SelectedButton == button.id ) then
		DataSearch_Var.SelectedButton = nil;
	else
		DataSearch_Var.SelectedButton = button.id;
	end
	DataSearch_OnShow();
end

function DataSearch_Sort(field, style, num)
	if ( DataSearch_Var.SearchType == "Creatures" ) then
		DataSearch_Data.Creatures = Lib.TableSort(DataSearch_Data.Creatures, field, style, num);
	end
	if ( DataSearch_Var.SearchType == "Items" ) then
		DataSearch_Data.Items = Lib.TableSort(DataSearch_Data.Items, field, style, num);
	end
	if ( DataSearch_Var.SearchType == "Players" ) then
		DataSearch_Data.Players = Lib.TableSort(DataSearch_Data.Players, field, style, num);
	end
	DataSearch_Var.SelectedButton = nil;
	DataSearch_Var.CurrentPage = 1;
	DataSearch_OnShow();
end

function DataSearch_ItemIcon_OnEnter()
	if ( this.link ) then
		ShowUIPanel(DataSearchTooltip);
		if( not DataSearchTooltip:IsVisible() ) then
			DataSearchTooltip:SetOwner(this, "ANCHOR_RIGHT");
		end
		DataSearchTooltip:SetHyperlink(this.link);
	end
end

function DataSearch_PrevPageButton_OnClick()
	PlaySound("UChatScrollButton");
	if ( DataSearch_Var.CurrentPage > 1 ) then
		DataSearch_Var.CurrentPage = DataSearch_Var.CurrentPage - 1;
	end
	DataSearch_OnShow();
end

function DataSearch_NextPageButton_OnClick()
	PlaySound("UChatScrollButton");
	if ( DataSearch_Var.Pages > DataSearch_Var.CurrentPage ) then
		DataSearch_Var.CurrentPage = DataSearch_Var.CurrentPage + 1;
	end
	DataSearch_OnShow();
end

function DataSearch_CreatureItemSearch()
	local name = this.name;
	DataSearch_Reset();
	DataSearch_Var.SearchType = "Items";
	DataSearch_Var.SearchCreature = name;
	DataSearch_OnShow();
	DataSearch_Search();
end

function DataSearch_ItemCreatureSearch()
	local item = this.item;
	DataSearch_Reset();
	DataSearch_Var.SearchType = "Creatures";
	DataSearch_Var.SearchItem = item;
	DataSearch_OnShow();
	DataSearch_Search();
end

function DataSearch_Search()
	
	PlaySound("UChatScrollButton");
	DataSearch_ResetButtons();
	
	local record;
	local data;
	local add;
	
	if ( DataSearch_Var.SearchType == "Creatures" ) then
		
		DataSearch_Data.Creatures = { };
		
		DataSearch_Var.SearchName = DataSearch_CreatureNameEdit:GetText();
		DataSearch_Var.SearchLevelLow = tonumber(DataSearch_CreatureLevelLowEdit:GetText());
		if not ( DataSearch_Var.SearchLevelLow ) then
			DataSearch_Var.SearchLevelLow = 1;
		end
		DataSearch_Var.SearchLevelHigh = tonumber(DataSearch_CreatureLevelHighEdit:GetText());
		if not ( DataSearch_Var.SearchLevelHigh ) then
			DataSearch_Var.SearchLevelHigh = 60;
		end
		DataSearch_Var.SearchElite = DataSearch_Var.SearchElite;
		DataSearch_Var.SearchZone = DataSearch_Var.SearchZone;
		DataSearch_Var.SearchItem = DataSearch_CreatureItemEdit:GetText();
		
		for key in KillStats do
			record = { };
			data = Data_KillStats_GetEntry(key);
			add = true;
			if ( key ~= "Zones" ) then
				if ( data.Player ) then
					add = false;
				end
				if ( DataSearch_Var.SearchName ~= "" ) then
					if not ( string.find(string.lower(key), string.lower(DataSearch_Var.SearchName) ) ) then
						add = false;
					end
				end
				if ( DataSearch_Var.SearchLevelLow ~= nil ) and ( DataSearch_Var.SearchLevelHigh ~= nil ) then
					if ( data.Level < DataSearch_Var.SearchLevelLow ) or ( data.Level > DataSearch_Var.SearchLevelHigh ) then
						add = false;
					end
				end
				if ( DataSearch_Var.SearchElite ) then
					if not ( data.Elite ) then
						add = false;
					end
				end
				if ( DataSearch_Var.SearchZone ~= "All Zones" ) then
					if not ( string.find(string.lower(data.Zone), string.lower(DataSearch_Var.SearchZone) ) ) then
						add = false;
					end
				end
				if ( DataSearch_Var.SearchItem ~= "" ) then
					local exists = false;
					for item in data.Loot do
						if ( string.find(string.lower(item), string.lower(DataSearch_Var.SearchItem) ) ) then
							exists = true;
						end
					end
					if not ( exists ) then
						add = false;
					end
				end
				if ( add ) then
					record = data;
					record.Value = Data_KillStats_GetCreatureValue(data.Name);
					local numitems = 0;
					for item in data.Loot do
						numitems = numitems + 1;
					end
					record.LootItems = numitems;
					if ( record ) then
						table.insert(DataSearch_Data.Creatures, record);
					end
				end
			end
		end
		DataSearch_Data.Creatures = Lib.TableSort(DataSearch_Data.Creatures, "Name", "asc");
		local num = table.getn(DataSearch_Data.Creatures);
		if ( num == 0 ) then
			DataSearch_Data.Creatures = nil;
			return;
		end
		DataSearch_Var.Pages = math.floor(num/6);
		if ( ( num/6 ) > math.floor(num/6) ) then
			DataSearch_Var.Pages = DataSearch_Var.Pages + 1;
		end
		DataSearch_Var.Results = num;
	end
	
	if ( DataSearch_Var.SearchType == "Items" ) then
		
		DataSearch_Data.Items = { };
		
		DataSearch_Var.SearchName = DataSearch_ItemNameEdit:GetText();
		DataSearch_Var.SearchValueLow = tonumber(DataSearch_ItemValueLowEdit:GetText());
		DataSearch_Var.SearchValueHigh = tonumber(DataSearch_ItemValueHighEdit:GetText());
		DataSearch_Var.SearchElite = DataSearch_Var.SearchElite;
		DataSearch_Var.SearchZone = DataSearch_Var.SearchZone;
		DataSearch_Var.SearchCreature = DataSearch_ItemCreatureEdit:GetText();
		
		for key in ItemStats do
			record = { };
			data = Data_ItemStats_GetItem(key);
			add = true;
			if ( DataSearch_Var.SearchName ~= "" ) then
				if not ( string.find(string.lower(key), string.lower(DataSearch_Var.SearchName) ) ) then
					add = false;
				end
			end
			if ( DataSearch_Var.SearchValueLow ~= nil ) and ( DataSearch_Var.SearchValueHigh ~= nil ) then
				if ( data.Value < DataSearch_Var.SearchValueLow ) or ( data.Value > DataSearch_Var.SearchValueHigh ) then
					add = false;
				end
			end
			if ( DataSearch_Var.SearchQuality > -1 ) then
				if not ( data.Quality == DataSearch_Var.SearchQuality ) then
					add = false;
				end
			end
			if ( DataSearch_Var.SearchCreature ~= "" ) then
				if not ( Data_KillStats_GetCreatureHasItem(DataSearch_Var.SearchCreature, key) ) then
					add = false;
				end
			end
			if ( add ) then
				record = data;
				record.Creatures = Data_KillStats_GetNumCreaturesHaveItem(data.Name);
				if ( record ) then
					table.insert(DataSearch_Data.Items, record);
				end
			end
		end
		DataSearch_Data.Items = Lib.TableSort(DataSearch_Data.Items, "Name", "asc");
		local num = table.getn(DataSearch_Data.Items);
		if ( num == 0 ) then
			DataSearch_Data.Items = nil;
			return;
		end
		DataSearch_Var.Pages = math.floor(num/6);
		if ( ( num/6 ) > math.floor(num/6) ) then
			DataSearch_Var.Pages = DataSearch_Var.Pages + 1;
		end
		DataSearch_Var.Results = num;
		
	end
	
	if ( DataSearch_Var.SearchType == "Players" ) then
		
		DataSearch_Data.Players = { };
		
		DataSearch_Var.SearchName = DataSearch_PlayerNameEdit:GetText();
		
		for key in KillStats do
			record = { };
			data = Data_KillStats_GetEntry(key);
			add = true;
			if ( key ~= "Zones" ) then
				if ( DataSearch_Var.SearchName ~= "" ) then
					if not ( string.find(string.lower(key), string.lower(DataSearch_Var.SearchName) ) ) then
						add = false;
					end
				end
				if not ( data.Player ) then
					add = false;
				end
				if ( add ) then
					record = data;
					if ( record ) then
						table.insert(DataSearch_Data.Players, record);
					end
				end
			end
		end
		DataSearch_Data.Players = Lib.TableSort(DataSearch_Data.Players, "Name", "asc");
		local num = table.getn(DataSearch_Data.Players);
		if ( num == 0 ) then
			DataSearch_Data.Players = nil;
			return;
		end
		DataSearch_Var.Pages = math.floor(num/6);
		if ( ( num/6 ) > math.floor(num/6) ) then
			DataSearch_Var.Pages = DataSearch_Var.Pages + 1;
		end
		DataSearch_Var.Results = num;
		
	end
	
	DataSearch_OnShow();
	
end

function DataSearch_DropDownOnShow()
	
	local button = this;
	local name = button:GetName();
	
	if ( name == "DataSearch_TypeDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, DataSearch_Var.SearchType);
		UIDropDownMenu_Initialize(button, DataSearch_TypeDropDownInit);
		UIDropDownMenu_SetWidth(120, button);
	end
	if ( name == "DataSearch_CreatureZonesDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, DataSearch_Var.SearchZone);
		UIDropDownMenu_Initialize(button, DataSearch_CreatureZonesDropDownInit);
		UIDropDownMenu_SetWidth(155, button);
	end
	if ( name == "DataSearch_ItemQualityDropDown" ) then
		UIDropDownMenu_SetSelectedValue(button, DataSearch_Var.SearchQuality);
		getglobal("DataSearch_ItemQualityDropDownText"):SetTextColor(ITEM_QUALITY_COLORS[DataSearch_Var.SearchQuality].r, ITEM_QUALITY_COLORS[DataSearch_Var.SearchQuality].g, ITEM_QUALITY_COLORS[DataSearch_Var.SearchQuality].b);
		UIDropDownMenu_Initialize(button, DataSearch_ItemQualityDropDownInit);
		UIDropDownMenu_SetWidth(155, button);
	end
end

function DataSearch_TypeDropDownInit()

	local func;
	func = DataSearch_TypeDropDownOnClick;
	
	local info = { };
	info.text = "Search Creatures";
	info.value = "Creatures";
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
	info.text = "Search Items";
	info.value = "Items";
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
	info.text = "Search Players";
	info.value = "Players";
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
end

function DataSearch_CreatureZonesDropDownInit()

	local func;
	func = DataSearch_CreatureZonesDropDownOnClick;
	
	local info = { };
	info.text = "All Zones";
	info.value = "All Zones";
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	UIDropDownMenu_AddButton(info);
	
	local zones = Data_KillStats_GetZones();
	local numZones = table.getn(zones);
	if ( numZones == 0 ) then
		return;
	end
	for i=1, numZones do
		info.text = zones[i];
		info.value = zones[i];
		info.func = func;
		if ( info.value == selectedValue ) then
			info.checked = 1;
		else
			info.checked = nil;
		end
		UIDropDownMenu_AddButton(info);
	end

end

function DataSearch_ItemQualityDropDownInit()

	local func;
	func = DataSearch_ItemQualityDropDownOnClick;
	
	local info = { };
	
	info.text = "All Qualities";
	info.value = -1;
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.textR = ITEM_QUALITY_COLORS[0].r;
	info.textG = ITEM_QUALITY_COLORS[0].g;
	info.textB = ITEM_QUALITY_COLORS[0].b;
	UIDropDownMenu_AddButton(info);
	
	info.text = "Common";
	info.value = 0;
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.textR = ITEM_QUALITY_COLORS[0].r;
	info.textG = ITEM_QUALITY_COLORS[0].g;
	info.textB = ITEM_QUALITY_COLORS[0].b;
	UIDropDownMenu_AddButton(info);
	
	info.text = "Special";
	info.value = 1;
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.textR = ITEM_QUALITY_COLORS[1].r;
	info.textG = ITEM_QUALITY_COLORS[1].g;
	info.textB = ITEM_QUALITY_COLORS[1].b;
	UIDropDownMenu_AddButton(info);
	
	info.text = "Uncommon";
	info.value = 2;
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.textR = ITEM_QUALITY_COLORS[2].r;
	info.textG = ITEM_QUALITY_COLORS[2].g;
	info.textB = ITEM_QUALITY_COLORS[2].b;
	UIDropDownMenu_AddButton(info);
	
	info.text = "Rare";
	info.value = 3;
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.textR = ITEM_QUALITY_COLORS[3].r;
	info.textG = ITEM_QUALITY_COLORS[3].g;
	info.textB = ITEM_QUALITY_COLORS[3].b;
	UIDropDownMenu_AddButton(info);
	
	info.text = "Epic";
	info.value = 4;
	info.func = func;
	if ( info.value == selectedValue ) then
		info.checked = 1;
	else
		info.checked = nil;
	end
	info.textR = ITEM_QUALITY_COLORS[4].r;
	info.textG = ITEM_QUALITY_COLORS[4].g;
	info.textB = ITEM_QUALITY_COLORS[4].b;
	UIDropDownMenu_AddButton(info);
	
end

function DataSearch_TypeDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(DataSearch_TypeDropDown, this.value);
	DataSearch_Var.SearchType = UIDropDownMenu_GetSelectedValue(DataSearch_TypeDropDown);
	DataSearch_Data.Creatures = nil;
	DataSearch_Data.Items = nil;
	DataSearch_Data.Players = nil;
	DataSearch_ResetButtons();
	DataSearch_OnShow();
end

function DataSearch_CreatureZonesDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(DataSearch_CreatureZonesDropDown, this.value);
	DataSearch_Var.SearchZone = UIDropDownMenu_GetSelectedValue(DataSearch_CreatureZonesDropDown);
	DataSearch_OnShow();
end

function DataSearch_ItemQualityDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(DataSearch_ItemQualityDropDown, this.value);
	getglobal("DataSearch_ItemQualityDropDownText"):SetTextColor(ITEM_QUALITY_COLORS[DataSearch_Var.SearchQuality].r, ITEM_QUALITY_COLORS[DataSearch_Var.SearchQuality].g, ITEM_QUALITY_COLORS[DataSearch_Var.SearchQuality].b);
	DataSearch_Var.SearchQuality = UIDropDownMenu_GetSelectedValue(DataSearch_ItemQualityDropDown);
	DataSearch_OnShow();
end

function DataSearch_DropDownRefresh()
	UIDropDownMenu_SetSelectedValue(DataSearch_TypeDropDown, DataSearch_Var.SearchType);
	UIDropDownMenu_Refresh(DataSearch_TypeDropDown);
	UIDropDownMenu_SetSelectedValue(DataSearch_CreatureZonesDropDown, DataSearch_Var.SearchZone);
	UIDropDownMenu_Refresh(DataSearch_CreatureZonesDropDown);
	UIDropDownMenu_SetSelectedValue(DataSearch_ItemQualityDropDown, DataSearch_Var.SearchQuality);
	getglobal("DataSearch_ItemQualityDropDownText"):SetTextColor(ITEM_QUALITY_COLORS[DataSearch_Var.SearchQuality].r, ITEM_QUALITY_COLORS[DataSearch_Var.SearchQuality].g, ITEM_QUALITY_COLORS[DataSearch_Var.SearchQuality].b);
	UIDropDownMenu_Refresh(DataSearch_ItemQualityDropDown);
end

function DataSearch_CheckButtonOnClick()

	if ( this:GetChecked() ) then
		PlaySound("igMainMenuOptionCheckBoxOff");
	else
		PlaySound("igMainMenuOptionCheckBoxOn");
	end

	local button = this;
	local name = button:GetName();
	local checked = button:GetChecked();
	
	if ( name == "DataSearch_CheckCreatureElite" ) then
		if ( checked ) then
			DataSearch_Var.SearchElite = true;
		else
			DataSearch_Var.SearchElite = false;
		end
	end
	
	DataSearch_OnShow();
	
end
