inspect   = require 'lib.inspect'
GameState = require 'lib.hump.gamestate'
Camera    = require 'lib.hump.camera'

TitleScreenState = require 'states.title'
LevelScreenState = require 'states.level'



function love.load()
  GameState.registerEvents()
  GameState.switch(TitleScreenState)
end
