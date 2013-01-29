-- Variables
Default_GetNumShapeshiftForms = nil;
Default_CastShapeshiftForm = nil;
Default_GetShapeshiftFormInfo = nil;
Default_GetShapeshiftFormCooldown = nil;
Default_ShapeshiftBar_Update = nil;
Default_ShowPetActionBar = nil;
Default_HidePetActionBar = nil;

AspectBar_Var= { };
AspectBar_Var.Loaded = false;

AspectBar_List = {};
AspectBar_SpellNames = {
	"Aspect of the Monkey",
	"Aspect of the Hawk",
	"Aspect of the Cheetah",
	"Aspect of the Beast",
	"Aspect of the Pack",
	"Aspect of the Wild"
};

function AspectBar_OnLoad()
	
	this:RegisterEvent("VARIABLES_LOADED");
	
	if not ( AspectBar_Var.Loaded ) then
		AspectBar_Initialize();
	end
	
	ChatMessage("Rauen's AspectBar Loaded.");
	
end

function AspectBar_OnEvent(event)
	
	if ( event == "LEARNED_SPELL_IN_TAB" ) then
		AspectBar_UpdateList();
	end
	
end

function AspectBar_Initialize()

	if ( UnitClass("player") == "Hunter" ) then
	
		-- Register Events
		this:RegisterEvent("LEARNED_SPELL_IN_TAB");
		
		AspectBarTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
		
		-- Initialize
		AspectBar_HookFunctions();
		AspectBar_UpdateList();
		
		-- Position
		ShapeshiftBarFrame:ClearAllPoints();
		if ( PetActionBarFrame:IsVisible() ) then
			ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "PetActionBarFrame", "TOPLEFT", 25, -5);
		else
			ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, 0);
		end
	
	end
	AspectBar_Var.Loaded = true;
	
end

function AspectBar_HookFunctions()

	-- GetNumShapeshitForms
	Default_GetNumShapeshiftForms = GetNumShapeshiftForms;
	GetNumShapeshiftForms = AspectBar_GetNumShapeshiftForms;

	-- CastShapeshiftForm
	Default_CastShapeshiftForm = CastShapeshiftForm;
	CastShapeshiftForm = AspectBar_CastShapeshiftForm;

	-- GetShapeshiftFormInfo
	Default_GetShapeshiftFormInfo = GetShapeshiftFormInfo;
	GetShapeshiftFormInfo = AspectBar_GetShapeshiftFormInfo;

	-- GetShapeshiftFormCooldown
	Default_GetShapeshiftFormCooldown = GetShapeshiftFormCooldown;
	GetShapeshiftFormCooldown = AspectBar_GetShapeshiftFormCooldown;

	-- ShapeshiftBar_Update
	Default_ShapeshiftBar_Update = ShapeshiftBar_Update;
	ShapeshiftBar_Update = AspectBar_ShapeshiftBar_Update;

	-- ShowPetActionBar
	Default_ShowPetActionBar = ShowPetActionBar;
	ShowPetActionBar = AspectBar_ShowPetActionBar;

	-- HidePetActionBar
	Default_HidePetActionBar = HidePetActionBar;
	HidePetActionBar = AspectBar_HidePetActionBar;

end

function AspectBar_UpdateList()
	AspectBar_List = AspectBar_GenerateList();
	ShapeshiftBar_Update();
end

-- does not care about ranks
function AspectBar_GetSpellId(spellName)
	local i = 1;
	local name, rankName;
	name, rankName = GetSpellName(i, "spell")
	while name do
		if ( name == spellName) then
			return i;
		end
		i = i + 1;
		name, rankName = GetSpellName(i, "spell")
	end
	return -1;
end

function AspectBar_GetAspectCooldown(aspect)
	return GetSpellCooldown(aspect.id, "spell");
end

function AspectBar_GetAspectTexture(aspect)
	return GetSpellTexture(aspect.id, "spell");
end


function AspectBar_GenerateList()
	local list = {};
	for k, v in AspectBar_SpellNames do 
		local spellId = AspectBar_GetSpellId(v);
		if ( spellId > -1 ) then
			table.insert(list, { id = spellId, name = v } );
		end
	end
	return list;
end

function AspectBar_GetNumShapeshiftForms()
	local numForms = Default_GetNumShapeshiftForms();
	numForms = numForms + getn(AspectBar_List);
	return numForms;
end

function AspectBar_CastShapeshiftForm(id)
	local originalForms = Default_GetNumShapeshiftForms();
	if (id > originalForms)  then
		local aspect = AspectBar_List[id - originalForms];
		if ( aspect ) then
			CastSpell(aspect.id, "spell");
		end
	else
		Default_CastShapeshiftForm(id);
	end
end

function AspectBar_IsAspectActive(aspect)
	return AspectBar_HasPlayerEffect(AspectBar_GetAspectTexture(aspect));
end

function AspectBar_GetShapeshiftFormInfo(id)
	local originalForms = Default_GetNumShapeshiftForms();
	if (id > originalForms) then
		local aspect = AspectBar_List[id - originalForms];
		if ( not aspect ) then
			return nil, nil, nil;
		end
		local texture, name, isActive, isCastable;
		texture = GetSpellTexture(aspect.id, "spell");
		isActive = AspectBar_IsAspectActive(aspect);
		isCastable = true;
		name = aspect.name;
		return texture, name, isActive, isCastable;
	else
		return Default_GetShapeshiftFormInfo(id);
	end
end

