local images = {}

for nameIndex, name in ipairs({
    6, 7, 8, 9, 10, 11, 12, 13, 14,
    'pip_heart', 'pip_diamond', 'pip_club', 'pip_spade',
    'mini_heart', 'mini_diamond', 'mini_club', 'mini_spade',
    'card', 'card_face_down',
    'face_jack', 'face_queen', 'face_king',
}) do
    images[name] = love.graphics.newImage('images/' .. name .. '.png')
end

return images
