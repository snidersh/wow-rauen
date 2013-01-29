function BagsOpen_OnLoad()

	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_NAME_UPDATE");
	this:RegisterEvent("MERCHANT_SHOW"); 
	this:RegisterEvent("MERCHANT_CLOSED"); 
	this:RegisterEvent("BANKFRAME_OPENED"); 
	this:RegisterEvent("BANKFRAME_CLOSED"); 
	this:RegisterEvent("MAIL_SHOW"); 
	this:RegisterEvent("MAIL_CLOSED"); 
	this:RegisterEvent("TRADE_SHOW"); 
	this:RegisterEvent("TRADE_CLOSED");
	
	-- Register Slash Commands
	SLASH_BAGSOPEN1 = "/bagsopen";
	SLASH_BAGSOPEN2 = "/bo";
	SlashCmdList["BAGSOPEN"] = function(msg)
		BagsOpen_ChatCommandHandler(msg);
	end
	
	ChatMessage("Rauen's BagsOpen Loaded.");
	
end

function BagsOpen_ChatCommandHandler(msg)

	-- Menu
	if ( boUI:IsVisible() ) then
		PlaySound("igMainMenuClose");
		HideUIPanel(boUI);
	else
		PlaySound("igMainMenuOpen");
		ShowUIPanel(boUI);
	end
	
end

function BagsOpen_Reset()

	BagsOpen_Config = { };
	BagsOpen_Config.Version = BAGSOPEN_VERSION;
	BagsOpen_Config.Enabled = true;
	BagsOpen_Config.One = true;
	BagsOpen_Config.Two = true;
	BagsOpen_Config.Three = true;
	BagsOpen_Config.Four = true;
	
	ChatMessage("BagsOpen configuration reset.");
	
end

function BagsOpen_OnEvent(event) 

	if ( event == "VARIABLES_LOADED") then
		if ( BagsOpen_Config ) then
			if ( BagsOpen_Config.Version ~= BAGSOPEN_VERSION ) then
				ChatMessage("BagsOpen updated to v"..BAGSOPEN_VERSION..".");
				BagsOpen_Reset();
			end
		else
			ChatMessage("BagsOpen updated to v"..BAGSOPEN_VERSION..".");
			BagsOpen_Reset();
		end
		return;
	end
	
	-- Init Default Values
	if ( event == "UNIT_NAME_UPDATE" ) then
		if ( BagsOpen_Config.Init == nil ) then
			BagsOpen_Config.Init = true;
			BagsOpen_Config.One = true;
			BagsOpen_Config.Two = true;
			BagsOpen_Config.Three = true;
			BagsOpen_Config.Four = true;
		end
	end
	
	if (event == "MERCHANT_SHOW") then 
		BagsOpen_Open();
	end 
	if (event == "MERCHANT_CLOSED") then 
		BagsOpen_Close(); 
	end 
	if (event == "BANKFRAME_OPENED") then 
		BagsOpen_Open();
	end 
	if (event == "BANKFRAME_CLOSED") then 
		BagsOpen_Close(); 
	end 
	if (event == "MAIL_SHOW") then 
		BagsOpen_Open(); 
	end 
	if (event == "MAIL_CLOSED") then 
		BagsOpen_Close();
	end 
	if (event == "TRADE_SHOW") then 
		BagsOpen_Open(); 
	end 
	if (event == "TRADE_CLOSED") then 
		BagsOpen_Close(); 
	end
	
end

function BagsOpen_Open()

	if not ( BagsOpen_Config.Enabled ) then
		return;
	end

	if ( BagsOpen_Config.One ) then
		OpenBag(1);
	end
	if ( BagsOpen_Config.Two ) then
		OpenBag(2);
	end
	if ( BagsOpen_Config.Three ) then
		OpenBag(3);
	end
	if ( BagsOpen_Config.Four ) then
		OpenBag(4);
	end

end

function BagsOpen_Close()
	CloseAllBags();
end