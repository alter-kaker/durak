local Players = {}

function Players:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    return o
end

function Players:init(names)
    for i, name in ipairs(names) do
        self[i] = { name = name, hand = {} }
    end
    self.current = 1
end

function Players:next()
    self.current = self.current + 1
    if self.current > #self then
        self.current = 1
    end
end

function Players:get_current_idx()
    return self.current
end

function Players:get_current_player()
    return self[self.current]
end

function Players:push_card(card, player_idx)
    local player_idx = player_idx or self.current
    table.insert(self[player_idx].hand, card)
end

function Players:position_cards(player_idx)
    for card_idx, card in ipairs(self[player_idx].hand) do
        card:set_position((card_idx * 60) + 10, ((player_idx - 1) * 110) + 30)
    end
end

function Players:refill(deck)
    for player_idx, player in ipairs(self) do
        while #player.hand < 7 and #deck > 0 do
            local card = deck:pop()
            self:push_card(card, player_idx)
        end
        self:position_cards(player_idx)
    end
end

return Players
