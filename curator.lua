------------MOD CODE -------------------------

--- Every played card counts in scoring

Curator = {}
Curator_Mod = SMODS.current_mod
Curator_Config = Curator_Mod.config

Curator.initialised = false
Curator.mod_ID_enter = {
	chosen = "None",
	precheck = "None",
	last = "None"
}
Curator.in_collection = function(card)
	if G.your_collection then
		for k, v in pairs(G.your_collection) do
			if card.area == v then
				return true
			end
		end
	end
	return false
end

Curator.normalise = function(input)
	local output = string.gsub(input, "_", "")
	output = string.gsub(output, " ", "")
	output = string.gsub(output, "0", "o")
	output = string.gsub(output, '[%p%c%s]', "")
	output = output:lower()
	return output
end

---Internal blacklist (DO NOT CHANGE THIS!! THESE MODS CAN CRASH THE GAME WHEN ENABLED)
---you can find the external blacklist in the config.lua file. Add blacklisted mods there and not here, so they save to your profile and you don't lose them when the mod updates
Curator.blacklist = {
	"BetmmaJokers",
	---reminder to NOT add mods to blacklist here. They will be cleared when the mod updates.
	---add mods to the blacklist in the config.lua file in Curator's mod folder
}

---mod icon atlas
SMODS.Atlas {
	key = "modicon",
	path = "icon.png",
	px = 34,
	py = 34,
}

