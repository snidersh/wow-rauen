function ChatMessage(message)
	DEFAULT_CHAT_FRAME:AddMessage(message);
end

function ChannelMessage(message, channel)
	SendChatMessage(message, channel);
end

function ErrorMessage(message)
	UIErrorsFrame:AddMessage(message, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
end

Lib = {

	GetItemName = function (bag, slot)
		local name;
		getglobal("GameTooltipTextLeft1"):SetText("");
		GameTooltip:SetBagItem( bag, slot );
		name = getglobal("GameTooltipTextLeft1"):GetText();
		if ( name == nil ) then
			name = "";
		end
		return name;
	end;

	GetNumItems = function (bag, item)
		local num = 0;
		local stack = 0;
		bag = bag - 1;
		for n = 1, GetContainerNumSlots(bag) do
			if ( Lib.GetItemName(bag, n) == item ) then
			_, stack = GetContainerItemInfo(bag, n);
				num = num + stack;
			end
		end
		return num;
	end;

	IsInPack = function (item)
		for m = 0, 4 do
			for n = 1, 16 do
				if ( Lib.GetItemName(m, n) == item ) then
					return true;
				end
			end
		end
		return false;
	end;

	ParseCoins = function (coins)
		local copper, silver, gold;
		copper = coins;
		gold = math.floor(copper/10000);
		copper = copper - (gold*10000);
		silver = math.floor(copper/100);
		copper = copper - (silver*100);
		return copper, silver, gold;
	end;

	GetTime = function ()
		local hour, minute = GetGameTime();
		local pm;
		if ( minute > 59 ) then
			minute = minute - 60;
			hour = hour + 1
		elseif ( minute < 0 ) then
			minute = 60 + minute;
			hour = hour - 1;
		end
		if ( hour > 23 ) then
			hour = hour - 24;
		elseif ( hour < 0 ) then
			hour = 24 + hour;
		end
		if ( hour >= 12 ) then
			pm = 1;
			hour = hour - 12;
		else
			pm = 0;
		end
		if ( hour == 0 ) then
			hour = 12;
		end
		return pm, hour, minute;
	end;

	GetTimeText = function ()
		local hour, minute = GetGameTime();
		local pm;
		if( hour >= 12 ) then
			pm = 1;
			hour = hour - 12;
		end
		if( hour == 0 ) then
			hour = 12;
		end
		if( pm ) then
			return format(TEXT(TIME_TWELVEHOURPM), hour, minute);
		else
			return format(TEXT(TIME_TWELVEHOURAM), hour, minute);
		end
	end;

	SpellExists = function (spell, rank)
		if ( Lib.GetSpellID(spell, rank) == 0 ) then
			return false;
		else
			return true;
		end
	end;

	GetSpellID = function (spell, rank)
		local i = 1;
		local spell_book, rank_book = GetSpellName(i, BOOKTYPE_SPELL);
		while spell_book do
			if ( spell_book == spell ) then
				if ( rank_book == rank ) then
					return i;
				end
			end
			i = i + 1;
			spell_book, rank_book = GetSpellName(i, BOOKTYPE_SPELL)
		end
		return 0;
	end;

	ParseLink = function (link)
		local _, _, item = string.find(link, "^.*%[(.*)%].*$");
		return item;
	end;
	
	Split = function (text, delimiter)
		local list = {};
		local pos = 1;
		while 1 do
			local first, last = strfind(text, delimiter, pos);
			if first then
				tinsert(list, strsub(text, pos, first-1));
				pos = last+1;
			else
				tinsert(list, strsub(text, pos));
				return list;
			end
		end
		return list;
	end;
	
	TableSort = function (rawtable, field, style, num)
		local sorted = { };
		local keylist = { };
		for key in rawtable do
			if ( rawtable[key][field] ) then
				table.insert(keylist, rawtable[key][field].."@"..tostring(key));
			else
				return rawtable;
			end
		end
		if ( num ) then
			if ( style == "asc" ) then
				table.sort(keylist, function(a,b) return tonumber(Lib.Split(a,"@")[1])<tonumber(Lib.Split(b,"@")[1]) end);
			else
				table.sort(keylist, function(a,b) return tonumber(Lib.Split(a,"@")[1])>tonumber(Lib.Split(b,"@")[1]) end);
			end
		else
			if ( style == "asc" ) then
				table.sort(keylist, function(a,b) return (Lib.Split(a,"@")[1])<(Lib.Split(b,"@")[1]) end);
			else
				table.sort(keylist, function(a,b) return (Lib.Split(a,"@")[1])>(Lib.Split(b,"@")[1]) end);
			end
		end
		for i=1, table.getn(keylist) do
			local key = Lib.Split(keylist[i], "@");
			sorted[i] = rawtable[tonumber(key[2])];
		end
		return sorted;
	end;

}