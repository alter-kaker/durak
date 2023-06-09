local Button = {}

function Button:new(font, x, y)
    local o = {
        x = x,
        y = y,
        font = font
    }
    setmetatable(o, self)
    self.__index = self

    return o
end

function Button:draw(text)
    local text_obj = love.graphics.newText(self.font, text)
    local width, height = text_obj:getDimensions()
    local box_offset = 4
    love.graphics.setColor(.8, .6, .5)
    love.graphics.rectangle(
        "fill",
        self.x - box_offset,
        self.y - box_offset,
        width + (2 * box_offset),
        height + (2 * box_offset)
    )

    love.graphics.setColor(0, 0, 0)
    love.graphics.draw(
        text_obj,
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
