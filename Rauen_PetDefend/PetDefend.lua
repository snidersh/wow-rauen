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

	-- Menu
	if ( pdUI:IsVisible() ) then
		PlaySound("igMainMenuClose");
		HideUIPanel(pdUI);
	else
		PlaySound("igMainMenuOpen");
		ShowUIPanel(pdUI);
	end

end

function PetDefend_Reset()

	PetDefend_Config = { };
	PetDefend_Config.Version = PETDEFEND_VERSION;
	PetDefend_Config.Enabled = true;
	PetDefend_Config.AssistInCombat = false;
	PetDefend_Config.LowHealth = false;
	PetDefend_Config.HealthMin = 25;
	PetDefend_Config.PetHealth = false;
	PetDefend_Config.PetMin = 25;
	PetDefend_Config.Growl = true;
	PetDefend_Config.GrowlName = "Growl";
	PetDefend_Config.Cower = false;
	PetDefend_Config.CowerMin = 25;
	PetDefend_Config.CowerName = "Cower";
	PetDefend_Config.DefendAll = true;
	PetDefend_Config.DefendMember = "PartyMember";
	PetDefend_Config.MemberAssisting = "";
	PetDefend_Config.Alert = true;
	PetDefend_Config.Channel = "PARTY";
	
	ChatMessage("PetDefend configuration reset.");
	
end

function PetDefend_OnEvent(event, arg1, arg2)

	if ( event == "VARIABLES_LOADED") then
		if ( PetDefend_Config ) then
			if ( PetDefend_Config.Version ~= PETDEFEND_VERSION ) then
				ChatMessage("PetDefend updated to v"..PETDEFEND_VERSION..".");
				PetDefend_Reset();
			end
		else
			ChatMessage("PetDefend updated to v"..PETDEFEND_VERSION..".");
			PetDefend_Reset();
		end
		return;
	end
	
	-- Check if Enabled
	if not ( PetDefend_Config.Enabled ) then
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
		PetDefend_Config.MemberAssisting = "";
		
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
		if not ( PetDefend_Var.IsCowering ) then
			if ( member == "pet" ) and ( PetDefend_Config.Cower ) then
				if ( (100*UnitHealth("pet")/UnitHealthMax("pet")) < PetDefend_Config.CowerMin  ) then
					PetDefend_Var.IsCowering = true;
					PetDefend_Cower();
					if ( PetDefend_Config.Alert ) then
						if ( PetDefend_Config.Channel == "CHAT" ) then
							ChatMessage(pet.." is Cowering!");
						elseif not ( ( PetDefend_Config.Channel == "PARTY" ) and ( UnitName("party1") == nil ) ) then
							ChannelMessage(pet.." is Cowering!", PetDefend_Config.Channel);
						end
					end
					return;
				end
			end
		else
			if ( (100*UnitHealth("pet")/UnitHealthMax("pet")) > PetDefend_Config.CowerMin  ) then
				PetDefend_Var.IsCowering = false;
				PetDefend_ResetAutocasts();
				if ( PetDefend_Config.Alert ) then
					if ( PetDefend_Config.Channel == "CHAT" ) then
						ChatMessage(pet.." is no longer Cowering!");
					elseif not ( ( PetDefend_Config.Channel == "PARTY" ) and ( UnitName("party1") == nil ) ) then
						ChannelMessage(pet.." is no longer Cowering!", PetDefend_Config.Channel);
					end
				end
				return;
			end
		end

		-- Check Party Members
		if not ( member == "player" ) and
		  not ( member == "party1" ) and
		  not ( member == "party2" ) and
		  not ( member == "party3" ) and
		  not ( member == "party4" ) then
			return;
		end
		
		-- Check Currently Assisting
		if ( member == PetDefend_Config.MemberAssisting ) then
			return;
		end
		
		-- Check LowHealth
		if ( PetDefend_Config.LowHealth ) then
			if ( member == "player" ) then
				if ( (100*UnitHealth("player")/UnitHealthMax("player")) < PetDefend_Config.HealthMin  ) then
					PetDefend_Attack(pet, "player", "LOW_HEALTH");
				end
				return;
			end
			for i=1, 4 do
				if ( UnitExists("party"..i) ) then
					if ( (100*UnitHealth("party"..i)/UnitHealthMax("party"..i)) < PetDefend_Config.HealthMin  ) then
						PetDefend_Attack(pet, "party"..i, "LOW_HEALTH");
						return;
					end
				end
			end
		end

		-- Check Defend Member
		if ( PetDefend_Config.DefendMember == "PartyMember" ) or ( UnitName(PetDefend_Config.DefendMember) == nil ) then
			PetDefend_Config.DefendAll = true;
		end
		if not ( PetDefend_Config.DefendAll ) and not ( member == PetDefend_Config.DefendMember ) then
			return;
		end

		-- Check InCombat
		if ( PetDefend_Var.InCombat ) and not ( PetDefend_Config.AssistInCombat ) then
			return;
		end
		
		-- Defend Party Member
		PetDefend_Attack(pet, member, "DEFEND");
		
	end
	
