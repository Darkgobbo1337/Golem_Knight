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
