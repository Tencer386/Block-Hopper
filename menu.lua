menu = 
{
    assets = 
    {
        title = love.graphics.newFont(30),
        menu = love.graphics.newFont(20),
        default = love.graphics.getFont(),
        -- Platform Image
        platformImg = love.graphics.newImage('Ground.png'),
        -- music
        menuMusic = love.audio.newSource("menu.wav", "stream"),
        selectTone = love.audio.newSource("tone1.wav", "static"),
        enterTone = love.audio.newSource("tone2.wav", "static")
    },
    items = 
    {
        "New Game",
        "Scoreboard",
        "Settings",
        "Quit"
    },
    selected_item = 1,
    sound = true,
}

function menu:entered()
    -- Reset menu to first item when state entered
    self.selected_item = 1
    love.audio.stop(play.playMusic)
    if self.sound == true then
        love.audio.play(self.assets.menuMusic)
    end
end

function menu:load()
    love.audio.setVolume(0.8)
    if self.sound == true then
        love.audio.play(self.assets.menuMusic)
    end
    self.musicCounter = 0
end

function menu:update(dt)
    if love.audio.getActiveSourceCount() == 0 then
        if self.sound == true then
            love.audio.play(self.assets.menuMusic)
        end
    end

end

function menu:draw()
    -- Calculate drawable positions
    local window_width, window_hight = love.graphics.getDimensions()
    local window_width_center, window_hight_center = window_width / 2, window_hight / 2

    local menu_width, menu_hight = 600, 300
    local menuw_width_center, menu_hight_center = menu_width / 2, menu_hight / 2

    local menu_x = window_width_center - menuw_width_center
    local menu_y = window_hight_center - menu_hight_center



    -- draw background assets from play state for "seemless" transition from menu to play
        -- platform
    love.graphics.setColor(232 / 255, 213 / 255, 183 / 255)
    love.graphics.draw(play.platform.platformImg, play.platform.x, play.platform.y)
        -- clouds
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(play.clouds.cloud1, 200, 80, 0, 0.5, 0.5, 0)
    love.graphics.draw(play.clouds.cloud2, 600, 150, 0, 0.8, 0.8, 0)    
    love.graphics.draw(play.clouds.cloud3, 950, 100, 0, 0.5, 0.5, 0)
        -- blocks
    love.graphics.setColor(129 / 255, 139 / 255, 149 / 255)
    love.graphics.rectangle('fill', love.graphics.getWidth() - 300, love.graphics.getHeight() / 1.5, 60, -100)
    love.graphics.rectangle('fill', love.graphics.getWidth() - 120, love.graphics.getHeight() / 1.5, 60, -120)
    love.graphics.rectangle('fill', love.graphics.getWidth() - 200, love.graphics.getHeight() / 1.5, 60, -60)
        --player
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(play.player.currentImg, 100, play.player.y - play.player.sizeY, 0, 1.5, 1.5, 0)


    -- Set window background
    love.graphics.setBackgroundColor(33 / 255, 84 / 255, 144 / 255)

    -- Draw background 
    love.graphics.setColor(129 / 255, 139 / 255, 149 / 255)
    love.graphics.rectangle("fill", menu_x, menu_y, menu_width, menu_hight)

    -- Draw title text
    love.graphics.setColor(204 / 255, 229 / 255, 255 / 255)
    love.graphics.setFont(self.assets.title)
    love.graphics.print("Block Hopper", menu_x + 200, menu_y + 20)
    love.graphics.setFont(self.assets.default)

    -- Draw help text
    love.graphics.print("Movement: [A] [W] [S] [D] Select: [SPACE]", menu_x + 40, menu_y + menu_hight - 30)

    -- Draw menu text
    love.graphics.setFont(self.assets.menu)
    for i, item in ipairs(self.items) do
        local item_x, item_y = menu_x + 200, menu_y + 50 + 30 * i

        if i == self.selected_item then
            love.graphics.setColor(14 / 255, 36 / 255, 48 / 255)
        else
            love.graphics.setColor(204 / 255, 229 / 255, 255 / 255)
        end

        love.graphics.print(item, item_x, item_y)
    end
    love.graphics.setFont(self.assets.default)
end

function menu:keypressed(key)
    if key == "w" or key == "up" then
        self.selected_item = self.selected_item - 1
        self.assets.selectTone:setVolume(0.4)
        if self.sound == true then
            love.audio.stop(self.assets.selectTone)
            love.audio.play(self.assets.selectTone)
        end

        if self.selected_item < 1 then
            self.selected_item = #self.items
        end
    end

    if key == "s" or key == "down" then
        self.selected_item = self.selected_item + 1
        self.assets.selectTone:setVolume(0.4)
        if self.sound == true then
            love.audio.stop(self.assets.selectTone)
            love.audio.play(self.assets.selectTone)
        end

        if self.selected_item > #self.items then
            self.selected_item = 1
        end
    end

    if key == "space" or key == "return" then
        if self.sound == true then
            love.audio.stop(self.assets.enterTone)
            love.audio.play(self.assets.enterTone)
        end
        if self.selected_item == 1 then
            game:change_state("play")
        elseif self.selected_item == 2 then
            game:change_state("scoreboard")
        elseif self.selected_item == 3 then
            game:change_state("settings")
        elseif self.selected_item == 4 then
            love.event.quit(0)
        end
    end
end

return menu