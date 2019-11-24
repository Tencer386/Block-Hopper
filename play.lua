play = {
    platform = {
        -- platform properties
        width = love.graphics.getWidth(),
        hight = love.graphics.getHeight(),
        x = 0,
        y = love.graphics.getHeight() / 1.5,
        -- Platform Image
        platformImg = love.graphics.newImage("Ground.png")
    },
    clouds = {
        cloud1 = love.graphics.newImage("cloud1.png"),
        cloud2 = love.graphics.newImage("cloud2.png"),
        cloud3 = love.graphics.newImage("cloud3.png")
    },
    player = {
        -- player properties
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 1.5,
        speed = 250,
        sizeX = 29,
        sizeY = 44,
        bufferX = 21,
        bufferY = 2,
        collision = true,
        -- physics behaviour
        ground = love.graphics.getHeight() / 1.5,
        yVelocity = 0,
        jumpHight = -400,
        gravity = -600,
        jumped = 0,
        -- player images, image options
        idle = love.graphics.newImage("idle.png"),
        run = love.graphics.newImage("run.png"),
        runF = love.graphics.newImage("runF.png"),
        crouch = love.graphics.newImage("crouch.png"),
        jump = love.graphics.newImage("jump.png"),
        fall = love.graphics.newImage("fall.png"),
        -- player image, currently displayed image
        currentImg = love.graphics.newImage("idle.png")
    },
    playMusic = love.audio.newSource("play.wav", "stream"),
    enterTone = love.audio.newSource("tone2.wav", "static"),
    difficulty = 2,
    started = 0,
    sound = true,
    debug = true
}

createBlocks = require("blocks")
createTimer = require("timer")

function play:toggle_sound()
    self.sound = not self.sound
    if self.sound == false then
        menu.sound = false
    else
        menu.sound = true
    end
    love.audio.stop()
    return self.sound 
  end

function play:entered()
    self.player.x = love.graphics.getWidth() / 2
    self.player.y = love.graphics.getHeight() / 1.5

    if self.started == 1 then
        resetBlocks()
        resetTimer()
    end

    if game.debug == false then
        play.debug = false
        blockP.debug = false
        timer.debug = false
    else
        play.debug = true
        blockP.debug = true
        timer.debug = true
    end

    if self.sound == true then
        self.playMusic:setVolume(1)
        menu.playMusicVolume = 1
        love.audio.play(self.playMusic)
    end

    -- sets spawnrate depending on difficulty setting
    if play.difficulty == 1 then
        blockP.spawntime = 4
    elseif play.difficulty == 2 then
        blockP.spawntime = 2
    elseif play.difficulty == 3 then
        blockP.spawntime = 1
    end
end

function play:changeDifficulty()
    self.difficulty = self.difficulty + 1
    if self.difficulty > 3 then
        self.difficulty = 1
    end
    return self.difficulty
end

function play:load()

end

