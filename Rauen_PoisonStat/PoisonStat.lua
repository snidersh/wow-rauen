-- Function hooks
local lOriginal_GameTooltip_ClearMoney;

local lInventorySlots = {
	{ name = "MainHandSlot" },
	{ name = "SecondaryHandSlot" },
	{ name = "RangedSlot" },
};

local lMouseEntered;
local lOkayToShow;

PoisonStat_BUTTONS = 2;

PoisonStat_Var = { };
PoisonStat_Var.Loaded = false;

local function PoisonStat_MoneyToggle()
	if( lOriginal_GameTooltip_ClearMoney ) then
		GameTooltip_ClearMoney = lOriginal_GameTooltip_ClearMoney;
		lOriginal_GameTooltip_ClearMoney = nil;
	else
		lOriginal_GameTooltip_ClearMoney = GameTooltip_ClearMoney;
		GameTooltip_ClearMoney = PoisonStat_GameTooltip_ClearMoney;
	end
end

local function PoisonStat_HasBuff(id)
	local index;
	local field;
	local text;

	if( id ) then
		local hasItem;

		-- protect money frame while we set hidden tooltip
		PoisonStat_MoneyToggle();
		hasItem = ItemTempTooltip:SetInventoryItem("player", id);
		PoisonStat_MoneyToggle();

		if( hasItem ) then
			for index = 1, 15, 1 do
				field = getglobal("ItemTempTooltipTextLeft"..index);
				if( field and field:IsVisible() ) then
					text = field:GetText();
					
					if( text and (string.find(text, "%(%d+ min%)") or string.find(text, "%((%d+) sec%)")) ) then
						return 1;
					end
				end
			end
		end
	end
	return nil;
end

local function PoisonStat_UpdateWindow()
	local n;
	local button;
	local iVisible = 0;
	local maxSize = 0;
	
	for n = 1, PoisonStat_BUTTONS do
		button = getglobal("PoisonStatButton"..n);
		if( button:IsVisible() ) then
			iVisible = iVisible + 1;
			local label = getglobal(button:GetName().."Label");
			if( label:IsVisible() ) then
				local size = label:GetWidth();
				if( size > maxSize ) then
					maxSize = size;
				end
			end
		end
	end
	
	if( iVisible == 0 ) then
		lOkayToShow = nil;
	else
		PoisonStatFrame:SetHeight(22 + iVisible * 42);
		PoisonStatFrame:SetWidth(66 + maxSize - 1);
		lOkayToShow = 1;
	end
end

local function PoisonStatButton_SetTooltip(button)
	if( button.id ) then
		GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
		GameTooltip:SetInventoryItem("player", button.id);
	end
end

local function PoisonStatButton_Clear(button)
	if( button.id ) then
		button.texture = nil;
		button.id = nil;
		
		getglobal(button:GetName().."Icon"):SetTexture("");
		PoisonStat_UpdateWindow();
		if( GameTooltip:IsOwned(button) ) then
			button.tooltip = nil;
			GameTooltip:Hide();
		end
	end
end

local function PoisonStatButton_Set(button, id)
	button.texture = GetInventoryItemTexture("player", id);
	button.id = id;
	
	getglobal(button:GetName().."Icon"):SetTexture(button.texture);
	if( button.tooltip ) then
		PoisonStatButton_SetTooltip(button);
	end
	PoisonStat_UpdateWindow();
end

function PoisonStat_OnLoad()
	
	this:RegisterEvent("UNIT_NAME_UPDATE");
	ChatMessage("Rauen's PoisonStat Loaded.");

end

function PoisonStat_Initialize()

	if ( UnitClass("player") == "Rogue" ) then
		local index;
		for index = 1, getn(lInventorySlots), 1 do
			lInventorySlots[index].id = GetInventorySlotInfo(lInventorySlots[index].name);
		end
		this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	end

end

function PoisonStat_OnEvent(event)

	if ( event == "UNIT_NAME_UPDATE" ) and not ( PoisonStat_Var.Loaded ) then
		PoisonStat_Initialize();
	end

	if( event == "UNIT_INVENTORY_CHANGED" ) then
		if( arg1 == "player" ) then
			local index;
			local n;
			local button;

			n = 1;
			for index = 1, getn(lInventorySlots), 1 do
				if( PoisonStat_HasBuff(lInventorySlots[index].id) ) then
					button = getglobal("PoisonStatButton"..n);
					button:Show();
					PoisonStatButton_Set(button, lInventorySlots[index].id);
					n = n + 1;
					if( n > PoisonStat_BUTTONS ) then
						break;
					end
				end
			end
			
			while( n <= PoisonStat_BUTTONS ) do
				button = getglobal("PoisonStatButton"..n);
				button:Hide();
				PoisonStatButton_Clear(button);
				n = n + 1;
			end
		end
		return;
	elseif( event == "VARIABLES_LOADED" ) then
		if( not PoisonStatState ) then
			PoisonStatState = { };
		end
	end
end

function PoisonStatButton_OnEnter()
	this.tooltip = 1;
	PoisonStatButton_SetTooltip(this);
end

function PoisonStatButton_OnLeave()
	if( this.tooltip ) then
		this.tooltip = nil;
		GameTooltip:Hide();
	end
end

function PoisonStatButton_OnLoad()
	this.timer = 0;
	this.flashTimer = 0;
end

function PoisonStatButton_OnUpdate(elapsed)
	if( elapsed ) then
		this.timer = this.timer + elapsed;
		this.flashTimer = this.flashTimer + elapsed;
		if( this.flashTimer >= 0.50 ) then
			this.flashTimer = 0;
			if( this.flash ) then
				this.flash = nil;
			else
				this.flash = 1;
			end
		end
		if( this.timer >= 0.25 ) then
			this.timer = 0;
			PoisonStat_UpdateWindow();
		end
	end
end

function PoisonStat_GameTooltip_ClearMoney()
	-- Intentionally empty; don't clear money while we use hidden tooltips
end