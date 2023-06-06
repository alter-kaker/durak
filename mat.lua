local Mat = {}

function Mat:new(players)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.in_play = {}
    o.discard_pile = {}

    return o
end

function Mat:push_attack(card)
    local x, _ = love.graphics.getDimensions()
    table.insert(self.in_play, { card, })
    card:set_position((x - (#self.in_play) * 60) - 10, 30)
end

function Mat:push_defend(card)
    local x, _ = love.graphics.getDimensions()
    table.insert(self.in_play[#self.in_play], card)
    card:set_position((x - (#self.in_play) * 60) - 10, 50)
end

function Mat:get_current_play()
    return self.in_play[#self.in_play] or {}
end

return Mat
