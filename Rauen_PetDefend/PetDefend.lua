-- Variables
PetDefend_Var = { };
PetDefend_Var.InCombat = false;
PetDefend_Var.GrowlToggled = false;
PetDefend_Var.GrowlID = 0;
PetDefend_Var.CowerToggled = false;
PetDefend_Var.CowerID = 0;
PetDefend_Var.IsCowering = false;

function PetDefend_OnLoad()

	-- Register for Events
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UNIT_COMBAT");
	this:RegisterEvent("PET_ATTACK_START");
	this:RegisterEvent("PET_ATTACK_STOP");
	
	-- Register Slash Commands
	SLASH_PETDEFEND1 = "/petdefend";
	SLASH_PETDEFEND2 = "/pd";
	SlashCmdList["PETDEFEND"] = function(msg)
		PetDefend_ChatCommandHandler(msg);
	end
	
	ChatMessage("Rauen's PetDefend Loaded.");

end

function PetDefend_ChatCommandHandler(msg)
	PlaySound("igMainMenuOpen");
	ShowUIPanel(pdUI);
end

function PetDefend_Upgrade()
	PetDefend_Config = { };
	PetDefend_Config.Version = PETDEFEND_VERSION;
	ChatMessage("PetDefend updated to v"..PETDEFEND_VERSION..".");
end

function PetDefend_Reset()

	if not ( PetDefend_Config ) then
		PetDefend_Upgrade();
	end
	PetDefend_Config[UnitName("player")] = { };
	local class = UnitClass("player");
	if ( class == "Hunter" ) or ( class == "Warlock" ) then
		PetDefend_Config[UnitName("player")].Enabled = true;
	else
		PetDefend_Config[UnitName("player")].Enabled = false;
	end
	PetDefend_Config[UnitName("player")].AssistInCombat = false;
	PetDefend_Config[UnitName("player")].LowHealth = false;
	PetDefend_Config[UnitName("player")].HealthMin = 25;
	PetDefend_Config[UnitName("player")].PetHealth = false;
	PetDefend_Config[UnitName("player")].PetMin = 25;
	PetDefend_Config[UnitName("player")].Growl = true;
	PetDefend_Config[UnitName("player")].GrowlName = "Growl";
	PetDefend_Config[UnitName("player")].Cower = false;
	PetDefend_Config[UnitName("player")].CowerMin = 25;
	PetDefend_Config[UnitName("player")].CowerName = "Cower";
	PetDefend_Config[UnitName("player")].DefendAll = true;
	PetDefend_Config[UnitName("player")].DefendHealers = false;
	PetDefend_Config[UnitName("player")].DefendMember = false;
	PetDefend_Config[UnitName("player")].DefendMemberName = "PartyMember";
	PetDefend_Config[UnitName("player")].MemberAssisting = "";
	PetDefend_Config[UnitName("player")].CowerAlert = false;
	PetDefend_Config[UnitName("player")].CowerChannel = "CHAT";
	PetDefend_Config[UnitName("player")].CowerMessage = "pet is cowering!";
	PetDefend_Config[UnitName("player")].AssistAlert = true;
	PetDefend_Config[UnitName("player")].AssistChannel = "PARTY";
	PetDefend_Config[UnitName("player")].AssistMessage = "pet is assisting player!";
	
	ChatMessage(UnitName("player").."'s PetDefend configuration reset.");
	
end