function play:update(dt)
    -- moves player left and right
    if love.keyboard.isDown("d", "right") then
        self.player.currentImg = self.player.run
        if self.player.x < love.graphics.getWidth() - self.player.idle:getWidth() then
            self.player.x = self.player.x + self.player.speed * dt
        end
    elseif love.keyboard.isDown("a", "left") then
        self.player.currentImg = self.player.runF
        if self.player.x > 0 then
            self.player.x = self.player.x - self.player.speed * dt
        end
    else
        self.player.currentImg = self.player.idle
    end

    -- player jumps with space and w
    if love.keyboard.isDown("space", "w", "up") then
        self.player.bufferX = 35
        self.player.bufferY = 11
        if self.player.yVelocity == 0 or self.player.yVelocity < 200 and self.player.yVelocity > -100 then
            if self.player.jumped <= 1 then
                self.player.yVelocity = self.player.jumpHight
                self.player.jumped = self.player.jumped + 1
            end
        end
        if self.player.yVelocity < 0 then
            self.player.currentImg = self.player.jump
        end
    end

    -- player crouches with left control and s
    if love.keyboard.isDown("lctrl", "s", "down") then
        self.player.currentImg = self.player.crouch
        --self.player.size = 16
    else
        --self.player.currentImg = self.player.idle
        self.player.size = 32
    end

    -- exits to menu
    function play:keypressed(key)
        if key == "escape" then
            self.started = 1
            if self.sound == true then
                love.audio.play(self.enterTone)
            end
            menu.playMusicVolume = 1
            game:change_state("menu")
        end
    end

    -- player fall physics
    if self.player.yVelocity ~= 0 then
        if self.player.yVelocity > 0 then
            self.player.currentImg = self.player.fall
        end
        self.player.y = self.player.y + self.player.yVelocity * dt
        self.player.yVelocity = self.player.yVelocity - self.player.gravity * dt
    end

    -- player collieds with ground level
    if self.player.y > self.player.ground then
        self.player.bufferX = 21
        self.player.bufferY = 2
        self.player.yVelocity = 0
        self.player.y = self.player.ground
        self.player.jumped = 0
    end

    -- increment timer
    createTimer()
    timer.inc()

    -- creates blocks
    createBlocks()
    blocks.new()

    -- moves blocks
    moveBlocks()

    -- removes blocks
    removeBlocks()

    -- collision detection between player and blocks
    if self.player.collision == true then
        for k = 1, #blocks, 1 do
            block = blocks[k]
            if
                ((self.player.x + self.player.bufferX) + self.player.sizeX > block.x and (self.player.y - self.player.bufferY) > block.y - block.sizeY) and
                    self.player.x + self.player.bufferX < block.x + block.sizeX
             then
                self.started = 1
                game.states.scoreboard:add_score(timer.total)
                game:change_state("scoreboard")
            end
        end
    end

    -- increased block speed every 30 sec
    if timer.total == blockP.speedincreasenext then
        blockP.speedincreasenext = blockP.speedincreasenext + blockP.speedinc
        blockP.easySpeedIncrease = blockP.easySpeedIncrease + 10
        blockP.medSpeedIncrease = blockP.medSpeedIncrease + 30
        blockP.hardSpeedIncrease = blockP.hardSpeedIncrease + 60

        if timer.total == 60 then
            if play.difficulty == 1 then
                blockP.spawntime = 2
            elseif play.difficulty == 2 then
                blockP.spawntime = 1
            elseif play.difficulty == 3 then
                blockP.spawntime = 0
            end
        end
    end
    if timer.total == 1 then
        love.audio.stop(menu.assets.menuMusic)
    end

    if love.audio.getActiveSourceCount() == 0 then
        if self.sound == true then
            love.audio.play(self.playMusic)
        end
    end
end

function play:draw()
    -- draws clouds
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.clouds.cloud1, 200, 80, 0, 0.5, 0.5, 0)
    love.graphics.draw(self.clouds.cloud2, 600, 150, 0, 0.8, 0.8, 0)
    love.graphics.draw(self.clouds.cloud3, 950, 100, 0, 0.5, 0.5, 0)

    -- colour white
    love.graphics.setColor(1, 1, 1)

    -- the platform will be drawn from the 'ground' asset
    love.graphics.draw(self.platform.platformImg, self.platform.x, self.platform.y)

    -- draws player with selected image
    love.graphics.draw(self.player.currentImg, self.player.x, self.player.y, 0, 1.5, 1.5, 0, self.player.size)
    --drawPlayer(self.player.x, self.player.y)

    -- draws blocks and timer
    drawBlock()
    drawTimer()

    -- debug draw
    love.graphics.setFont(timer.timerFont)
    love.graphics.setColor(0, 0, 0)
    if play.debug == true then
        love.graphics.print(
            self.player.yVelocity,
            10,
            love.graphics.getHeight() - (love.graphics.getHeight() - 100),
            0,
            1
        )
    end
end

return play
