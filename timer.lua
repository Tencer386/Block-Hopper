timer = {
    base = 0,
    baseInc = 1,

    sec = 0,
    min = 0,
    total = 0,

    timerFont = love.graphics.newFont(30),

    debug = true
}

function resetTimer()
    timer.base = 0
    timer.sec = 0
    timer.min = 0
    timer.total = 0
end

function createTimer()

    function timer:inc()

        dt = love.timer.getDelta()

        timer.base = timer.base + dt

        if timer.base  >= timer.baseInc then
            timer.base = timer.base - timer.baseInc
            timer.sec = timer.sec + 1
            timer.total = timer.total + 1
        end 

        if timer.sec == 60 then
            timer.min = timer.min + 1
            timer.sec = 0
        end
    end
end

function drawTimer()
    love.graphics.setFont(timer.timerFont)
    love.graphics.setColor(0,0,0)

    if timer.sec < 10 then
        love.graphics.print("Game Time: " .. timer.min .. ":" .. "0" .. timer.sec, 10, love.graphics.getHeight() - (love.graphics.getHeight() - 10), 0, 1)
    else
        love.graphics.print("Game Time: " .. timer.min .. ":" .. timer.sec, 10, love.graphics.getHeight() - (love.graphics.getHeight() - 10), 0, 1)
    end

    if timer.debug == true then
        love.graphics.print("Base Time: " .. timer.base, 10, love.graphics.getHeight() - (love.graphics.getHeight() - 40), 0, 1)
        
        if timer.total <10 then
            love.graphics.print("Total Time: " .. "0" .. timer.total, 10, love.graphics.getHeight() - (love.graphics.getHeight() - 70), 0, 1)
        else
            love.graphics.print("Total Time: " .. timer.total, 10, love.graphics.getHeight() - (love.graphics.getHeight() - 70), 0, 1)
        end
    end
end

return createTimer