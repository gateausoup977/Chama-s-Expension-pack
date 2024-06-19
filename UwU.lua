--- STEAMODDED HEADER
--- MOD_NAME:  Chama's Expension Pack
--- MOD_ID: CEP
--- MOD_AUTHOR: [Chamalloww]
--- MOD_DESCRIPTION: add 3 deck and that's it for the moment
--- BADGE_COLOUR: FF33B1

----------------------------------------------
------------MOD CODE ------------------------- 

-- Configs

local joker_config = {

}

local tarot_config = {

}

local spectral_config = {

}

local deck_config = {
    bighand = true,
    infinitejoker = true,
    hinfinitejoker = true
}
-------- Helper functions

-- Jocker
local function init_joker(joker, no_sprite)
    no_sprite = no_sprite or false

    local new_joker = SMODS.Joker:new(
        joker.ability_name,
        joker.slug,
        joker.ability,
        { x = 0, y = 0 },
        joker.loc,
        joker.rarity,
        joker.cost,
        joker.unlocked,
        joker.discovered,
        joker.blueprint_compat,
        joker.eternal_compat,
        joker.effect,
        joker.atlas,
        joker.soul_pos
    )
    new_joker:register()

    if not no_sprite then
        local sprite = SMODS.Sprite:new(
            new_joker.slug,
            SMODS.findModByID("CEP").path,
            new_joker.slug .. ".png",
            71,
            95,
            "asset_atli"
        )
        sprite:register()
    end
end

-- tarot
local function init_tarot(tarot, no_sprite)
    no_sprite = no_sprite or false

    local new_tarot = SMODS.Tarot:new(
        tarot.name,
        tarot.slug,
        tarot.config,
        { x = 0, y = 0 },
        tarot.loc,
        tarot.cost,
        tarot.cost_mult,
        tarot.effect,
        tarot.consumeable,
        tarot.discovered,
        tarot.atlas
    )
    new_tarot:register()

    if not no_sprite then
        local sprite = SMODS.Sprite:new(
            new_tarot.slug,
            SMODS.findModByID("CEP").path,
            new_tarot.slug .. ".png",
            71,
            95,
            "asset_atli"
        )
        sprite:register()
    end
end

-- spectral
local function init_spectral(spectral, no_sprite)
    no_sprite = no_sprite or false

    local new_spectral = SMODS.Spectral:new(
        spectral.name,
        spectral.slug,
        spectral.config,
        { x = 0, y = 0 },
        spectral.loc,
        spectral.cost,
        spectral.consumeable,
        spectral.discovered,
        spectral.atlas
    )
    new_spectral:register()

    if not no_sprite then
        local sprite = SMODS.Sprite:new(
            new_spectral.slug,
            SMODS.findModByID("CEP").path,
            new_spectral.slug .. ".png",
            71,
            95,
            "asset_atli"
        )
        sprite:register()
    end
end

-- deck
local function init_deck(deck, no_sprite)
    no_sprite = no_sprite or false

    local new_deck = SMODS.Deck:new(
        deck.name,
        deck.slug,
        deck.config,
        { x = 0, y = 0 },
        deck.loc
    )
    new_deck:register()

    if not no_sprite then
        local sprite = SMODS.Sprite:new(
            new_deck.slug,
            SMODS.findModByID("CEP").path,
            new_deck.slug .. ".png",
            71,
            95,
            "asset_atli"
        )
        sprite:register()
    end
end

-- variable for deck config

-- bighand
local CDhandsndiscards = 1
local CDhandsize = 7


-- InfiniteJoker
local IJantescaling = 1

-- functions for decks

-- Initialize deck effect
local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
    Backapply_to_runRef(arg_56_0)

    if arg_56_0.effect.config.CEP_infinitejoker then
        G.E_MANAGER:add_event(Event({
            func = function()
                -- Set joker slots to 2
                G.jokers.config.card_limit = 2

                -- set joker count to 0
                IJantescaling = 1

                -- Add effect to starting params
                G.GAME.starting_params.CEP_infinitejoker = true

                return true
            end
        }))
    end

    if arg_56_0.effect.config.CEP_hinfinitejoker then
        G.E_MANAGER:add_event(Event({
            func = function()
                -- Set joker slots to 2
                G.jokers.config.card_limit = 2

                -- set joker count to 0
                IJantescaling = 1

                -- Add effect to starting params
                G.GAME.starting_params.CEP_hinfinitejoker = true

                return true
            end
        }))
    end
