-- Variables
CombatWatch_Var = { };
CombatWatch_Var.LowHealth = false;
CombatWatch_Var.LowPetHealth = false;
CombatWatch_Var.PartyLowHealth = {
	["party1"] = false,
	["party1pet"] = false,
	["party2"] = false,
	["party2pet"] = false,
	["party3"] = false,
	["party3pet"] = false,
	["party4"] = false,
	["party4pet"] = false,
};
CombatWatch_Var.LowMana = false;
CombatWatch_Var.InCombat = false;
CombatWatch_Var.CombatStart = 0;
CombatWatch_Var.CombatEnd = 0;
CombatWatch_Var.CreatureName = "";
CombatWatch_Var.Hit = 0;
CombatWatch_Var.Crit = 0;
CombatWatch_Var.Dam = 0;
CombatWatch_Var.CritDam = 0;
CombatWatch_Var.SpellHit = 0;
CombatWatch_Var.SpellCrit = 0;
CombatWatch_Var.SpellDam = 0;
CombatWatch_Var.SpellCritDam = 0;
CombatWatch_Var.PetHit = 0;
CombatWatch_Var.PetDam = 0;
CombatWatch_Var.PetCrit = 0;
CombatWatch_Var.PetCritDam = 0;
CombatWatch_Var.Block = 0;
CombatWatch_Var.Dodge = 0;
CombatWatch_Var.Evade = 0;
CombatWatch_Var.Parry = 0;
CombatWatch_Var.Miss = 0;
CombatWatch_Var.Resist = 0;
CombatWatch_Var.XP = 0;

-- Animation Constants
CombatWatch_MaxSpeed = .025;
CombatWatch_TopPoint = 240; --210;
CombatWatch_BottomPoint = 80; --60;
CombatWatch_Alpha = 1;
CombatWatch_AnimationSpeed = 0.025; --0.015;
CombatWatch_TextSize = 18; --24;
CombatWatch_Step = 2;

--Animation System
CombatWatch_Var.LastBar = 1;
arrAniData = {
		["aniData1"] = {},
		["aniData2"] = {},
		["aniData3"] = {},
		["aniData4"] = {},
		["aniData5"] = {}
}

function CombatWatch_OnLoad()

	-- Register Events
	this:RegisterEvent("VARIABLES_LOADED");
	
	this:RegisterEvent("CHAT_MSG_SYSTEM");
	this:RegisterEvent("PLAYER_REGEN_ENABLED");
	this:RegisterEvent("PLAYER_REGEN_DISABLED");
	
	this:RegisterEvent("UNIT_COMBAT");
	this:RegisterEvent("UNIT_SPELLMISS");
	
	this:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS");
	this:RegisterEvent("CHAT_MSG_COMBAT_PET_HITS");
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE");
	
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
	
	this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF");
	this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS");
	
	this:RegisterEvent("CHAT_MSG_SKILL");
	
	this:RegisterEvent("UNIT_HEALTH");
	this:RegisterEvent("UNIT_MANA");
	
	this:RegisterEvent("PLAYER_COMBO_POINTS");
	this:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");
	
	-- Register Slash Commands
	SLASH_CombatWatch1 = "/combatwatch";
	SLASH_CombatWatch2 = "/cw";
	SlashCmdList["CombatWatch"] = function(msg)
		CombatWatch_ChatCommandHandler(msg);
	end
	
	-- Initialize
	CombatWatch_aniInit();
	
	ChatMessage("Rauen's CombatWatch Loaded.");
	
end

function CombatWatch_ChatCommandHandler(msg)

	if ( string.sub(msg, 1, 4) == "show" ) then
		if ( cwUI_General:IsVisible() ) then
			PlaySound("igMainMenuClose");
			HideUIPanel(cwUI_General);
		else
			PlaySound("igMainMenuOpen");
			msg = string.sub(msg, 6);
			ShowUIPanel(getglobal("cwUI_"..msg));
		end
		return;
	end
	
	if ( msg == "buff" ) then
		cwSummaryBuff:Show();
		return;
	end
	
	if ( msg == "summary" ) or ( msg == "window" ) then
		cwSummary:Show();
		return;
	end

	-- Menu
	if ( cwUI_General:IsVisible() ) then
		PlaySound("igMainMenuClose");
		HideUIPanel(cwUI_General);
	else
		PlaySound("igMainMenuOpen");
		ShowUIPanel(cwUI_General);
	end
	
