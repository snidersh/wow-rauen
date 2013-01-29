StaticPopupDialogs["SET_KARMANOTE"] = {
	text = TEXT("Set Karma Note:"),
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	hasEditBox = 1,
	maxLetters = 200,
	hasWideEditBox = 1,
	OnAccept = function()
		local editBox = getglobal(this:GetParent():GetName().."WideEditBox");
		local name = UnitName("target");
		if ( name ) then
			Data_KarmaStats_SetNote(name, editBox:GetText());
			ChatMessage("Karma note set for "..name..".");
		end
	end,
	OnShow = function()
		this:SetWidth(420);
		local name = UnitName("target");
		local text = getglobal(this:GetName().."Text");
		text:SetText("Set Karma Note for "..name..":");
		local note = Data_KarmaStats_GetNote(name);
		if ( note ) then
			getglobal(this:GetName().."WideEditBox"):SetText(note);
		end
		getglobal(this:GetName().."WideEditBox"):SetFocus();
	end,
	OnHide = function()
		if ( ChatFrameEditBox:IsVisible() ) then
			ChatFrameEditBox:SetFocus();
		end
		getglobal(this:GetName().."WideEditBox"):SetText("");
	end,
	EditBoxOnEnterPressed = function()
		local editBox = getglobal(this:GetParent():GetName().."WideEditBox");
		local name = UnitName("target");
		if ( name ) then
			Data_KarmaStats_SetNote(name, editBox:GetText());
			ChatMessage("Karma note set for "..name..".");
		end
		this:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function()
		this:GetParent():Hide();
	end,
	timeout = 0,
	exclusive = 1
};

function Karma_OnLoad()

	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");
	
	-- Register Slash Commands
	SLASH_KARMA1 = "/karma";
	SlashCmdList["KARMA"] = function(msg)
		Karma_ChatCommandHandler(msg);
	end
	SLASH_GOODKARMA1 = "/goodkarma";
	SLASH_GOODKARMA2 = "/gkarma";
	SlashCmdList["GOODKARMA"] = function(msg)
		Karma_GoodChatCommandHandler(msg);
	end
	SLASH_BADKARMA1 = "/badkarma";
	SLASH_BADKARMA2 = "/bkarma";
	SlashCmdList["BADKARMA"] = function(msg)
		Karma_BadChatCommandHandler(msg);
	end
	SLASH_KARMANOTE1 = "/karmanote";
	SLASH_KARMNOTEA2 = "/kn";
	SlashCmdList["KARMANOTE"] = function(msg)
		Karma_NoteChatCommandHandler(msg);
	end
	SLASH_KARMANOTE1 = "/clearkarma";
	SLASH_KARMNOTEA2 = "/ckarma";
	SlashCmdList["CLEARKARMA"] = function(msg)
		Karma_ClearChatCommandHandler(msg);
	end
	
	UnitPopupButtons["KARMA"] = { text = "Karma", dist = 0, nested = 1 };
	UnitPopupButtons["KARMA_GOOD"] = { text = "Bestow Good Karma", dist = 0 };
	UnitPopupButtons["KARMA_BAD"] = { text = "Bestow Bad Karma", dist = 0 };
	UnitPopupButtons["KARMA_NOTE"] = { text = "Edit Karma Note", dist = 0 };
	UnitPopupButtons["KARMA_RESET"] = { text = "Clear Karma", dist = 0 };
	UnitPopupMenus["PLAYER"] = { "WHISPER", "INSPECT", "INVITE", "TRADE", "FOLLOW", "DUEL", "KARMA", "CANCEL" };
	UnitPopupMenus["PARTY"] = { "WHISPER", "PROMOTE", "LOOT_PROMOTE", "UNINVITE", "INSPECT", "TRADE", "FOLLOW", "DUEL", "KARMA", "CANCEL" };
	UnitPopupMenus[7] = { "KARMA_GOOD", "KARMA_BAD", "KARMA_NOTE", "KARMA_RESET" };
	UnitPopupMenus[9] = { "KARMA_GOOD", "KARMA_BAD", "KARMA_NOTE", "KARMA_RESET" };
	
	ChatMessage("Rauen's Karma Loaded.");
	
