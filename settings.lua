local settings = {
    assets = {
      title = love.graphics.newFont(30),
      menu = love.graphics.newFont(20),
      default = love.graphics.getFont(),
      selectTone = love.audio.newSource("tone1.wav", "static"),
      enterTone = love.audio.newSource("tone2.wav", "static")
    },
    selected_item = 1,
    settings = {
      "Sound [on]",
      "Difficulty [normal]",
      "Clear scoreboard",
      "Return to menu"
    },
    sound = true
  }

  function settings:entered()

  end
  
  
  function settings:draw()
    -- Calculate drawable positions
    local window_width, window_height = love.graphics.getDimensions()
    local window_width_center, window_height_center = window_width / 2, window_height / 2
  
    local settings_width, settings_height = 400, 300
    local settings_width_center, settings_height_center = settings_width / 2, settings_height / 2
  
    local settings_x, settings_y = window_width_center - settings_width_center, window_height_center - settings_height_center
  
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
    -- love.graphics.setBackgroundColor(14, 36, 48) -- love versions prior to 0.11.0
    love.graphics.setBackgroundColor(33 / 255, 84 / 255, 144 / 255)
  
    -- Draw background rectangle
    -- love.graphics.setColor(232, 213, 183) -- love version prior to 0.11.0
    love.graphics.setColor(129 / 255, 139 / 255, 149 / 255) -- love version prior to 0.11.0
    love.graphics.rectangle("fill", settings_x, settings_y, settings_width, settings_height)
  
    -- Draw title text
    -- love.graphics.setColor(252, 58, 81) -- love versions prior to 0.11.0
    love.graphics.setColor(204 / 255, 229 / 255, 255 / 255)
    love.graphics.setFont(self.assets.title)
    love.graphics.print("Settings", settings_x + 40, settings_y + 20)
    love.graphics.setFont(self.assets.default)
  
    -- Draw help text
    love.graphics.print("Move: [W] [S] Select: [SPACE]", settings_x + 40, settings_y + settings_height - 30)
  
    -- Draw menu text
    love.graphics.setFont(self.assets.menu)
    for i, setting in ipairs(self.settings) do
      local setting_x, setting_y = settings_x + 40, settings_y + 50
  
      if i == self.selected_item then
        -- love.graphics.setColor(14, 36, 48) -- love versions prior to 0.11.0
        love.graphics.setColor(14 / 255, 36 / 255, 48 / 255)
      else
        -- love.graphics.setColor(252, 58, 81) -- love versions prior to 0.11.0
        love.graphics.setColor(204 / 255, 229 / 255, 255 / 255)
      end
  
      love.graphics.print(setting, setting_x, 30 * i + setting_y)
    end
    love.graphics.setFont(self.assets.default)
  
  end
  
  function settings:update()
    if play.sound == false then
      self.sound = false
    else
      self.sound = true
    end

    if love.audio.getActiveSourceCount() == 0 then
      if self.sound == true then
          love.audio.play(menu.assets.menuMusic)
      end
    end
  end

  function settings:keypressed(key)
    if key == "w" or key == "up" then
      self.selected_item = self.selected_item - 1
      self.assets.selectTone:setVolume(0.4)
      if self.sound == true then
        love.audio.stop(self.assets.selectTone)
        love.audio.play(self.assets.selectTone)
    end

      if self.selected_item < 1 then
        self.selected_item = #self.settings
      end
    end
  
    if key == "s" or key == "down" then
      self.selected_item = self.selected_item + 1
      self.assets.selectTone:setVolume(0.4)
      if self.sound == true then
        love.audio.stop(self.assets.selectTone)
        love.audio.play(self.assets.selectTone)
    end
  
      if self.selected_item > #self.settings then
        self.selected_item = 1
      end
    end
    
    if key == "escape" then
      if self.sound == true then
        love.audio.stop(self.assets.enterTone)
        love.audio.play(self.assets.enterTone)
      end
      game:change_state("menu")
    end

  
    if key == "return" or key == "space" then
      if self.sound == true then
        love.audio.stop(self.assets.enterTone)
        love.audio.play(self.assets.enterTone)
      end
      if self.selected_item == 1 then
        if game.states.play:toggle_sound() then
          self.settings[1] = "Sound [on]"
        else 
          self.settings[1] = "Sound [off]"
        end
      elseif self.selected_item == 2 then
        local difficulty = game.states.play:changeDifficulty()
  
        if difficulty == 1 then
          self.settings[2] = "Difficulty [easy]"
          print("Difficulty = " .. play.difficulty)
        elseif difficulty == 2 then
          self.settings[2] = "Difficulty [normal]"
          print("Difficulty = " .. play.difficulty)
        elseif difficulty == 3 then
          self.settings[2] = "Difficulty [hard]"
          print("Difficulty = " .. play.difficulty)
        end
      elseif self.selected_item == 3 then
        game.states.scoreboard:clear_scores()
      elseif self.selected_item == 4 then
        game:change_state("menu")
      end
    end
  end
  
  return settings
  