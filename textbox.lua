return {
    draw = function(label, text, font, x, y)
        local text_obj = love.graphics.newText(font, label .. text)
        local width, height = text_obj:getDimensions()
        local box_offset = 2
        love.graphics.setColor(.3, .3, .3)
        love.graphics.rectangle("fill", x - box_offset, y - box_offset, width + (2 * box_offset),
            height + (2 * box_offset))
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(text_obj, x, y)
    end
}
