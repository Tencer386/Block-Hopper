play = {
    platform = {
        -- platform properties
        width = love.graphics.getWidth(),
        hight = love.graphics.getHeight(),
        x = 0,
        y = love.graphics.getHeight() / 1.5 
    },

    block = {},
    player = {
        -- player properties
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 1.5,
        speed = 400,
        size = 32,

        -- physics behaviour
        ground = love.graphics.getHeight() / 1.5,
        yVelocity = 0,
        jumpHight = -300,
        gravity = -500,

        -- player images, image options
        img = love.graphics.newImage('purple.png'),
        imgCrouch = love.graphics.newImage('purpleCrouch.png'),
        -- player image, currently displayed image
        currentImg = love.graphics.newImage('purple.png')
    }
}

function play:entered()

    self.block = {}

end

function play:load()

end

function play:update(dt)

    -- print('test')
    -- moves player left and right
    if love.keyboard.isDown('d', 'right') then
        if self.player.x < love.graphics.getWidth() - self.player.img:getWidth() then
            self.player.x = self.player.x + self.player.speed * dt
        end
    elseif love.keyboard.isDown('a', 'left') then
        if self.player.x > 0 then
            self.player.x = self.player.x - self.player.speed * dt
        end
    end

    -- player jumps with space and w
    if love.keyboard.isDown('space', 'w', 'up') then
        if self.player.yVelocity == 0 then
            self.player.yVelocity = self.player.jumpHight
        end
    end

    -- player crouches with left control and s
    if love.keyboard.isDown('lctrl', 's', 'down') then
        self.player.currentImg = self.player.imgCrouch
        self.player.size = 16
    else
        self.player.currentImg = self.player.img
        self.player.size = 32
    end

    -- player fall physics
    if self.player.yVelocity ~= 0 then
        self.player.y = self.player.y + self.player.yVelocity * dt
        self.player.yVelocity = self.player.yVelocity - self.player.gravity * dt
    end

    -- player collieds with ground level
    if self.player.y > self.player.ground then
        self.player.yVelocity = 0
        self.player.y = self.player.ground
    end

    -- create blocks
    numberOfBlocks = 3
    while #self.block < numberOfBlocks do
        local blocks = {
            sizex = love.math.random(40, 100),
            sizey = love.math.random(40, 290),
            speed = love.math.random(100 - 300),
            x = love.graphics.getWidth() - 300,
            y = love.graphics.getHeight() / 1.5
        }
 --       numberOfBlocks = numberOfBlocks + 1
        table.insert(self.block, blocks)

        print('adding blocks')

        --TO DO SOUNDS
    end

    -- block movement
    -- for k, block in pairs(self.block) do
    for k, block in pairs(self.block) do
        self.block.x = self.block.x + self.block.speed * dt
        --print ('move')
    end


end

function play:draw()
    love.graphics.setColor(1, 1, 1)             -- sets the colour to white

    -- the platform will be drawn as a white rectangele while taking in the variables declaired above
    love.graphics.rectangle('fill', self.platform.x, self.platform.y, self.platform.width, self.platform.hight)

    -- draws player with selected image
    love.graphics.draw(self.player.currentImg, self.player.x, self.player.y, 0, 1, 1, 0, self.player.size)

    -- draws block
    love.graphics.setColor(255 / 255, 0 / 255, 0 / 255)
    for k, blocks in pairs(self.block) do
        love.graphics.rectangle('fill', self.block.x, self.block.y - self.block.sizey, self.block.sizex, self.block.sizey)
        --print('drawing')
    end
end

return play