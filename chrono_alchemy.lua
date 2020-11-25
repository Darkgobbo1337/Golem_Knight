newTalent{
	name = "Chrono Infusion",
	type = {"spell/chrono-alchemy", 1},
	mode = "sustained",
	require = spells_req1,
	sustain_mana = 20,
	points = 5,
	cooldown = 8,
	tactical = { BUFF = 2 },
	getIncrease = function(self, t) return self:combatTalentScale(t, 0.05, 0.25) * 100 end,
    	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 40, 15, 30) end,
	infusion = function(self, t) return DamageType.TEMP_CONF, "temporal_confusion" end
	sustain_slots = 'alchemy_infusion',
	is_infusion = true,
	activate = function(self, t)
		game:playSoundNear(self, "talents/arcane")
		local ret = {}
        		self:talentTemporaryValue(ret, "inc_damage", {[DamageType.TEMPORAL] = t.getIncrease(self, t)}),
		if self:getTalentLevel(t) >= 3 then
        		self:talentTemporaryValue(ret, "resists_pen", {[DamageType.TEMPORAL] = t.getResistPenalty(self, t)})
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
		return ([[When you use your abilities, you infuse them with physical damage that confuses your foe.
                You increase your Temporal damage by %d%%. At rank 3 and higher you increase your Temporal resistance penetration by %d%%.
                You cannot have more than one alchemist infusion sustain active at once. 
                Switching to another infusion is instant but puts the others on a short 3 turn cooldown.]]):
		tformat(daminc,pen)
	end,
}
Chono Infusion 
Use mode: Sustained
Mana Cost: 20
Range: Melee/Personal
Cooldown: 8
Use Speed: Spell
When you use your abilities you infuse them with Temporal damage that confuses your foe. 
You increase your Temporal damage by (7%-30%). At rank 3 and higher you increase your Temporal resistance Penetration by (5%-15%).
You cannot have more than one alchemist infusion sustain active at once.

Gravity Gem 
Use mode: Activated
Mana Cost: 40
Gem Cost: 3
Range: 7
Cooldown: 25
Use Speed: Spell
You crush three alchemist gems into a sphere and toss it into your enemies' midst causing a gravity well to form that pulls all enemies around in radius (5-10). Enemies in radius 3 will take spellpower(25-230) Temporal damage and have a chance of being pinned.
The damage is increased with spellpower and quality of the gem used.

Destabilize Space 
Use mode: Activated
Mana Cost: 50
Range:(4-10)
Cooldown: (30-18)
Use Speed: Spell
You warp space and time to switch spaces with a creature within (4-10) spaces. Every other enemy within (2-5) radius is teleported randomly within 4 spaces and takes (10-75) Temporal damage.
The damage and radius are increased with spellpower

Temporal Form 
Use mode: Passive
You borrow from time and become entangled in both past and future. While Chrono Infusion is active you pull a temporal copy of your golem from an alternate timeline after casting a spell that uses an alchemist gem. Your golem appears next to an opponent within radius 3 and makes (1-3) melee attacks before vanishing back to it’s timeline. The golem is out of phase with normal reality and deals 50% less damage.
Also your golem gains the bonus of your Chrono Infusion and some of your golem’s talents deal Temporal damage that tries to stun, blind, pin, or confuse the target.
The duration and damage all increase with spellpower.

