
local LevelScreenState = GameState.new()

local assets = {
  player = {
    walk  = {path="assets/gfx/player_walk.png", frame_width=36}
    stand = {"assets/gfx/player_stand.png",     frame_width=32}
    shoot = {"assets/gfx/player_fire.png",      frame_width=38}
  }
}

function LevelScreenState:enter(from)
end


function LevelScreenState:draw()
  love.graphics.draw(self.titlebackground)
end


function LevelScreenState:keypressed(key)
end

function LevelScreenState:keyreleased(key)
end

return LevelScreenState
