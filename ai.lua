local rules = require("rules")
local moves = require("moves")

local lower_value = function(card1, card2, kozyr)
    if (card1.card.suit == kozyr) == (card2.card.suit == kozyr) then
        if card1.card.rank > card2.card.rank then
            return card2
        else
            return card1
        end
    elseif card1.card.suit == kozyr then
        return card2
    else
        return card1
    end
end

local lowest_value = function(cards, kozyr)
    local lowest_card = cards[1]
    for i = 2, #cards do
        print("checking card " .. cards[i].card:name())
        lowest_card = lower_value(lowest_card, cards[i], kozyr)
    end
    return lowest_card
end

return function(hand, stacks, kozyr, move)
    local cards = {}
    for i = 1, #hand do
        local card = hand[i]
        if rules[move](card, stacks) then
            table.insert(cards, { idx = i, card = card })
        end
    end

    -- simple strategy, pick lowest value valid card
    local lowest = lowest_value(cards, kozyr)
    if lowest then return lowest.idx else return nil end
end
