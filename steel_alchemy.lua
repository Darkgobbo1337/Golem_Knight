newTalent{
	name = "Living Steel Infusion",
	type = {"spell/steel-alchemy", 1},
	mode = "sustained",
	require = spells_req1,
	sustain_mana = 20,
	points = 5,
	cooldown = 6,
	tactical = { BUFF = 2 },
	getIncrease = function(self, t) return self:combatTalentScale(t, 0.05, 0.25) * 100 end,
    	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 40, 15, 30) end,
	infusion = function(self, t) return DamageType.PHYS_ROOT end,
	sustain_slots = 'alchemy_infusion',
	is_infusion = true,
	activate = function(self, t)
		game:playSoundNear(self, "talents/arcane")
		local ret = {}
        		self:talentTemporaryValue(ret, "inc_damage", {[DamageType.PHYSICAL] = t.getIncrease(self, t)}),
		if self:getTalentLevel(t) >= 3 then
        		self:talentTemporaryValue(ret, "resists_pen", {[DamageType.PHYSICAL] = t.getResistPenalty(self, t)})
		end
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[When you use your abilities, you infuse them with physical damage that throws your foe off-balance.
                You increase your Physical damage by %d%%. At rank 3 and higher you increase your Physical resistance penetration by %d%%.
                You cannot have more than one alchemist infusion sustain active at once. 
                Switching to another infusion is instant but puts the others on a short 3 turn cooldown.]]):
		tformat(t.getIncrease(self,t), t.getResistPenalty(self,t))
	end,
}

                

newTalent{
	name = "Gem Boulder",
	type = {"spell/steel-alchemy", 2},
	require = spells_req2,
	points = 5,
	mana = 30,
	cooldown = 12,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 3, 8, 0.5, 0, 0, true)) end,
	radius = 1
	direct_hit = true
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	--Calculate damage from Infusion and Alchemist Gems
	computeDamage = function(self, t, ammo)
		local inc_dam = 0
		local damtype = DamageType.PHYSICAL
		local particle = "ball_physical"
			for tid, act in pairs(target.sustain_talents) do
				local tt = self:getTalentFromId(tid)
					if tt.infusion then damtype, particle = tt.infusion(self, tt) end
			end
		inc_dam = inc_dam + (ammo.alchemist_bomb and ammo.alchemist_bomb.power or 0) / 100
		local dam = self:combatTalentPhysicalDamage(t, 15, 150, ((ammo.alchemist_power or 0) + self:combatPhysicalpower()) / 2)
		dam = dam * (1 + inc_dam)
		return dam, damtype, particle
	end,
	--knockback calculation
	getDist = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	--apply damage
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local target = game.level.map(x, y, engine.Map.ACTOR) or self.ai_target.actor or {name=_t"something"}
		self:logCombat(target, "#Source# hurls a gem boulder at #target#!")
		self:project(tg, x, y, dam, {dist=t.getDist(self, t), dam=self:physCrit(t.getDam(self, t))}, {type="archery"})
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	--tactical ai infomation
	tactical = { DISABLE = { knockback = 3 }, ESCAPE = { knockback = 2 }, 
		{ ATTACKAREA = function(self, t, target)
        		if self:isTalentActive(self.T_DISEASE_INFUSION) then return { BLIGHT = 2 }
        		elseif self:isTalentActive(self.T_CHRONO_INFUSION) then return { TEMPORAL = 2 }
        		elseif self:isTalentActive(self.T_FORBIDDEN_INFUSION) then return { DARKNESS = 2 }
        		elseif self:isTalentActive(self.T_CELESTIAL_INFUSION) then return { LIGHT = 2 }
    			else return { PHYSICAL = 2 }
        	end
    	end },
	info = function(self, t)
		return ([[You imbue a gem and throw it at your foe and it grows in flight to the size of a boulder. It deals %0.2f Infusion damage to the target and in a radius of %d around the target. Targets hit by the boulder have a chance to be knocked back(3-9).
		The damage increases with Strength and quality of the gems used.]]):
		tformat(damDesc(self, DamageType.PHYSICAL, t.getDam(self, t)), t.getDist(self, t), self:getTalentRadius(t))
	end,
}