end

function PetDefend_Attack(pet, member, event)

	-- Check Growl
	PetDefend_Growl(event);
	
	-- Pet Defend Player
	if ( member == "player" ) then
		if not ( UnitCanAttack("player", "target") ) then
			return;
		end
		if ( PetDefend_Config.Alert ) then
			ChatMessage(pet.." is assisting you!");
		end
		PetDefend_Config.MemberAssisting = member;
		PetAttack();
		return;
	end

	-- Pet Defend Party Member
	if ( UnitExists("target") ) then
		AssistUnit(member);
		if not ( UnitCanAttack("player", "target") ) then
			return;
		end
		if ( PetDefend_Config.Alert ) then
			if ( PetDefend_Config.Channel == "CHAT" ) then
				ChatMessage(pet.." is assisting "..UnitName(member).."!");
			elseif not ( ( PetDefend_Config.Channel == "PARTY" ) and ( UnitName("party1") == nil ) ) then
				ChannelMessage(pet.." is assisting "..UnitName(member).."!", PetDefend_Config.Channel);
			end
		end
		PetDefend_Config.MemberAssisting = member;
		PetAttack();
		TargetLastEnemy();
	else
		AssistUnit(member);
		if not ( UnitCanAttack("player", "target") ) then
			return;
		end
		if ( PetDefend_Config.Alert ) then
			if ( PetDefend_Config.Channel == "CHAT" ) then
				ChatMessage(pet.." is assisting "..UnitName(member).."!");
			elseif not ( ( PetDefend_Config.Channel == "PARTY" ) and ( UnitName("party1") == nil ) ) then
				ChannelMessage(pet.." is assisting "..UnitName(member).."!", PetDefend_Config.Channel);
			end
		end
		PetDefend_Config.MemberAssisting = member;
		PetAttack();
		ClearTarget();
	end
		
end

-- Growl
function PetDefend_Growl(event)
	for i=1, 10 do
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i);
		if ( name == PetDefend_Config.GrowlName ) then
			if not ( autoCastEnabled ) then
				if ( PetDefend_Config.Growl ) or ( event == "LOW_HEALTH" )  then
					TogglePetAutocast(i);
					PetDefend_Var.GrowlToggled = true;
					PetDefend_Var.GrowlID = i;
				end
			end
		end
		if ( name == PetDefend_Config.CowerName ) then
			if ( autoCastEnabled ) then
				if ( PetDefend_Config.Growl ) or ( event == "LOW_HEALTH" )  then
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
		if ( string.upper(name) == string.upper(PetDefend_Config.CowerName) ) then
			if not ( autoCastEnabled ) then
				TogglePetAutocast(i);
				PetDefend_Var.CowerToggled = true;
				PetDefend_Var.CowerID = i;
			end
		end
		if ( string.upper(name) == string.upper(PetDefend_Config.GrowlName) ) then
			if ( autoCastEnabled ) then
				TogglePetAutocast(i);
				PetDefend_Var.GrowlToggled = true;
				PetDefend_Var.GrowlID = i;
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