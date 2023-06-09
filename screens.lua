local moves = require('moves')
local player_types = require('player_types')
local textbox = require('textbox')
local font = love.graphics.newFont("Px437_IBM_CGA.ttf")

local screens = {}
screens.START = function(game)
    textbox.draw("Your Name: ", game.players[1].name, font, 100, 100)
    game.button:draw("start")
end
screens.PLAY = function(game)
    for player_idx = 1, #game.players do
        local player = game.players[player_idx]
        love.graphics.setColor(1, 1, 1)
        local name_scale = 1
        if player_idx == game.players:get_current_idx() then
            name_scale = 1.5
        end
        love.graphics.print(player.name, 5, ((player_idx - 1) * 110) + 10, 0, name_scale)
        for _, card in ipairs(player.hand) do
            if player.type == player_types.HUMAN then
                card:draw()
            else
                card:draw_back()
            end
            if player_idx == game.players:get_current_idx() and card:touched() then
                card:highlight()
            end
        end
    end

    for _, stack in ipairs(game.mat.in_play) do
        for _, card in ipairs(stack) do
            card:draw()
        end
    end

    for _, card in ipairs(game.mat.discard_pile) do
        card:draw_back()
    end

    game.deck:draw()

    local button_text
    if game.move == moves.ATTACKING and #game.mat.in_play > 0 then
        button_text = "Discard"
    elseif game.move == moves.DEFENDING then
        button_text = "Take"
    end
    if button_text then
        game.button:draw(button_text)
    end
end
screens.END = function(game)
    love.graphics.print(game.winner.name .. " has won!", 100, 100, 0, 5)
end

return screens
