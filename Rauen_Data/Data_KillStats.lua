function Data_KillStats_Reset()
	KillStats = { };
	KillStats.Zones = { };
end

function Data_KillStats_Check(name)
	if not ( KillStats ) then
		Data_KillStats_Reset();
	end
	if not ( KillStats[name] ) then
		Data_KillStats_CreateBlankEntry(name);
	end
end

function Data_KillStats_CheckZone(zone)
	for i=1, table.getn(KillStats.Zones) do
		if ( KillStats.Zones[i] == zone ) then
			return;
		end
	end
	tinsert(KillStats.Zones, zone);
end

function Data_KillStats_GetZones()
	return KillStats.Zones;
end

function Data_KillStats_GetEntry(name)
	return KillStats[name];
end

function Data_KillStats_RemoveEntry(name)
	
	local temp = { };
	for key in KillStats do
		if not ( key == name ) then
			temp[key] = KillStats[key];
		end
	end
	KillStats = { };
	KillStats = temp;
	
end

function Data_KillStats_RemoveLoot(name, item)
	
	if not ( KillStats[name] ) then
		return;
	end
	
	local temp = { };
	for key in KillStats[name].Loot do
		if not ( key == item ) then
			temp[key] = KillStats[name].Loot[key];
		end
	end
	KillStats[name].Loot = { };
	KillStats[name].Loot = temp;
	
end

function Data_KillStats_Get(name, field)
	Data_KillStats_Check(name);
	if ( field == "PlayerLevel" ) then
		return KillStats[name].PlayerLevel;
	end
	if ( field == "Zone" ) then
		return KillStats[name].Zone;
	end
	if ( field == "Level" ) then
		return KillStats[name].Level;
	end
	if ( field == "Class" ) then
		return KillStats[name].Class;
	end
	if ( field == "Elite" ) then
		return KillStats[name].Elite;
	end
	if ( field == "Player" ) then
		return KillStats[name].Player;
	end
	if ( field == "Rank" ) then
		return KillStats[name].Rank;
	end
	if ( field == "RankNum" ) then
		return KillStats[name].RankNum;
	end
	if ( field == "Family" ) then
		return KillStats[name].Family;
	end
	if ( field == "Type" ) then
		return KillStats[name].Type;
	end
	if ( field == "Kills" ) then
		return KillStats[name].Kills;
	end
	if ( field == "Dur" ) then
		return KillStats[name].Dur;
	end
	if ( field == "XP" ) then
		return KillStats[name].XP;
	end
	if ( field == "Copper" ) then
		return KillStats[name].Copper;
	end
	if ( field == "Loots" ) then
		return KillStats[name].Loots;
	end
	return nil;
end

function Data_KillStats_GetNumItems(name, item)
	local num = 0;
	if not ( KillStats[name] ) then
		return 0;
	end
	local data = KillStats[name].Loot;
	if ( data ) then
		for entry in data do
			if ( string.upper(entry) == string.upper(item) ) then
				num = data[entry];
			end
		end
	end
	return num;
end

function Data_KillStats_GetCreatureHasItem(name, item)
	for entry in KillStats do
		if ( string.find(string.upper(entry), string.upper(name)) ) then
			if ( KillStats[entry].Loot[item] ) then
				return true;
			end
		end
	end
	return false;
end

function Data_KillStats_GetDropRate(name, item)
	if ( KillStats[name] ) then
		return math.floor(100*KillStats[name].Loot[item] / KillStats[name].Loots);
	end
	return nil;
end

function Data_KillStats_GetNumCreaturesHaveItem(itemName)
	local num = 0;
	for key in KillStats do
		if ( key ~= "Zones" ) then
			for item in KillStats[key].Loot do
				if ( item == itemName ) then
					num = num + 1;
				end
			end
		end
	end
	return num;
end

function Data_KillStats_GetCreatureValue(name)
	if ( KillStats[name].Copper ) then
		local value = KillStats[name].Copper;
		local percent;
		for item in KillStats[name].Loot do
			percent = math.floor(100* KillStats[name].Loot[item] /  KillStats[name].Loots);
			local itemvalue = Data_ItemStats_Get(item, "Value");
			if ( itemvalue > 0 ) then
				value = value + math.floor((itemvalue*percent/100));
			end
		end
		return value;
	end
	return 0;