end

Default_UnitPopup_OnClick = UnitPopup_OnClick;
function UnitPopup_OnClick()
	local index = this.value;
	local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local button = UnitPopupMenus[this.owner][index];
	local unit = dropdownFrame.unit;
	local name = dropdownFrame.name;
	if not ( name ) then
		Default_UnitPopup_OnClick();
		return;
	end
	if ( button == "KARMA_GOOD" ) then
		Karma_GoodChatCommandHandler(name);
		ToggleDropDownMenu(1, nil, TargetFrameDropDown, "TargetFrame", 120, 10);
		return;
	end
	if ( button == "KARMA_BAD" ) then
		Karma_BadChatCommandHandler(name);
		ToggleDropDownMenu(1, nil, TargetFrameDropDown, "TargetFrame", 120, 10);
		return;
	end
	if ( button == "KARMA_NOTE" ) then
		StaticPopup_Show("SET_KARMANOTE");
		ToggleDropDownMenu(1, nil, TargetFrameDropDown, "TargetFrame", 120, 10);
		return;
	end
	if ( button == "KARMA_RESET" ) then
		Karma_ClearChatCommandHandler(name);
		ToggleDropDownMenu(1, nil, TargetFrameDropDown, "TargetFrame", 120, 10);
		return;
	end
	Default_UnitPopup_OnClick();
end

function Karma_ChatCommandHandler(msg)
	
	if ( msg == "shownames" ) then
		for name in KarmaStats do
			local fame, karma = Data_KarmaStats_GetFameKarma(name);
			if ( fame ) and ( karma ) then
				ChatMessage("Name: "..name.." Fame: "..fame.." Karma: "..karma);
			else
				ChatMessage("Name: "..name);
			end
		end
		return;
	end
	
	PlaySound("igMainMenuOpen");
	ShowUIPanel(kUI);
	
end

function Karma_GoodChatCommandHandler(name)
	if ( name == UnitName("player") ) then
		return;
	end
	Data_KarmaStats_AddKarma(name);
	ChatMessage(name.." has been blessed with good karma.");
	if ( Karma_Config[UnitName("player")].GoodKarmaTell ) then
		local message = Karma_Config[UnitName("player")].GoodKarmaMessage;
		message = string.gsub(message, "player", UnitName("player"));
		message = string.gsub(message, "target", name);
		SendChatMessage(message, "WHISPER", "Common", name);
	end
end

function Karma_BadChatCommandHandler(name)
	if ( name == UnitName("player") ) then
		return;
	end
	Data_KarmaStats_RemoveKarma(name);
	ChatMessage(name.." has been tainted by bad karma.");
	if ( Karma_Config[UnitName("player")].BadKarmaTell ) then
		local message = Karma_Config[UnitName("player")].BadKarmaMessage;
		message = string.gsub(message, "player", UnitName("player"));
		message = string.gsub(message, "target", name);
		SendChatMessage(message, "WHISPER", "Common", name);
	end
end

function Karma_ClearChatCommandHandler(name)
	if ( name == UnitName("player") ) then
		return;
	end
	Data_KarmaStats_RemoveEntry(name);
	ChatMessage(name.."'s reputation has been cleared.");
end

function Karma_NoteChatCommandHandler(msg)

	if ( string.sub(msg, 1, 4) == "show" ) then
		local name = string.sub(msg, 6);
		local note = Data_KarmaStats_GetNote(name);
		if ( note ) then
			ChatMessage(name.."'s Karma Note: "..note);
		end
	else
		local list = Lib.Split(msg, " ");
		local name = list[1];
		local note = list[2];
		Data_KarmaStats_SetNote(name, note);
		ChatMessage("Karma note set for "..name..".");
	end

end

function Karma_Upgrade()
	Karma_Config = { };
	Karma_Config.Version = KARMA_VERSION;
	ChatMessage("Karma updated to v"..KARMA_VERSION..".");
end

