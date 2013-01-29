function Data_ItemStats_Reset()
	ItemStats = { };
end

function Data_ItemStats_Check(item)
	if not ( ItemStats ) then
		Data_ItemStats_Reset();
	end
	if not ( ItemStats[item] ) then
		Data_ItemStats_CreateBlankEntry(item);
	end
end

function Data_ItemStats_GetItem(item)
	return ItemStats[item];
end

function Data_ItemStats_RemoveItem(name)
	local temp = { };
	for key in ItemStats do
		if not ( key == name ) then
			temp[key] = ItemStats[key];
		end
	end
	ItemStats = { };
	ItemStats = temp;
end

function Data_ItemStats_Get(item, field)
	Data_ItemStats_Check(item);
	if ( field == "Value" ) then
		return ItemStats[item].Value;
	end
	if ( field == "Texture" ) then
		return ItemStats[item].Texture;
	end
	if ( field == "Quality" ) then
		return ItemStats[item].Quality;
	end
	if ( field == "Link" ) then
		return ItemStats[item].Link;
	end
	return nil;
end

function Data_ItemStats_CreateBlankEntry(item)
	ItemStats[item] = { };
	ItemStats[item].Name = item;
	ItemStats[item].Value = -1;
	ItemStats[item].Texture = "";
	ItemStats[item].Quality = 0;
	ItemStats[item].Link = "";
end

function Data_ItemStats_Set(item, field, value)
	Data_ItemStats_Check(item);
	if ( field == "Value" ) then
		if ( value > -1 ) then
			ItemStats[item].Value = value;
		end
	end
	if ( field == "Texture" ) then
		if ( value ~= "" ) then
			ItemStats[item].Texture = value;
		end
	end
	if ( field == "Quality" ) then
		if ( value > -1 ) then
			ItemStats[item].Quality = value;
		end
	end
	if ( field == "Link" ) then
		if ( value ~= "" ) then
			ItemStats[item].Link = value;
		end
	end
end
