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

function ItemWatch_OnLoad()

	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("MERCHANT_SHOW");
	
	-- Register Slash Commands
	SLASH_ItemWatch1 = "/itemwatch";
	SLASH_ItemWatch2 = "/iw";
	SlashCmdList["ItemWatch"] = function(msg)
		ItemWatch_ChatCommandHandler(msg);
	end
	
	ChatMessage("Rauen's ItemWatch Loaded.");
end

function ItemWatch_ChatCommandHandler(msg)

	-- Menu
	if ( iwUI:IsVisible() ) then
		PlaySound("igMainMenuClose");
		HideUIPanel(iwUI);
	else
		PlaySound("igMainMenuOpen");
		ShowUIPanel(iwUI);
	end
	
end

function ItemWatch_Reset()

	ItemWatch_Config = { };
	ItemWatch_Config.Enabled = true;
	ItemWatch_Config.Version = ITEMWATCH_VERSION;
	ItemWatch_Config.ShowNum = false;
	ItemWatch_Config.ShowCraft = true;
	ItemWatch_Config.ShowProduct = true;
	ItemWatch_Config.ShowValue = true;
	ItemWatch_Config.ShowEffect = true;
	
	ItemWatch_Config.Color = {
		["optimal"] = { r = 1.00, g = 0.50, b = 0.25 },
		["medium"] = { r = 1.00, g = 1.00, b = 0.00 },
		["easy"] = { r = 0.25, g = 0.75, b = 0.25 },
		["trivial"] = { r = 0.50, g = 0.50, b = 0.50 },
		["ShowCraft"] = { r = 0.75, g = 0.75, b = 1.0 },
		["ShowValue"] = { r = 1.0, g = 1.0, b = 0.0 },
		["ShowEffect"] = { r = 0.75, g = 1.0, b = 0.75 },
}
	
	ChatMessage("ItemWatch configuration reset.");
	
end

function ItemWatch_ResetStats()
	Data_ItemStats_Reset();
	ChatMessage("ItemWatch statistics reset.");
end

function ItemWatch_OnEvent()

	if ( event == "VARIABLES_LOADED") then
		if ( ItemWatch_Config ) then
			if ( ItemWatch_Config.Version ~= ITEMWATCH_VERSION ) then
				ChatMessage("ItemWatch updated to v"..ITEMWATCH_VERSION..".");
				ItemWatch_Reset();
			end
		else
			ChatMessage("ItemWatch updated to v"..ITEMWATCH_VERSION..".");
			ItemWatch_Reset();
		end
		return;
	end

	if ( event == "MERCHANT_SHOW" ) then
		return ItemWatch_MerchantScan(this);
	end
	
	if ( event == "TOOLTIP_ADD_MONEY" ) then
		return ItemWatch_ToolTipMoney(arg1, arg2);
	end
  
end

ItemWatch_Saved_GameTooltip_OnEvent = GameTooltip_OnEvent;
GameTooltip_OnEvent = function ()
	if event ~= "CLEAR_TOOLTIP" then
        return ItemWatch_Saved_GameTooltip_OnEvent();
    end 
end

function ItemWatch_ToolTipMoney(frameName, money)
	if InRepairMode() then
		return;
	end
	ItemWatch_LastItemMoney = money;
end

function ItemWatch_OnShow()
	
	if not ( ItemWatch_Config.Enabled ) then
		return;
	end
	
	if ( MerchantFrame:IsVisible() ) then
		return;
	end
	
	if ( MouseIsOver(MinimapCluster) or MouseIsOver(BuffFrame) ) then
		return;
	end
	
	local label = getglobal("GameTooltipTextLeft1");
	if ( label ) then
		local itemName = label:GetText();
		if ( PaperDollFrame:IsVisible() ) then
			if ( ItemWatch_Config.ShowEffect ) then
				ItemWatch_AddEffects(itemName);
			end
		else
			if not ( IsShiftKeyDown() ) then
				if ( TradeSkillFrame:IsVisible() ) then
					if ( ItemWatch_Config.ShowProduct ) then
						ItemWatch_AddProducts(itemName, "Skill");
					end
					return;
				elseif ( CraftFrame:IsVisible() ) then
					if ( ItemWatch_Config.ShowProduct ) then
						ItemWatch_AddProducts(itemName, "Craft");
					end
					return;
				end
			end
			if ( ItemWatch_Config.ShowCraft ) then
				ItemWatch_AddCrafts(itemName);
			end
			if ( ItemWatch_Config.ShowValue ) then
				ItemWatch_AddValue(itemName);
			end
		end
	end
