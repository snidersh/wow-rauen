-- Constants
local UPDATE_RATE = 0.25;
local OFFSET_X = 0.0;
local OFFSET_Y = -0.02;

function MapInfo_OnLoad()

	-- Register Variables
	this:RegisterEvent("VARIABLES_LOADED");
	
	-- Initialize
	MapInfoFrame.TimeSinceLastUpdate = 0;
	
	ChatMessage("Rauen's MapInfo Loaded.");
	
end

function MapInfo_OnEvent()

	if ( event == "VARIABLES_LOADED") then
		if ( MapInfo_Config ) then
			if ( MapInfo_Config.Version ~= MAPINFO_VERSION ) then
				ChatMessage("MapInfo updated to v"..MAPINFO_VERSION..".");
				MapInfo_Reset();
			end
		else
			ChatMessage("MapInfo updated to v"..MAPINFO_VERSION..".");
			MapInfo_Reset();
		end
		return;
	end

end

function MapInfo_Reset()

	MapInfo_Config = { };
	MapInfo_Config.Enabled = true;
	MapInfo_Config.Version = MAPINFO_VERSION;
	MapInfo_Config.ShowCursor = true;
	MapInfo_Config.ShowPlayer = false;
	
	ChatMessage("MapInfo configuration reset.");
	
end

function MapInfo_OnUpdate(arg1)

	if not ( MapInfo_Config.Enabled ) then
		MapInfoCursorText:SetText(" ");
		MapInfoPlayerText:SetText(" ");
		return;
	end

	MapInfoFrame.TimeSinceLastUpdate = MapInfoFrame.TimeSinceLastUpdate + arg1;
	if ( MapInfoFrame.TimeSinceLastUpdate > UPDATE_RATE)  then
	
		local x, y = GetCursorPosition();
		local scale = WorldMapFrame:GetScale();

		x = x / scale;
		y = y / scale;
	
		local width = WorldMapButton:GetWidth();
		local height = WorldMapButton:GetHeight();
		local centerX, centerY = WorldMapFrame:GetCenter();
	
		if (not centerX) then
			centerX = width / 2;
		end
	
		if (not centerY) then
			centerY = height / 2;
		end
	
		local adjustedX = (x - (centerX - (width/2))) / width;
		local adjustedY = (centerY + (height/2) - y) / height;

		adjustedX = adjustedX + OFFSET_X;
		adjustedY = adjustedY + OFFSET_Y;
	
		if ( MapInfo_Config.ShowCursor ) then
			MapInfoCursorText:SetText(format("%d,%d", adjustedX * 100.0, adjustedY * 100.0));
		else
			MapInfoCursorText:SetText(" ");
		end
		
		if ( MapInfo_Config.ShowPlayer ) then
			local px, py = GetPlayerMapPosition("player");
			MapInfoPlayerText:SetText(format("%d,%d", px * 100.0, py * 100.0));
		else
			MapInfoPlayerText:SetText(" ");
		end

		MapInfoFrame.TimeSinceLastUpdate = 0.0;
	end
end
