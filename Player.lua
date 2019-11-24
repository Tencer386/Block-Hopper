function createPlayer()
    sp = require("anim8.lua")
    Sheet = love.graphics.newImage('adventurer.png')

    local grid = sp.newGrid(50, 37, Sheet:getWidth(), Sheet:getHeight())
    playerAnim = sp.newAnimation(grid(2,'2-7'), 0.1)
end

function updateAnim(dt)
    playerAnim:update(dt)
end

function drawPlayer(x, y)
    playerAnim:draw(sheet, x, y)
end