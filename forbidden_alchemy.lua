newTalent{
	name = "Forbidden Infusion",
	type = {"spell/forbidden-alchemy", 1},
	mode = "sustained",
	require = spells_req1,
	sustain_mana = 20,
	points = 5,
	cooldown = 8,
	tactical = { BUFF = 2 },
	getIncrease = function(self, t) return self:combatTalentScale(t, 0.05, 0.25) * 100 end,
    	getResistPenalty = function(self, t) return self:combatTalentLimit(t, 40, 15, 30) end,
	infusion = function(self, t) return DamageType.DARK_FEAR, "darkness_fear" end
	sustain_slots = 'alchemy_infusion',
	is_infusion = true,
	activate = function(self, t)
		game:playSoundNear(self, "talents/arcane")
		local ret = {}
        		self:talentTemporaryValue(ret, "inc_damage", {[DamageType.DARKNESS] = t.getIncrease(self, t)}),
		if self:getTalentLevel(t) >= 3 then
        		self:talentTemporaryValue(ret, "resists_pen", {[DamageType.DARKNESS] = t.getResistPenalty(self, t)})
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
		return ([[When you use your abilities, you infuse them with darkness damage that frightens your foes.
                You increase your Darkness damage by %d%%. At rank 3 and higher you increase your Darkness resistance penetration by %d%%.
                You cannot have more than one alchemist infusion sustain active at once. 
                Switching to another infusion is instant but puts the others on a short 3 turn cooldown.]]):
		tformat(daminc,pen)
	end,
}Forbidden Infusion 
Use mode: Sustained
Mana Cost: 20
Range: Melee/Personal
Cooldown: 8
Use Speed: Spell
When you use your abilities you infuse them with Darkness damage that frightens your foes. 
You increase your Darkness damage by (7%-30%). At rank 3 and higher you increase your Darkness resistance penetration by (5%-15%).
You cannot have more than one alchemist infusion sustain active at once.

Gem-tacles 
Use mode: Activated
Stamina Cost: 10
Mana Cost: 15
Gem Cost: 2
Range: 2-5
Cooldown: 16
Use Speed: Weapon
You crush two alchemist gems and strike out with your weapon in a cone. All enemies caught in the cone take (.7-1.2) weapon damage as Infusion damage. Every enemy that is hit spawns a crystalline tentacle that attacks an adjacent enemy for (10-50) Infusion damage for (2-4) turns.
The tentacle damage is increased by spellpower and quality of gems used.

Binding Darkness: 
Use mode: Activated
Stamina Cost: 10
Mana Cost: 10
Range: 6
Cooldown: 10
Use Speed: Spell
You force the shadows and darkness to wrap around your foe constricting them and thrashing at all enemies around. You constrict your target dealing (50-350) darkness damage to your target and tendrils of darkness lash out at any foe within radius (2-4) dealing (5-60) darkness damage each turn.
The damage of the constrict and tendrils are both increased by your spellpower

Writhing Form 
Use mode: Passive
You borrow from the insane and become an avatar of fear and darkness. While Forbidden Infusion is active your shield becomes a dark twisted form that lashes out at all enemies to the sides of your target. It loses (50%-15%) of its block and gains the following statistics. All attacks with your shield tentacle has a chance to fear your target decreasing their damage by (10%-45%)
Statistics: Power 8-30
Uses stats: 60% Str  60% Mag
Damage type: Darkness
Crit chance 1%-8%
Attack speed 100%
Also your golem gains the bonus of your Forbidden Infusion and some of your golem’s talents constrict the target dealing darkness damage.

