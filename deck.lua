local images = require('images')
local card_width = 53
local card_height = 73

local Card = {}


function Card:new(suit, rank, images)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.suit = suit
    o.rank = rank
    o.images = images
    o.position = {
        x = 0,
        y = 0,
    }

    return o
end

function Card:name()
    return '\tsuit: ' .. self.suit .. ', rank: ' .. self.rank
end

function Card:draw_back()
    local x, y = self.position.x, self.position.y

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(images.card_face_down, x, y)
end

function Card:draw()
    local x, y = self.position.x, self.position.y

    local x_left = 11
    local x_mid = 21
    local y_top = 7
    local y_third = 19
    local y_qtr = 23
    local y_mid = 31

    local function draw_corner(image, offset_x, offset_y)
        love.graphics.draw(
            image,
            x + offset_x,
            y + offset_y
        )

        love.graphics.draw(
            image,
            x + card_width - offset_x,
            y + card_height - offset_y,
            0,
            -1
        )
    end

    local function draw_pip(offset_x, offset_y, mirror_x, mirror_y)
        local pip_width = 11
        love.graphics.draw(
            self.images.pip,
            x + offset_x,
            y + offset_y
        )

        if mirror_x then
            love.graphics.draw(
                self.images.pip,
                x + card_width - offset_x - pip_width,
                y + offset_y
            )
        end

        if mirror_y then
            love.graphics.draw(
                self.images.pip,
                x + offset_x + pip_width,
                y + card_height - offset_y,
                0,
                -1
            )
        end

        if mirror_x and mirror_y then
            love.graphics.draw(
                self.images.pip,
                x + card_width - offset_x,
                y + card_height - offset_y,
                0,
                -1
            )
        end
    end

    local draw_pips = {
        [6]  = function()
            draw_pip(x_left, y_top, true, true)
        end,
        [7]  = function()
            draw_pip(x_left, y_top, true, true)
            draw_pip(x_left, y_mid, true)
            draw_pip(x_mid, y_third)
        end,
        [8]  = function()
            draw_pip(x_left, y_top, true, true)
            draw_pip(x_left, y_mid, true)
            draw_pip(x_mid, y_third, false, true)
        end,
        [9]  = function()
            draw_pip(x_left, y_top, true, true)
            draw_pip(x_left, y_qtr, true, true)
            draw_pip(x_mid, y_mid)
        end,
        [10] = function()
            draw_pip(x_left, y_top, true, true)
            draw_pip(x_left, y_qtr, true, true)
            draw_pip(x_mid, 16, false, true)
        end,
        [14] = function()
            draw_pip(x_mid, y_mid)
        end,
    }

    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(self.images.card, x, y)

    if self.suit == 'heart' or self.suit == 'diamond' then
        love.graphics.setColor(.89, .06, .39)
    else
        love.graphics.setColor(.2, .2, .2)
    end

    draw_corner(self.images.rank, 3, 4)
    draw_corner(self.images.suit, 3, 14)

    if self.images.face then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.images.face, x + 12, y + 11)
    end

    if self.images.pip then
        draw_pips[self.rank]()
    end
end

function Card:touched()
    local x, y = self.position.x, self.position.y
    local mouse_x, mouse_y = love.mouse.getPosition()
    return mouse_x > x and mouse_x < x + card_width
        and mouse_y > y and mouse_y < y + card_height
end

function Card:highlight()
    love.graphics.setColor(1, .8, .3)
    love.graphics.rectangle('line', self.position.x, self.position.y, card_width, card_height)
end

function Card:set_position(x, y)
    self.position.x = x
    self.position.y = y
end

local Deck = {}

function Deck:new(decks)
    local face_images = {
        [11] = "face_jack",
        [12] = "face_queen",
        [13] = "face_king",
    }

    local n = decks or 1
    local o = {}
    setmetatable(o, self)
    self.__index = self
    for i = 1, n do
        for suitIndex, suit in ipairs({ 'club', 'diamond', 'heart', 'spade' }) do
            for rank = 6, 14 do
                local face_image = face_images[rank]
                local pip
                if rank < 11 or rank == 14 then
                    pip = "pip_" .. suit
                end
                table.insert(o, Card:new(suit, rank, {
                    card = images.card,
                    rank = images[rank],
                    suit = images['mini_' .. suit],
                    face = images[face_image],
                    pip = images[pip]
                }))
            end
        end
    end

    return o
end

function Deck:shuffle()
    for i = 1, #self do
        local r = i + (love.math.random(#self - i))
        self[i], self[r] = self[r], self[i]
    end

    local x, y = love.graphics.getDimensions()
    self[1]:set_position(x - 60, y - 108)
    for i = 2, #self do
        local card = self[i]
        card:set_position(x - 56 - (i * 2), y - 80)
    end
end

function Deck:draw()
    self[1]:draw()
    for i = 2, #self do
        self[i]:draw_back()
    end
end

function Deck:pop()
    return table.remove(self)
end

return Deck
