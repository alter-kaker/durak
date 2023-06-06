local START = "start"
local ATTACKING = "attacking"
local DEFENDING = "defending"
local END = "end"

local Game = {
    images = {},
    players = {},
    elapsed = 0,
    deck = {},
    trump_suit = "",
    mat = {},
    move = START,
    winner = nil
}
local Players = require("players")
local Deck = require("deck")
local Mat = require("mat")

function Game:new(players)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.players = Players:new()
    o.elapsed = 0

    o.mat = Mat:new()

    o.move = START

    return o
end

function Game:load(names)
    self.players:init(names)

    local images = {}

    for nameIndex, name in ipairs({
        6, 7, 8, 9, 10, 11, 12, 13, 14,
        'pip_heart', 'pip_diamond', 'pip_club', 'pip_spade',
        'mini_heart', 'mini_diamond', 'mini_club', 'mini_spade',
        'card', 'card_face_down',
        'face_jack', 'face_queen', 'face_king',
    }) do
        images[name] = love.graphics.newImage('images/' .. name .. '.png')
    end

    local decks = #self.players / 2
    self.deck = Deck:new(decks, images)
    self.trump_suit = self.deck[1].suit
end

function Game:start()
    if self.move == START then
        self.move = ATTACKING
        self.deck:shuffle()
        for player_idx = 1, #self.players do
            local player = self.players[player_idx]
            for _ = 1, 7 do
                local card = self.deck:pop()
                self.players:push_card(card, player_idx)
            end
        end
    end
end

function Game:put_down(card)
    if self.move == ATTACKING then
        local ranks = {}
        for _, card_on_mat in ipairs(self.mat:get_current_play()) do
            print(card_on_mat.rank)
            ranks[card_on_mat.rank] = true
        end

        if #self.mat.in_play == 0 or ranks[card.rank] then
            self.mat:push_attack(card)
            self.move = DEFENDING
            self.players:next()
            return true
        end
    elseif self.move == DEFENDING then
        local attack_card = self.mat:get_current_play()[1]
        if (card.suit == self.trump_suit and
                attack_card.suit ~= self.trump_suit)
            or (card.suit == attack_card.suit
                and card.rank > attack_card.rank) then
            self.mat:push_defend(card)
            self.move = ATTACKING
            self.players:next()
            return true
        end
    end
    return false
end

function Game:give_up(player)
    if self.move == DEFENDING then
        for _, stack in ipairs(self.mat.in_play) do
            for _, card in stack do
                table.insert(player.hand, card)
                self.players.next()
                self.move = ATTACKING
            end
        end
        return true
    elseif self.move == ATTACKING then
        for _, stack in ipairs(self.mat.in_play) do
            for _, card in stack do
                self.players.next()
                table.insert(self.mat.discard_pile, card)
            end
        end
        return true
    end

    return false
end

function Game:end_game(game)
    for _, player in self.players do
        if #player.hand == 0 then
            self.winner = player
            self.move = END
            return true
        end
    end

    return false
end

function Game:draw()
    for player_idx = 1, #self.players do
        local player = self.players[player_idx]
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(player.name, 5, ((player_idx - 1) * 110) + 10)
        for card_idx, card in ipairs(player.hand) do
            card:draw()
            if player_idx == self.players:get_current_idx() and card:touched() then
                card:highlight()
            end
        end
    end

    for _, stack in ipairs(self.mat.in_play) do
        for _, card in ipairs(stack) do
            card:draw()
        end
    end

    self.deck:draw()
end

function Game:update(dt)
    self.elapsed = self.elapsed + dt
end

function Game:click()
    local active_hand = self.players:get_current_player().hand
    for card_idx, card in ipairs(active_hand) do
        if card:touched() then
            if self:put_down(card) then
                table.remove(active_hand, card_idx)
            end
        end
    end
end

return Game
