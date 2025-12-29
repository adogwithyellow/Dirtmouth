SMODS.Joker {
	key = 'unbreakstrength',
	config = {extra = {Xmult = 3}},
	rarity = 4,
	pools = {["HKJokersCharms"] = true},
	atlas = 'HKCharms',
	pos = {x = 0, y = 0},
	cost = 25,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.Xmult}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xmult_mod = card.ability.extra.Xmult,
				message = localize {type = 'variable', key = 'a_xmult', vars = {card.ability.extra.Xmult}}
			}
		end
	end
}