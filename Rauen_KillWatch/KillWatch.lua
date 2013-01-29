KillWatch_Var = { };
KillWatch_Var.CombatStart = 0;
KillWatch_Var.CombatEnd = 0;
KillWatch_Var.Duration = 0;
KillWatch_Var.XP = 0;
KillWatch_Var.Rank = nil;

function KillWatch_OnLoad()

	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");
	
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	this:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");
	this:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN");
	this:RegisterEvent("LOOT_OPENED");
	
	-- Register Slash Commands
	SLASH_KillWatch1 = "/killwatch";
	SLASH_KillWatch2 = "/kw";
	SlashCmdList["KillWatch"] = function(msg)
		KillWatch_ChatCommandHandler(msg);
	end
	
	ChatMessage("Rauen's KillWatch Loaded.");
	
end

function KillWatch_ChatCommandHandler(msg)
	
	-- Menu
	if ( kwUI:IsVisible() ) then
		PlaySound("igMainMenuClose");
		HideUIPanel(kwUI);
	else
		PlaySound("igMainMenuOpen");
		ShowUIPanel(kwUI);
	end
	
end

function KillWatch_Reset()

	KillWatch_Config = { };
	KillWatch_Config.Enabled = true;
	KillWatch_Config.Version = KILLWATCH_VERSION;
	KillWatch_Config.ShowLoot = false;
	KillWatch_Config.ShowQuality = false;
	KillWatch_Config.ShowLootPercent = false;
	KillWatch_Config.ShowValue = false;
	KillWatch_Config.GraphicValue = true;
	KillWatch_Config.LootQuality = 4;
	KillWatch_Config.ShowCoins = true;
	KillWatch_Config.GraphicCoins = true;
	KillWatch_Config.ShowDur = true;
	KillWatch_Config.ShowKills = true;
	KillWatch_Config.ShowXP = true;
	KillWatch_Config.ShowZone = true;
	KillWatch_Config.ShowRatingCoin = false;
	KillWatch_Config.ShowRatingXP = false;
	KillWatch_Config.ShowRatingLoot = false;
	KillWatch_Config.ShowRating = false;
	
	KillWatch_Config.Color = { 
		["Current"] = { r = 0.75, g = 0.75, b = 1.0 },
		["Old"] = { r = 0.5, g = 0.5, b = 0.5 },
	}
	
	ChatMessage("KillWatch configuration reset.");
	
end

function KillWatch_ResetStats()
	Data_KillStats_Reset();
	ChatMessage("KillWatch statistics reset.");
end

function KillWatch_OnEvent(event)

	if ( event == "VARIABLES_LOADED") then
		if ( KillWatch_Config ) then
			if ( KillWatch_Config.Version ~= KILLWATCH_VERSION ) then
				ChatMessage("KillWatch updated to v"..KILLWATCH_VERSION..".");
				KillWatch_Reset();
			end
		else
			ChatMessage("KillWatch updated to v"..KILLWATCH_VERSION..".");
			KillWatch_Reset();
		end
		return;
	end
	
	if not ( KillWatch_Config.Enabled ) then
		return;
	end
	
	if (event == "PLAYER_REGEN_DISABLED") then
		KillWatch_Var.StartCombat = GetTime();
	end
	
	if ( event == "CHAT_MSG_COMBAT_XP_GAIN" ) then
		local CreatureName;
		local Experience = 0;
		for name, xp in string.gfind(arg1, "(.+) dies, you gain (%d+) experience.") do
			CreatureName = name;
			Experience = xp;
		end
		for xp in string.gfind(arg1, "+(%d+) exp Rested") do
			Experience = Experience - xp;
		end
		for xp in string.gfind(arg1, "+(%d+) exp Group") do
			Experience = Experience - xp;
		end
		if ( CreatureName ) then
			KillWatch_Var.XP = Experience;
			KillWatch_Var.EndCombat = GetTime();
			if ( KillWatch_Var.StartCombat == nil ) then
				KillWatch_ClearVars();
				return;
			end
			KillWatch_Var.Duration = KillWatch_Var.EndCombat - KillWatch_Var.StartCombat;
			KillWatch_Save(CreatureName, nil);
		end
	end
	
	if ( event == "CHAT_MSG_COMBAT_HONOR_GAIN" ) then
		local PlayerName, PlayerRank;
		for name, rank in string.gfind(arg1, "(.+) dies, honorable kill Rank: (.+)") do
			PlayerName = name;
			PlayerRank = string.sub( rank, 1, string.find(rank, "Estimated")-3 );
		end
		if ( PlayerName ) then
			KillWatch_Var.XP = 0;
			KillWatch_Var.Duration = 0;
			KillWatch_Var.Rank = PlayerRank;
			KillWatch_Save(PlayerName, true);
		end
		return;
	end
	
	if ( event == "LOOT_OPENED" ) then
		if ( UnitCanAttack("player", "target") ) then
			KillWatch_ScanLoot();
		end
	end