end

-- fuction incrementing joker limit when adding a new joker

local add_to_deckref = Card.add_to_deck
function Card:add_to_deck(from_debuff)
    if not self.added_to_deck then
        if (G.GAME.starting_params.CEP_infinitejoker or G.GAME.starting_params.CEP_hinfinitejoker) and self.ability.set == "Joker" then
            -- set jocker slot at current jocker + 2
            G.jokers.config.card_limit = #G.jokers.cards + 2
        end
    add_to_deckref(self, from_debuff)
    end
end

-- scaling functions

function IJnewantescaling() 
    if #G.jokers.cards > 5 then -- log scale when jokers > 5

        IJantescaling = math.log(#G.jokers.cards,2) - math.log(5,2) + 1

        if #G.jokers.cards > 50 then -- log scale when jokers > 50 (brutal)

            IJantescaling = IJantescaling * ( math.log(#G.jokers.cards - 49 , 2))

        end
    else 

        IJantescaling = 1

    end
end

function HIJnewantescaling()
    if #G.jokers.cards > 5 then -- sqrt scale when jokers > 5

        IJantescaling = math.sqrt(#G.jokers.cards) - math.sqrt(5) + 1

        if #G.jokers.cards > 50 then -- sqrt scale when jokers > 50 (brutal)

            IJantescaling = IJantescaling * ( math.sqrt(#G.jokers.cards - 50 ))

        end
    else

        IJantescaling = 1

    end
end

-- overiding some functions for the diferent jokers

-- function set_blind for the infinite joker

local original_set_blind = Blind.set_blind

function Blind:set_blind(blind, reset, silent)
    original_set_blind(self, blind, reset, silent)
    if G.GAME.starting_params.CEP_infinitejoker or G.GAME.starting_params.CEP_hinfinitejoker then
        if G.GAME.starting_params.CEP_infinitejoker then
            IJnewantescaling()
        elseif G.GAME.starting_params.CEP_hinfinitejoker then
            HIJnewantescaling()
        end
        self.chips = get_blind_amount(G.GAME.round_resets.ante)*self.mult*G.GAME.starting_params.ante_scaling*IJantescaling
        self.chip_text = number_format(self.chips)
    end
end

-- create deck

local decks = {

    bighand = {
        name = "Big Hands",
        slug = "bighand",
        config = {
            ante_scaling = 1.5,
            discards = CDhandsndiscards,
            hands = CDhandsndiscards,
            hand_size = CDhandsize,

            atlas = "b_bighand",

            bighand = deck_config["bighand"]
        },
        loc = {
            name = "Big Hands",
            text = {
                "+" .. CDhandsndiscards .. " {C:blue}hands{}, {C:red}discards{}",
                "+" .. CDhandsize .. " {C:attention}hand size{}.",
                " ",
                "Ante scales {C:attention}X1.5{} as fast"
            }
        }
    },

    InfiniteJoker = {
        name = "Infinite Jokers",
        slug = "infinitejoker",
        config = {
            dollars = 10,

            CEP_infinitejoker = true,

            atlas = "b_infinitejoker",

            infinitejoker = deck_config["infinitejoker"]
        },
        loc = {
            name = "Infinite Jokers",
            text = {
                "You can have {C:purple}infinite{} jokers",
                "You start with {C:money}$14{}",
                "Ante scales {C:attention}fast{} after 5 jokers"
            }
        }
    },

    harderInfiniteJoker = {
        name = "Harder Infinite Jokers",
        slug = "hinfinitejoker",
        config = {
            dollars = 10,

            CEP_hinfinitejoker = true,

            atlas = "b_hinfinitejoker",

            hinfinitejoker = deck_config["infinitejoker"]
        },
        loc = {
            name = "Harder Infinite Jokers",
            text = {
                "You can have {C:purple}infinite{} jokers",
                "You start with {C:money}$14{}",
                "Ante scales {C:attention}faster{} after 5 jokers"
            }
        }
    }

}

-- initialize every things

function SMODS.INIT.CEP()

    -- Initialize Decks
    for deck in decks do
        init_deck(deck)
    end
end