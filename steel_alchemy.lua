newTalent{
	name = "Living Steel Infusion",
	type = {"spell/steel-alchemy", 1},
	mode = "sustained",
	require = spells_req1,
	sustain_mana = 20,
	points = 5,
	cooldown = 8,
	tactical = { BUFF = 2 },
	getIncrease = function(self, t) return self:combatTalentScale(t, 0.05, 0.25) * 100 end,
    	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 40, 5, 30) end,
	sustain_slots = 'alchemy_infusion',
	activate = function(self, t)
		game:playSoundNear(self, "talents/arcane")
		local ret = {}
        local pen = {}
		self:talentTemporaryValue(ret, "inc_damage", {[DamageType.PHYSICAL] = t.getIncrease(self, t)}),
        	self:talentTemporaryValue(pen, "resists_pen", {[DamageType.PHYSICAL] = t.getResistPenalty(self, t)})
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local daminc = t.getIncrease(self, t)
        local phypen = t.getResistPenalty(self, t)
		return ([[When you use your abilities, you infuse them with physical damage that throws your foe off-balance.
                You increase your Physical damage by %d%%. At rank 3 and higher you increase your Physical resistance penetration by %d%%.
                You cannot have more than one alchemist infusion sustain active at once. 
                Switching to another infusion is an instant but puts the others on a short 3 turn cooldown.]]):
		tformat(daminc,physpen)
	end,
}


                When you use your abilities, you infuse them with physical damage that throws your foe off-balance.
                You increase your Physical damage by %d%%. At rank 3 and higher you increase your Physical resistance penetration by %d%%.
                You cannot have more than one alchemist infusion sustain active at once.



newTalent[
	name = "Gem Boulder",
	type = {"spell/steel-alchemy", 2},
	points = 5,
	mana = 30,
	gem
	Gem Cost: 1
	Range: 3-8
	Cooldown = 12,
	Use Speed: Spell
	You imbue a gem and throw it at your foe and it grows in flight to the size of a boulder. It deals (125-300) Infusion damage to the target and in a radius of 1 around the target. Targets hit by the boulder have a chance to be knocked back(3-9).
	The damage increases with Strength and quality of the gems used.

]
newTalent[ 
	name = "Thorn Spikes",
	type = {"spell/steel-alchemy", 3},
	Use mode = "sustained"
	Mana Cost: 25
	Cooldown: 15
	Use Speed: Spell
	Your gems in your armor become spikes that gouge and tear your opponents when they strike you. When hit in melee combat you deal (5-50) damage back to your attacker in the form of physical bleed damage.
	The damage increases with your Spellpower.

]
newTalent[
	name = "Warden Form",
	type = {"spell/steel-alchemy", 4},
	Use mode: Passive
	You borrow from the dwarves to become like living steel, meshing magic and nature to keep you alive. While Living Steel infusion is active you automatically block after casting a spell that uses an alchemist gem. When you block you consume an alchemist gem to heal (2-10) over 4 turns. This can stack up to five times and refreshes the duration each time.
	Also your golem gains the bonus of your Living Steel Infusion and some of your golem’s talents root all targets hit dealing physical damage every turn.
	The heal and the pin damage scale with Strength.

]