end

function KillWatch_Save(CreatureName, IsPlayer)
	
	Data_KillStats_Set(CreatureName, "PlayerLevel", UnitLevel("player"));
	Data_KillStats_Set(CreatureName, "Zone", GetZoneText());
	
	if ( Data_KillStats_Get(CreatureName, "PlayerLevel") ~= UnitLevel("player") ) then
		Data_KillStats_ResetDurXP(CreatureName);
	end
	
	Data_KillStats_SetDur(CreatureName, KillWatch_Var.Duration);
	Data_KillStats_AddKill(CreatureName);
	Data_KillStats_SetXP(CreatureName, KillWatch_Var.XP);
	if ( IsPlayer ) then
		Data_KillStats_Set(CreatureName, "Player", true);
		if ( KillWatch_Var.Rank ) then
			Data_KillStats_Set(CreatureName, "Rank", KillWatch_Var.Rank);
		end
	end
	
	KillWatch_ClearVars();
	
end

function KillWatch_ClearVars()
	KillWatch_Var.CombatStart = 0;
	KillWatch_Var.CombatEnd = 0;
	KillWatch_Var.Duration = 0;
	KillWatch_Var.XP = 0;
	KillWatch_Var.Rank = nil;
end

function KillWatch_ScanLoot()

	local CreatureName = UnitName("target");
	
	Data_KillStats_AddLoots(CreatureName);
	
	-- Fill in Fundamental Information
	Data_KillStats_Set(CreatureName, "PlayerLevel", UnitLevel("player"));
	Data_KillStats_Set(CreatureName, "Zone", GetZoneText());
	Data_KillStats_SetLevel(CreatureName, UnitLevel("target"));
	Data_KillStats_Set(CreatureName, "Elite", UnitIsPlusMob("target"));
	Data_KillStats_Set(CreatureName, "Family", UnitCreatureFamily("target"));
	Data_KillStats_Set(CreatureName, "Type", UnitCreatureType("target"));
	
	local numLootItems = LootFrame.numLootItems;
	local texture, item, quantity, quality;
	local link, tooltip;
	for index = 1, numLootItems do
		local slot = index;
		if ( slot <= numLootItems ) then
			texture, item, quantity, quality = GetLootSlotInfo(slot);
			link = GetLootSlotLink(slot);
			-- Coin
			if ( LootSlotIsCoin(slot) and ( UnitIsDead("target") ) ) then
				local copper, silver, gold;
				local total = 0;
				for amount in string.gfind(item, "(%d+) Copper") do
					copper = amount;
				end
				for amount in string.gfind(item, "(%d+) Silver") do
					silver = amount;
				end
				for amount in string.gfind(item, "(%d+) Gold") do
					gold = amount;
				end
				if ( copper ) then
					total = total + copper;
				end
				if ( silver ) then
					total = total + ( silver*100 );
				end
				if ( gold ) then
					total = total + ( gold*10000 );
				end
				Data_KillStats_SetCopper(CreatureName, total);
				
			end
			-- Items
			if ( LootSlotIsItem(slot) ) then
			
				Data_KillStats_SetLoot(CreatureName, item, quantity);
				Data_ItemStats_Set(item, "Texture", texture);
				Data_ItemStats_Set(item, "Quality", quality);
				Data_ItemStats_Set(item, "Link", link);
				
			end
		end
	end
end

