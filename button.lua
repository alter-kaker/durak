local Button = {}

function Button:new(x, y)
    local o = { x = x, y = y }
    setmetatable(o, self)
    self.__index = self

    return o
end

function Button:draw(text)
    love.graphics.setColor(.8, .6, .5)
    love.graphics.rectangle(
        "fill",
        self.x,
        self.y,
        150,
        30
    )

    love.graphics.setColor(0, 0, 0)
    love.graphics.print(
        text,
        self.x,
        self.y
    )
end

function Button:touched()
    local x, y = self.x, self.y
    local mouse_x, mouse_y = love.mouse.getPosition()
    return mouse_x > x and mouse_x < x + 150
        and mouse_y > y and mouse_y < y + 30
end

return Button
