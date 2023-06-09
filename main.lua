local Game = require("game")
local game = Game:new()
function love.load()
    game:load({ { name = "yeshaya", type = "human" }, { name = "abigail", type = "ai" } })
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

function love.textinput(text)
    game:input(text)
end

function love.keypressed(key)
    game:keypressed(key)
end
