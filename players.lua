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
    card:set_position(((#self[player_idx].hand) * 60) + 10, ((player_idx - 1) * 110) + 30)
    table.insert(self[player_idx].hand, card)

end

return Players
