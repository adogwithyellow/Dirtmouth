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
	key = 'oro',
	config = {extra = {mult = 0, mult_gain = 2}},
	rarity = 1,
	atlas = 'HKJokers',
	pos = {x = 0, y = 0},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult, card.ability.extra.mult_gain}}
	end,
	calculate = function(self, card, context)
	if context.before and next(context.poker_hands['Straight']) then
	card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
		return {
			message = 'Upgraded!',
				colour = G.C.RED
			}
		end

	if context.joker_main then
		return {
				mult_mod = card.ability.extra.mult,
				message = localize {type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
			}
		end
	end
}

SMODS.Joker {
	key = 'mato',
	config = {extra = {mult = 0, mult_gain = 2}},
	rarity = 1,
	atlas = 'HKJokers',
	pos = {x = 0, y = 0},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult, card.ability.extra.mult_gain}}
	end,
	calculate = function(self, card, context)
	if context.before and next(context.poker_hands['Flush']) then
	card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
		return {
			message = 'Upgraded!',
				colour = G.C.RED
			}
		end

	if context.joker_main then
		return {
				mult_mod = card.ability.extra.mult,
				message = localize {type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
			}
		end
	end
}

SMODS.Joker {
	key = 'nosk',
	config = {extra = {rounds = 2, timer = 0}},
	rarity = 2,
	atlas = 'HKJokers',
	pos = {x = 0, y = 0},
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.rounds, card.ability.extra.timer}}
	end,
	calculate = function(self, card, context)
		local target = nil
		local pos = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                pos = i
				break
			end
		end
		target = (pos and pos > 1) and G.jokers.cards[pos - 1] or nil

		local change = SMODS.blueprint_effect(card, target, context)
		if change then
			SMODS.calculate_effect(change, card)
		end

		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			card.ability.extra.timer = card.ability.extra.timer + 1
			if card.ability.extra.timer == card.ability.extra.rounds - 1 then
				local eval = function(card) return card.ability.extra.timer == card.ability.extra.rounds - 1 and not G.RESET_JIGGLES end
				juice_card_until(card, eval, true)
				return {
					message = localize('k_noskalmost')
				}
			end
			if card.ability.extra.timer == card.ability.extra.rounds then
				for i = 1, #G.jokers.cards do
					if G.jokers.cards[i] == card then
						pos = i
						break
					end
				end
				if pos and G.jokers.cards[pos - 1] and not SMODS.is_eternal(G.jokers.cards[pos - 1], card) and not G.jokers.cards[pos - 1].getting_sliced then
					target = G.jokers.cards[pos - 1]
					target.getting_sliced = true
					G.GAME.joker_buffer = G.GAME.joker_buffer - 1
					G.E_MANAGER:add_event(Event({
						func = function()
							G.GAME.joker_buffer = 0
							card:juice_up(0.8, 0.8)
							target:start_dissolve({ HEX("4f556a") }, nil, 1.6)
							play_sound('slice1', 0.96 + math.random() * 0.08)
							return true
						end
					}))
					card.ability.extra.timer = 0
					return {
						message = localize('k_destroygeneric')
					}
				end
			end
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
	config = {},
	rarity = 'HKMod_DreamRare',
	atlas = 'HKJokers',
	pos = {x = 0, y = 0},
	cost = 10,
	calculate = function(self, card, context)
		local target = nil
		local pos = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                pos = i
				break
			end
		end
		target = (pos and pos > 1) and G.jokers.cards[pos - 1] or nil

		local change = SMODS.blueprint_effect(card, target, context)
		if change then
			SMODS.calculate_effect(change, card)
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
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
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