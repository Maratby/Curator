---Curated Packs

SMODS.Booster {
    key = 'curated_regular',
    name = 'Curated Pack',
    atlas = "curated-1st",
    diiscovered = true,
    pos = { x = 0, y = 0 },
    cost = 6,
    ---The placeholder "RandomMod" value will be used as a flag for backup later
    config = { extra = 4, choose = 1, curated = { mod_name = "RandomMod", } },
    group_key = 'k_curated_pack',
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.choose, self.config.extra, self.config.curated.mod_name } }
    end,
    set_ability = function(self, card, initial, delay_sprites)
        if Curator.joker_table then
            local temp = pseudorandom_element(Curator.joker_table, pseudoseed('curated_pack'))
            if temp then
                self.config.curated.mod_name = temp.DisplayName
            end
        end
    end,
    create_card = function(self, card, i)
        local tempset = "cura_curated_pack_pool_" .. self.config.curated.mod_name
        local newCard = SMODS.create_card { set = tempset, area = G.pack_cards }
        return newCard
    end,
    weight = 0.80,
    kind = 'Curated',
}

SMODS.Booster {
    key = 'curated_jumbo',
    name = 'Curated Pack',
    atlas = "curated-1st",
    diiscovered = true,
    pos = { x = 1, y = 0 },
    cost = 10,
    config = { extra = 5, choose = 1, curated = { mod_name = "RandomMod", } },
    group_key = 'k_curated_pack',
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.choose, self.config.extra, self.config.curated.mod_name } }
    end,
    set_ability = function(self, card, initial, delay_sprites)
        if Curator.joker_table then
            local temp = pseudorandom_element(Curator.joker_table, pseudoseed('curated_pack'))
            if temp then
                self.config.curated.mod_name = temp.DisplayName
            end
        end
    end,
    create_card = function(self, card, i)
        local tempset = "cura_curated_pack_pool_" .. self.config.curated.mod_name
        local newCard = SMODS.create_card { set = tempset, area = G.pack_cards }
        return newCard
    end,
    weight = 0.70,
    kind = 'Curated',
}

SMODS.Booster {
    key = 'curated_mega',
    name = 'Curated Pack',
    atlas = "curated-1st",
    diiscovered = true,
    pos = { x = 2, y = 0 },
    cost = 16,
    config = { extra = 7, choose = 2, curated = { mod_name = "RandomMod", } },
    group_key = 'k_curated_pack',
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.choose, self.config.extra, self.config.curated.mod_name } }
    end,
    set_ability = function(self, card, initial, delay_sprites)
        if Curator.joker_table then
            local temp = pseudorandom_element(Curator.joker_table, pseudoseed('curated_pack'))
            if temp then
                self.config.curated.mod_name = temp.DisplayName
            end
        end
    end,
    create_card = function(self, card, i)
        local tempset = "cura_curated_pack_pool_" .. self.config.curated.mod_name
        local newCard = SMODS.create_card { set = tempset, area = G.pack_cards }
        return newCard
    end,
    weight = 0.50,
    kind = 'Curated',
}

---Selector Pack (All UI related code for the Selectro Pack is in curator.lua)

SMODS.Booster {
    key = 'curated_selector',
    name = 'Curated Pack',
    atlas = "curated-2nd",
    diiscovered = true,
    pos = { x = 0, y = 0 },
    cost = 16,
    config = { extra = 6, choose = 2, curated = { mod_name = "RandomMod", } },
    group_key = 'k_curated_selector',
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.choose, self.config.extra, Curator.mod_ID_enter.chosen or "None"} }
    end,
    create_card = function(self, card, i)
        local tempset = ("cura_curated_pack_pool_" .. Curator.mod_ID_enter.chosen) or "Joker"
        local newCard = SMODS.create_card { set = tempset, area = G.pack_cards }
        return newCard
    end,
    weight = 0.35,
    kind = 'Curated_Selector',
}
