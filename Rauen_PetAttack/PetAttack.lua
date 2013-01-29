-- Binding Variables
BINDING_HEADER_PETATTACK_HEADER = "Rauen's PetAttack";
BINDING_NAME_PETATTACK_BINDING = "Attack";

function PetAttack_OnLoad()

	-- Register for Events
	this:RegisterEvent("VARIABLES_LOADED");

	-- Register Slash Commands
	SLASH_PETATTACK1 = "/petattack";
	SLASH_PETATTACK2 = "/pa";
	SlashCmdList["PETATTACK"] = function(msg)
		PetAttack_ChatCommandHandler(msg);
	end

	ChatMessage("Rauen's PetAttack Loaded.");
	
end

function PetAttack_OnEvent()

	if ( event == "VARIABLES_LOADED") then
		if ( PetAttack_Config ) then
			if ( PetAttack_Config.Version ~= PETATTACK_VERSION ) then
				ChatMessage("PetAttack updated to v"..PETATTACK_VERSION..".");
				PetAttack_Reset();
			end
		else
			ChatMessage("PetAttack updated to v"..PETATTACK_VERSION..".");
			PetAttack_Reset();
		end
		return;
	end
	
end

function PetAttack_ChatCommandHandler(msg)

	-- Menu
	if ( paUI:IsVisible() ) then
		PlaySound("igMainMenuClose");
		HideUIPanel(paUI);
	else
		PlaySound("igMainMenuOpen");
		ShowUIPanel(paUI);
	end
	
end

function PetAttack_Reset()

	PetAttack_Config = { };
	PetAttack_Config.Enabled = true;
	PetAttack_Config.Version = PETATTACK_VERSION;
	PetAttack_Config.AttackAlert = true;
	PetAttack_Config.AttackChannel = "SAY";
	PetAttack_Config.AssistMeAlert = true;
	PetAttack_Config.AssistMeChannel = "SAY";
	PetAttack_Config.AssistOtherAlert = true;
	PetAttack_Config.AssistOtherChannel = "SAY";
	PetAttack_Config.Cast = false;
	PetAttack_Config.Spell = "Hunter's Mark";
	PetAttack_Config.Rank = "Rank 1";
	
	ChatMessage("PetAttack configuration reset.");
	
end

function PetAttack_Attack()

	-- Check if Enabled
	if not ( PetAttack_Config.Enabled ) then
		return;
	end

	-- Assign Variables
	local pet = UnitName("pet");
	local target = UnitName("target");

	-- Check if Pet Exists and Target Exists
	if UnitExists("target") and not (pet == nil) and not ( UnitIsDead("pet") ) then

		-- Assist Other
		if  ( UnitIsPlayer("target") ) and ( UnitCanCooperate("player", "target") ) then
			player = target;
			AssistUnit("target");
			target = UnitName("target");
			if (target == nil) then
				return;
			end
			if not ( UnitCanAttack("player", "target") ) then
				return;
			end
			message = SetMessage(pet, target, player, "assist_other");
			-- Check Alert
			if ( PetAttack_Config.AssistOtherAlert ) then
				if ( PetAttack_Config.AssistOtherChannel == "CHAT" ) then
					ChatMessage(message);
				elseif not ( ( PetAttack_Config.AssistOtherChannel == "PARTY" ) and ( UnitName("party1") == nil ) ) then
					ChannelMessage(message, PetAttack_Config.AssistOtherChannel);
				end
			end

		elseif ( UnitCanAttack("player", "target") ) then
		
			-- Assist Player
			if UnitIsTappedByPlayer("target") then
				message = SetMessage(pet, target, "me", "assist_me");
				-- Check Alert
				if ( PetAttack_Config.AssistMeAlert ) then
					if ( PetAttack_Config.AssistMeChannel == "CHAT" ) then
						ChatMessage(message);
					elseif not ( ( PetAttack_Config.AssistMeChannel == "PARTY" ) and ( UnitName("party1") == nil ) ) then
						ChannelMessage(message, PetAttack_Config.AssistMeChannel);
					end
				end

			-- Attack Mob
			else
		
				-- Check Cast
				if ( PetAttack_Config.Cast ) then
					CastSpell( Lib.GetSpellID( PetAttack_Config.Spell, PetAttack_Config.Rank ), BOOKTYPE_SPELL);
				end
		
				-- Attack
				message = SetMessage(pet, target, "none", "attack");
				-- Check Alert
				if ( PetAttack_Config.AttackAlert ) then
					if ( PetAttack_Config.AttackChannel == "CHAT" ) then
						ChatMessage(message);
					elseif not ( ( PetAttack_Config.AttackChannel == "PARTY" ) and ( UnitName("party1") == nil ) ) then
						ChannelMessage(message, PetAttack_Config.AttackChannel);
					end
				end
		
			end
		else
			return;
		end
		
		-- Pet Attack Target
		PetAttack();
		
	end
end
