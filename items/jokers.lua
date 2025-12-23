-- disclaimer: all jokers that share the same effect as zote are uncoded and i plan to work on them next, the templates are just there for convenience

SMODS.Joker {
	key = 'knight',
	config = {extra = {chips = 25}},
	rarity = 1,
	atlas = 'HKJokers',
	pos = {x = 0, y = 0},
	cost = 3,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}
			}
		end
	end
}

SMODS.Joker {
	key = 'sly',
	config = {extra = {Xmult_gain = 0.3, money = 9}},
	rarity = 3,
	atlas = 'HKJokers',
	pos = {x = 4, y = 0},
	cost = 9,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.Xmult_gain, card.ability.extra.money, (1 + card.ability.extra.Xmult_gain * math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0)) / card.ability.extra.money))}}
	end,
	calculate = function(self, card, context)
		if context.joker_main and to_number(math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0)) / card.ability.extra.money)) >= 1 then
        	return {
				Xmult_mod = 1 + to_number(card.ability.extra.Xmult_gain * math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0)) / card.ability.extra.money)),
				message = localize {type = 'variable', key = 'a_Xmult', vars = {card.ability.extra.Xmult_gain * math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0)) / card.ability.extra.money)}}
			}
		end
	end
}

SMODS.Joker {
	key = 'zote',
	config = {extra = {chips = 5}},
	rarity = 1,
	atlas = 'HKJokers',
	pos = {x = 3, y = 0},
	cost = 1,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}
			}
		end
	end
}

SMODS.Joker {
	key = 'nosk',
	config = {},
	rarity = 2,
	atlas = 'HKJokers',
	pos = {x = 0, y = 0},
	cost = 6,
	calculate = function(self, card, context)
		local target = nil
		local pos = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                pos = i
				break
			end
		end
		target = (pos and pos < 1) and G.jokers.cards[pos + 1] or nil

		local change = SMODS.blueprint_effect(card, target, context)
		if change then
			SMODS.calculate_effect(change, card)
		end
	end
}

SMODS.Joker {
	key = 'traitorlord',
	config = {extra = {mult = 0, mult_gain = 3, destroyable = nil}},
	rarity = 2,
	atlas = 'HKJokers',
	pos = {x = 0, y = 0},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult, card.ability.extra.mult_gain}}
	end,
	calculate = function(self, card, context)
		if context.before and context.main_eval and not context.blueprint then
			card.ability.extra.destroyable = pseudorandom_element(G.play.cards, pseudoseed('traitor'))
		end
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize {type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
			}
		end
		if context.destroy_card and not context.blueprint then
			if context.destroy_card == card.ability.extra.destroyable then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
				return {
					message = localize ('k_traitordestroy'),
					remove = true
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'wingednosk',
	config = {extra = {chips = 5}},
	rarity = 'HKMod_DreamRare',
	atlas = 'HKJokers',
	pos = {x = 0, y = 0},
	cost = 20,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}
			}
		end
	end
}

SMODS.Joker {
	key = 'voidform',
	config = {extra = {mult = 40}},
	rarity = 'HKMod_DreamRare',
	atlas = 'HKJokers',
	pos = {x = 1, y = 0},
	cost = 20,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return{
				mult_mod = card.ability.extra.mult,
				message = localize {type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
			}
		end
	end
}

SMODS.Joker {
	key = 'voidfocus',
	rarity = 'HKMod_DreamRare',
	atlas = 'HKJokers',
	pos = {x = 2, y = 0},
	cost = 30,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.game_over and not context.blueprint then
			if G.GAME.blind.boss then
				for i = 1, #G.jokers.cards do
					if G.jokers.cards[i] == card then
						if i > 1 then
							G.jokers.cards[i-1]:set_edition('e_negative')
						end
						if i < #G.jokers.cards then
							G.jokers.cards[i+1]:set_edition('e_negative')
						end
					end
				end
			end
		end
	end
}