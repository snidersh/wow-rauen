FLIGHTPATH_RECORD_MODE = false;

function FlightPath_OnLoad()

	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");
	--this:RegisterEvent("TAXIMAP_OPENED");
	
	tinsert(UISpecialFrames,"FlightPath");
	FlightPath_ResetVars();
	
	-- Register Slash Commands
	SLASH_FLIGHTPATH1 = "/flightpath";
	SLASH_FLIGHTPATH2 = "/fp";
	SlashCmdList["FLIGHTPATH"] = function(msg)
		FlightPath_ChatCommandHandler(msg);
	end
	
	ChatMessage("Rauen's FlightPath Loaded.");
	
end

function FlightPath_ChatCommandHandler(msg)
	PlaySound("igMainMenuOpen");
	ShowUIPanel(FlightPath);
end

function FlightPath_ResetVars()
	FlightPath_Var = { };
	FlightPath_Var.SelectedNode1 = nil;
	FlightPath_Var.SelectedNode2 = nil;
	FlightPath_Var.Flight = nil;
end

function FlightPath_Upgrade()
	FlightPath_Config = { };
	FlightPath_Config.Version = FLIGHTPATH_VERSION;
	FlightPath_SetNodes();
	ChatMessage("FlightPath updated to v"..FLIGHTPATH_VERSION..".");
end

function FlightPath_Reset()

	if not ( FlightPath_Config ) then
		FlightPath_Upgrade = { };
	end
	FlightPath_Config[UnitName("player")] = { };
	FlightPath_Config[UnitName("player")].Enabled = true;
	
	FlightPath_Config[UnitName("player")].Nodes = { };
	for node in FlightPath_Nodes do
		FlightPath_Config[UnitName("player")].Nodes[node] = false;
	end
	
	ChatMessage(UnitName("player").."'s FlightPath configuration reset.");
	
end

function FlightPath_OnEvent(event) 
	if ( event == "VARIABLES_LOADED") then
		if ( FlightPath_Config ) then
			if ( FlightPath_Config.Version ~= FLIGHTPATH_VERSION ) then
				FlightPath_Upgrade();
			end
		else
			FlightPath_Upgrade();
		end
		if not ( FlightPath_Config[UnitName("player")] ) then
			FlightPath_Reset();
		end
		FlightPath_SetNodes()
		return;
	end
	
	--[[if not ( FLIGHTPATH_RECORD_MODE ) then
		return;
	end
	
	if ( event == "TAXIMAP_OPENED" ) then
		local current, node;
		for i=1, NumTaxiNodes() do
			if ( TaxiNodeGetType(i) == "CURRENT" ) then
				current = TaxiNodeName(i);
			end
		end
		current = FlightPath_TranslateNode(current);
		for i=1, NumTaxiNodes() do
			if ( TaxiNodeGetType(i) ~= "CURRENT" ) then
				node = FlightPath_TranslateNode(TaxiNodeName(i));
				if ( FlightPath_Nodes[current][node] ) then
					FlightPath_Nodes[current][node].Cost = TaxiNodeCost(i);
					ChatMessage("Flight Cost Recorded: "..current.." - "..node.." [ "..FlightPath_Nodes[current][node].Cost.."c ].");
				else
					ChatMessage("Cannot find "..current.." - "..node..".");
				end
			end
		end
		FlightPath_Var.StartNode = current;
	end]]
	
end

--[[Default_TakeTaxiNode = TakeTaxiNode;
function TakeTaxiNode(nodeID)
	if ( FLIGHTPATH_RECORD_MODE ) then
		local node = FlightPath_TranslateNode(TaxiNodeName(nodeID));
		if ( FlightPath_Nodes[FlightPath_Var.StartNode][node] ) then
			FlightPath_Var.FinishNode = node;
			FlightPath_Var.StartTime = GetTime();
			FlightPath_Var.Recording = true;
			if ( Clock_Var.StopwatchRunning ) then
				Clock_StopwatchOnClick();
			end
			Clock_StopwatchOnClick();
			ChatMessage("Recording Flight Time: "..FlightPath_Var.StartNode.." - "..FlightPath_Var.FinishNode..".");
		else
			ChatMessage("Cannot find "..FlightPath_Var.StartNode.." - "..node..".");
		end
	end
	Default_TakeTaxiNode(nodeID);
end]]

