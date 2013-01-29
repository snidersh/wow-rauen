-- Variables
cwSummary_Var = { };
cwSummary_Var.CombatStart = 0;
cwSummary_Var.CombatEnd = 0;
cwSummary_Var.CreatureName = "Unknown Entity";
cwSummary_Var.Hit = 0;
cwSummary_Var.Crit = 0;
cwSummary_Var.Dam = 0;
cwSummary_Var.CritDam = 0;
cwSummary_Var.SpellHit = 0;
cwSummary_Var.SpellCrit = 0;
cwSummary_Var.SpellDam = 0;
cwSummary_Var.SpellCritDam = 0;
cwSummary_Var.PetHit = 0;
cwSummary_Var.PetCrit = 0;
cwSummary_Var.PetDam = 0;
cwSummary_Var.PetCritDam = 0;
cwSummary_Var.Block = 0;
cwSummary_Var.Dodge = 0;
cwSummary_Var.Evade = 0;
cwSummary_Var.Parry = 0;
cwSummary_Var.Miss = 0;
cwSummary_Var.Resist = 0;
cwSummary_Var.XP = 0;

CWSUMMARYBUFF_FLASH_TIME_ON = 0.75;
CWSUMMARYBUFF_FLASH_TIME_OFF = 0.75;
CWSUMMARYBUFF_MIN_ALPHA = 0.3;
CWSUMMARYBUFF_WARNING_TIME = 11;
CWSUMMARYBUFF_DURATION_WARNING_TIME = 11;

function cwSummary_OnLoad()
end

function cwSummary_OnUpdate()
	if ( CombatWatch_Var.InCombat ) and ( CombatWatch_Var.CombatStart ) then
		CombatWatch_Var.CombatEnd = GetTime();
		cwSummary_SetVars();
		cwSummary_OnShow();
	end
end

