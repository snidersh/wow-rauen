function Data_OnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
end

function Data_OnEvent()
	if ( event == "VARIABLES_LOADED") then
		if ( Data_Config ) then
			local resetItemStats = false;
			local resetKillStats = false;
			if ( Data_Config.ItemStats_Version ~= DATA_ITEMSTATS_VERSION ) then
				resetItemStats = true;
			end
			if ( Data_Config.KillStats_Version ~= DATA_KILLSTATS_VERSION ) then
				resetKillStats = true;
			end
			Data_Reset(resetItemStats, resetKillStats);
		else
			Data_Reset(true, true);
		end
	end
end

function Data_Reset(resetItemStats, resetKillStats)
	Data_Config = { };
	Data_Config.Enabled = true;
	Data_Config.Version = DATA_VERSION;
	Data_Config.ItemStats_Version = DATA_ITEMSTATS_VERSION;
	Data_Config.KillStats_Version = DATA_KILLSTATS_VERSION;
	if ( resetItemStats ) then
		Data_ItemStats_Reset();
		ChatMessage("ItemStats database updated to v"..DATA_ITEMSTATS_VERSION..".");
	end
	if ( resetKillStats ) then
		Data_KillStats_Reset();
		ChatMessage("KillStats database updated to v"..DATA_KILLSTATS_VERSION..".");
	end
end