Default_TaxiNodeOnButtonEnter = TaxiNodeOnButtonEnter;
function TaxiNodeOnButtonEnter(button)
	local current, node;
	local index = this:GetID();
	for i=1, NumTaxiNodes() do
		if ( TaxiNodeGetType(i) == "CURRENT" ) then
			current = TaxiNodeName(i);
		end
	end
	GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
	current = FlightPath_TranslateNode(current);
	node = FlightPath_TranslateNode(TaxiNodeName(index));
	GameTooltip:AddLine(node);
	GameTooltip:AddLine(FlightPath_Nodes[node].Zone, 0.75, 0.75, 1.0);
	if ( current ~= node ) then
		if ( FlightPath_Nodes[current][node] ) then
			if ( FlightPath_Nodes[current][node].Time > 0 ) then
				local hours, minutes, seconds = Lib.ParseTime(FlightPath_Nodes[current][node].Time);
				GameTooltip:AddLine("Flight Time: "..format("%d", minutes).."m "..format("%d", seconds).."s", 0.75, 1.0, 0.75);
			end
			if ( TaxiNodeCost(this:GetID()) > 0 ) then
				GameTooltip:AddLine("Flight Cost:", 1.0, 1.0, 0.75);
			else
				GameTooltip:AddLine("Flight Cost: Free", 1.0, 1.0, 0.75);
			end
		end
	end
	local type = TaxiNodeGetType(index);
	if ( type == "REACHABLE" ) then
		SetTooltipMoney(GameTooltip, TaxiNodeCost(this:GetID()));
	elseif ( type == "CURRENT" ) then
		GameTooltip:AddLine(TEXT(TAXINODEYOUAREHERE), "", 0.5, 1.0, 0.5);
	end
	GameTooltip:Show();
end

--[[function FlightPath_OnUpdate()
	if ( FlightPath_Var.Recording ) then
		local elapsed = math.floor(GetTime() - FlightPath_Var.StartTime);
		if not ( UnitOnTaxi("player") ) and ( elapsed > 10 ) then
			FlightPath_Var.Recording = false;
			if ( Clock_Var.StopwatchRunning ) then
				Clock_StopwatchOnClick();
			end
			FlightPath_Nodes[FlightPath_Var.StartNode][FlightPath_Var.FinishNode].Time = elapsed;
			ChatMessage("Flight Time Recorded: "..FlightPath_Var.StartNode.." - "..FlightPath_Var.FinishNode.." [ "..FlightPath_Nodes[FlightPath_Var.StartNode][FlightPath_Var.FinishNode].Time .."s ].");
			FlightPath_Var.StartTime = nil;
			FlightPath_Var.StartNode = "";
			FlightPath_Var.FinishNode = "";
		end
	end
end]]

function FlightPath_OnShow()

	local frame;
	local button;
	local text;
	
	-- Title
	text = getglobal("FlightPath_TitleText");
	text:SetText("Rauen's FlightPath v"..FlightPath_Config.Version);
	frame = getglobal("FlightPath_Title");
	frame:SetWidth(text:GetWidth()+250);
	
	button = getglobal("FlightPath_ResetMapButton");
	button:SetAlpha(0.8);
	
	button = getglobal("FlightPath_ShowPathButton");
	button:SetAlpha(0.8);
	button:Disable();
	if ( FlightPath_Var.SelectedNode1 ) and ( FlightPath_Var.SelectedNode2 ) then
		if not ( FlightPath_Var.Flight ) then
			button:Enable();
		end
	end
	
	--FlightPath_SetLines();
	FlightPath_SetButtons();
	
end

function FlightPath_SetLines()
	for i=2, 10 do
		getglobal("FlightPath_Line"..i):Hide();
	end
	if not ( FlightPath_Var.Flight ) then
		return;
	end
	local node, parent;
	local line, x1, x2, y1, y2, map;
	for i=2, (FlightPath_Var.Flight.Hops) do
		node = FlightPath_Var.Flight.Path[i];
		parent = FlightPath_Var.Flight.Path[i-1];
		if ( node ) and ( parent ) then
			if ( FlightPath_Nodes[parent][node].Type == "Bird" ) then
				x1 = FlightPath_Nodes[parent].Map.X;
				y1 = FlightPath_Nodes[parent].Map.Y;
				x2 = FlightPath_Nodes[node].Map.X;
				y2 = FlightPath_Nodes[node].Map.Y;
				map = FlightPath_Nodes[node].Continent;
				FlightPath_ShowLine(i, map, x1, y1, x2, y2);
			end
		end
	end
end