end

function CombatWatch_Reset()

	CombatWatch_Config = { };
	CombatWatch_Config.Version = COMBATWATCH_VERSION;
	CombatWatch_Config.Enabled = true;
	CombatWatch_Config.CritAlert = true;
	CombatWatch_Config.PetCritAlert = true;
	CombatWatch_Config.HealSelfAlert = true;
	CombatWatch_Config.HealOtherAlert = true;
	CombatWatch_Config.SkillAlert = true;
	CombatWatch_Config.HealthAlert = true;
	CombatWatch_Config.HealthPartyAlert = false;
	CombatWatch_Config.HealthPartyAlertChan = "PARTY";
	CombatWatch_Config.HealthMin = 25;
	CombatWatch_Config.HealthEmote = false;
	CombatWatch_Config.HealthEmoteToken = "healme";
	CombatWatch_Config.ManaAlert = true;
	CombatWatch_Config.ManaPartyAlert = false;
	CombatWatch_Config.ManaPartyAlertChan = "PARTY";
	CombatWatch_Config.ManaMin = 25;
	CombatWatch_Config.ManaEmote = false;
	CombatWatch_Config.ManaEmoteToken = "oom";
	CombatWatch_Config.PetHealthAlert = true;
	CombatWatch_Config.PetHealthPartyAlert = false;
	CombatWatch_Config.PetHealthPartyAlertChan = "PARTY";
	CombatWatch_Config.PetHealthMin = 25;
	CombatWatch_Config.PartyHealthAlert = false;
	CombatWatch_Config.PartyHealthMin = 35;
	CombatWatch_Config.Summary = true;
	CombatWatch_Config.ComboAlert = false;
	CombatWatch_Config.XPAlert = false;
	CombatWatch_Config.DpsAlert = false;
	CombatWatch_Config.SummaryWindow = true;
	CombatWatch_Config.SummaryWindowStyleV = false;
	CombatWatch_Config.SummaryWindowAlpha = 1.0;
	CombatWatch_Config.PetWindow = true;

	CombatWatch_Config.PartyAlert = {
		["HealthPartyAlert"] = "I am low on health!",
		["ManaPartyAlert"] = "I am low on mana!",
		["PetHealthPartyAlert"] = "%s's health is low!",
	}
	
	CombatWatch_Config.Color = {
		["HealSelfAlert"] =  {r = 0.0, g = 1.0, b = 0.0},
		["HealOtherAlert"] =  {r = 0.0, g = 0.7, b = 0.0},
		["CritAlert"] =  {r = 1.0, g = 1.0, b = 0.0},
		["PetCritAlert"] =  {r = 1.0, g = 1.0, b = 0.0},
		["SkillAlert"] = {r = 0.0, g = 0.0, b = 1.0},
		["HealthAlert"] = {r = 1.0, g = 0.0, b = 0.0},
		["PetHealthAlert"] = {r = 1.0, g = 0.0, b = 0.0},
		["PartyHealthAlert"] = {r = 1.0, g = 0.0, b = 0.0},
		["ManaAlert"] = {r = 1.0, g = 0.0, b = 0.0},
		["ComboAlert"] = {r = 1.0, g = 1.0, b = 1.0},
		["XPAlert"] = {r = 0.0, g = 0.0, b = 1.0},
		["DpsAlert"] = {r = 1.0, g = 1.0, b = 0.0},
	}
	
	ChatMessage("CombatWatch configuration reset.");
	
end

function CombatWatch_OnUpdate()
	CombatWatch_UpdateAnimation();
end

