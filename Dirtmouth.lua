SMODS.Atlas { --Joker sprites
	key = "HKJokers",
	path = "jokers.png",
	px = 71,
	py = 95
}

SMODS.Atlas { --Charm Joker Sprites
	key = "HKCharms",
	path = "charms.png",
	px = 74,
	py = 74
}

SMODS.Rarity { --Dream Rarity (for Dream Nail)
    key = "DreamRare",
    badge_colour = HEX("E8B8E5"),
    default_weight = 0,
    get_weight = function(self, weight, object_type)
        return weight
    end
}

SMODS.Atlas { --Mod icon
    key = "modicon",
    path = "icon.png",
    px = 34,
    py = 34
}

assert(SMODS.load_file("items/jokers.lua"))()
assert(SMODS.load_file("items/charms.lua"))()	