newTalent{
	name = "Throw Boulder",
	type = {"wild-gift/other", },
	points = 5,
	mana = 30,
	cooldown = 12,
	range = 10,
	radius = 1,
	direct_hit = true,
	tactical = { DISABLE = { knockback = 3 }, ATTACKAREA = {PHYSICAL = 2 }, ESCAPE = { knockback = 2 } },
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	getDam = function(self, t) return self:combatScale(self:getStr() * self:getTalentLevel(t), 12, 0, 262, 500) end,
	getDist = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local target = game.level.map(x, y, engine.Map.ACTOR) or self.ai_target.actor or {name=_t"something"}
		self:logCombat(target, "#Source# hurls a gem boulder at #target#!")
		self:project(tg, x, y, dam, {dist=t.getDist(self, t), dam=self:physCrit(t.getDam(self, t))}, {type="archery"})
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		return ([[Throw a huge boulder, dealing %0.2f physical damage and knocking targets back %d tiles within radius %d.
		The damage will increase with your Strength.]]):tformat(damDesc(self, DamageType.PHYSICAL, t.getDam(self, t)), t.getDist(self, t), self:getTalentRadius(t))
	end,
}

newTalent[ 
	name = "Thorn Spikes",
	type = {"spell/steel-alchemy", 3},
	mode = "sustained",
	require = spells_req3
	sustain_mana = 25,
	points = 5,
	cooldown = 15,
	tactical = { BUFF =2, DEFEND = 2 },
	getDamageOnMeleeHit = function(self, t) return self:combatTalentSpellDamage(t, 1, 150, getcombatSpellpower(self, t)) end,
	
	activate = function(self, t)
        local power = t.getArmor(self, t)
        self.carbon_armor = power
        game:playSoundNear(self, "talents/spell_generic")
        return {
            armor = self:addTemporaryValue("carbon_spikes", power),
            onhit = self:addTemporaryValue("on_melee_hit", {[DamageType.PHYSICALBLEED]=t.getDamageOnMeleeHit(self, t)}),            
        	}
    	end,
	Your gems in your armor become spikes that gouge and tear your opponents when they strike you. When hit in melee combat you deal (5-50) damage back to your attacker in the form of physical bleed damage.
	The damage increases with your Spellpower.

]

newTalent{
	name = "Spikeskin",
	type = {"race/drem", 2},
	require = racial_req2,
	points = 5,
	mode = "passive",
	getDamage = function(self, t) return self:combatStatScale("mag", 40, 150) / 5 end,
	getNb = function(self, t) return math.floor(self:getTalentLevel(t)) end,
	callbackOnMeleeHit = function(self, t, src, dam)
		if self.turn_procs.spikeskin or src:hasEffect(src.EFF_SPIKESKIN_BLACK_BLOOD) then return end
		self.turn_procs.spikeskin = true
		src:setEffect(src.EFF_SPIKESKIN_BLACK_BLOOD, 5, {src=self, power=t.getDamage(self, t)})
	end,
	callbackOnActBase = function(self, t)
		local nb_foes = 0
		for i = 1, #self.fov.actors_dist do
			local act = self.fov.actors_dist[i]
			if act and self:canSee(act) and act:hasEffect(act.EFF_SPIKESKIN_BLACK_BLOOD) and core.fov.distance(self.x, self.y, act.x, act.y) <= 2 then nb_foes = nb_foes + 1 end
		end
		if nb_foes >= 1 then
			nb_foes = math.min(nb_foes, t.getNb(self, t))
			self:setEffect(self.EFF_SPIKESKIN, 2, {power=nb_foes * 5})
		end
	end,
	info = function(self, t)
		return ([[Your skin grows small spikes coated in dark blight.
		When you are hit in melee the attacker starts bleeding black blood for 5 turns that deals %0.2f darkness damage each turn. This effect may only happen once per turn.
		You are empowered by the sight of the black blood, for each bleeding creature in radius 2 you gain 5%% all resistances, limited to %d creatures.
		The damage will scale with your Magic stat.]]):
		tformat(damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), t.getNb(self, t))
	end,
}