function Karma_Reset()

	if ( not Karma_Config ) then
		Karma_Upgrade();
	end
	Karma_Config[UnitName("player")] = { };
	Karma_Config[UnitName("player")].Enabled = true;
	Karma_Config[UnitName("player")].ShowGuild = true;
	Karma_Config[UnitName("player")].ShowKarma = true;
	Karma_Config[UnitName("player")].ShowNote = false;
	Karma_Config[UnitName("player")].GoodKarmaTell = false;
	Karma_Config[UnitName("player")].GoodKarmaMessage = "{player has bestowed good karma upon you}";
	Karma_Config[UnitName("player")].BadKarmaTell = false;
	Karma_Config[UnitName("player")].BadKarmaMessage = "{player has bestowed bad karma upon you}";
	
	ChatMessage(UnitName("player").."'s Karma configuration reset.");
	
end

function Karma_ResetStats()
	Data_KarmaStats_Reset();
	ChatMessage("Karma statistics reset.");
end

function Karma_OnEvent(event)

	if ( event == "VARIABLES_LOADED") then
		if ( Karma_Config ) then
			if ( Karma_Config.Version ~= KARMA_VERSION ) then
				Karma_Upgrade();
			end
		else
			Karma_Upgrade();
		end
		if not ( Karma_Config[UnitName("player")] ) then
			Karma_Reset();
		end

		return;
	end
	
	if not ( Karma_Config[UnitName("player")].Enabled ) then
		return;
	end

end

function Karma_OnShow()

	if not ( Karma_Config[UnitName("player")].Enabled ) then
		return;
	end

	if ( MouseIsOver( MinimapCluster ) ) then
		return;
	end
	
	if not ( UnitIsPlayer("mouseover") ) then
		return;
	end

	local color = { };
	local LinesAdded = 0;
	
	local name = UnitName("mouseover");
	local gender = UnitSex("mouseover");
	if ( gender == 0 ) then
		gender = "Male";
	else
		gender = "Female";
	end
	
	local guild = GetGuildInfo("mouseover");
	local fame, karma = Data_KarmaStats_GetFameKarma(name);
	local title = Data_KarmaStats_GetKarmaTitle(name, gender);
	local note = Data_KarmaStats_GetNote(name);
	
	local lines = { };
	local num = GameTooltip:NumLines();
	for i=1, num do
		local line = getglobal("GameTooltipTextLeft"..i);
		lines[i] = line:GetText();
	end
	GameTooltip:ClearLines();
	
	color.r, color.g, color.b = GameTooltip_UnitColor("mouseover");
	GameTooltip:AddLine(lines[1], color.r, color.g, color.b);
	
	if ( guild ) and ( Karma_Config[UnitName("player")].ShowGuild ) then
		GameTooltip:AddLine(guild, 0.75, 0.75, 1.0);
		LinesAdded = LinesAdded + 1;
	end
	if ( title ) and ( Karma_Config[UnitName("player")].ShowKarma ) then
		color = Data_KarmaStats_GetColor(name);
		GameTooltip:AddLine("Karma: "..title, color.r, color.g, color.b);
		LinesAdded = LinesAdded + 1;
	end
	if ( note ) and ( Karma_Config[UnitName("player")].ShowNote ) then
		color = Data_KarmaStats_GetColor(name);
		if ( string.len(note) > 25 ) then
			note = string.sub(note, 1, 25).."...";
		end
		GameTooltip:AddLine("Note: "..note, color.r, color.g, color.b);
		LinesAdded = LinesAdded + 1;
	end
	for i=2,  num do
		color.r = 1.0;
		color.g = 1.0;
		color.b = 1.0;
		if ( lines[i] == "Resurrectable" ) then
			color.r = 0.25;
			color.g = 0.75;
			color.b = 0.25;
		end
		GameTooltip:AddLine(lines[i], color.r, color.g, color.b);
	end
	
	Karma_ResizeTooltip(LinesAdded);
	
end

function Karma_ResizeTooltip(LinesAdded)
	if ( LinesAdded > 0 ) then
		GameTooltip:SetHeight(GameTooltip:GetHeight() + (14 * LinesAdded));
		for i=1, GameTooltip:NumLines() do
			local text = getglobal("GameTooltipTextLeft" .. i)
			if ( ( text:GetWidth()+30 ) > GameTooltip:GetWidth() ) then
				GameTooltip:SetWidth( text:GetWidth() + 30 );
			end
		end

	end
end