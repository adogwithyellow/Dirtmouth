SMODS.Atlas { --TODO: maybe figure out custom negative textures for some jokers? mainly for form and focus
	key = "HKJokers",
	path = "jokers.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "placeholder",
	path = "placeholder.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "HKCharms",
	path = "charms.png",
	px = 74,
	py = 74
}

SMODS.Rarity {
    key = "DreamRare",
    badge_colour = HEX("E8B8E5"),
    default_weight = 0,
    get_weight = function(self, weight, object_type)
        return weight
    end
}

SMODS.Atlas {
    key = "modicon",
    path = "icon.png",
    px = 34,
    py = 34
}

assert(SMODS.load_file("items/jokers.lua"))()
assert(SMODS.load_file("items/charms.lua"))()