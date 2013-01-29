ConfigMenu_PanelButtons = {
	["ActionBars"] = "abUI",
	["BagsOpen"] = "boUI",
	--["ButtonLock"] = "blUI",
	["Clock"] = "cUI",
	["CombatWatch"] = "cwUI_General",
	["DataSearch"] = "DataSearch",
	["ItemWatch"] = "iwUI",
	["KillWatch"] = "kwUI",
	["MapInfo"] = "miUI",
	["MouseLook"] = "mlUI",
	["PetAttack"] = "paUI",
	["PetDefend"] = "pdUI",
	["PetFeed"] = "pfUI",
	["TradeWatch"] = "twUI"
}

ConfigMenu_Enabled = {
	["ActionBars"] = function() return Bars_Config.Enabled end,
	["BagsOpen"] = function() return BagsOpen_Config.Enabled end,
	--["ButtonLock"] = function() return ButtonLock_Config.Enabled end,
	["Clock"] = function() return Clock_Config.Enabled end,
	["CombatWatch"] = function() return CombatWatch_Config.Enabled end,
	["DataSearch"] = function() return Data_Config.Enabled end,
	["ItemWatch"] = function() return ItemWatch_Config.Enabled end,
	["KillWatch"] = function() return KillWatch_Config.Enabled end,
	["MapInfo"] = function() return MapInfo_Config.Enabled end,
	["MouseLook"] = function() return MouseLook_Config.Enabled end,
	["PetAttack"] = function() return PetAttack_Config.Enabled end,
	["PetDefend"] = function() return PetDefend_Config.Enabled end,
	["PetFeed"] = function() return PetFeed_Config.Enabled end,
	["TradeWatch"] = function() return TradeWatch_Config.Enabled end,
}

ConfigMenu_Panels = {
	"abUI",
	"boUI",
	--"blUI",
	"cUI",
	"cwUI_General",
	"cwUI_Druid",
	"cwUI_Hunter",
	"cwUI_Mage",
	"cwUI_Paladin",
	"cwUI_Priest",
	"cwUI_Rogue",
	"cwUI_Shaman",
	"cwUI_Warlock",
	"cwUI_Warrior",
	"DataSearch",
	"iwUI",
	"kwUI",
	"miUI",
	"mlUI",
	"paUI",
	"pdUI",
	"pfUI",
	"twUI"
}

function ConfigMenu_OnLoad()

	this:RegisterEvent("VARIABLES_LOADED");
	tinsert(UISpecialFrames,"ConfigMenuFrame");
	
	ChatMessage("Rauen's ConfigMenu Loaded.");
	
end

function ConfigMenu_OnClick()
	if ( ConfigMenuFrame:IsVisible() ) then
		PlaySound("igMainMenuClose");
		HideUIPanel(ConfigMenuFrame);
	else
		ConfigMenu_ClosePanels();
		PlaySound("igMainMenuOpen");
		ShowUIPanel(ConfigMenuFrame);
	end
end

function ConfigMenu_OnMouseDown()
	if ( arg1 == "RightButton" ) then
		this.isMoving = true;
	end
end

function ConfigMenu_OnMouseUp()
	if ( this.isMoving ) then
		this.isMoving = false;
		ConfigMenu_Config.X = this.currentX;
		ConfigMenu_Config.Y = this.currentY;
	end
end

function ConfigMenu_OnUpdate()
	if ( this.isMoving ) then
		local mouseX, mouseY = GetCursorPosition();
		local centerX, centerY = Minimap:GetCenter();
		local scale = Minimap:GetScale();
		mouseX = mouseX / scale;
		mouseY = mouseY / scale;
		local radius = (Minimap:GetWidth()/2) + (this:GetWidth()/3) - 1;
		local x = math.abs(mouseX - centerX);
		local y = math.abs(mouseY - centerY);
		local xSign = 1;
		local ySign = 1;
		if not (mouseX >= centerX) then
			xSign = -1;
		end
		if not (mouseY >= centerY) then
			ySign = -1;
		end
		local angle = math.atan(x/y);
		x = math.sin(angle)*radius;
		y = math.cos(angle)*radius;
		this.currentX = xSign*x;
		this.currentY = ySign*y;
		this:SetPoint("CENTER", "Minimap", "CENTER", this.currentX, this.currentY);
	end
end

function ConfigMenu_Position()
	if ( ConfigMenu_Config.X ~= 0 ) and ( ConfigMenu_Config.Y ~= 0 ) then
		local button = getglobal("ConfigMenu_MinimapButton");
		button:SetPoint("CENTER", "Minimap", "CENTER", ConfigMenu_Config.X, ConfigMenu_Config.Y);
	end
end

function ConfigMenu_OnEvent()

	if (event == "VARIABLES_LOADED") then
		if ( ConfigMenu_Config ) then
			if ( ConfigMenu_Config.Version ~= CONFIGMENU_VERSION ) then
				ChatMessage("ConfigMenu updated to v"..CONFIGMENU_VERSION..".");
				ConfigMenu_Reset();
			end
		else
			ChatMessage("ConfigMenu updated to v"..CONFIGMENU_VERSION..".");
			ConfigMenu_Reset();
		end
		ConfigMenu_Position();
		return;
	end
	
end

function ConfigMenu_Reset()

	ConfigMenu_Config = { };
	ConfigMenu_Config.Version = CONFIGMENU_VERSION;
	ConfigMenu_Config.Enabled = true;
	ConfigMenu_Config.X = 0;
	ConfigMenu_Config.Y = 0;
	
	ChatMessage("ConfigMenu configuration reset.");

end

function ConfigMenu_Close()
	PlaySound("igMainMenuClose");
	HideUIPanel(ConfigMenuFrame);
end

function ConfigMenu_OnShow()

	-- Title
	text = getglobal("ConfigMenu_FrameHeaderText");
	text:SetText("Rauen's AddOns v"..RAUENS_ADDONS_VERSION);
	frame = getglobal("ConfigMenu_FrameHeader");
	frame:SetWidth(text:GetWidth()+250);

	local button, panel;
	for key in ConfigMenu_PanelButtons do
		button = getglobal("ConfigMenuButton_"..key);
		panel = getglobal(ConfigMenu_PanelButtons[key]);
		if ( key == "DataSearch" ) then
			button:SetText("Search Data");
		else
			button:SetText(key);
		end
		button:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		--button:SetAlpha(1.0);
		if not ( panel ) then
			button:Disable();
		else
			if not ( ConfigMenu_Enabled[key]() ) then
				--button:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
				button:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
				--button:SetAlpha(0.8);
			end
		end
	end
	
end

function ConfigMenu_ClosePanels()
	local panel;
	for i=1,  table.getn(ConfigMenu_Panels) do
		panel = getglobal(ConfigMenu_Panels[i]);
		if ( panel ) then
			if ( panel:IsVisible() ) then
				panel:Hide();
			end
		end
	end
end