function PetDefend_OnEvent(event, arg1, arg2)

	if ( event == "VARIABLES_LOADED") then
		if ( PetDefend_Config ) then
			if ( PetDefend_Config.Version ~= PETDEFEND_VERSION ) then
				PetDefend_Upgrade();
			end
		else
			PetDefend_Upgrade();
		end
		if not ( PetDefend_Config[UnitName("player")] ) then
			PetDefend_Reset();
		end
		return;
	end
	
	-- Check if Enabled
	if not ( PetDefend_Config[UnitName("player")].Enabled ) then
		return;
	end
	
	-- Check for Pet
	if not ( UnitExists("pet") ) or ( UnitIsDead("pet") ) then
		return;
	end

	if ( event == "PET_ATTACK_START" ) then

		-- Flag Pet as InCombat
		PetDefend_Var.InCombat = true;

	elseif ( event == "PET_ATTACK_STOP" ) then

		-- Remove Pet's InCombat Flag
		PetDefend_Var.InCombat = false;
		PetDefend_Config[UnitName("player")].MemberAssisting = "";
		
		-- Reset State
		PetDefend_ResetAutocasts();
		PetDefend_Var.IsCowering = false;

	elseif ( event == "UNIT_COMBAT" ) then

		-- Assign Variables
		local pet = UnitName("pet");
		local member = arg1;
		local damage = arg2;
		
		-- Check Event Type
		if not ( damage == "WOUND" ) then
			return;
		end
		
		-- Check for Defensive Mode
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(9);
		if not ( isActive ) then
			return;
		end
		
		-- Check Cower
		--if not ( PetDefend_Var.IsCowering ) then
		--	if ( member == "pet" ) and ( PetDefend_Config[UnitName("player")].Cower ) then
		--		if ( (100*UnitHealth("pet")/UnitHealthMax("pet")) < PetDefend_Config[UnitName("player")].CowerMin  ) then
		--			PetDefend_Var.IsCowering = true;
		--			PetDefend_Cower();
		--			if ( PetDefend_Config[UnitName("player")].CowerAlert ) then
		--				if ( PetDefend_Config[UnitName("player")].CowerChannel == "CHAT" ) then
		--					ChatMessage(PetDefend_ProcessMessage(PetDefend_Config[UnitName("player")].CowerMessage, pet, nil));
		--				elseif not ( ( PetDefend_Config[UnitName("player")].CowerChannel == "PARTY" ) and ( UnitName("party1") == nil ) ) then
		--					ChannelMessage(PetDefend_ProcessMessage(PetDefend_Config[UnitName("player")].CowerMessage, pet, nil), PetDefend_Config[UnitName("player")].CowerChannel);
		--				end
		--			end
		--			return;
		--		end
		--	end
		--else
		--	if ( (100*UnitHealth("pet")/UnitHealthMax("pet")) > PetDefend_Config[UnitName("player")].CowerMin  ) then
		--		PetDefend_Var.IsCowering = false;
		--		PetDefend_ResetAutocasts();
		--		return;
		--	end
		--end

		-- Check Party Members
		if not ( member == "player" ) and
		  not ( member == "party1" ) and
		  not ( member == "partypet1" ) and
		  not ( member == "party2" ) and
		  not ( member == "partypet2" ) and
		  not ( member == "party3" ) and
		  not ( member == "partypet3" ) and
		  not ( member == "party4" ) and
		  not ( member == "partypet4" ) then
			return;
		end
		
		-- Check Currently Assisting
		if ( member == PetDefend_Config[UnitName("player")].MemberAssisting ) then
			return;
		end
		
		-- Check LowHealth
		if ( PetDefend_Config[UnitName("player")].LowHealth ) then
			if ( member == "player" ) then
				if ( (100*UnitHealth("player")/UnitHealthMax("player")) < PetDefend_Config[UnitName("player")].HealthMin  ) then
					PetDefend_Attack(pet, "player", "LOW_HEALTH");
				end
				return;
			end
			for i=1, 4 do
				if ( UnitExists("party"..i) ) then
					if ( (100*UnitHealth("party"..i)/UnitHealthMax("party"..i)) < PetDefend_Config[UnitName("player")].HealthMin  ) then
						PetDefend_Attack(pet, "party"..i, "LOW_HEALTH");
						return;
					end
				end
				if ( UnitExists("partypet"..i) ) then
					if ( (100*UnitHealth("partypet"..i)/UnitHealthMax("partypet"..i)) < PetDefend_Config[UnitName("player")].HealthMin  ) then
						PetDefend_Attack(pet, "partypet"..i, "LOW_HEALTH");
						return;
					end
				end
			end
		end
		
		if not ( PetDefend_Config[UnitName("player")].DefendAll ) then
			if not ( PetDefend_Config[UnitName("player")].DefendMember ) and not ( PetDefend_Config[UnitName("player")].DefendHealers ) then
				return;
			end
		end

		-- Check Defend Member
		if ( PetDefend_Config[UnitName("player")].DefendMember ) then
			if ( member ~= PetDefend_Config[UnitName("player")].DefendMemberName ) then
				return;
			end
		end
		
		-- Check Defend_Healers
		if ( PetDefend_Config[UnitName("player")].DefendHealers ) then
			if ( string.sub(member, 1, 7) == "partypet" ) then
				return;
			end
			if not ( ( UnitClass(member) == "Druid" ) or
			   ( UnitClass(member) == "Priest" ) or
			   ( UnitClass(member) == "Paladin" ) or
			   ( UnitClass(member) == "Shaman" ) ) then
			   		return;
			end
		end

		-- Check InCombat
		if ( PetDefend_Var.InCombat ) and not ( PetDefend_Config[UnitName("player")].AssistInCombat ) then
			return;
		end
		
		-- Defend Party Member
		PetDefend_Attack(pet, member, "DEFEND");
		
	end
	
end