function cwSummary_OnShow()

	local Dur, TDam, DPS, SDPS, ODPS, PDPS, TDPS = 0;
	local DamP, CritDamP, SpellDamP, SpellCritDamP = 0;
	local KXP = 0;
	local panel, text;
	
	THit = cwSummary_Var.Hit + cwSummary_Var.SpellHit;
	TDam = cwSummary_Var.Dam + cwSummary_Var.SpellDam;
	Dur = cwSummary_Var.CombatEnd - cwSummary_Var.CombatStart;
	DPS = cwSummary_Var.Dam / Dur;
	SDPS = cwSummary_Var.SpellDam / Dur;
	ODPS = TDam / Dur;
	PDPS = cwSummary_Var.PetDam / Dur;
	TDPS = (TDam + cwSummary_Var.PetDam) / Dur;

	DamP = ( cwSummary_Var.Dam/TDam ) * 100;
	CritDamP = ( cwSummary_Var.CritDam/TDam ) * 100;
	SpellDamP = ( cwSummary_Var.SpellDam/TDam ) * 100;
	SpellCritDamP = ( cwSummary_Var.SpellCritDam/TDam ) * 100;
	
	AvgDam = TDam / THit;
	
	KXP = ( UnitXPMax("player") - UnitXP("player") ) / cwSummary_Var.XP;
	
	cwSummary:SetAlpha(CombatWatch_Config.SummaryWindowAlpha);
	cwPetSummary:SetAlpha(CombatWatch_Config.SummaryWindowAlpha);
	
	-- Style
	if not ( CombatWatch_Config.SummaryWindowStyleV ) then
		panel = getglobal("cwSummary");
		panel:SetHeight(140);
		panel:SetWidth(370);
		getglobal("cwSummary_StatHit"):SetPoint("TOPLEFT", "cwSummary", "TOPLEFT", 170, -32);
		getglobal("cwSummary_StatDam"):SetPoint("TOPLEFT", "cwSummary", "TOPLEFT", 250, -32);
		getglobal("cwSummary_StatDamP"):SetPoint("TOPLEFT", "cwSummary", "TOPLEFT", 310, -32);
		panel = getglobal("cwPetSummary");
		panel:SetHeight(65);
		panel:SetWidth(370);
		getglobal("cwPetSummary_StatHit"):SetPoint("TOPLEFT", "cwPetSummary", "TOPLEFT", 100, -20);
		getglobal("cwPetSummary_StatDam"):SetPoint("TOPLEFT", "cwPetSummary", "TOPLEFT", 160, -20);
	else
		panel = getglobal("cwSummary");
		panel:SetHeight(240);
		panel:SetWidth(220);
		getglobal("cwSummary_StatHit"):SetPoint("TOPLEFT", "cwSummary_StatKillXP", "BOTTOMLEFT", 0, -15);
		getglobal("cwSummary_StatDam"):SetPoint("TOPLEFT", "cwSummary_StatMiss", "BOTTOMLEFT", 0, -30);
		getglobal("cwSummary_StatDamP"):SetPoint("TOPLEFT", "cwSummary_StatMiss", "BOTTOMLEFT", 60, -30);
		panel = getglobal("cwPetSummary");
		panel:SetHeight(70);
		panel:SetWidth(220);
		getglobal("cwPetSummary_StatHit"):SetPoint("TOPLEFT", "cwPetSummary_Name", "TOPRIGHT", 65, 0);
		getglobal("cwPetSummary_StatDam"):SetPoint("TOPLEFT", "cwPetSummary_Name", "TOPRIGHT", 115, 0);
	end
	
	-- Name
	text = getglobal("cwSummary_NameText");
	text:SetText(cwSummary_Var.CreatureName);
	text:SetWidth(200);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	
	-- Dur
	text = getglobal("cwSummary_StatDurText");
	text:SetText("Duration:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatDur_ValueText");
	text:SetText(format("%d",Dur).."s");
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( Dur == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- DPS
	text = getglobal("cwSummary_StatDPSText");
	text:SetText("DPS:");
	text:SetWidth(40);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatDPS_ValueText");
	text:SetText(format("%d", ODPS).." dps");
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( ODPS == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- XP
	text = getglobal("cwSummary_StatXPText");
	text:SetText("Exp:");
	text:SetWidth(40);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatXP_ValueText");
	text:SetText(format("%d", cwSummary_Var.XP).." xp");
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( cwSummary_Var.XP == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- KXP
	if ( UnitLevel("player") < 60 ) then
		text = getglobal("cwSummary_StatKillXPText");
		text:SetText("Lvl "..(UnitLevel("player")+1)..":");
		text:SetWidth(50);
		text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		text = getglobal("cwSummary_StatKillXP_ValueText");
		text:SetText(format("%d", KXP).." kills");
		text:SetWidth(100);
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		if ( cwSummary_Var.XP == 0 ) then
			text:SetText("- kills");
			text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
		end
	end
	
	-- Block
	text = getglobal("cwSummary_StatBlockText");
	text:SetText("Blocks:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatBlock_ValueText");
	text:SetText(format("%d",cwSummary_Var.Block));
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( cwSummary_Var.Block == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Dodge
	text = getglobal("cwSummary_StatDodgeText");
	text:SetText("Dodges:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatDodge_ValueText");
	text:SetText(format("%d",cwSummary_Var.Dodge));
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( cwSummary_Var.Dodge == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Parry
	text = getglobal("cwSummary_StatParryText");
	text:SetText("Parries:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatParry_ValueText");
	text:SetText(format("%d",cwSummary_Var.Parry));
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( cwSummary_Var.Parry == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Evade
	text = getglobal("cwSummary_StatEvadeText");
	text:SetText("Evades:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatEvade_ValueText");
	text:SetText(format("%d",cwSummary_Var.Evade));
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( cwSummary_Var.Evade == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Miss
	text = getglobal("cwSummary_StatMissText");
	text:SetText("Misses:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatMiss_ValueText");
	text:SetText(format("%d",cwSummary_Var.Miss));
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( cwSummary_Var.Miss == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Resist
	text = getglobal("cwSummary_StatResistText");
	text:SetText("Resists:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatResist_ValueText");
	text:SetText(format("%d",cwSummary_Var.Resist));
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( cwSummary_Var.Resist == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- TotalHit
	text = getglobal("cwSummary_StatTotalHitText");
	text:SetText("Total Hits:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatTotalHit_ValueText");
	text:SetText(format("%d", THit));
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( THit == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- TDam
	text = getglobal("cwSummary_StatTotalDamText");
	text:SetWidth(100);
	if ( TDam > 0 ) then
		text:SetText(format("%d",TDam).." dmg");
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	else
		text:SetText("-");
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Hit
	text = getglobal("cwSummary_StatHitText");
	text:SetText("Hits:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatHit_ValueText");
	text:SetText(format("%d",cwSummary_Var.Hit));
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( cwSummary_Var.Hit == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Dam
	text = getglobal("cwSummary_StatDamText");
	text:SetWidth(100);
	if ( cwSummary_Var.Dam > 0 ) then
		text:SetText(format("%d",cwSummary_Var.Dam).." dmg");
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	else
		text:SetText("-");
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Average
	text = getglobal("cwSummary_StatAverageText");
	text:SetText("Average:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	
	-- AverageDam
	text = getglobal("cwSummary_StatAverageDamText");
	text:SetWidth(100);
	if ( AvgDam > 0 ) then
		text:SetText(format("%d",AvgDam).." dmg");
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	else
		text:SetText("-");
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- DamP
	text = getglobal("cwSummary_StatDamPText");
	text:SetWidth(100);
	if ( DamP > 0 ) then
		text:SetText(format("%d",DamP).."%");
		text:SetTextColor(0.75, 0.75, 0.75);
	else
		text:SetText("-");
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Crit
	text = getglobal("cwSummary_StatCritText");
	text:SetText("Crits:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatCrit_ValueText");
	text:SetText(format("%d",cwSummary_Var.Crit));
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( cwSummary_Var.Crit == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- CritDam
	text = getglobal("cwSummary_StatCritDamText");
	text:SetWidth(100);
	if ( cwSummary_Var.CritDam > 0 ) then
		text:SetText(format("%d",cwSummary_Var.CritDam).." dmg");
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	else
		text:SetText("-");
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- CritDamP
	text = getglobal("cwSummary_StatCritDamPText");
	text:SetWidth(100);
	if ( CritDamP > 0 ) then
		text:SetText(format("%d",CritDamP).."%");
		text:SetTextColor(0.75, 0.75, 0.75);
	else
		text:SetText("-");
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- SpellHit
	text = getglobal("cwSummary_StatSpellHitText");
	text:SetText("Spell Hits:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatSpellHit_ValueText");
	text:SetText(format("%d",cwSummary_Var.SpellHit));
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( cwSummary_Var.SpellHit == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- SpellDam
	text = getglobal("cwSummary_StatSpellDamText");
	text:SetWidth(100);
	if ( cwSummary_Var.SpellDam > 0 ) then
		text:SetText(format("%d",cwSummary_Var.SpellDam).." dmg");
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	else
		text:SetText("-");
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- SpellDamP
	text = getglobal("cwSummary_StatSpellDamPText");
	text:SetWidth(100);
	if ( SpellDamP > 0 ) then
		text:SetText(format("%d",SpellDamP).."%");
		text:SetTextColor(0.75, 0.75, 0.75);
	else
		text:SetText("-");
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- SpellCrit
	text = getglobal("cwSummary_StatSpellCritText");
	text:SetText("Spell Crits:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwSummary_StatSpellCrit_ValueText");
	text:SetText(format("%d",cwSummary_Var.SpellCrit));
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( cwSummary_Var.SpellCrit == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- SpellCritDam
	text = getglobal("cwSummary_StatSpellCritDamText");
	text:SetWidth(100);
	if ( cwSummary_Var.SpellCritDam > 0 ) then
		text:SetText(format("%d",cwSummary_Var.SpellCritDam).." dmg");
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	else
		text:SetText("-");
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- SpellCritDamP
	text = getglobal("cwSummary_StatSpellCritDamPText");
	text:SetWidth(100);
	if ( SpellCritDamP > 0 ) then
		text:SetText(format("%d",SpellCritDamP).."%");
		text:SetTextColor(0.75, 0.75, 0.75);
	else
		text:SetText("-");
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- Check for Pet Here
	if ( CombatWatch_Config.PetWindow ) then
		if ( cwSummary_Var.PetDam > 0 ) and ( UnitName("pet") ) then
			cwPetSummary:Show();
		else
			cwPetSummary:Hide();
			return;
		end
	else
		cwPetSummary:Hide();
		return;
	end
	
	-- PetName
	text = getglobal("cwPetSummary_NameText");
	if ( UnitName("pet") ) then
		text:SetText(UnitName("pet"));
	else
		text:SetText("Pet");
	end
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	
	-- PetDPS
	text = getglobal("cwPetSummary_StatDPSText");
	text:SetText("DPS:");
	text:SetWidth(40);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwPetSummary_StatDPS_ValueText");
	text:SetText(format("%d", PDPS).." dps");
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( PDPS == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetHit
	text = getglobal("cwPetSummary_StatHitText");
	text:SetText("Hits:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwPetSummary_StatHit_ValueText");
	text:SetText(format("%d",cwSummary_Var.PetHit));
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( cwSummary_Var.PetHit == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetDam
	text = getglobal("cwPetSummary_StatDamText");
	text:SetWidth(100);
	if ( cwSummary_Var.PetDam > 0 ) then
		text:SetText(format("%d",cwSummary_Var.PetDam).." dmg");
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	else
		text:SetText("-");
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetCrit
	text = getglobal("cwPetSummary_StatCritText");
	text:SetText("Crits:");
	text:SetWidth(60);
	text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	text = getglobal("cwPetSummary_StatCrit_ValueText");
	text:SetText(format("%d",cwSummary_Var.PetCrit));
	text:SetWidth(100);
	text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	if ( cwSummary_Var.PetCrit == 0 ) then
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
	-- PetCritDam
	text = getglobal("cwPetSummary_StatCritDamText");
	text:SetWidth(100);
	if ( cwSummary_Var.PetCritDam > 0 ) then
		text:SetText(format("%d",cwSummary_Var.PetCritDam).." dmg");
		text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	else
		text:SetText("-");
		text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
	
end

function cwSummary_SetVars()
	cwSummary_Var.CombatStart = CombatWatch_Var.CombatStart;
	cwSummary_Var.CombatEnd = CombatWatch_Var.CombatEnd;
	cwSummary_Var.CreatureName = CombatWatch_Var.CreatureName;
	cwSummary_Var.Hit = CombatWatch_Var.Hit;
	cwSummary_Var.Crit = CombatWatch_Var.Crit;
	cwSummary_Var.Dam = CombatWatch_Var.Dam;
	cwSummary_Var.CritDam = CombatWatch_Var.CritDam;
	cwSummary_Var.SpellHit = CombatWatch_Var.SpellHit;
	cwSummary_Var.SpellCrit = CombatWatch_Var.SpellCrit;
	cwSummary_Var.SpellDam = CombatWatch_Var.SpellDam;
	cwSummary_Var.SpellCritDam = CombatWatch_Var.SpellCritDam;
	cwSummary_Var.PetHit = CombatWatch_Var.PetHit;
	cwSummary_Var.PetCrit = CombatWatch_Var.PetCrit;
	cwSummary_Var.PetDam = CombatWatch_Var.PetDam;
	cwSummary_Var.PetCritDam = CombatWatch_Var.PetCritDam;
	cwSummary_Var.Block = CombatWatch_Var.Block;
	cwSummary_Var.Dodge = CombatWatch_Var.Dodge;
	cwSummary_Var.Evade = CombatWatch_Var.Evade;
	cwSummary_Var.Parry = CombatWatch_Var.Parry;
	cwSummary_Var.Miss = CombatWatch_Var.Miss;
	cwSummary_Var.Resist = CombatWatch_Var.Resist;
	cwSummary_Var.XP = CombatWatch_Var.XP;
end

function cwSummary_Close()
	PlaySound("igMainMenuClose");
	HideUIPanel(cwSummary);
	HideUIPanel(cwPetSummary);
end

function cwSummary_ResetPos()
	local panel = getglobal("cwSummary");
	panel:SetPoint("TOP", "UIParent", "TOP", 0, -80);
	cwSummary_OnShow();
end

function cwSummary_Style()
	if ( CombatWatch_Config.SummaryWindowStyleV ) then
		CombatWatch_Config.SummaryWindowStyleV = false;
	else
		CombatWatch_Config.SummaryWindowStyleV = true;
	end
	cwSummary_OnShow();
end

function cwSummaryBuff_OnLoad()
end

function cwSummaryBuff_OnShow()
	getglobal("cwSummaryBuff_Duration"):SetPoint("TOP", "cwSummaryBuff_Button", "BOTTOM", 0, 0);
	getglobal("cwSummaryBuff_ButtonIcon"):SetTexture("Interface/Icons/INV_Misc_Note_02");
	cwSummaryBuff_UpdatePosition();
	cwSummaryBuff.BuffFrameUpdateTime = 0;
	cwSummaryBuff.BuffFrameFlashTime = 0;
	cwSummaryBuff.BuffFrameFlashState = 1;
	cwSummaryBuff.BUFF_ALPHA_VALUE = 1;
	cwSummaryBuff.start = GetTime();
	cwSummaryBuff.active = true;
end

function cwSummaryBuff_OnUpdate(elapsed)
	if ( cwSummaryBuff.BuffFrameUpdateTime > 0 ) then
		cwSummaryBuff.BuffFrameUpdateTime = cwSummaryBuff.BuffFrameUpdateTime - elapsed;
	else
		cwSummaryBuff.BuffFrameUpdateTime = cwSummaryBuff.BuffFrameUpdateTime + TOOLTIP_UPDATE_TIME;
	end

	cwSummaryBuff.BuffFrameFlashTime = cwSummaryBuff.BuffFrameFlashTime - elapsed;
	if ( cwSummaryBuff.BuffFrameFlashTime < 0 ) then
		local overtime = -cwSummaryBuff.BuffFrameFlashTime;
		if ( cwSummaryBuff.BuffFrameFlashState == 0 ) then
			cwSummaryBuff.BuffFrameFlashState = 1;
			cwSummaryBuff.BuffFrameFlashTime = CWSUMMARYBUFF_FLASH_TIME_ON;
		else
			cwSummaryBuff.BuffFrameFlashState = 0;
			cwSummaryBuff.BuffFrameFlashTime = CWSUMMARYBUFF_FLASH_TIME_OFF;
		end
		if ( overtime < cwSummaryBuff.BuffFrameFlashTime ) then
			cwSummaryBuff.BuffFrameFlashTime = cwSummaryBuff.BuffFrameFlashTime - overtime;
		end
	end

	if ( cwSummaryBuff.BuffFrameFlashState == 1 ) then
		cwSummaryBuff.BUFF_ALPHA_VALUE = (CWSUMMARYBUFF_FLASH_TIME_ON - cwSummaryBuff.BuffFrameFlashTime) / CWSUMMARYBUFF_FLASH_TIME_ON;
	else
		cwSummaryBuff.BUFF_ALPHA_VALUE = cwSummaryBuff.BuffFrameFlashTime / CWSUMMARYBUFF_FLASH_TIME_ON;
	end
	cwSummaryBuff.BUFF_ALPHA_VALUE = (cwSummaryBuff.BUFF_ALPHA_VALUE * (1 - CWSUMMARYBUFF_MIN_ALPHA)) + CWSUMMARYBUFF_MIN_ALPHA;
end

function cwSummaryBuffButton_OnLoad()
	this:RegisterForClicks("LeftButtonUp");
end

function cwSummaryBuffButton_OnUpdate()
	
	 cwSummaryBuff_UpdatePosition();
	
	local buffButton = getglobal("cwSummaryBuff");
	local buffDuration = getglobal("cwSummaryBuff_Duration");
	
	if ( CombatWatch_Var.InCombat ) then
		buffDuration:Hide();
		return;
	end

	local timeLeft = 30 - (GetTime() - cwSummaryBuff.start);
	if ( timeLeft < CWSUMMARYBUFF_WARNING_TIME ) then
		this:SetAlpha(cwSummaryBuff.BUFF_ALPHA_VALUE);
	end

	-- Update duration
	cwSummaryBuff_UpdateDuration(this, timeLeft);
	if ( SHOW_BUFF_DURATIONS == "1" ) then
		buffDuration:Show();
	else
		buffDuration:Hide();
	end
	
	if ( timeLeft < 0 ) or ( timeLeft == 0 ) then
		cwSummaryBuff.active = false;
		buffButton:Hide();
		buffDuration:Hide();
	end

end

function cwSummaryBuffButton_OnClick()
	cwSummaryBuff.active = false;
	PlaySound("igMainMenuOpen");
	HideUIPanel(cwSummaryBuff);
	ShowUIPanel(cwSummary);
end

function cwSummaryBuff_UpdateDuration(buffButton, timeLeft)
	local duration = getglobal("cwSummaryBuff_Duration");
	if ( SHOW_BUFF_DURATIONS == "1" and timeLeft ) then
		duration:SetText(SecondsToTimeAbbrev(timeLeft));
		if ( timeLeft < CWSUMMARYBUFF_DURATION_WARNING_TIME ) then
			duration:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		else
			duration:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		end
		duration:Show();
	else
		duration:Hide();
	end
end

function cwSummaryBuff_UpdatePosition()
	local button = getglobal("cwSummaryBuff_Button");
	local buffIndex = -1;
	local buff;
	for i=0, 15 do
		buff = GetPlayerBuff(i, "HELPFUL");
		if ( buff > -1 ) then
			buffIndex = i;
		end
	end
	if ( buffIndex == -1 ) then
		button:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -205, -13);
	elseif ( buffIndex == 6 ) then
		button:SetPoint("TOP", "BuffButton0", "BOTTOM", 0, -15);
	else
		button:SetPoint("TOPRIGHT", "BuffButton"..buffIndex, "TOPLEFT", -5, 0);
	end
end