function AspectBar_GetShapeshiftFormCooldown(id)
	local originalForms = Default_GetNumShapeshiftForms();
	if (id > originalForms) then
		local aspect = AspectBar_List[id - originalForms];
		if ( not aspect ) then
			return nil, nil, nil;
		end
		local start, duration, enable = AspectBar_GetAspectCooldown(aspect);
		return start, duration, enable;
	else
		return Default_GetShapeshiftFormCooldown(id);
	end
end

function AspectBar_HasBuffTexture(texture)
	local id = 1;
	for id = 1, 15 do
		if ( GetPlayerBuffTexture(id) == texture ) then
			return true;
		end
	end
	return false;
end

-- tooltip helper function
AspectBar_TOOLTIPS_UNSAFE_FRAMES = { 
   "TaxiFrame", "MerchantFrame", "TradeSkillFrame", "SuggestFrame", "WhoFrame", "AuctionFrame", "MailFrame" 
   }; 

-- use this to add unsafe frames 
function AspectBar_TooltipsCanNotBeUsedWithFrame(frame) 
   table.insert(AspectBar_TOOLTIPS_UNSAFE_FRAMES, frame); 
end 

-- will return 1 if it is "safe" to use tooltips, otherwise 0 
function AspectBar_TooltipsCanBeUsed() 
   local frame = nil; 
   for k, v in AspectBar_TOOLTIPS_UNSAFE_FRAMES do 
      frame = getglobal(v); 
      if ( ( frame ) and ( frame:IsVisible() ) ) then 
         return false; 
      end 
   end 
   return true; 
end

function AspectBar_PlayerHasBuff(name)
	local i = 0;
	local buffName = AspectBar_GetBuffName("player", i);
	while buffName do
		if ( buffName == name ) then
			return true;
		end
		i = i + 1;
		buffName = AspectBar_GetBuffName("player", i);
	end
	return false;
end

function AspectBar_Update_Position()
	if ( ShapeshiftBarFrame:IsVisible() ) then
		ShapeshiftBarFrame:ClearAllPoints();
		if ( PetActionBarFrame:IsVisible() ) then
			ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "PetActionBarFrame", "TOPLEFT", 25, -5);
		else
			ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, 0);
		end
	end
end

function AspectBar_ShapeshiftBar_Update()
	Default_ShapeshiftBar_Update();
	AspectBar_Update_Position();
end

function AspectBar_ShowPetActionBar()
	Default_ShowPetActionBar();
	ShapeshiftBarFrame:ClearAllPoints();
	ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "PetActionBarFrame", "TOPLEFT", 25, -5);
	PETACTIONBAR_XPOS = 36;
end

function AspectBar_HidePetActionBar()
	ShapeshiftBarFrame:ClearAllPoints();
	ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, 0);
	Default_HidePetActionBar();
end

function AspectBar_GetBuffName(unit,i,debuff)
	local buffindex;
	local buff;
	
	local buffFilter = "HELPFUL|PASSIVE";
	
	if (debuff ~= nil) then
		buffFilter = "HARMFUL";
	end
	buffindex = i;
	if (buffindex < 24) then
		buff = GetPlayerBuff(buffindex, buffFilter);
		if (buff == -1) then
			buff = nil;
		end
	end
	
	if (buff) then
		local tooltip = getglobal("AspectBarTooltip");
		if ( AspectBar_TooltipsCanBeUsed() ) then
			local name = nil;
			if (unit == "player") then
				tooltip:SetPlayerBuff(buff);
				local tooltiptext = getglobal("AspectBarTooltipTextLeft1");
				name = tooltiptext:GetText();
			end
			if ( name ~= nil ) then
				return name;
			end
		else
		end
	end
	return nil;
end

function AspectBar_HasPlayerEffect(texture)
	if ( texture ) then
		for id = 0, 24 do
			if ( GetPlayerBuffTexture(id) == texture ) then
				return true;
			end
		end
		local icon = GetTrackingTexture();
		if ( icon == texture ) then 
			return true;
		end
	end
	return false;
end

function AspectBar_GetRankAsNumber(rankName)
	if ( rankName ) then
		local index, index2 = strfind(rankName, "Rank");
		if ( ( index ) and (index2 ) ) then
			local tmpStr = strsub(rankName, index2+1);
			while ( ( tmpStr) and ( strlen(tmpStr) > 1 ) and ( strsub(tmpStr, 1, 1) == " " ) ) do
				tmpStr = strsub(tmpStr, 2);
			end
			local i = tonumber(tmpStr);
			if ( i ) then
				return i;
			else
				return 0;
			end
		else
			return 0;
		end
	else
		return 0;
	end
end

function AspectBar_GetSpellId(spellName, spellRank, spellBook)
	local i = 1;
	local highestId = -1;
	local highestRankSoFar = -1;
	local rank;
	local spellRankNumber = 0;
	if (spellRank) then
		spellRankNumber = tonumber(spellRank);
		if (spellRankNumber) then
			spellRankNumber = 0;
		end
	end
	if ( not spellBook ) then
		spellBook = "spell";
	end
	local name, rankName;
	name, rankName = GetSpellName(i, spellBook);
	while name do
		if ( name == spellName) then
			if ( spellRank == nil ) then
				rank = AspectBar_GetRankAsNumber(rankName);
				if ( rank ) then
					if ( rank > highestRankSoFar ) then
						highestRankSoFar = rank;
						highestId = i;
					end
				else
					return i;
				end
			else
				rank = AspectBar_GetRankAsNumber(rankName);
				if ( rank == spellRankNumber ) then
					highestId = i;
					break;
				elseif ( rank > highestRankSoFar ) then
					highestRankSoFar = rank;
					highestId = i;
				end
			end
		end
		i = i + 1;
		name, rankName = GetSpellName(i, spellBook)
	end
	return highestId;
end