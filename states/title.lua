
local TitleScreenState = GameState.new()

local assets = {
  bg = 'assets/gfx/title.png'
}

function TitleScreenState:enter(from)
  self.titlebackground = love.graphics.newImage(assets.bg)
end


function TitleScreenState:draw()
  love.graphics.draw(self.titlebackground)
end


function TitleScreenState:keypressed(key)
  GameState.switch(LevelScreenState)
end

function TitleScreenState:keyreleased(key)
end

return TitleScreenState