[[damage type is entirely just from changing the effect to Cut instead of black blood (might need to change parameters to suit, but otherwise)
[8:40 PM]
and remove the 
        if nb_foes >= 1 then
            nb_foes = math.min(nb_foes, t.getNb(self, t))
            self:setEffect(self.EFF_SPIKESKIN, 2, {power=nb_foes * 5})
        end
[8:40 PM]
then you're good.

callbackOnMeleeHit = function(self, t, src, dam)
    if src:canBe('cut') then
        src:setEffect(src.EFF_CUT, 5, {power=t.getDamage(self, t)})
end,

callbackOnMeleeHit = function(self, t, src, dam)
    if src:canBe('cut') and src.turn_procs.bledthistrn = true then
    src.turn_procs.bledthistrn = true   
    src:setEffect(src.EFF_CUT, 5, {power=t.getDamage(self, t)})
end,]]

-- Carbon spikes
newTalent{
    name = "Carbon Spikes",
    type = {"chronomancy/other", 1},
    no_sustain_autoreset = true,
    points = 5,
    mode = "sustained",
    sustain_paradox = 20,
    cooldown = 12,
    
    getDamageOnMeleeHit = function(self, t) return self:combatTalentSpellDamage(t, 1, 150, getParadoxSpellpower(self, t)) end,
    getArmor = function(self, t) return math.ceil(self:combatTalentSpellDamage(t, 20, 50, getParadoxSpellpower(self, t))) end,
    callbackOnActBase = function(self, t)
        local maxspikes = t.getArmor(self, t)
        if self.carbon_armor < maxspikes then
            self.carbon_armor = self.carbon_armor + 1
        end
    end,
    do_carbonLoss = function(self, t)
        if self.carbon_armor >= 1 then
            self.carbon_armor = self.carbon_armor - 1
        else
            -- Deactivate without loosing energy
            self:forceUseTalent(self.T_CARBON_SPIKES, {ignore_energy=true})
        end
    end,
    activate = function(self, t)
        local power = t.getArmor(self, t)
        self.carbon_armor = power
        game:playSoundNear(self, "talents/spell_generic")
        return {
            armor = self:addTemporaryValue("carbon_spikes", power),
            onhit = self:addTemporaryValue("on_melee_hit", {[DamageType.BLEED]=t.getDamageOnMeleeHit(self, t)}),            
        }
    end,
    deactivate = function(self, t, p)
        self:removeTemporaryValue("carbon_spikes", p.armor)
        self:removeTemporaryValue("on_melee_hit", p.onhit)
        self.carbon_armor = nil
        return true
    end,
    info = function(self, t)
        local damage = t.getDamageOnMeleeHit(self, t)
        local armor = t.getArmor(self, t)
        return ([[Fragile spikes of carbon protrude from your flesh, clothing, and armor, increasing your armor rating by %d and inflicting %0.2f bleed damage over six turns on attackers.   Each time you're struck, the armor increase will be reduced by 1.  Each turn the spell will regenerate 1 armor up to its starting value.
        If the armor increase from the spell ever falls below 1, the sustain will deactivate and the effect will end.
        The armor and bleed damage will increase with your Spellpower.]]):
        tformat(armor, damDesc(self, DamageType.PHYSICAL, damage))
    end,
}


newTalent[
	name = "Warden Form",
	type = {"spell/steel-alchemy", 4},
	Use mode: Passive
	You borrow from the dwarves to become like living steel, meshing magic and nature to keep you alive. While Living Steel infusion is active you automatically block after casting a spell that uses an alchemist gem. When you block you consume an alchemist gem to heal (2-10) over 4 turns. This can stack up to five times and refreshes the duration each time.
	Also your golem gains the bonus of your Living Steel Infusion and some of your golem’s talents root all targets hit dealing physical damage every turn.
	The heal and the pin damage scale with Strength.

]