end

function ItemWatch_OnHide()
	this = this:GetParent();
	return GameTooltip_ClearMoney();
end

function ItemWatch_AddEffects(itemName)

	local summary = false;

	local str = 0;
	local sta = 0;
	local agi = 0;
	local int = 0;
	local spr = 0;
	
	local bar = 0;
	local ar = 0;
	
	local bpow = 0;
	local pow = 0
	
	local dps = 0;
	local crit = 0;
	local spellcrit = 0;
	local dod = 0;
	
	local health = 0;
	local mana = 0;
	local healthregen = 0;
	local manaregen = 0;

	-- Record Bonuses
	local text = getglobal("GameTooltipTextLeft1"):GetText();
	if ( text == "Party Options" ) or ( string.find(text, UnitName("player") ) ) then
		summary = true;
		str = UnitStat("player", 1);
		agi = UnitStat("player", 2);
		sta = UnitStat("player", 3);
		int = UnitStat("player", 4);
		spr = UnitStat("player", 5);
		ar = UnitArmor("player");
		pow = UnitAttackPower("player");
	else
		for i=1, GameTooltip:NumLines() do
			text = getglobal("GameTooltipTextLeft" .. i):GetText();
			for bonus in string.gfind(text, "(%d+) Armor") do
				if ( text == bonus.." Armor" ) then
					bar = bar + bonus;
					ar = ar + bonus;
				end
			end
			for bonus in string.gfind(text, "Armor +(.+)") do
				if ( text == "Armor +"..bonus ) then
					ar = ar + bonus;
				end
			end
			for bonus in string.gfind(text, "Reinforced Armor +(.+)") do
				ar = ar + bonus;
			end
			for bonus in string.gfind(text, "+(%d+) Strength") do
				str = str + bonus;
			end
			for bonus in string.gfind(text, "+(%d+) Stamina") do
				sta = sta + bonus;
			end
			for bonus in string.gfind(text, "+(%d+) Agility") do
				agi = agi + bonus;
			end
			for bonus in string.gfind(text, "+(%d+) Intellect") do
				int = int + bonus;
			end
			for bonus in string.gfind(text, "+(%d+) Spirit") do
				spr = spr + bonus;
			end
			for bonus in string.gfind(text, "+(%d+) Attack Power") do
				bpow = bpow +bonus;
				pow = pow + bonus;
			end
		end
	end
	
	-- Calculate Effects
	local class = UnitClass("player");
	if ( class == "Druid" ) then
		health = sta*10;
		mana = int*15;
		healthregen = spr;
		manaregen = spr;
		ar = ar + agi*2;
		crit = crit + agi/20;
		spellcrit = int;
		dod = dod + agi/20;
		pow = pow + str*2;
		dps = dps + pow/14;
	end
	if ( class == "Hunter" ) then
		health = sta*10;
		mana = int*15;
		healthregen = spr;
		manaregen = spr;
		ar = ar + agi*2;
		crit = crit + agi/53;
		spellcrit = int;
		dod = dod + agi/26.5;
		pow = pow + agi + str;
		dps = dps + pow/14;
	end
	if ( class == "Mage" ) then
		health = sta*10;
		mana = int*15;
		healthregen = spr;
		manaregen = spr;
		ar = ar + agi*2;
		crit = crit + agi/20;
		spellcrit = int;
		dod = dod + agi/20;
		pow = pow + str*2;
		dps = dps + pow/14;
	end
	if ( class == "Paladin" ) then
		health = sta*10;
		mana = int*15;
		healthregen = spr;
		manaregen = spr;
		ar = ar + agi*2;
		crit = crit + agi/20;
		spellcrit = int;
		dod = dod + agi/20;
		pow = pow + str*2;
		dps = dps + pow/14;
	end
	if ( class == "Priest" ) then
		health = sta*10;
		mana = int*15;
		healthregen = spr;
		manaregen = spr;
		ar = ar + agi*2;
		crit = crit + agi/20;
		spellcrit = int;
		dod = dod + agi/20;
		pow = pow + str*2;
		dps = dps + pow/14;
	end
	if ( class == "Rogue" ) then
		health = sta*10;
		healthregen = spr;
		ar = ar + agi*2;
		crit = crit + agi/29;
		dod = dod + agi/14.5;
		pow = pow + agi + str;
		dps = dps + pow/14;
	end
	if ( class == "Shaman" ) then
		health = sta*10;
		mana = int*15;
		healthregen = spr;
		manaregen = spr;
		ar = ar + agi*2;
		crit = crit + agi/20;
		spellcrit = int;
		dod = dod + agi/20;
		pow = pow + str*2;
		dps = dps + pow/14;
	end
	if ( class == "Warlock" ) then
		health = sta*10;
		mana = int*15;
		healthregen = spr;
		manaregen = spr;
		ar = ar + agi*2;
		crit = crit + agi/20;
		spellcrit = int;
		dod = dod + agi/20;
		pow = pow + str*2;
		dps = dps + pow/14;
	end
	if ( class == "Warrior" ) then
		health = sta*10;
		healthregen = spr;
		ar = ar + agi*2;
		crit = crit + agi/20;
		dod = dod + agi/20;
		pow = pow + str*2;
		dps = dps + pow/14;
	end
	
	-- Add Effects
	color = ItemWatch_Config.Color["ShowEffect"];
	LinesAdded = 0;
	if ( ar > bar ) or
	  ( health > 0 ) or
	  ( mana > 0 ) or
	  ( pow > bpow ) or
	  ( dps > 0 ) or
	  ( crit > 0 ) or
	  ( dod > 0 ) then
		GameTooltip:AddLine(" ", 0.0, 0.0, 0.0);
		if ( summary ) then
			GameTooltip:AddLine(UnitName("player").."'s Effective Bonus", 1.0, 1.0, 1.0);
		else
			GameTooltip:AddLine("Effective Bonus", 1.0, 1.0, 1.0);
		end
		LinesAdded = LinesAdded + 2;
	end
	if ( ar > bar ) and not ( summary ) then
		GameTooltip:AddLine(ar.." Armor", color.r, color.g, color.b);
		LinesAdded = LinesAdded + 1;
	end
	if ( health > 0 ) then
		GameTooltip:AddLine("+"..format("%d",health).." Health", color.r, color.g, color.b);
		LinesAdded = LinesAdded + 1;
	end
	if ( mana > 0 ) then
		GameTooltip:AddLine("+"..format("%d",mana).." Mana", color.r, color.g, color.b);
		LinesAdded = LinesAdded + 1;
	end
	if ( pow > bpow ) then
		GameTooltip:AddLine("+"..format("%d",pow).." Attack Power", color.r, color.g, color.b);
		LinesAdded = LinesAdded + 1;
	end
	if ( dps > 0 ) then
		GameTooltip:AddLine("+"..format("%0.2f",dps).."% Dps", color.r, color.g, color.b);
		LinesAdded = LinesAdded + 1;
	end
	if ( crit > 0 ) then
		GameTooltip:AddLine("+"..format("%0.2f",crit).."% Crit Chance", color.r, color.g, color.b);
		LinesAdded = LinesAdded + 1;
	end
	if ( spellcrit > 0 ) then
		GameTooltip:AddLine("+Spell Crit Chance", color.r, color.g, color.b);
		LinesAdded = LinesAdded + 1;
	end
	if ( dod > 0 ) then
		GameTooltip:AddLine("+"..format("%0.2f",dod).."% Dodge Chance", color.r, color.g, color.b);
		LinesAdded = LinesAdded + 1;
	end
	if ( healthregen > 0 ) then
		GameTooltip:AddLine("+Health Regeneration", color.r, color.g, color.b);
		LinesAdded = LinesAdded + 1;
	end
	if ( manaregen > 0 ) then
		GameTooltip:AddLine("+Mana Regeneration", color.r, color.g, color.b);
		LinesAdded = LinesAdded + 1;
	end
	if ( summary ) then
		GameTooltip:AddLine(" ", 0.0, 0.0, 0.0);
		LinesAdded = LinesAdded + 1;
	end
	
	ItemWatch_ResizeTooltip(LinesAdded);