end

function Data_KillStats_CreateBlankEntry(name)
	KillStats[name] = { };
	KillStats[name].Name = name;
	KillStats[name].PlayerLevel = 0;
	KillStats[name].Zone = "";
	KillStats[name].Level = 0;
	KillStats[name].Class = "";
	KillStats[name].Elite = false;
	KillStats[name].Player = false;
	KillStats[name].Rank = "";
	KillStats[name].RankNum = 0;
	KillStats[name].Family = "";
	KillStats[name].Type = "";
	KillStats[name].Kills = 0;
	KillStats[name].Dur = 0;
	KillStats[name].XP = 0;
	KillStats[name].Copper = 0;
	KillStats[name].Loots = 0;
	KillStats[name].Loot = { };
end

function Data_KillStats_Set(name, field, value)
	Data_KillStats_Check(name);
	if ( field == "PlayerLevel" ) then
		KillStats[name].PlayerLevel = value;
	end
	if ( field == "Zone" ) then
		KillStats[name].Zone = value;
		Data_KillStats_CheckZone(value);
	end
	if ( field == "Level" ) then
		KillStats[name].Level = value;
	end
	if ( field == "Class" ) then
		KillStats[name].Class = value;
	end
	if ( field == "Elite" ) then
		KillStats[name].Elite = value;
	end
	if ( field == "Player" ) then
		KillStats[name].Player = value;
	end
	if ( field == "Rank" ) then
		KillStats[name].Rank = value;
	end
	if ( field == "RankNum" ) then
		KillStats[name].RankNum = value;
	end
	if ( field == "Family" ) then
		KillStats[name].Family = value;
	end
	if ( field == "Type" ) then
		KillStats[name].Type = value;
	end
	if ( field == "Kills" ) then
		KillStats[name].Kills = value;
	end
	if ( field == "Dur" ) then
		KillStats[name].Dur = value;
	end
	if ( field == "XP" ) then
		KillStats[name].XP = value;
	end
	if ( field == "Copper" ) then
		KillStats[name].Copper = value;
	end
	if ( field == "Loots" ) then
		KillStats[name].Loots = value;
	end
end

function Data_KillStats_ResetDurXP(name)
	Data_KillStats_Check(name);
	KillStats[name].Dur = 0;
	KillStats[name].XP = 0;
end

function Data_KillStats_SetDur(name, duration)
	Data_KillStats_Check(name);
	local dur = KillStats[name].Dur;
	if ( dur == 0 ) then
		dur = 0 + duration;
	else
		dur = math.floor(( duration + dur ) / 2);
	end
	KillStats[name].Dur = dur;
end

function Data_KillStats_AddKill(name)
	Data_KillStats_Check(name);
	local kills = KillStats[name].Kills;
	kills = kills + 1;
	KillStats[name].Kills = kills;
end

function Data_KillStats_AddLoots(name)
	Data_KillStats_Check(name);
	local loots = KillStats[name].Loots;
	loots = loots + 1;
	KillStats[name].Loots = loots;
end

function Data_KillStats_SetXP(name, experience)
	Data_KillStats_Check(name);
	local xp = KillStats[name].XP;
	if ( xp == 0 ) then
		xp = 0 + experience;
	else
		xp = math.floor(( experience + xp ) / 2);
	end
	KillStats[name].XP = xp;
end

function Data_KillStats_SetLevel(name, targetlevel)
	Data_KillStats_Check(name);
	local level = KillStats[name].Level;
	if ( level == 0 ) then
		level = targetlevel;
	else
		level = math.floor(( level + targetlevel ) / 2) ;
	end
	KillStats[name].Level = level;
end

function Data_KillStats_SetCopper(name, amount)
	Data_KillStats_Check(name);
	local copper = KillStats[name].Copper;
	if ( copper == 0 ) then
		copper = amount;
	else
		copper = math.floor( ( amount + copper) / 2 );
	end
	KillStats[name].Copper = copper;
end

function Data_KillStats_SetLoot(name, item, quantity)
	Data_KillStats_Check(name);
	if ( KillStats[name].Loot[item] ) then
		KillStats[name].Loot[item] = KillStats[name].Loot[item] + quantity;
	else
		KillStats[name].Loot[item] = quantity;
	end
end
