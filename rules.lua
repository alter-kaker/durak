local moves = require('moves')

return {
    [moves.ATTACKING] = function(card, stacks, kozyr)
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
    end,

    [moves.DEFENDING] = function(card, stacks, kozyr)
        local attack_card = stacks[#stacks][1]
        return (card.suit == kozyr and attack_card.suit ~= kozyr)
            or (card.suit == attack_card.suit and card.rank > attack_card.rank)
    end
}