function CombatWatch_OnEvent(event)

	local PetName, CreatureName, PersonName, Damage, Spell;

	if (event == "VARIABLES_LOADED") then
		if ( CombatWatch_Config ) then
			if ( CombatWatch_Config.Version ~= COMBATWATCH_VERSION ) then
				ChatMessage("CombatWatch updated to v"..COMBATWATCH_VERSION..".");
				CombatWatch_Reset();
			end
		else
			ChatMessage("CombatWatch updated to v"..COMBATWATCH_VERSION..".");
			CombatWatch_Reset();
		end
		return;
	end
	
	if ( not CombatWatch_Config.Enabled ) then
		return;
	end
	
	if (event == "PLAYER_REGEN_ENABLED") then
		CombatWatch_Var.CombatEnd = GetTime();
		CombatWatch_Var.InCombat = false;
		if ( CombatWatch_Var.CombatStart == nil ) then
			CombatWatch_ClearVars();
			cwSummaryBuff:Hide();
			return;
		end
		if ( CombatWatch_Var.Dam == 0 ) and
		  ( CombatWatch_Var.SpellDam == 0 ) and
		  ( CombatWatch_Var.PetDam == 0 ) then
			CombatWatch_ClearVars();
			cwSummaryBuff:Hide();
			return;
		end
		if ( CombatWatch_Config.Summary ) then
			CombatWatch_ShowSummary();
		end
		if ( CombatWatch_Config.SummaryWindow ) then
			cwSummary_SetVars();
			if ( cwSummary:IsVisible() ) then
				cwSummary_OnShow();
			else
				if ( cwSummaryBuff:IsVisible() ) then
					cwSummaryBuff_OnShow();
				else
					cwSummaryBuff:Show();
				end
			end
		end
		CombatWatch_ClearVars();
	end
	
	if (event == "PLAYER_REGEN_DISABLED") then	
		CombatWatch_Var.CombatStart = GetTime();
		CombatWatch_Var.InCombat = true;
		if ( CombatWatch_Config.SummaryWindow ) then
			if not ( cwSummary:IsVisible() ) then
				if ( cwSummaryBuff:IsVisible() ) then
					cwSummaryBuff_OnShow();
				else
					cwSummaryBuff:Show();
				end
			end
		end
	end
	
	if ( event == "UNIT_HEALTH" ) then
		if ( arg1 == "player" ) and ( CombatWatch_Config.HealthAlert ) then
			if ( UnitIsDeadOrGhost("player") ) then
				return;
			end
			if ( (100*UnitHealth("player")/UnitHealthMax("player")) < CombatWatch_Config.HealthMin  ) then
				if not ( CombatWatch_Var.LowHealth ) then
					CombatWatch_Display("Low Health", CombatWatch_Config.Color["HealthAlert"]);
					CombatWatch_Var.LowHealth = true;
					if ( CombatWatch_Config.HealthPartyAlert ) then
						if not ( ( UnitName("party1") == nil ) and ( CombatWatch_Config.HealthPartyAlertChan == "PARTY" ) ) then
							ChannelMessage(CombatWatch_Config.PartyAlert["HealthPartyAlert"], CombatWatch_Config.HealthPartyAlertChan);
						end
					end
					if ( CombatWatch_Config.HealthEmote ) then
						DoEmote(string.upper(CombatWatch_Config.HealthEmoteToken));
					end
					
				end
			else
				if ( CombatWatch_Var.LowHealth ) then
					CombatWatch_Var.LowHealth = false;
				end
			end
		end
		if ( arg1 == "pet" ) and ( CombatWatch_Config.PetHealthAlert ) then
			if ( UnitIsDead("pet") ) then
				return;
			end
			if ( (100*UnitHealth("pet")/UnitHealthMax("pet")) < CombatWatch_Config.PetHealthMin  ) then
				if not ( CombatWatch_Var.LowPetHealth ) then
					CombatWatch_Display("Low Pet Health", CombatWatch_Config.Color["PetHealthAlert"]);
					CombatWatch_Var.LowPetHealth = true;
					if ( CombatWatch_Config.PetHealthPartyAlert ) then
						if not ( ( UnitName("party1") == nil ) and ( CombatWatch_Config.PetHealthPartyAlertChan == "PARTY" ) ) then
							local message = CombatWatch_Config.PartyAlert["PetHealthPartyAlert"];
							if not ( UnitName("pet") == "Unknown Entity" ) then
								message = string.format(message, UnitName("pet"));
								ChannelMessage(message, CombatWatch_Config.PetHealthPartyAlertChan);
							end
						end
					end
				end
			else
				if ( CombatWatch_Var.LowPetHealth ) then
					CombatWatch_Var.LowPetHealth = false;
				end
			end
		end
		if ( string.sub(arg1, 1, 5) == "party" ) and ( CombatWatch_Config.PartyHealthAlert ) then
			if ( UnitIsDeadOrGhost(arg1) ) then
				return;
			end
			if ( (100*UnitHealth(arg1)/UnitHealthMax(arg1)) < CombatWatch_Config.PartyHealthMin  ) then
				if not ( CombatWatch_Var.PartyLowHealth[arg1] ) then
					CombatWatch_Display(UnitName(arg1).."'s Health is Low", CombatWatch_Config.Color["PartyHealthAlert"]);
					CombatWatch_Var.PartyLowHealth[arg1] = true;
				end
			else
				if ( CombatWatch_Var.PartyLowHealth[arg1] ) then
					CombatWatch_Var.PartyLowHealth[arg1] = false;
				end
			end
		end
	end
	
	if ( event == "UNIT_MANA" ) then
		if ( arg1 == "player" ) and ( CombatWatch_Config.ManaAlert ) then
			if ( UnitPowerType("player") ~= 0 ) then
				return;
			end
			if ( UnitIsDeadOrGhost("player") ) then
				return;
			end
			if ( (100*UnitMana("player")/UnitManaMax("player")) < CombatWatch_Config.ManaMin  ) then
				if not ( CombatWatch_Var.LowMana ) then
					CombatWatch_Display("Low Mana", CombatWatch_Config.Color["ManaAlert"]);
					CombatWatch_Var.LowMana = true;
					if ( CombatWatch_Config.ManaPartyAlert ) then
						if not ( ( UnitName("party1") == nil ) and ( CombatWatch_Config.ManaPartyAlertChan == "PARTY" ) ) then
							ChannelMessage(CombatWatch_Config.PartyAlert["ManaPartyAlert"], CombatWatch_Config.ManaPartyAlertChan );
						end
					end
					if ( CombatWatch_Config.ManaEmote ) then
						DoEmote(string.upper(CombatWatch_Config.ManaEmoteToken));
					end
				end
			else
				if ( CombatWatch_Var.LowMana ) then
					CombatWatch_Var.LowMana = false;
				end
			end
		end
	end
	
	if ( event == "CHAT_MSG_COMBAT_SELF_HITS" 
		or event == "CHAT_MSG_SPELL_SELF_DAMAGE"
		or event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE"
		or event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE"
		or event == "CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE"
		) then

		for Spell, CreatureName, Damage in string.gfind(arg1, "Your (.+) crits (.+) for (%d+).") do
			if ( CombatWatch_Config.CritAlert ) then
				CombatWatch_Display(arg1, CombatWatch_Config.Color["CritAlert"]);
			end
			CombatWatch_Var.SpellHit = CombatWatch_Var.SpellHit + 1;
			CombatWatch_Var.SpellCrit = CombatWatch_Var.SpellCrit + 1;
			CombatWatch_Var.SpellDam = CombatWatch_Var.SpellDam + Damage;
			CombatWatch_Var.SpellCritDam = CombatWatch_Var.SpellCritDam + Damage;
			CombatWatch_Var.CreatureName = CreatureName;
		end
		for CreatureName, Damage in string.gfind(arg1, "You crit (.+) for (%d+)") do
			if ( CombatWatch_Config.CritAlert ) then
				CombatWatch_Display(arg1, CombatWatch_Config.Color["CritAlert"]);
			end
			CombatWatch_Var.Hit = CombatWatch_Var.Hit + 1;
			CombatWatch_Var.Crit = CombatWatch_Var.Crit + 1;
			CombatWatch_Var.Dam = CombatWatch_Var.Dam + Damage;
			CombatWatch_Var.CritDam = CombatWatch_Var.CritDam + Damage;
			CombatWatch_Var.CreatureName = CreatureName;
		end
		
		for CreatureName, Damage, DamageType, Spell in string.gfind(arg1, "(.+) suffers (%d+) (.+) damage from your (.+).") do
			CombatWatch_Var.SpellHit = CombatWatch_Var.SpellHit + 1;
			CombatWatch_Var.SpellDam = CombatWatch_Var.SpellDam + Damage;
			CombatWatch_Var.CreatureName = CreatureName;
		end
		for Spell, CreatureName, Damage in string.gfind(arg1, "Your (.+) hits (.+) for (%d+).") do
			CombatWatch_Var.SpellHit = CombatWatch_Var.SpellHit + 1;
			CombatWatch_Var.SpellDam = CombatWatch_Var.SpellDam + Damage;
			CombatWatch_Var.CreatureName = CreatureName;
		end
		for CreatureName, Damage in string.gfind(arg1, "You hit (.+) for (%d+)") do
			CombatWatch_Var.Hit = CombatWatch_Var.Hit + 1;
			CombatWatch_Var.Dam = CombatWatch_Var.Dam + Damage;
			CombatWatch_Var.CreatureName = CreatureName;
		end
		for CreatureName, Spell in string.gfind(arg1, "(.+)'s (.+) was resisted.") do
			CombatWatch_Var.Resist = CombatWatch_Var.Resist + 1;
			CombatWatch_Var.CreatureName = CreatureName;
		end
	end
	
	if ( event == "CHAT_MSG_SPELL_SELF_BUFF" )
	  or ( event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" ) then
		for Damage, Spell in string.gfind(arg1, "You gain (%d+) from (%w+)") do
			if ( CombatWatch_Config.HealSelfAlert ) then
				CombatWatch_Display(Damage, CombatWatch_Config.Color["HealSelfAlert"]);
			end
		end
		for Spell, PersonName, Damage in string.gfind(arg1, "Your (.+) heals (.+) for (%d+).") do
			if ( PersonName == "you") then
				if ( CombatWatch_Config.HealSelfAlert ) then
					CombatWatch_Display(Damage, CombatWatch_Config.Color["HealSelfAlert"]);
				end
			else
				if ( CombatWatch_Config.HealOtherAlert ) then
					CombatWatch_Display(Damage, CombatWatch_Config.Color["HealOtherAlert"]);
				end
			end
		end
		for Spell, PersonName, Damage in string.gfind(arg1, "Your (.+) critically heals (.+) for (%d+).") do
			if ( CombatWatch_Config.HealAlert ) then
				if ( PersonName == "you") then
					if ( CombatWatch_Config.HealSelfAlert ) then
						CombatWatch_Display(arg1, CombatWatch_Config.Color["HealSelfAlert"]);
					end
				else
					if ( CombatWatch_Config.HealOtherAlert ) then
						CombatWatch_Display(arg1, CombatWatch_Config.Color["HealOtherAlert"]);
					end
				end
			end
		end
	end
	
	if ( event == "UNIT_COMBAT" ) then
		if ( arg1 ~= "player" ) then
			return;
		end
		if ( arg2 == "HEAL" ) then
			if ( arg4 ~= 0 or arg4 ~= nil ) then
				if ( CombatWatch_Config.HealSelfAlert ) then
					CombatWatch_Display(arg4, CombatWatch_Config.Color["HealSelfAlert"]);
				end
			end
		end
		if ( arg2 == "DODGE" ) then
			CombatWatch_Var.Dodge = CombatWatch_Var.Dodge + 1;
		end
		if ( arg2 == "BLOCK" ) then
			CombatWatch_Var.Block = CombatWatch_Var.Block + 1;
		end
		if ( arg2 == "PARRY" ) then
			CombatWatch_Var.Parry = CombatWatch_Var.Parry + 1;
		end
		if ( arg2 == "EVADE" ) then
			CombatWatch_Var.Evade = CombatWatch_Var.Evade + 1;
		end
		if ( arg2 == "MISS" ) then
			CombatWatch_Var.Miss = CombatWatch_Var.Miss + 1;
		end
	end
	
	if ( event == "CHAT_MSG_COMBAT_PET_HITS" ) then
		for PetName, CreatureName, Damage in string.gfind(arg1, "(.+) crits (.+) for (%d+).") do
			if ( CombatWatch_Config.CritAlert ) then
				CombatWatch_Display(arg1, CombatWatch_Config.Color["CritAlert"]);
			end
			CombatWatch_Var.PetHit = CombatWatch_Var.PetHit + 1;
			CombatWatch_Var.PetDam = CombatWatch_Var.PetDam + Damage;
			CombatWatch_Var.PetDam = CombatWatch_Var.PetCritDam + Damage;
			CombatWatch_Var.CreatureName = CreatureName;
		end
		for PetName, CreatureName, Damage in string.gfind(arg1, "(.+) hits (.+) for (%d+).") do
			CombatWatch_Var.PetHit = CombatWatch_Var.PetHit + 1;
			CombatWatch_Var.PetDam = CombatWatch_Var.PetDam + Damage;
			CombatWatch_Var.CreatureName = CreatureName;
		end
	end

	if (event == "CHAT_MSG_SPELL_PET_DAMAGE") then
		for PetName, Spell, CreatureName, Damage in string.gfind(arg1, "(.+)'s (.+) crits (.+) for (%d+).") do
			if (PetName == UnitName('pet') or PetName == 'your pet') then
				if ( CombatWatch_Config.PetCritAlert ) then
					CombatWatch_Display(arg1, CombatWatch_Config.Color["PetCritAlert"]);
				end
				CombatWatch_Var.PetHit = CombatWatch_Var.PetHit + 1;
				CombatWatch_Var.PetDam = CombatWatch_Var.PetDam + Damage;
				CombatWatch_Var.PetCritDam = CombatWatch_Var.PetCritDam + Damage;
				CombatWatch_Var.CreatureName = CreatureName;
			end
		end
		for PetName, Spell, CreatureName, Damage in string.gfind(arg1, "(.+)'s (.+) hits (.+) for (%d+).") do			
			if (petName == UnitName('pet') or petName == 'your pet') then
				CombatWatch_Var.PetHit = CombatWatch_Var.PetHit + 1;
				CombatWatch_Var.PetDam = CombatWatch_Var.PetDam + Damage;
			end
			CombatWatch_Var.CreatureName = CreatureName;
		end
	end
	
	if ( event == "CHAT_MSG_SKILL" ) then
		for Spell, Damage in string.gfind(arg1, "Your skill in (.+) has increased to (%d+).") do
			if ( CombatWatch_Config.SkillAlert ) then
				CombatWatch_Display(Spell.." "..Damage, CombatWatch_Config.Color["SkillAlert"]);
			end
		end
	end
	
	if (event == "PLAYER_COMBO_POINTS" ) then
		if ( CombatWatch_Config.ComboAlert ) and ( UnitPowerType("player") == 3 ) then
			local points = GetComboPoints();
			if ( points ~= 0) then
				CombatWatch_Display(points.." Combo Points!", CombatWatch_Config.Color["ComboAlert"]);
			end
		end
	end
	
	if ( event == "CHAT_MSG_COMBAT_XP_GAIN" ) then
		for Damage in string.gfind(arg1, "you gain (%d+) experience") do
			CombatWatch_Var.XP = CombatWatch_Var.XP + Damage;
			if ( CombatWatch_Config.XPAlert ) then
				CombatWatch_Display(Damage.." Exp", CombatWatch_Config.Color["XPAlert"]);
			end
		end
	end

end

function CombatWatch_ShowSummary()

	if ( CombatWatch_Var.Dam == 0 ) and
		( CombatWatch_Var.SpellDam == 0 ) and
		( CombatWatch_Var.PetDam == 0 ) then
		CombatWatch_ClearVars();
		return;
	end

	local Dur, TDam, DPS, SDPS, ODPS, PDPS, TDPS;
	
	TDam = CombatWatch_Var.Dam + CombatWatch_Var.SpellDam;
	Dur = CombatWatch_Var.CombatEnd - CombatWatch_Var.CombatStart;
	DPS = CombatWatch_Var.Dam / Dur;
	SDPS = CombatWatch_Var.SpellDam / Dur;
	ODPS = TDam / Dur;
	PDPS = CombatWatch_Var.PetDam / Dur;
	TDPS = (TDam + CombatWatch_Var.PetDam) / Dur;
	
	if ( CombatWatch_Config.DpsAlert ) then
		CombatWatch_Display(format("%2d",ODPS).." dps", CombatWatch_Config.Color["DpsAlert"]);
	end
	
	CombatWatch_ChatMessage("Combat Summary ("..format("%2d",Dur).."s)");
	CombatWatch_ChatMessage("You did "..format("%4d",TDam).." damage ("..format("%2d",ODPS).." dps).");
	if ( CombatWatch_Var.PetDam > 0 ) and ( UnitName("pet") ) then
		CombatWatch_ChatMessage(UnitName("pet").." did "..format("%3d",CombatWatch_Var.PetDam).." damage ("..format("%2d",PDPS).." dps).");
	end
	
end

function CombatWatch_ClearVars()
	CombatWatch_Var.CombatStart = 0;
	CombatWatch_Var.CombatEnd = 0;
	CombatWatch_Var.CreatureName = "";
	CombatWatch_Var.Hit = 0;
	CombatWatch_Var.Crit = 0;
	CombatWatch_Var.Dam = 0;
	CombatWatch_Var.CritDam = 0;
	CombatWatch_Var.SpellHit = 0;
	CombatWatch_Var.SpellCrit = 0;
	CombatWatch_Var.SpellDam = 0;
	CombatWatch_Var.SpellCritDam = 0;
	CombatWatch_Var.PetHit = 0;
	CombatWatch_Var.PetDam = 0;
	CombatWatch_Var.PetCrit = 0;
	CombatWatch_Var.PetCritDam = 0;
	CombatWatch_Var.Block = 0;
	CombatWatch_Var.Dodge = 0;
	CombatWatch_Var.Evade = 0;
	CombatWatch_Var.Parry = 0;
	CombatWatch_Var.Miss = 0;
	CombatWatch_Var.Resist = 0;
	CombatWatch_Var.XP = 0;
end

--Display the Text
function CombatWatch_Display(msg, color)
	local adat, adatpre;
	
	--Set up  text animation
	adat = arrAniData["aniData"..CombatWatch_Var.LastBar];
	--get last number
	local lastnum = CombatWatch_Var.LastBar-1;
	if(lastnum == 0) then
		lastnum = 5;
	end
	adatpre = arrAniData["aniData"..lastnum];
	
	local startpos, endpos;
	startpos = CombatWatch_BottomPoint;
	
	if (adat.Active == true) then
		adat.posX = 0;
		adat.posY = startpos;
	else
		adat.Active = true;
	end
	
	adat.alpha = CombatWatch_Alpha;
	
	-- if the the previous one is active, and its close to it
	if (adatpre.Active == true) then
		--move the position up
		if ((adat.posY - adatpre.posY) <= CombatWatch_TextSize) then
			adat.posY = adat.posY + (CombatWatch_TextSize - (adat.posY - adatpre.posY));
		end
		--if its gone too far up, stop
		if (adat.posY > (CombatWatch_TopPoint + (CombatWatch_BottomPoint * 2))) then
			adat.posY = (CombatWatch_TopPoint + (CombatWatch_BottomPoint * 2))
		end
	end
		
	adat.FObject:SetTextHeight(CombatWatch_TextSize);
	
	--set the color
	adat.FObject:SetTextColor(color.r, color.g, color.b);
	--set alpha
	adat.FObject:SetAlpha(adat.alpha);
	--Position
	adat.FObject:SetPoint("CENTER", "UIParent", "CENTER", 0, adat.posY);
	--Set the text to display
	adat.FObject:SetText(msg);
	
	adat.lastupdate = GetTime();
	
	--update current text being used
	CombatWatch_LASTBAR = CombatWatch_Var.LastBar + 1;
	
	--if we reached the end, set to first
	if (CombatWatch_Var.LastBar == 6) then
		CombatWatch_Var.LastBar = 1;
	end
end

-- Upate animations that are being used
function CombatWatch_UpdateAnimation()	
	
	for key, value in arrAniData do
		if (value.Active) then
			CombatWatch_DoAnimation(value);
		end
	end

end

--Move text to get the animation
function CombatWatch_DoAnimation(aniData)

	local curtime = GetTime();
	local startpos, endpos, step, alpha;
	local avgpos, diffpos;
		
	avgpos = (CombatWatch_TopPoint + CombatWatch_BottomPoint)/2;
	diffpos = (CombatWatch_TopPoint - CombatWatch_BottomPoint)/2;
		
	--if its time to update, move the text step positions
	if ((curtime-aniData.lastupdate) > CombatWatch_AnimationSpeed) then
		--set parameters based on direction settings
		startpos = CombatWatch_BottomPoint;
		endpos = CombatWatch_TopPoint;
		step = CombatWatch_Step;
		if (aniData.posY > avgpos) then
			alpha = (1 - ((aniData.posY-avgpos) / (diffpos - CombatWatch_Step)));
		else
			alpha = 1;
		end
		
		if (alpha > 1) then
			alpha = 1;
		end

		alpha = alpha * CombatWatch_Alpha;
					
		aniData.posY = aniData.posY + step;
		aniData.lastupdate = curtime;
		aniData.alpha = alpha;
		
		aniData.FObject:SetAlpha(aniData.alpha);
		aniData.FObject:SetPoint("CENTER", "UIParent", "CENTER", 0, aniData.posY);
			
		--if it reachs the end, reset
		if (aniData.posY >= endpos) then
			CombatWatch_aniReset(aniData);
		end
	end

end

--Rest the text animation
function CombatWatch_aniReset(aniData)	
	local startpos;
	startpos = CombatWatch_BottomPoint;
	
	aniData.Active = false;
	aniData.crit = false;
	aniData.posY = startpos;
	aniData.posX = 0;
	aniData.alpha = 0;
	
	aniData.FObject:SetAlpha(aniData.alpha);
	aniData.FObject:SetPoint("CENTER", "UIParent", "CENTER", aniData.posX, aniData.posY);
end

--Rest all the text animations
function CombatWatch_aniResetAll()
	
	for key, value in arrAniData do
		CombatWatch_aniReset(value);
	end

end

--Initial animation settings
function CombatWatch_aniInit()

	for key, value in arrAniData do
		value.FObject = getglobal("CombatWatch_"..key);
		value.lastupdate = 0;
	end
	
	CombatWatch_aniResetAll();
end

function CombatWatch_ChatMessage(message)
	if ( ChatFrame2:IsVisible() ) then
		ChatFrame2:AddMessage(message, 1.0, 0.5, 0.25);
	else
		DEFAULT_CHAT_FRAME:AddMessage(message, 1.0, 0.5, 0.25);
	end
end

function CombatWatch_ErrorMessage(message)
	UIErrorsFrame:AddMessage(message, 1.0, 1.0, 0.0, 1.0, UIERRORS_HOLD_TIME);
end
