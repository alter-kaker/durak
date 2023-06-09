return {
    draw = function(text, font)
        local text_obj = love.graphics.newText(font, text..' ')
        local height = text_obj:getHeight()
        local box_offset = 4
        love.graphics.setColor(.3, .3, .3)
        love.graphics.rectangle(
            "fill",
            0,
            love.graphics.getHeight() - height - (2 * box_offset),
            love.graphics.getWidth(),
            height + (2 * box_offset)
        )
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(text_obj, box_offset, love.graphics.getHeight() - height - box_offset)
    end
}