function PetDefend_Attack(pet, member, event)

	local message;

	-- Check Growl
	--PetDefend_Growl(event);
	
	-- Pet Defend Player
	if ( member == "player" ) then
		if not ( UnitCanAttack("player", "target") ) then
			return;
		end
		if ( PetDefend_Config[UnitName("player")].Alert ) then
			message = PetDefend_ProcessMessage(PetDefend_Config[UnitName("player")].AssistMessage, pet, "you");
			ChatMessage(message);
		end
		PetDefend_Config[UnitName("player")].MemberAssisting = member;
		PetAttack();
		return;
	end

	-- Pet Defend Party Member
	if ( UnitExists("target") ) then
		AssistUnit(member);
		if not ( UnitCanAttack("player", "target") ) then
			return;
		end
		if ( PetDefend_Config[UnitName("player")].AssistAlert ) then
			message = PetDefend_ProcessMessage(PetDefend_Config[UnitName("player")].AssistMessage, pet, UnitName(member));
			if ( PetDefend_Config[UnitName("player")].AssistChannel == "CHAT" ) then
				ChatMessage(message);
			elseif not ( ( PetDefend_Config[UnitName("player")].AssistChannel == "PARTY" ) and ( UnitName("party1") == nil ) ) then
				ChannelMessage(message, PetDefend_Config[UnitName("player")].AssistChannel);
			end
		end
		PetDefend_Config[UnitName("player")].MemberAssisting = member;
		PetAttack();
		TargetLastEnemy();
	else
		AssistUnit(member);
		if not ( UnitCanAttack("player", "target") ) then
			return;
		end
		message = PetDefend_ProcessMessage(PetDefend_Config[UnitName("player")].AssistMessage, pet, UnitName(member));
		if ( PetDefend_Config[UnitName("player")].AssistAlert ) then
			if ( PetDefend_Config[UnitName("player")].AssistChannel == "CHAT" ) then
				ChatMessage(message);
			elseif not ( ( PetDefend_Config[UnitName("player")].AssistChannel == "PARTY" ) and ( UnitName("party1") == nil ) ) then
				ChannelMessage(message, PetDefend_Config[UnitName("player")].AssistChannel);
			end
		end
		PetDefend_Config[UnitName("player")].MemberAssisting = member;
		PetAttack();
		ClearTarget();
	end
		
end

-- Growl
function PetDefend_Growl(event)
	for i=1, 10 do
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
		if ( name == PetDefend_Config[UnitName("player")].GrowlName ) then
			if not ( autoCastEnabled ) then
				if ( PetDefend_Config[UnitName("player")].Growl ) or ( event == "LOW_HEALTH" )  then
					TogglePetAutocast(i);
					PetDefend_Var.GrowlToggled = true;
					PetDefend_Var.GrowlID = i;
				end
			end
		end
		if ( name == PetDefend_Config[UnitName("player")].CowerName ) then
			if ( autoCastEnabled ) then
				if ( PetDefend_Config[UnitName("player")].Growl ) or ( event == "LOW_HEALTH" )  then
					TogglePetAutocast(i);
					PetDefend_Var.CowerToggled = true;
					PetDefend_Var.CowerID = i;
				end
			end
		end
	end
end

-- Cower
function PetDefend_Cower()
	for i=1, 10 do
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
		if ( name ) then
			if ( string.upper(name) == string.upper(PetDefend_Config[UnitName("player")].CowerName) ) then
				if not ( autoCastEnabled ) then
					TogglePetAutocast(i);
					PetDefend_Var.CowerToggled = true;
					PetDefend_Var.CowerID = i;
				end
			end
			if ( string.upper(name) == string.upper(PetDefend_Config[UnitName("player")].GrowlName) ) then
				if ( autoCastEnabled ) then
					TogglePetAutocast(i);
					PetDefend_Var.GrowlToggled = true;
					PetDefend_Var.GrowlID = i;
				end
			end
		end
	end
end

-- Reset Growl and Cower
function PetDefend_ResetAutocasts()
	if ( PetDefend_Var.GrowlToggled ) then
		TogglePetAutocast(PetDefend_Var.GrowlID);
		PetDefend_Var.GrowlToggled = false;
		PetDefend_Var.GrowlID = 0;
	end
	if ( PetDefend_Var.CowerToggled ) then
		TogglePetAutocast(PetDefend_Var.CowerID);
		PetDefend_Var.CowerToggled = false;
		PetDefend_Var.CowerID = 0;
	end
end

function PetDefend_ProcessMessage(message, pet, player)
	if ( pet ) then
		message = string.gsub(message, "pet", pet);
	end
	if ( player ) then
		message = string.gsub(message, "player", player);
	end
	return message;
end
