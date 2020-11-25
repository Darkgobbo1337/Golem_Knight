newTalent{
	name = "Disease Infusion",
	type = {"spell/disease-alchemy", 1},
	mode = "sustained",
	require = spells_req1,
	sustain_mana = 20,
	points = 5,
	cooldown = 8,
	tactical = { BUFF = 2 },
	getIncrease = function(self, t) return self:combatTalentScale(t, 0.05, 0.25) * 100 end,
    	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 40, 15, 30) end,
	infusion = function(self, t) return DamageType.BLIGHT_DISEASE, "blight_disease" end
	sustain_slots = 'alchemy_infusion',
	is_infusion = true,
	activate = function(self, t)
		game:playSoundNear(self, "talents/arcane")
		local ret = {}
        		self:talentTemporaryValue(ret, "inc_damage", {[DamageType.BLIGHT] = t.getIncrease(self, t)}),
		if self:getTalentLevel(t) >= 3 then
        		self:talentTemporaryValue(ret, "resists_pen", {[DamageType.BLIGHT] = t.getResistPenalty(self, t)})
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
        	local pen = t.getResistPenalty(self, t)
		return ([[When you use your abilities, you infuse them with light damage that diseases your foe.
                You increase your Blight damage by %d%%. At rank 3 and higher you increase your Blight resistance penetration by %d%%.
                You cannot have more than one alchemist infusion sustain active at once. 
                Switching to another infusion is instant but puts the others on a short 3 turn cooldown.]]):
		tformat(daminc,pen)
	end,
}
Disease Infusion 
Use mode: Sustained
Mana Cost: 20
Range: Melee/Personal
Cooldown: 8
Use Speed: Spell
When you use your abilities you infuse them with Blight damage that diseases your foe. 
You increase your Blight damage by (7%-30%). At rank 3 and higher you increase your Blight resistance penetration by (5%-15%).
You cannot have more than one alchemist infusion sustain active at once.

Gem Crystals
Use mode: Activated
Mana Cost: 10
Gem Cost: 4
Range: 5
Cooldown: (15-6)
Use Speed: Spell
You imbue a few gems with magic and toss them out to summon (2-5) crystals in a radius 3 around your target. These crystals taunt enemies around them and when destroyed they explode dealing (30-300) Infusion damage to all immediately around them in radius (1-2).
The damage increases with spellpower and quality of the gems used.

Contagion Echoes
Use mode: Activated
Stamina Cost: 10
Mana Cost: 5
Range: Melee/personal
Cooldown: 10
Use Speed: Weapon
You strike out with both your weapon (1 - 1.8) and your shield (1.2 - 2.0) each dealing Blight damage in a radius 1 splash. Each splash has a chance of inflicting a random disease on the targets hit by it.
The chance to inflict diseases increases with your spellpower.

Reaving Form
Use mode: Passive
You borrow from the corrupt and become a carrier of magical illness and corrupted strength. While Disease Infusion is active you automatically make a shield bash for (.7-1.1) blight damage after casting a spell that uses an alchemist gem. If the target has any diseases the duration is increased by (1-3)
Also your golem gains the bonus of your Disease Infusion and some of your golem’s talents splash in radius (1-3) with infectious blight damage.
The damage will increase with spellpower.