function KillWatch_OnShow()

	if not ( KillWatch_Config.Enabled ) then
		return;
	end

	if ( MouseIsOver( MinimapCluster ) ) then
		return;
	end
	
	local lbl = getglobal("GameTooltipTextLeft1");
	if lbl then
		local CreatureName = lbl:GetText();
		
		local stats;
		local color = { };
		local LinesAdded = 0;
		
		if (  UnitIsPlayer("mouseover") ) then
			
			local guild = GetGuildInfo("mouseover");
			if ( guild ) then
				local lines = { };
				local num = GameTooltip:NumLines();
				for i=1, num do
					lines[i] = getglobal("GameTooltipTextLeft"..i):GetText();
				end
				GameTooltip:ClearLines();
				color.r, color.g, color.b = GameTooltip_UnitColor("mouseover");
				GameTooltip:AddLine(lines[1], color.r, color.g, color.b);
				color = KillWatch_Config.Color["Current"];
				GameTooltip:AddLine(guild, color.r, color.g, color.b);
				for i=2,  num do
					GameTooltip:AddLine(lines[i], 1.0, 1.0, 1.0);
				end
				LinesAdded = LinesAdded + 1;
			end
			CreatureName = UnitName("mouseover");
			
			stats = Data_KillStats_GetEntry(CreatureName);
			
			if ( stats ) then
				local rankname, ranknum = GetPVPRankInfo(UnitPVPRank("mouseover"));
				--Data_KillStats_Set(CreatureName, "Rank", rankname);
				Data_KillStats_Set(CreatureName, "RankNum", ranknum);
				Data_KillStats_Set(CreatureName, "Level", UnitLevel("mouseover"));
				Data_KillStats_Set(CreatureName, "Class", UnitClass("mouseover"));
			end
			
		else
			stats = Data_KillStats_GetEntry(CreatureName);
		end
		
		if ( stats ) then
		
			color = KillWatch_Config.Color["Current"];
			
			if ( KillWatch_Config.ShowZone ) and ( stats.Zone ~= "" ) then
				GameTooltip:AddLine(stats.Zone, color.r, color.g, color.b);
				LinesAdded = LinesAdded + 1;
			end
			
			if ( KillWatch_Config.ShowKills ) or
			  ( KillWatch_Config.ShowDur and stats.Dur > 0 ) or
			  ( KillWatch_Config.ShowXP ) or
			  ( KillWatch_Config.ShowCoins and stats.Copper > 0 ) then
				GameTooltip:AddLine(" ", 0.0, 0.0, 0.0);
				LinesAdded = LinesAdded + 1;
			end
			
			if ( KillWatch_Config.ShowKills ) then
				if ( stats.Kills > 0 ) then
					GameTooltip:AddLine("Kills: "..stats.Kills, color.r, color.g, color.b);
				else
					color = KillWatch_Config.Color["Old"];
					if ( stats.Loots > 0 ) then
						GameTooltip:AddLine("Kills: "..stats.Loots, color.r, color.g, color.b);
					else
						GameTooltip:AddLine("Kills: None", color.r, color.g, color.b);
					end
					color = KillWatch_Config.Color["Current"];
				end
				LinesAdded = LinesAdded + 1;
			end
			
			if not ( stats.Player ) then
			
				if ( KillWatch_Config.ShowDur ) and ( stats.Dur > 0 ) then
					if ( stats.PlayerLevel == UnitLevel("player") ) then
						color = KillWatch_Config.Color["Current"];
					else
						color = KillWatch_Config.Color["Old"];
					end
					GameTooltip:AddLine("Combat: "..format("%d", stats.Dur).."s", color.r, color.g, color.b);
					color = KillWatch_Config.Color["Current"];
					LinesAdded = LinesAdded + 1;
				end
			
				if ( KillWatch_Config.ShowXP ) then
					if ( stats.XP > 0 ) then
						if ( stats.PlayerLevel == UnitLevel("player") ) then
							color = KillWatch_Config.Color["Current"];
						else
							color = KillWatch_Config.Color["Old"];
						end
						GameTooltip:AddLine("Experience: "..format("%d", stats.XP).."xp", color.r, color.g, color.b);
						color = KillWatch_Config.Color["Current"];
					else
						color = KillWatch_Config.Color["Old"];
						GameTooltip:AddLine("Experience: None", color.r, color.g, color.b);
						color = KillWatch_Config.Color["Current"];
					end
					LinesAdded = LinesAdded + 1;
				end
			
				if ( KillWatch_Config.ShowCoins ) and ( stats.Copper > 0 ) then
					if ( KillWatch_Config.GraphicCoins ) then
						GameTooltip:AddLine("Coin:", color.r, color.g, color.b);
						KillWatch_SetTooltipMoney("1", stats.Copper, 45);
					else
						local copper, silver, gold = Lib.ParseCoins(stats.Copper);
						if ( gold > 0 ) then
							GameTooltip:AddLine("Coin: "..format("%d",gold).."g "..format("%d",silver).." s "..format("%d",copper).."c", color.r, color.g, color.b);
						elseif ( silver > 0 ) then
							GameTooltip:AddLine("Coin: "..format("%d",silver).."s "..format("%d",copper).."c", color.r, color.g, color.b);
						else
							GameTooltip:AddLine("Coin: "..format("%d",copper).."c", color.r, color.g, color.b);
						end
					end
					LinesAdded = LinesAdded + 1;
				end
			
				local value = 0;
			
				local items = { };
				local percent = { };
				for item in stats.Loot do
					percent[item] = math.floor(100*stats.Loot[item] / stats.Loots);
					local itemvalue = Data_ItemStats_Get(item, "Value");
					if ( itemvalue > 0 ) then
						value = value + math.floor((itemvalue*percent[item]/100));
					end
					table.insert(items, item);
				end
				table.sort(items);
			
				if ( table.getn(items) > 0 ) and ( KillWatch_Config.ShowLoot ) then
					GameTooltip:AddLine(" ", 0.0, 0.0, 0.0);
					LinesAdded = LinesAdded + 1;
				end
			
				if ( KillWatch_Config.ShowLoot) then
					if ( KillWatch_Config.ShowQuality ) then
						for q=0, KillWatch_Config.LootQuality do
							for i=1, table.getn(items) do
								local item = Data_ItemStats_GetItem(items[i]);
								local lootlink = "";
								local lootitem = "";
								if ( item.Quality == q ) then
									lootlink = item.Link;
									if ( lootlink ~= "" ) then
										for j=1, string.len(lootlink) do
											if ( string.sub(lootlink, j, j) ~= "[" ) and ( string.sub(lootlink, j, j) ~= "]" ) then
												lootitem = lootitem..string.sub(lootlink, j, j);
											end
										end
									else
										lootitem = items[i];
									end
									if ( KillWatch_Config.ShowLootPercent ) then
										GameTooltip:AddLine(format("%d",percent[items[i]]).."% "..lootitem, color.r, color.g, color.b);
									else
										GameTooltip:AddLine(lootitem, color.r, color.g, color.b);
									end
									LinesAdded = LinesAdded + 1;
								end
							end
						end
					else
						for i=1, table.getn(items) do
							local item =  items[i];
							if ( KillWatch_Config.ShowLootPercent ) then
								GameTooltip:AddLine(format("%d",percent[item]).."% "..item, color.r, color.g, color.b);
							else
								GameTooltip:AddLine(item, color.r, color.g, color.b);
							end
							LinesAdded = LinesAdded + 1;
						end
					end
				end
			
				if ( stats.Dur > 0 ) and
				( ( KillWatch_Config.ShowRatingCoin ) or
				( KillWatch_Config.ShowRatingXP ) or
				( KillWatch_Config.ShowRatingLoot ) or
				( KillWatch_Config.ShowRating ) ) then
					GameTooltip:AddLine(" ", 0.0, 0.0, 0.0);
					LinesAdded = LinesAdded + 1;
				end
			
				local rating = 0;
				local ratingCoin = stats.Copper / KillStats[CreatureName].Dur;
				rating = rating + ratingCoin;
				if ( KillWatch_Config.ShowRatingCoin ) and ( stats.Copper > 0 ) and ( stats.Dur > 0 ) then
					GameTooltip:AddLine("Rating (Coin): "..format("%.2f",ratingCoin), color.r, color.g, color.b);
					LinesAdded = LinesAdded + 1;
				end
			
				local ratingXP = stats.XP / stats.Dur;
				rating = rating + ratingXP;
				if ( KillWatch_Config.ShowRatingXP ) and ( stats.XP > 0 ) and ( stats.Dur > 0 ) then
					if ( stats.PlayerLevel == UnitLevel("player") ) then
						color = KillWatch_Config.Color["Current"];
					else
						color = KillWatch_Config.Color["Old"];
					end
					GameTooltip:AddLine("Rating (Exp):   "..format("%.2f",ratingXP), color.r, color.g, color.b);
					color = KillWatch_Config.Color["Current"];
					LinesAdded = LinesAdded + 1;
				end
			
				local ratingLoot = value / stats.Dur;
				rating = rating + ratingLoot;
				if ( KillWatch_Config.ShowRatingLoot ) and ( value > 0 ) and ( stats.Dur > 0 ) then
					GameTooltip:AddLine("Rating (Loot): "..format("%.2f",ratingLoot), color.r, color.g, color.b);
					LinesAdded = LinesAdded + 1;
				end
			
				local rating = rating / 3;
				if ( KillWatch_Config.ShowRating ) and ( rating > 0 ) and ( stats.Dur > 0 )  then
					if ( stats.PlayerLevel == UnitLevel("player") ) then
						color = KillWatch_Config.Color["Current"];
					else
						color = KillWatch_Config.Color["Old"];
					end
					GameTooltip:AddLine("Rating: "..format("%.2f",rating), color.r, color.g, color.b);
					color = KillWatch_Config.Color["Current"];
					LinesAdded = LinesAdded + 1;
				end
			
				value = value + stats.Copper;
				if ( KillWatch_Config.ShowValue ) and ( value > 0 ) then
					GameTooltip:AddLine(" ", 0.0, 0.0, 0.0);
					if ( KillWatch_Config.GraphicValue ) then
						GameTooltip:AddLine("Total Value:", color.r, color.g, color.b);
						KillWatch_SetTooltipMoney("2", value, 80);
					else
						local copper, silver, gold = Lib.ParseCoins(value);
						if ( gold > 0 ) then
							GameTooltip:AddLine("Total Value: "..format("%d",gold).."g "..format("%d",silver).." s "..format("%d",copper).."c", color.r, color.g, color.b);
						elseif ( silver > 0 ) then
							GameTooltip:AddLine("Total Value: "..format("%d",silver).."s "..format("%d",copper).."c", color.r, color.g, color.b);
						else
							GameTooltip:AddLine("Total Value: "..format("%d",copper).."c", color.r, color.g, color.b);
						end
					end
					LinesAdded = LinesAdded + 2;
				end
			
			end
		
		end
			
		KillWatch_ResizeTooltip(LinesAdded);
			
	end
