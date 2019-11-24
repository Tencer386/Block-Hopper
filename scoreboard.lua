local scoreboard = {
    assets = {
      title = love.graphics.newFont(30),
      menu = love.graphics.newFont(20),
      default = love.graphics.getFont()
    },
    scoreboard_file = "scores.txt",
    score_limit = 6,
    scores = {},
    sound = true,
    enterTone = love.audio.newSource("tone2.wav", "static")
  }
  
  function scoreboard:clear_scores()
    local score_file = love.filesystem.newFile(self.scoreboard_file)
    score_file:open("w")
    score_file:close()
  end
  
  function scoreboard:load_scores()
    self.scores = {}
  
    -- if love.filesystem.exists(self.scoreboard_file) then -- for older love viersions
    if love.filesystem.getInfo(self.scoreboard_file) then
      for score in love.filesystem.lines(self.scoreboard_file) do
        table.insert(self.scores, tonumber(score))
      end
    else
      table.insert(self.scores, "No score data...")
    end
  end
  
  function scoreboard:add_score(score)
    local scores = {}
  
    if love.filesystem.getInfo(self.scoreboard_file) then
      for score in love.filesystem.lines(self.scoreboard_file) do
        table.insert(scores, tonumber(score))
      end
    end
  
    table.insert(scores, tonumber(score))
  
    table.sort(scores, function(a, b) return a > b end)
  
    while #scores > self.score_limit do
      -- Removes an element at the end of the array
      table.remove(scores)
    end
  
    local score_file = love.filesystem.newFile(self.scoreboard_file)
    score_file:open("w")
  
    for k, score in pairs(scores) do
      score_file:write(score .. "\n")
    end
  
    score_file:close()
  end
  
  function scoreboard:entered()
    self:load_scores()
    love.audio.stop(play.playMusic)
    if play.sound == false then
      self.sound = false
    end

    if self.sound == true then
        love.audio.play(menu.assets.menuMusic)
    end
    counter = 0
  end
  
  function scoreboard:draw()
    -- Calculate drawable positions
    local window_width, window_height = love.graphics.getDimensions()
    local window_width_center, window_height_center = window_width / 2, window_height / 2
  
    local scoreboard_width, scoreboard_height = 400, 300
    local scoreboard_width_center, scoreboard_height_center = scoreboard_width / 2, scoreboard_height / 2
  
    local scoreboard_x, scoreboard_y = window_width_center - scoreboard_width_center, window_height_center - scoreboard_height_center
  
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
    love.graphics.rectangle("fill", scoreboard_x, scoreboard_y, scoreboard_width, scoreboard_height)
  
    -- Draw title text
    -- love.graphics.setColor(252, 58, 81) -- love versions prior to 0.11.0
    love.graphics.setColor(204 / 255, 229 / 255, 255 / 255)
    love.graphics.setFont(self.assets.title)
    love.graphics.print("Scoreboard", scoreboard_x + 40, scoreboard_y + 20)
    love.graphics.setFont(self.assets.default)
  
    -- Draw help text
    love.graphics.print("Return to menu: [SPACE] or [ESC]", scoreboard_x + 40, scoreboard_y + scoreboard_height - 30)
  
    -- Draw menu text
    love.graphics.setFont(self.assets.menu)
    for i, score in ipairs(self.scores) do
      local score_x, score_y = scoreboard_x + 40, scoreboard_y + 50
  
      -- love.graphics.setColor(252, 58, 81) -- love versions prior to 0.11.0
      love.graphics.setColor(204 / 255, 229 / 255, 255 / 255)
      love.graphics.print(score, score_x, 30 * i + score_y)
    end
    love.graphics.setFont(self.assets.default)
  
  end

  function scoreboard:update(dt)
    if love.audio.getActiveSourceCount() == 0 then
      if self.sound == true then
          love.audio.play(menu.assets.menuMusic)
      end
    end
  end
  
  
  function scoreboard:keypressed(key)
    if key == "space" or key == "escape" then
      if self.sound == true then
        love.audio.play(self.enterTone)
      end
      game:change_state("menu")
    end
  end
  
  return scoreboard
  