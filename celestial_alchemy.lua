newTalent{
	name = "Celestial Infusion",
	type = {"spell/celestial-alchemy", 1},
	mode = "sustained",
	require = spells_req1,
	sustain_mana = 20,
	points = 5,
	cooldown = 8,
	tactical = { BUFF = 2 },
	getIncrease = function(self, t) return self:combatTalentScale(t, 0.05, 0.25) * 100 end,
    	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 40, 15, 30) end,
	infusion = function(self, t) return DamageType.LIGHT_BLIND, "blinding light" end
	sustain_slots = 'alchemy_infusion',
	is_infusion = true,
	activate = function(self, t)
		game:playSoundNear(self, "talents/arcane")
		local ret = {}
        		self:talentTemporaryValue(ret, "inc_damage", {[DamageType.LIGHT] = t.getIncrease(self, t)}),
		if self:getTalentLevel(t) >= 3 then
        		self:talentTemporaryValue(ret, "resists_pen", {[DamageType.LIGHT] = t.getResistPenalty(self, t)})
		end
		return ret
		local function activate_infusion(self, btid)
			for tid, lev in pairs(self.talents) do
				if tid ~= btid and self.talents_def[tid].is_infusion and (not self.talents_cd[tid] or self.talents_cd[tid] < 3) then 
					self.talents_cd[tid] = 3
				end
			end
		end
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local daminc = t.getIncrease(self, t)
        	local phypen = t.getResistPenalty(self, t)
		return ([[When you use your abilities, you infuse them with light damage that blinds your foe.
                You increase your Light damage by %d%%. At rank 3 and higher you increase your Light resistance penetration by %d%%.
                You cannot have more than one alchemist infusion sustain active at once. 
                Switching to another infusion is instant but puts the others on a short 3 turn cooldown.]]):
		tformat(daminc,physpen)
	end,
}

Gem Shield 
Use mode: Activated
Mana Cost: 40
Gem Cost: 5
Range: Melee/Personal
Cooldown: (18-12)
Use Speed: Spell
You crush alchemist gems and spread the dust around you forming a shield to protect you from (150-400)damage for 5 turns. The first time you are attacked you send out a beam dealing (25-100) Infusion damage at your attacker to range 5. This beam always goes as far as it can even when struck in melee.
The damage and shield power are increased by spellpower and quality of gem used.

Blinding Strikes
Use mode: Activated
Stamina Cost: 20
Mana Cost: 15
Range: Melee/personal
Cooldown: 10
Use Speed: Shield
You strike with shield dealing (.8-1.5) shield damage as blinding light damage. You follow up with a weapon strike with a (3%-15%) increased chance of a crit and (20%-60%) crit power if the target is blinded. 

Paladin Form: 
Use mode: Passive
You borrow from the divine and become a beacon of light shining hope into your allies and despair into your foes. While Celestial Infusion is active you deal (10-60) light damage on all of your strikes. If you have a temporary damage shield up it will increase its power by (5-30) once per turn and add (1-3) to the duration. The duration can only be added to a damage shield once.
Also your golem gains the bonus of your Celestial Infusion and some of your golem’s talents lite the tile of its target and all adjacent tiles while doing blinding light damage..
The damage and power increase will increase with spellpower.

