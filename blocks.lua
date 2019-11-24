blocks = {

}
blockP = {
    maxBlocks = 10,
    currentBlocks = 0,

    dumpped = 0,
    lastBlockSpawn = -2,

    spawntime = 0,
    speedinc = 10,
    speedincreasenext = 20,
    speedincreasestart = 10,

    easySpeedIncrease = 10,
    medSpeedIncrease = 30,
    hardSpeedIncrease = 60,

    debug = true
}

function resetBlocks()
    blocks = { }
    blockP.lastBlockSpawn = -2
    blockP.currentBlocks = 0
end

function createBlock()


    function blocks:new(dt)
        -- creates a block if maxBlocks isnt reached
        while blockP.currentBlocks < blockP.maxBlocks and blockP.lastBlockSpawn + blockP.spawntime <= timer.total do
            local block = {
                sizeX = love.math.random(40, 100),
                sizeY = love.math.random(40, 140),
                speed = love.math.random(200, 300),
                x = love.graphics.getWidth() + 100,
                y = love.graphics.getHeight() / 1.5
            }
            blockP.currentBlocks = blockP.currentBlocks + 1
            table.insert(blocks,blockP.currentBlocks, block)
            blockP.lastBlockSpawn = timer.total

                -- increased block speed every 30 sec
            if timer.total > blockP.speedincreasestart then
                if play.difficulty == 1 then
                    block.speed = block.speed + blockP.easySpeedIncrease
                elseif play.difficulty == 2 then
                    block.speed = block.speed + blockP.medSpeedIncrease
                elseif play.difficulty == 3 then
                    block.speed = block.speed + blockP.hardSpeedIncrease
            end
        end

            -- Debug code to see the new table
            if blockP.debug then
                local inspect = require('inspect')
                print("----------------------------------------------------")
                print(inspect(blocks))
                print(inspect(blockP))
            end
        end
    end
end

function drawBlock()
    love.graphics.setColor(129 / 255, 139 / 255, 149 / 255)

    -- draws each block created
    for k = 1, #blocks, 1 do
        block = blocks[k]  
        love.graphics.rectangle('fill', block.x, block.y - block.sizeY, block.sizeX, block.sizeY)
    end
end

function moveBlocks()

    dt = love.timer.getDelta()

    --moves each block on screen
    for k, block in ipairs(blocks) do
        block.x = block.x - block.speed * dt
    end
end


function removeBlocks()
    -- removes each block after they are off screenm
    for k, block in ipairs(blocks) do
        if block.x < 0 - block.sizeX then
            table.remove(blocks, k)
            blockP.currentBlocks = blockP.currentBlocks - 1

            blockP.dumpped = 0
        end
    end
end

return createBlock