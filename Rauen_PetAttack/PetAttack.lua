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

function PetAttack_ChatCommandHandler(msg)
	PlaySound("igMainMenuOpen");
	ShowUIPanel(paUI);
end

function PetAttack_OnEvent()

	if ( event == "VARIABLES_LOADED") then
		if ( PetAttack_Config ) then
			if ( PetAttack_Config.Version ~= PETATTACK_VERSION ) then
				PetAttack_Upgrade();
			end
		else
			PetAttack_Upgrade();
		end
		if not ( PetAttack_Config[UnitName("player")] ) then
			PetAttack_Reset();
		end
		return;
	end
	
end

function PetAttack_Upgrade()
	PetAttack_Config = { };
	PetAttack_Config.Version = PETATTACK_VERSION;
	ChatMessage("PetAttack updated to v"..PETATTACK_VERSION..".");
end

function PetAttack_Reset()

	if not ( PetAttack_Config ) then
		PetAttack_Upgrade();
	end
	PetAttack_Config[UnitName("player")] = { };
	local class = UnitClass("player");
	if ( class == "Hunter" ) or ( class == "Warlock" ) then
		PetAttack_Config[UnitName("player")].Enabled = true;
	else
		PetAttack_Config[UnitName("player")].Enabled = false;
	end
	PetAttack_Config[UnitName("player")].AttackAlert = true;
	PetAttack_Config[UnitName("player")].AttackChannel = "SAY";
	PetAttack_Config[UnitName("player")].AssistMeAlert = true;
	PetAttack_Config[UnitName("player")].AssistMeChannel = "SAY";
	PetAttack_Config[UnitName("player")].AssistOtherAlert = true;
	PetAttack_Config[UnitName("player")].AssistOtherChannel = "SAY";
	PetAttack_Config[UnitName("player")].Cast = false;
	PetAttack_Config[UnitName("player")].Spell = "Hunter's Mark";
	PetAttack_Config[UnitName("player")].Rank = "Rank 1";
	
	PetAttack_Config[UnitName("player")].Messages = { };
	PetAttack_Config[UnitName("player")].Messages.AssistMe = {
		"pet! Assist me!",
		"pet! Aid me!",
		"pet! I need your help!"
		};
	PetAttack_Config[UnitName("player")].Messages.AssistOther = {
		"pet! Assist player!",
		"pet! Aid player!",
		"pet! Help player!"
		};
	PetAttack_Config[UnitName("player")].Messages.Attack = {
		"pet! Attack the target!",
		"Attack the target, pet!"
		};
	
	ChatMessage(UnitName("player").."'s PetAttack configuration reset.");
	
end

function PetAttack_Attack()

	-- Check if Enabled
	if not ( PetAttack_Config[UnitName("player")].Enabled ) then
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
			if ( PetAttack_Config[UnitName("player")].AssistOtherAlert ) then
				if ( PetAttack_Config[UnitName("player")].AssistOtherChannel == "CHAT" ) then
					ChatMessage(message);
				elseif not ( ( PetAttack_Config[UnitName("player")].AssistOtherChannel == "PARTY" ) and ( UnitName("party1") == nil ) ) then
					ChannelMessage(message, PetAttack_Config[UnitName("player")].AssistOtherChannel);
				end
			end

		elseif ( UnitCanAttack("player", "target") ) then
		
			-- Assist Player
			if UnitIsTappedByPlayer("target") then
				message = SetMessage(pet, target, "me", "assist_me");
				-- Check Alert
				if ( PetAttack_Config[UnitName("player")].AssistMeAlert ) then
					if ( PetAttack_Config[UnitName("player")].AssistMeChannel == "CHAT" ) then
						ChatMessage(message);
					elseif not ( ( PetAttack_Config[UnitName("player")].AssistMeChannel == "PARTY" ) and ( UnitName("party1") == nil ) ) then
						ChannelMessage(message, PetAttack_Config[UnitName("player")].AssistMeChannel);
					end
				end

			-- Attack Mob
			else
		
				-- Check Cast
				if ( PetAttack_Config[UnitName("player")].Cast ) then
					local spell_id = Lib.GetSpellID( PetAttack_Config[UnitName("player")].Spell, PetAttack_Config[UnitName("player")].Rank);
					if ( spell_id ) then
						CastSpell( spell_id, BOOKTYPE_SPELL);
					end
				end
		
				-- Attack
				message = SetMessage(pet, target, "none", "attack");
				-- Check Alert
				if ( PetAttack_Config[UnitName("player")].AttackAlert ) then
					if ( PetAttack_Config[UnitName("player")].AttackChannel == "CHAT" ) then
						ChatMessage(message);
					elseif not ( ( PetAttack_Config[UnitName("player")].AttackChannel == "PARTY" ) and ( UnitName("party1") == nil ) ) then
						ChannelMessage(message, PetAttack_Config[UnitName("player")].AttackChannel);
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


function SetMessage(pet, target, player, type)
	
	if (type == "assist_me") then
		message = PetAttack_Config[UnitName("player")].Messages.AssistMe[math.random(table.getn(PetAttack_Config[UnitName("player")].Messages.AssistMe))];
	elseif (type == "assist_other") then
		message = PetAttack_Config[UnitName("player")].Messages.AssistOther[math.random(table.getn(PetAttack_Config[UnitName("player")].Messages.AssistOther))];
	elseif (type == "attack") then
		message = PetAttack_Config[UnitName("player")].Messages.Attack[math.random(table.getn(PetAttack_Config[UnitName("player")].Messages.Attack))];
	end
	
	message = string.gsub(message, "pet", pet);
	message = string.gsub(message, "player", player);
	message = string.gsub(message, "target", target);
	
	return message;
	
end