end

function ItemWatch_AddCrafts(itemName)

	local color = ItemWatch_Config.Color["ShowCraft"];
	local LinesAdded = 0;
	    
	-- Check if Alchemy Component
	for i=1, table.getn(ItemWatch_Components_Alchemy) do
			if ( itemName == ItemWatch_Components_Alchemy[i] ) then
			GameTooltip:AddLine("Alchemy", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
			
	-- Check if Blacksmithing Component
	for i=1, table.getn(ItemWatch_Components_Blacksmithing) do
		if ( itemName == ItemWatch_Components_Blacksmithing[i] ) then
			GameTooltip:AddLine("Blacksmithing", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
			
	-- Check if Armorsmithing Component
	for i=1, table.getn(ItemWatch_Components_Blacksmithing_Armorsmith) do
		if ( itemName == ItemWatch_Components_Blacksmithing_Armorsmith[i] ) then
			GameTooltip:AddLine("Armor Blacksmithing", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Weaponsmith Component
	for i=1, table.getn(ItemWatch_Components_Blacksmithing_Weaponsmith) do
		if ( itemName == ItemWatch_Components_Blacksmithing_Weaponsmith[i] ) then
			GameTooltip:AddLine("Weapon Blacksmithing", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Axesmith Component
	for i=1, table.getn(ItemWatch_Components_Blacksmithing_Axesmith) do
		if ( itemName == ItemWatch_Components_Blacksmithing_Axesmith[i] ) then
			GameTooltip:AddLine("Axe Blacksmithing", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Hammersmith Component
	for i=1, table.getn(ItemWatch_Components_Blacksmithing_Hammersmith) do
		if ( itemName == ItemWatch_Components_Blacksmithing_Hammersmith[i] ) then
			GameTooltip:AddLine("Hammer Blacksmithing", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Swordsmith Component
	for i=1, table.getn(ItemWatch_Components_Blacksmithing_Swordsmith) do
		if ( itemName == ItemWatch_Components_Blacksmithing_Swordsmith[i] ) then
			GameTooltip:AddLine("Sword Blacksmithing", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Cooking Component
	for i=1, table.getn(ItemWatch_Components_Cooking) do
		if ( itemName == ItemWatch_Components_Cooking[i] ) then
			GameTooltip:AddLine("Cooking", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
	
	-- Check if Druid Component
	for i=1, table.getn(ItemWatch_Components_Druid) do
		if ( itemName == ItemWatch_Components_Druid[i] ) then
			GameTooltip:AddLine("Druid Spells", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Enchanting Component
	for i=1, table.getn(ItemWatch_Components_Enchanting) do
		if ( itemName == ItemWatch_Components_Enchanting[i] ) then
			GameTooltip:AddLine("Enchanting", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Engineering Component
	for i=1, table.getn(ItemWatch_Components_Engineering) do
	if ( itemName == ItemWatch_Components_Engineering[i] ) then
			GameTooltip:AddLine("Engineering", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Gnome Engineering Component
	for i=1, table.getn(ItemWatch_Components_Engineering_Gnome) do
		if ( itemName == ItemWatch_Components_Engineering_Gnome[i] ) then
			GameTooltip:AddLine("Gnomish Engineering", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Goblin Engineering Component
	for i=1, table.getn(ItemWatch_Components_Engineering_Goblin) do
		if ( itemName == ItemWatch_Components_Engineering_Goblin[i] ) then
			GameTooltip:AddLine("Goblin Engineering", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if FirstAid Component
	for i=1, table.getn(ItemWatch_Components_FirstAid) do
		if ( itemName == ItemWatch_Components_FirstAid[i] ) then
			GameTooltip:AddLine("First Aid", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Fishing Component
	for i=1, table.getn(ItemWatch_Components_Fishing) do
		if ( itemName == ItemWatch_Components_Fishing[i] ) then
			GameTooltip:AddLine("Fishing", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Leatherworking Component
	for i=1, table.getn(ItemWatch_Components_Leatherworking) do
		if ( itemName == ItemWatch_Components_Leatherworking[i] ) then
			GameTooltip:AddLine("Leatherworking", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Dragonscale Leatherworking Component
	for i=1, table.getn(ItemWatch_Components_Leatherworking_Dragonscale) do
		if ( itemName == ItemWatch_Components_Leatherworking_Dragonscale[i] ) then
			GameTooltip:AddLine("Dragonscale Leatherworking", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Elemental Leatherworking Component
	for i=1, table.getn(ItemWatch_Components_Leatherworking_Elemental) do
		if ( itemName == ItemWatch_Components_Leatherworking_Elemental[i] ) then
			GameTooltip:AddLine("Elemental Leatherworking", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Tribal Leatherworking Component
	for i=1, table.getn(ItemWatch_Components_Leatherworking_Tribal) do
		if ( itemName == ItemWatch_Components_Leatherworking_Tribal[i] ) then
			GameTooltip:AddLine("Tribal Leatherworking", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
	
	-- Check if Lockpicking Component
	for i=1, table.getn(ItemWatch_Components_Lockpicking) do
		if ( itemName == ItemWatch_Components_Lockpicking[i] ) then
			GameTooltip:AddLine("Lockpicking", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
	
	-- Check if Mage Component
	for i=1, table.getn(ItemWatch_Components_Mage) do
		if ( itemName == ItemWatch_Components_Mage[i] ) then
			GameTooltip:AddLine("Mage Spells", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Mining Component
	for i=1, table.getn(ItemWatch_Components_Mining) do
		if ( itemName == ItemWatch_Components_Mining[i] ) then
			GameTooltip:AddLine("Mining", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
	
	-- Check if Paladin Component
	for i=1, table.getn(ItemWatch_Components_Paladin) do
		if ( itemName == ItemWatch_Components_Paladin[i] ) then
			GameTooltip:AddLine("Paladin Spells", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Poisons Component
	for i=1, table.getn(ItemWatch_Components_Poisons) do
		if ( itemName == ItemWatch_Components_Poisons[i] ) then
			GameTooltip:AddLine("Rogue Tricks", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
	
	-- Check if Priest Component
	for i=1, table.getn(ItemWatch_Components_Priest) do
		if ( itemName == ItemWatch_Components_Priest[i] ) then
			GameTooltip:AddLine("Priest Spells", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
	
	-- Check if Shaman Component
	for i=1, table.getn(ItemWatch_Components_Shaman) do
		if ( itemName == ItemWatch_Components_Shaman[i] ) then
			GameTooltip:AddLine("Shaman Spells", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Skinning Component
	for i=1, table.getn(ItemWatch_Components_Skinning) do
		if ( itemName == ItemWatch_Components_Skinning[i] ) then
			GameTooltip:AddLine("Skinning", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
		
	-- Check if Tailoring Component
	for i=1, table.getn(ItemWatch_Components_Tailoring) do
		if ( itemName == ItemWatch_Components_Tailoring[i] ) then
			GameTooltip:AddLine("Tailoring", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
	
	-- Check if Warlock Component
	for i=1, table.getn(ItemWatch_Components_Warlock) do
		if ( itemName == ItemWatch_Components_Warlock[i] ) then
			GameTooltip:AddLine("Warlock Spells", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		end
	end
	
	ItemWatch_ResizeTooltip(LinesAdded);
	
end

function ItemWatch_AddValue(itemName)
	
	if ( MerchantFrame:IsVisible() ) then
		return;
	end
	
	local item = Data_ItemStats_GetItem(itemName);
	if not ( item ) then
		return;
	end
	
	local color = ItemWatch_Config.Color["ShowValue"];
	local LinesAdded = 0;
	
	if ( item.Value ) then
		if ( item.Value == -1 ) then
			return;
		end
		local price = item.Value;
		if ( price == 0 ) then
			GameTooltip:AddLine("No Merchant Value", color.r, color.g, color.b);
			LinesAdded = LinesAdded + 1;
		else
			GameTooltip:AddLine("Merchant Value (each):", color.r, color.g, color.b);
			SetTooltipMoney(GameTooltip, price);
			LinesAdded = LinesAdded + 2;
		end
	end
	
	ItemWatch_ResizeTooltip(LinesAdded);

end

function ItemWatch_AddProducts(itemName, trade)

	local LinesAdded = 0;
	
	if ( trade == "Skill" ) then
	
		for skillIndex=1, GetNumTradeSkills() do
			local skillName, skillType, numAvailable = GetTradeSkillInfo(skillIndex);
			if ( skillType ~= "header" ) then
				local reagentName, color;
				for i=1, GetTradeSkillNumReagents(skillIndex) do
					reagentName = GetTradeSkillReagentInfo(skillIndex, i);
					if ( reagentName == itemName ) then
						color = ItemWatch_Config.Color[skillType];
						if ( numAvailable > 0 ) and ( ItemWatch_Config.ShowNum ) then
							GameTooltip:AddLine(skillName.." ["..numAvailable.."]", color.r, color.g, color.b);
						else
							GameTooltip:AddLine(skillName, color.r, color.g, color.b);
						end
						LinesAdded = LinesAdded + 1;
					end
				end
			end
		end
	
	end
	
	if ( trade == "Craft" ) then
	
		for skillIndex=1, GetNumCrafts() do
			local skillName, _, skillType, numAvailable = GetCraftInfo(skillIndex);
			if ( skillType ~= "header" ) then
				local reagentName, color;
				for i=1, GetCraftNumReagents(skillIndex) do
					reagentName = GetCraftReagentInfo(skillIndex, i);
					if ( reagentName == itemName ) then
						color = ItemWatch_Config.Color[skillType];
						if ( numAvailable > 0 ) and ( ItemWatch_Config.ShowNum ) then
							GameTooltip:AddLine(skillName.." ["..numAvailable.."]", color.r, color.g, color.b);
						else
							GameTooltip:AddLine(skillName, color.r, color.g, color.b);
						end
						LinesAdded = LinesAdded + 1;
					end
				end
			end
		end
	
	end
	
	ItemWatch_ResizeTooltip(LinesAdded);
	
end

function ItemWatch_ResizeTooltip(LinesAdded)
	if ( LinesAdded > 0 ) then
		local oldh = GameTooltip:GetHeight();
		local newh = oldh + ( 14*LinesAdded );
		GameTooltip:SetHeight(newh);
		for i=1, GameTooltip:NumLines() do
			local text = getglobal("GameTooltipTextLeft" .. i)
			if ( ( text:GetWidth()+30 ) > GameTooltip:GetWidth() ) then
				GameTooltip:SetWidth( text:GetWidth() + 30 );
			end
		end
	end
end

function ItemWatch_MerchantScan(frame)
	if not ( ItemWatch_Config.Enabled ) then
		return;
	end
	frame:RegisterEvent("TOOLTIP_ADD_MONEY");
	for bag=0, NUM_BAG_FRAMES do
		for slot=1, GetContainerNumSlots(bag) do
			local item = Lib.GetItemName(bag, slot);
			if ( item ~= "" ) then
				ItemWatch_LastItemMoney = 0;
				ItemWatch_Tooltip:SetBagItem(bag, slot);
				local texture, count, _, quality = GetContainerItemInfo(bag, slot);
				local value = ItemWatch_LastItemMoney / count;
				Data_ItemStats_Set(item, "Value", value);
				Data_ItemStats_Set(item, "Texture", texture);
				Data_ItemStats_Set(item, "Quality", quality);
				Data_ItemStats_Set(item, "Link", GetContainerItemLink(bag, slot));
			end
		end
	end
	frame:UnregisterEvent("TOOLTIP_ADD_MONEY");
end
