local rules = {}

rules.valid_attack = function(card, stacks, kozyr)
    if #stacks == 0 then
        return true
    else
        local ranks = {}
        for i = 1, #stacks do
            for j = 1, #stacks[i] do
                local rank = stacks[i][j].rank
                ranks[rank] = true
            end
        end

        return ranks[card.rank]
    end
end

rules.valid_defense = function(card, stacks, kozyr)
    local attack_card = stacks[#stacks][1]
    return (card.suit == kozyr and attack_card.suit ~= kozyr)
        or (card.suit == attack_card.suit and card.rank > attack_card.rank)
end

rules.lower_value = function(card1, card2, kozyr)
    if (card1.suit == kozyr) == (card2.suit == kozyr) then
        if card1.rank > card2.rank then
            return card2
        else
            return card1
        end
    elseif card1.suit == kozyr then
        return card2
    else
        return card1
    end
end

rules.lowest_value = function(cards, kozyr)
    local lowest_card = cards[1]
    for i = 2, #cards do
        lowest_card = rules.lower_value(lowest_card, cards[i], kozyr)
    end
    return lowest_card
end

return rules
