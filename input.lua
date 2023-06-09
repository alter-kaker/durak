local screens = require('screens')
local plays = require('plays')
local utf8 = require('utf8')

return {
    ['backspace'] = function(game)
        game.players[1].name = string.sub(game.players[1].name, 0, utf8.len(game.players[1].name) - 1)
    end,
    ['return'] = function(game)
        plays.start_game(game)
    end,
}