function FlightPath_ShowLine(line, map, x1, y1, x2, y2)
	local tex = getglobal("FlightPath_Line"..line);
	local dx = abs(x1 - x2);
	local dy = abs(y1 - y2);
	if (x1 > x2) then
		x1, y1, x2, y2 = x2, y2, x1, y1;
	end
	tex:ClearAllPoints();
	tex:SetTexCoord(0, 1, 0, 1);
	if (y1 > y2) then
		tex:SetTexture("Interface\\AddOns\\Rauen_FlightPath\\Skin\\LineDown64");
		tex:SetPoint("TOPLEFT", "FlightPath_"..map.."Map", "TOPLEFT", x1, y1-280);
	else
		tex:SetTexture("Interface\\AddOns\\Rauen_FlightPath\\Skin\\LineUp64");
		tex:SetPoint("BOTTOMLEFT", "FlightPath_"..map.."Map", "BOTTOMLEFT", x1, y1);
	end
	tex:SetWidth(dx);
	tex:SetHeight(dy);
	tex:Show();
end

function FlightPath_SetButtons()

	local button, map, zone, x, y, isAvailable;
	
	text = getglobal("FlightPath_MarkerStart");
	text:Hide();
	text = getglobal("FlightPath_MarkerFinish");
	text:Hide();
	for i=2, 10 do
		getglobal("FlightPath_Marker"..i):Hide();
	end
	
	for node in FlightPath_Nodes do
	
		map = FlightPath_Nodes[node].Continent;
		zone = FlightPath_Nodes[node].Zone;
		x = FlightPath_Nodes[node].Map.X;
		y = FlightPath_Nodes[node].Map.Y;
		isAvailable = FlightPath_Config[UnitName("player")].Nodes[node];

		button = getglobal("FlightPath_Button_"..node);
		button.name = node;
		button.zone = zone;
		button.isAvailable = isAvailable;
		button:ClearAllPoints();
		button:SetPoint("CENTER", "FlightPath_"..map.."Map", "BOTTOMLEFT", x, y);
		button:UnlockHighlight();
		button:Show();
		if ( FlightPath_Var.SelectedNode1 == node ) then
			button:LockHighlight();
			text = getglobal("FlightPath_MarkerStart");
			text:ClearAllPoints();
			text:SetPoint("TOP", "FlightPath_Button_"..node, "BOTTOM", 0, 8);
			text:Show();
		end
		if ( FlightPath_Var.SelectedNode2 == node ) then
			button:LockHighlight();
			text = getglobal("FlightPath_MarkerFinish");
			text:ClearAllPoints();
			text:SetPoint("TOP", "FlightPath_Button_"..node, "BOTTOM", 0, 8);
			text:Show();
		end
		if ( node == "Nighthaven" ) and not ( UnitClass("player") == "Druid" ) then
			button:Hide();
		else
			button:Show();
		end
		if ( button.isAvailable ) then
			button:SetAlpha(1.0);
		else
			button:SetAlpha(0.4);
		end
		if ( FlightPath_Var.Flight ) then
			if ( FlightPath_IsInPath(node) ) then
				if not ( FlightPath_Var.SelectedNode1 == node ) and not ( FlightPath_Var.SelectedNode2 == node ) then
					text = getglobal("FlightPath_Marker"..FlightPath_NodeNumber(node));
					text:ClearAllPoints();
					text:SetPoint("LEFT", "FlightPath_Button_"..node, "RIGHT", -22, 2);
					text:Show();
				end
				button:Show();
			else
				button:Hide();
			end
		end
	
	end

end

function FlightPath_ResetMap()
	FlightPath_ResetVars();
	if ( miniFlightPath:IsVisible() ) then
		PlaySound("igMainMenuClose");
		HideUIPanel(miniFlightPath);
	end
	FlightPath_OnShow();
end