---atlases
SMODS.Atlas({ key = 'curated-1st', path = 'curated1.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'curated-2nd', path = 'curated2.png', px = 71, py = 95 })

---sound
SMODS.Sound({ key = "wrong", path = "wrong.mp3", pitch = 1, })
SMODS.Sound({ key = "correct", path = "correct.mp3", pitch = 1, })

---load files

SMODS.load_file("items/Boosters.lua")()

---split string at symbol (thanks Meta, Rock Muncher)
function Curator.string_split(string, symbol)
	local index = string.find(string, symbol)
	local string1 = string.sub(string, 1, index - 1)
	local string2 = string.sub(string, index + 1, -1)
	return string1, string2
end

function Curator.key_to_prefix(joker_key)
	local prefix = nil
	local string1 = nil
	return prefix
end

Curator.debug = true

--- thanks a million bajillion to @frost for all the help on the UI code
--- awesome person that taught me why the answers were right instead of just telling me what the right answer is :fire:

--- function for making UI buttons
function Curator.create_uibox_button(button_key, text, _minw, _minh)
	return {
		n = G.UIT.C,
		config = { minw = _minw, minh = _minh, padding = 0.05, align = 'cm' },
		nodes = {
			{
				n = G.UIT.R,
				config = { minw = _minw, minh = _minh, padding = 0.05, align = "cm" },
				nodes = {
					{
						n = G.UIT.C,
						config = { button = button_key, r = 0.1, emboss = 0.05, minw = _minw, minh = _minh, align = "cm", colour = HEX("3a5055"), hover = true, shadow = true },
						nodes = {
							{ n = G.UIT.T, config = { text = text, colour = HEX("FFFFFF"), scale = 0.4, align = "cm" } }
						}
					}
				}
			},
		}
	}
end

---everything else Ui related

function G.FUNCS.cura_confirm()
	local valid = false
	Curator.mod_ID_enter.precheck = Curator.normalise(Curator.mod_ID_enter.precheck)
	---the text input is really weird with 0s and Os for some reason
	Curator.mod_ID_enter.precheck = string.gsub(Curator.mod_ID_enter.precheck, "O", "o")
	Curator.mod_ID_enter.precheck = string.gsub(Curator.mod_ID_enter.precheck, "0", "o")
	for index, value in pairs(Curator.joker_table) do
		if value.NormalisedName == Curator.mod_ID_enter.precheck then
			valid = true
			G.cura_selector_active = false
			play_sound("cura_correct", 1, 1)
			Curator.mod_ID_enter.chosen = Curator.mod_ID_enter.precheck
			G.FUNCS.exit_overlay_menu()
		end
	end
	if valid == false then
		play_sound("cura_wrong", 1, 1)
	end
end

function G.FUNCS.cura_confirm_previous()
	if Curator.mod_ID_enter.last ~= "None" and Curator.mod_ID_enter.last ~= "" then
		Curator.mod_ID_enter.chosen = Curator.mod_ID_enter.last
		G.cura_selector_active = false
		play_sound("cura_correct", 1, 1)
		G.FUNCS.exit_overlay_menu()
	else
		play_sound("cura_wrong", 1, 1)
	end
end

function G.FUNCS.cura_cancel()
	G.FUNCS.exit_overlay_menu()
end

function Curator.create_uibox_selector(card)
	if Curator.joker_table then
		Curator.mod_ID_enter.last = Curator.mod_ID_enter.chosen
		Curator.mod_ID_enter.chosen = "None"
		Curator.mod_ID_enter.precheck = "None"
		G.cura_selector_active = true
		G.FUNCS.overlay_menu({
			definition = create_UIBox_generic_options({
				no_back = true,
				contents = {
					{
						n = G.UIT.C,
						config = { minw = 1, minh = 0.5, padding = 0.15, align = "cm" },
						nodes = {
							{
								n = G.UIT.R,
								config = { minw = 1, minh = 0.2, padding = 0.15, align = "cm" },
								nodes = {
									{ n = G.UIT.T, config = { text = localize("k_cura_enter_prompt"), colour = HEX("FFFFFF"), scale = 0.8, shadow = true, align = "cm" } }
								}
							},
							{
								n = G.UIT.R,
								config = { minw = 1, minh = 0.2, padding = 0.05, align = "cm" },
								nodes = {
									{ n = G.UIT.T, config = { text = localize("k_cura_excludes"), colour = HEX("FFFFFF"), scale = 0.3, shadow = true, align = "cm" } }
								},
							},
							{
								n = G.UIT.R,
								config = { minw = 1, minh = 1, padding = 0.15, align = "cm" },
								nodes = {
									create_text_input({
										colour = HEX("aaaaaa"),
										hooked_colour = HEX("404040"),
										h = 1,
										w = 10,
										text_scale = 0.5,
										max_length = 50,
										ref_table = Curator.mod_ID_enter,
										ref_value = 'precheck'
									})
								}
							},
							{
								n = G.UIT.R,
								config = { minw = 1, minh = 0.3, padding = 0.05, align = 'cm' },
								nodes = {
									Curator.create_uibox_button('cura_confirm', localize("k_cura_confirm"), 3, 1),
									Curator.create_uibox_button('cura_confirm_previous', localize("k_cura_last_confirm"),
										3, 1),
									Curator.create_uibox_button('cura_cancel', localize("k_cura_cancel"), 3, 1)
								}
							}
						}
					}
				}
			})
		})
		G.OVERLAY_MENU:recalculate()
	end
end

local card_click_ref = Card.click
function Card:click()
	local ret = card_click_ref(self)
	local desel_flag = false
	if self and self.config.center.key == "p_cura_curated_selector" then
		if G.shop_booster and G.shop_booster.highlighted then
			for index, value in ipairs(G.shop_booster.highlighted) do
				if value == self then
					desel_flag = true
				end
			end
		end
		if G.shop_jokers and G.shop_jokers.highlighted then
			for index, value in ipairs(G.shop_jokers.highlighted) do
				if value == self then
					desel_flag = true
				end
			end
		end
		if self.highlighted then
			desel_flag = true
		end

		if desel_flag then
			Curator.create_uibox_selector(self)
		end
	end
	return ret
end

local exit_overlay_ref = G.FUNCS.exit_overlay_menu
function G.FUNCS.exit_overlay_menu()
	local ret = exit_overlay_ref()
	if G.cura_selector_active then
		if G.shop then
			G.shop_jokers:unhighlight_all()
		end
		if G.shop_booster then
			G.shop_booster:unhighlight_all()
		end
		G.cura_selector_active = false
	end
	return ret
end

--- thanks again n' the balatro game

local Game_start_run_ref = Game.start_run
function Game.start_run(self, args)
	if not Curator.initialised then
		Curator.joker_table = {}
		for _, center in ipairs(G.P_CENTER_POOLS.Joker) do
			local blacklisted = false
			if G.P_CENTERS[center.key].rarity == 1 or G.P_CENTERS[center.key].rarity == 2 or G.P_CENTERS[center.key].rarity == 3 or Curator_Config.RarityLimiter == false then
				if center.original_mod then
					if not Curator.joker_table[center.original_mod.id] then
						---Curator.blacklist is the internal blacklist, which is for known incompatible mods, and shouldn't be changed
						for __, value in ipairs(Curator.blacklist) do
							if center.original_mod.id == value then
								blacklisted = true
							end
						end
						---the blacklist in config is the external blacklist, which is for preferences. You can change that one.
						for __, value in ipairs(Curator_Config.blacklist) do
							if center.original_mod.id == value then
								blacklisted = true
							end
						end
						if not blacklisted then
							Curator.joker_table[center.original_mod.id] = {}
						end
					end
					if not blacklisted then
						if not Curator.joker_table[center.original_mod.id].Jokers then
							Curator.joker_table[center.original_mod.id].Jokers = {}
						end
						---saving an additional value which is the name of the mod with punctuation, spaces and capitals removed
						if not Curator.joker_table[center.original_mod.id].NormalisedName then
							Curator.joker_table[center.original_mod.id].NormalisedName = Curator.normalise(center
								.original_mod
								.id)
						end
						if not Curator.joker_table[center.original_mod.id].DisplayName then
							Curator.joker_table[center.original_mod.id].DisplayName = center.original_mod.id
						end
						if not Curator.joker_table[center.original_mod.id].Prefix then
							local value1 = nil
							local value2 = nil
							local value3 = nil
							value1, value2 = Curator.string_split(center.key, "_")
							value3 = Curator.string_split(value2, "_")
							local _prefix = value3
							Curator.joker_table[center.original_mod.id].Prefix = _prefix
						end

						table.insert(Curator.joker_table[center.original_mod.id].Jokers, center.key)
					end
				end
			end
		end
		---yes, this had to be done in an additional for loop, or else the pools would register before every card was placed into them
		for _, value in pairs(Curator.joker_table) do
			if value.Jokers then
				SMODS.ObjectType({
					key = "cura_curated_pack_pool_" .. value.NormalisedName,
					default = "j_splash", ---I like splash way more than jimbo
					cards = {
						["j_splash"] = true
					}
				})
				SMODS.ObjectTypes["cura_curated_pack_pool_" .. value.NormalisedName]:inject()
				for index, value2 in pairs(value.Jokers) do
					SMODS.ObjectTypes["cura_curated_pack_pool_" .. value.NormalisedName]:inject_card(G.P_CENTERS[value2])
				end
			end
		end
		Curator.initialised = true
	end
	Game_start_run_ref(self, args)
end

Curator_Mod.config_tab = function()
	return {
		n = G.UIT.ROOT,
		config = { align = "m", r = 0.1, padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6 },
		nodes = {
			{ n = G.UIT.R, config = { align = "cl", padding = 0, minh = 0.1 }, nodes = {} },
			{
				n = G.UIT.R,
				config = { align = "cl", padding = 0 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cl", padding = 0.05 },
						nodes = {
							create_toggle { col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = Curator_Config, ref_value = "RarityLimiter" },
						}
					},
					{
						n = G.UIT.C,
						config = { align = "c", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = "Exclude Legendaries and Modded Rarities", scale = 0.3, colour = G.C.UI.TEXT_LIGHT } },
						}
					},
				}
			},
		}
	}
end

----------------------------------------------
------------MOD CODE END----------------------
