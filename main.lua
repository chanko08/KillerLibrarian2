GameState = require 'lib.hump.gamestate'

TitleScreenState = require 'states.title'
LevelScreenState = require 'states.level'



function love.load()
  GameState.registerEvents()
  GameState.switch(TitleScreenState)
end