function FlightPath_ButtonOnClick()
	PlaySound("igMainMenuOptionCheckBoxOn");
	local name = this.name;
	if ( FlightPath_Var.Flight ) then
		return;
	end
	if ( IsShiftKeyDown() ) then
		if ( this.isAvailable ) then
			FlightPath_Config[UnitName("player")].Nodes[name] = false;
			this.isAvailable = false;
		else
			FlightPath_Config[UnitName("player")].Nodes[name] = true;
			this.isAvailable = true;
		end
		if ( FlightPath_Var.SelectedNode1 == name ) then
			FlightPath_Var.SelectedNode1 = nil;
		end
		if ( FlightPath_Var.SelectedNode2 == name ) then
			FlightPath_Var.SelectedNode2 = nil;
		end
		FlightPath_OnShow();
	elseif ( IsAltKeyDown() ) then
		for node in FlightPath_Nodes do
			if ( this.isAvailable ) then
				FlightPath_Config[UnitName("player")].Nodes[node] = false;
			else
				FlightPath_Config[UnitName("player")].Nodes[node] = true;
			end
		end
		FlightPath_OnShow();
	else
		if not ( this.isAvailable ) then
			return;
		end
		if ( FlightPath_Var.SelectedNode1 == name ) then
			FlightPath_Var.SelectedNode1 = nil;
			FlightPath_OnShow();
			return;
		end
		if ( FlightPath_Var.SelectedNode2 == name ) then
			FlightPath_Var.SelectedNode2 = nil;
			FlightPath_OnShow();
			return;
		end
		if not ( FlightPath_Var.SelectedNode1 ) then
			FlightPath_Var.SelectedNode1 = name;
			FlightPath_OnShow();
			return;
		end
		if not ( FlightPath_Var.SelectedNode2 ) then
			FlightPath_Var.SelectedNode2 = name;
			FlightPath_OnShow();
			return;
		end
	end
end

function FlightPath_OnButtonEnter(button)
	local name = this.name;
	local zone = this.zone;
	if ( name and zone ) then
		local showinfo = true;
		local dur = 0;
		local cost = 0;
		local showcost = false;
		local showdur = false;
		GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
		if not ( FlightPath_Var.Flight ) then
			showinfo = false;
		else
			local parent, node;
			local index = 0;
			for i=2, FlightPath_Var.Flight.Hops do
				node = FlightPath_Var.Flight.Path[i];
				if ( node == name ) then
					index = i;
				end
			end
			if ( index > 1 ) then
				for i=2, index do
					node = FlightPath_Var.Flight.Path[i];
					parent = FlightPath_Var.Flight.Path[i-1];
					dur = dur + FlightPath_Nodes[parent][node].Time;
					cost = cost + FlightPath_Nodes[parent][node].Cost;
				end
				if ( dur > 0 ) or ( cost > 0 ) then
					if ( dur > 0 ) then
						showdur = true
					end
					if ( cost > 0 ) then
						showcost = true;
					end
				else
					showinfo = false;
				end
			else
				showinfo = false;
			end
		end
		if ( showinfo ) then
			GameTooltip:AddLine(name);
			GameTooltip:AddLine(zone, 0.75, 0.75, 1.0);
			if ( showdur ) then
				local hours, minutes, seconds = Lib.ParseTime(dur);
				GameTooltip:AddLine("Travel Time: "..format("%d", minutes).."m "..format("%d", seconds).."s", 0.75, 1.0, 0.75);
			end
			if ( showcost ) then
				GameTooltip:AddLine("Travel Cost:", 1.0, 1.0, 0.75);
				SetTooltipMoney(GameTooltip, cost);
			else
				GameTooltip:AddLine("Travel Cost: Free", 1.0, 1.0, 0.75);
			end
		else
			if ( this.isAvailable ) then
				GameTooltip:AddLine(name);
				GameTooltip:AddLine(zone, 0.75, 0.75, 1.0);
			else
				GameTooltip:AddLine(name, 0.5, 0.5, 0.5);
				GameTooltip:AddLine(zone, 0.5, 0.5, 0.5);
				GameTooltip:AddLine("Disabled Node", 0.5, 0.5, 0.5);
				GameTooltip:AddLine(" ", 0.0, 0.0, 0.0);
				GameTooltip:AddLine("Shift-click to toggle node.", 0.5, 0.5, 0.5);
				GameTooltip:AddLine("Alt-click to toggle all nodes.", 0.5, 0.5, 0.5);
			end
		end
		GameTooltip:Show();
	end
end

function FlightPath_Close()
	PlaySound("igMainMenuClose");
	HideUIPanel(FlightPath);
end

function FlightPath_ShowMini()
	PlaySound("igMainMenuOpen");
	ShowUIPanel(miniFlightPath);
end

function FlightPath_IsInPath(node)
	for i=1, FlightPath_Var.Flight.Hops do
		if ( node ==  FlightPath_Var.Flight.Path[i] ) then
			return true;
		end
	end
	return false;
end

function FlightPath_NodeNumber(node)
	for i=1, FlightPath_Var.Flight.Hops do
		if ( node ==  FlightPath_Var.Flight.Path[i] ) then
			return i;
		end
	end
	return 0;
end

function FlightPath_TranslateNode(node)
	if ( string.find(node, ",") ) then
		node = string.sub(node, 1, string.find(node, ",")-1);
	end
	if ( node == "Theramore" ) then
		node = "Theramore Isle";
	end
	if ( node == "Moonglade" ) then
		node = "Lake Elune'ara";
	end
	if ( node == "Feathermoon" ) then
		node = "Feathermoon Stronghold";
	end
	return node;