end

function KillWatch_OnHide()
	getglobal("KillWatch_MoneyFrame1"):Hide();
	getglobal("KillWatch_MoneyFrame2"):Hide();
end

function KillWatch_SetTooltipMoney(frame, money, width)
	local numLines = GameTooltip:NumLines();
	local moneyFrame = getglobal("KillWatch_MoneyFrame"..frame);
	moneyFrame:SetPoint("LEFT", "GameTooltipTextLeft"..numLines, "LEFT", width, 0);
	moneyFrame:Show();
	MoneyFrame_Update(moneyFrame:GetName(), money);
end

function KillWatch_ResizeTooltip(LinesAdded)
	if ( LinesAdded > 0 ) then
		GameTooltip:SetHeight(GameTooltip:GetHeight() + (14 * LinesAdded));
		local frame;
		frame = getglobal("KillWatch_MoneyFrame1");
		if ( frame:IsVisible() ) then
			if ( ( frame:GetWidth()+45 ) > GameTooltip:GetWidth() ) then
				GameTooltip:SetWidth( frame:GetWidth() + 45 + 20 );
			end
		end
		frame = getglobal("KillWatch_MoneyFrame2");
		if ( frame:IsVisible() ) then
			if ( ( frame:GetWidth()+80 ) > GameTooltip:GetWidth() ) then
				GameTooltip:SetWidth( frame:GetWidth() + 80 + 20 );
			end
		end
		for i=1, GameTooltip:NumLines() do
			local text = getglobal("GameTooltipTextLeft" .. i)
			if ( ( text:GetWidth()+30 ) > GameTooltip:GetWidth() ) then
				GameTooltip:SetWidth( text:GetWidth() + 30 );
			end
		end

	end
end
