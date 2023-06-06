local Game = require("game")
local game = Game:new()
function love.load()
    game:load({"marc", "mir"})
    game:start()
end

function love.draw()
    game:draw()
end

function love.update(dt)
    game:update(dt)
end

function love.mousereleased()
    game:click()
end