end

function FlightPath_ShowPath()
	PlaySound("igMainMenuOptionCheckBoxOn");
	FlightPath_FindPath(FlightPath_Var.SelectedNode1, FlightPath_Var.SelectedNode2);
	if ( FlightPath_Var.Flight ) then
		FlightPath_ShowMini();
	end
	FlightPath_OnShow();
end

function FlightPath_FindPath(start, stop)

	if not ( FlightPath_Nodes[start] ) then
		return;
	end
	if not ( FlightPath_Nodes[stop] ) then
		return;
	end

	local nodes = { };
	local parents = { };
	local index = 1;
	local found = false;
	nodes[index] = { };
	nodes[index][start] = FlightPath_Nodes[start];
	while ( not found ) and ( index < 30 ) do
		index = index + 1;
		nodes[index] = { };
		for parent in nodes[index-1] do
			for node in FlightPath_Nodes[parent] do
				if ( node ~= "Zone" ) and ( node ~= "Continent" ) and ( node ~= "Map" ) then
					local isParent = false;
					for key in parents do
						if ( key == node ) then
							isParent = true;
						end
					end
					local isRestricted = false;
					if ( node == "Nighthaven" and UnitClass("player") ~= "Druid" ) then
						isRestricted = true;
					end
					local isAvailable = getglobal("FlightPath_Button_"..node).isAvailable;
					if not ( isParent ) and not ( isRestricted ) and ( isAvailable ) then
						parents[node] = parent;
						nodes[index][node] = FlightPath_Nodes[node];
						if ( node == stop ) then
							if ( index == 2 ) then
								FlightPath_ResetVars();
								return;
							end
							found = true;
						end
					end
				end
			end
		end
	end
	
	if ( found ) then
		local fpath = { };
		local fcost = 0;
		local ftime = 0;
		
		node = stop;
		fpath[index] = node;
		local num = index;
		for i=2, num do
			index = index - 1;
			node = parents[node];
			fpath[index] = node;
			fcost = fcost + FlightPath_Nodes[parents[node]][node].Cost;
			ftime = ftime + FlightPath_Nodes[parents[node]][node].Time;
		end
		FlightPath_Var.Flight = { };
		FlightPath_Var.Flight.Path = fpath;
		FlightPath_Var.Flight.Hops = num;
		FlightPath_Var.Flight.Cost = fcost;
		FlightPath_Var.Flight.Time = ftime;
		return;
	end
	
	FlightPath_ResetVars();
	
end

function miniFlightPath_Close()
	PlaySound("igMainMenuClose");
	HideUIPanel(miniFlightPath);
end

function miniFlightPath_ShowOnClick()
	if ( FlightPath:IsVisible() ) then
		PlaySound("igMainMenuClose");
		HideUIPanel(FlightPath);
	else
		PlaySound("igMainMenuOpen");
		ShowUIPanel(FlightPath);
	end
end

function miniFlightPath_OnShow()

	for i=2, 10 do
		getglobal("miniFlightPath_Text"..i):Hide();
	end

	local text;
	local frame = getglobal("miniFlightPath");
	local width = frame:GetWidth();
	local height = 25;
	
	local node = FlightPath_Var.Flight.Path[1];
	text= getglobal("miniFlightPath_TextPath");
	text:SetText(FlightPath_Var.Flight.Path[1].." to "..FlightPath_Var.Flight.Path[FlightPath_Var.Flight.Hops]);
	height = height + 18;
	
	for i=2, (FlightPath_Var.Flight.Hops) do
		text= getglobal("miniFlightPath_Text"..i);
		local node = FlightPath_Var.Flight.Path[i];
		local parent = FlightPath_Var.Flight.Path[i-1];
		if ( node ) and ( parent ) then
			if ( FlightPath_Nodes[parent][node].Type == "Boat" ) then
				text:SetText("Sail from "..parent.." to "..node..".");
			else
				text:SetText("Fly from "..parent.." to "..node..".");
			end
			if ( text:GetWidth() > (width - 50) ) then
				width = text:GetWidth() + 50;
			end
			text:Show();
			height = height + 15;
		end
	end
	
	frame:SetWidth(width);
	height = height + 25;
	frame:SetHeight(height);
	
	frame:ClearAllPoints();
	frame:SetPoint("BOTTOM", "FlightPath", "TOP", 0, 15);

end