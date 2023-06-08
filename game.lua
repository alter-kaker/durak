local utf8 = require("utf8")

local Game = {
    images = {},
    players = {},
    elapsed = 0,
    deck = {},
    trump_suit = "",
    mat = {},
    move = nil,
    winner = nil
}
local Players = require("players")
local Deck = require("deck")
local Mat = require("mat")
local Button = require("button")

local rules = require("rules")
local ai = require("ai")

local moves = require('moves')
local player_types = require('player_types')
local screens = require('draw')
local plays = require('plays')


local players = {
    {
        name = "",
        type = player_types.HUMAN
    },
    {
        name = "Robet",
        type = player_types.AI
    }
}

function Game:new(players)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.players = Players:new()
    o.elapsed = 0

    o.mat = Mat:new()

    o.move = moves.ATTACKING
    o.screen = screens.START

    return o
end

function Game:load()
    self.players:init(players)
    local decks = #self.players / 2
    self.deck   = Deck:new(decks)
    self.button = Button:new(10, 300)
end

function Game:start()
    self.deck:shuffle()
    self.trump_suit = self.deck[1].suit
    self.players:refill(self.deck)

    local starting_player_idx = self:starting_player()
    if starting_player_idx then
        self.players.current = starting_player_idx
    end
end

function Game:starting_player()
    local lowest_trump
    local starting_player_idx
    for player_idx = 1, #self.players do
        for _, card in ipairs(self.players[player_idx].hand) do
            if card.suit == self.trump_suit then
                if not lowest_trump or card.rank < lowest_trump then
                    lowest_trump = card.rank
                    if lowest_trump == 6 then
                        return player_idx
                    end
                    starting_player_idx = player_idx
                end
            end
        end
    end

    return starting_player_idx
end

function Game:end_game(game)
    for _, player in self.players do
        if #player.hand == 0 then
            self.winner = player
            self.screen = screens.END
            return true
        end
    end

    return false
end

function Game:draw()
    self.screen(self)
end

function Game:update(dt)
    self.elapsed = self.elapsed + dt
    if #self.deck == 0 then
        for _, player in ipairs(self.players) do
            if #player.hand == 0 then
                self.screen = screens.END
                self.winner = player
            end
        end
    elseif self.players:get_current_player().type == player_types.AI then
        local hand = self.players:get_current_player().hand
        local card_idx = ai(
            hand,
            self.mat.in_play,
            self.trump_suit,
            self.move
        )

        if card_idx then
            plays.play(table.remove(hand, card_idx), self)
        else
            plays.withdraw(self)
        end
    end
end

function Game:click()
    if self.screen == screens.START and self.button:touched() then
        self.screen = screens.PLAY
    elseif self.players:get_current_player().type == player_types.HUMAN then
        if self.button:touched() then
            plays.withdraw(self)
        else
            local active_hand = self.players:get_current_player().hand
            for card_idx, card in ipairs(active_hand) do
                if card:touched() and rules[self.move](card, self.mat.in_play, self.trump_suit) then
                    plays.play(table.remove(active_hand, card_idx), self)
                end
            end
        end
    end
end

function Game:input(text)
    if self.screen == screens.START then
        self.players[1].name = self.players[1].name .. text
    end
end

function Game:keypressed(key)
    if self.screen == screens.START then
        if key == "backspace" then
            self.players[1].name = string.sub(self.players[1].name, 0, utf8.len(self.players[1].name) - 1)
        end
    end
end

return Game
