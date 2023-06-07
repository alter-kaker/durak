local rules = require("rules")
local moves = require("moves")

local ai = {
    moves = {
        [moves.ATTACKING] = function(hand, stacks, kozyr)
            local attacks = {}
            for i = 1, #hand do
                local card = hand[i]
                if rules.valid_attack(card, stacks) then
                    table.insert(attacks, card)
                end
            end

            -- simple strategy, pick lowest value valid card
            return rules.lowest_value(attacks, kozyr)
        end,

        [moves.DEFENDING] = function(hand, stacks, kozyr)
            local defenses = {}
            for i = 1, #hand do
                local card = hand[i]
                if rules.valid_defense(card, stacks, kozyr) then
                    table.insert(defenses, card)
                end
            end

            -- simple strategy, pick lowest value valid card
            return rules.lowest_value(defenses, kozyr)
        end
    }
}

ai.compute_move = function(hand, stacks, kozyr, move)
    return ai.moves[move](hand, stacks, kozyr)
end

return ai
