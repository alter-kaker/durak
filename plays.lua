local utf8 = require('utf8')
local moves = require('moves')
local screens = require('screens')

local function validate_player_name(name)
    return utf8.len(name) < 1
end

return {
    play = function(card, game)
        if game.move == moves.ATTACKING then
            game.mat:push_attack(card)
            game.move = moves.DEFENDING

            game.players:next()
        elseif game.move == moves.DEFENDING then
            game.mat:push_defend(card)
            game.move = moves.ATTACKING
            game.players:next()
            return true
        end
    end,
    withdraw = function(game)
        if game.move == moves.DEFENDING then
            for _, stack in ipairs(game.mat.in_play) do
                for _, card in ipairs(stack) do
                    local player_idx = game.players:get_current_idx()
                    game.players:push_card(card, player_idx)
                end
            end
            game.mat.in_play = {}
            game.players:next()
            game.players:refill(game.deck) -- attacker refills first
            game.move = moves.ATTACKING
        elseif game.move == moves.ATTACKING then
            for _, stack in ipairs(game.mat.in_play) do
                for _, card in ipairs(stack) do
                    game.mat:push_discard(card)
                end
            end
            game.mat.in_play = {}
            game.players:refill(game.deck) -- attacker refills first
            game.players:next()
        end
    end,
    start_game = function(game)
        print('validating')
        if validate_player_name(game.players[1].name) then
            game.status_text = "Please enter a valid name"
        else
            game.status_text = ""
            game.screen = screens.PLAY
        end
    end
}
