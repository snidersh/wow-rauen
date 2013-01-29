function updateContainerFrameAnchors()
	local uiScale = GetCVar("uiscale") + 0;
--	local screenHeight = GetScreenHeight();
	local screenHeight = 768;
	if ( GetCVar("useUiScale") == "1" ) then
		screenHeight = 768 / uiScale;
	end
	local freeScreenHeight = screenHeight - CONTAINER_OFFSET;
	local index = 1;
	local column = 0;
	while ContainerFrame1.bags[index] do
		local frame = getglobal(ContainerFrame1.bags[index]);
		-- freeScreenHeight determines when to start a new column of bags
		if ( index == 1 ) then
			-- First bag
			frame:SetPoint("BOTTOMRIGHT", frame:GetParent():GetName(), "BOTTOMRIGHT", -42, CONTAINER_OFFSET); -- Rauen
		elseif ( freeScreenHeight < frame:GetHeight() ) then
			-- Start a new column
			column = column + 1;
			freeScreenHeight = UIParent:GetHeight() - CONTAINER_OFFSET;
			frame:SetPoint("BOTTOMRIGHT", frame:GetParent():GetName(), "BOTTOMRIGHT", -(column * CONTAINER_WIDTH) - 42, CONTAINER_OFFSET); -- Rauen
		else
			-- Anchor to the previous bag
			frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING);	
		end
		freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING;
		index = index + 1;
	end
	-- This is used to position the unit tooltip
	local oldContainerPosition = OPEN_CONTAINER_POSITION;
	if ( index == 1 ) then
		DEFAULT_TOOLTIP_POSITION = -13;
	else
		DEFAULT_TOOLTIP_POSITION = -((column + 1) * CONTAINER_WIDTH);
	end
	if ( DEFAULT_TOOLTIP_POSITION ~= oldContainerPosition and GameTooltip.default and GameTooltip:IsVisible() ) then
		GameTooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", DEFAULT_TOOLTIP_POSITION, 64);
	end
end