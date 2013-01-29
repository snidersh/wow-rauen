ButtonLock_Config = { };
ButtonLock_Config.Locked = false;

Default_PickupAction = PickupAction;
function PickupAction(id)
	if not ( ButtonLock_Config.Locked ) then
		Default_PickupAction( id );
	end
end

Default_PickupPetAction = PickupPetAction;
function PickupPetAction(id)
	if not ( ButtonLock_Config.Locked ) then
		Default_PickupPetAction( id );
	end
end

function ButtonLock_OnLoad()

	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");

	-- Register Slash Commands
	SLASH_BUTTONLOCK1 = "/buttonlock";
	SLASH_BUTTONLOCK2 = "/bl";
	SlashCmdList["BUTTONLOCK"] = function(msg)
		ButtonLock_ChatCommandHandler(msg);
	end	

	ChatMessage("Rauen's ButtonLock Loaded.");
	
end

function ButtonLock_ChatCommandHandler(msg)

	-- Print Help
	if ( msg == "help" ) or ( msg == "" ) then
		ChatMessage("Rauen's ButtonLock:");
		ChatMessage("/buttonlock or /bl <command>");
		ChatMessage("- help - Print this helplist.");
		ChatMessage("- on|off|lock|unlock - Toggle Lock.");
		return;
	end
	
	-- Lock
	if ( msg == "on" ) or ( msg == "lock" ) then
		ButtonLock_CheckButton:SetChecked(1);
		ButtonLock_Config.Locked = true;
		ChatMessage("Action Buttons are now Locked.");
	end
	
	-- Unlock
	if ( msg == "off" ) or ( msg == "unlock" ) then
		ButtonLock_CheckButton:SetChecked(0);
		ButtonLock_Config.Locked = false;
		ChatMessage("Action Buttons are now Unlocked.");
	end
	
end

function ButtonLock_OnEvent(event)
	if ( event == "VARIABLES_LOADED" ) then
		RegisterForSave("ButtonLock_Config");
		this:SetChecked(ButtonLock_Config.Locked);
	end
end

function ButtonLock_OnClick()
	ButtonLock_Config.Locked = this:GetChecked()
	if ( ButtonLock_Config.Locked ) then
		GameTooltip:SetText("Action Buttons are Locked");
		PlaySound("igMainMenuOptionCheckBoxOn");
	else
		GameTooltip:SetText("Action Buttons are Unlocked");
		PlaySound("igMainMenuOptionCheckBoxOff");
	end
end

function ButtonLock_OnEnter()
	GameTooltip:SetOwner(this,"ANCHOR_RIGHT");
	if ( ButtonLock_Config.Locked ) then
		GameTooltip:SetText("Action Buttons are Locked");
	else
		GameTooltip:SetText("Action Buttons are Unlocked");
	end
end

function ButtonLock_OnLeave()
	GameTooltip:Hide();
end