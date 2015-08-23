inspect    = require 'lib.inspect'
GameState  = require 'lib.hump.gamestate'
HumpCamera = require 'lib.hump.camera'
Vector     = require 'lib.hump.vector'
class      = require 'lib.hump.class'
Timer      = require 'lib.hump.timer'
anim8      = require 'lib.anim8'
bump       = require 'lib.bump'
tiny       = require 'lib.tiny'
_          = require 'lib.underscore'


animation   = require 'systems.animation'
player      = require 'systems.player'
librarycard = require 'systems.librarycard'
book        = require 'systems.book'
collision   = require 'systems.collision'
enemy       = require 'systems.enemy'
collection  = require 'systems.collection'
wingame     = require 'systems.wingame'
losegame    = require 'systems.losegame'
title       = require 'systems.title'
level_gui   = require 'systems.level_gui'

TileLayerRenderer = require 'systems.renderers.tilelayer'

LevelLoader      = require 'levelloader'
Camera           = require 'camera'

ecs     = tiny.world()
physics = bump.newWorld()
camera  = true

pause = false

change_state = false
function switch_state(st, ...)
  change_state = {}
  change_state.state = st
  change_state.args = {...}
end

function state_refresh()
  ecs = tiny.world()
  physics = bump.newWorld()
end


function level_state(lvlid)
  tiny.addSystem(ecs, TileLayerRenderer)
  tiny.addSystem(ecs, animation.renderer)
  tiny.addSystem(ecs, animation.system)
  tiny.addSystem(ecs, player.controller)
  tiny.addSystem(ecs, player.system)
  tiny.addSystem(ecs, librarycard.system)
  tiny.addSystem(ecs, book.system)
  tiny.addSystem(ecs, enemy.system)
  tiny.addSystem(ecs, enemy.teenager.system)
  tiny.addSystem(ecs, collision.system)
  tiny.addSystem(ecs, level_gui.system)
  LevelLoader.load_level(lvlid)
  --initialize the proper systems
end


function game_win_state()
  tiny.addSystem(ecs, animation.renderer)
  tiny.addSystem(ecs, animation.system)
  tiny.addSystem(ecs, wingame.system)
  camera = HumpCamera()
  camera:lookAt(320,200)
  tiny.addEntity(ecs, wingame.new())
end

function game_over_state(lvlid)
  tiny.addSystem(ecs, animation.renderer)
  tiny.addSystem(ecs, animation.system)
  tiny.addSystem(ecs, losegame.system)
  camera = HumpCamera()
  camera:lookAt(320, 200)
  tiny.addEntity(ecs, losegame.new(lvlid))
end

function title_screen_state()
  tiny.addSystem(ecs, animation.renderer)
  tiny.addSystem(ecs, animation.system)
  tiny.addSystem(ecs, title.system)
  camera = HumpCamera()
  camera:lookAt(320, 200)
  tiny.addEntity(ecs, title.new())
end


function love.load()
  ecs = tiny.world()
  physics = bump.newWorld()


  switch_state(title_screen_state)
end


function love.update(dt)
  if change_state then
    state_refresh()
    change_state.state(unpack(change_state.args))
    change_state=nil
  end

  if not pause then
    Timer.update(dt)
    if camera.update then
      camera:update(dt)
    end
    tiny.update(ecs, dt, tiny.rejectAny('draw', 'keyboard'))
  end
end

function love.draw()
  camera:attach()
  tiny.update(ecs, 0, tiny.requireAll('draw', 'with_camera'))
  camera:detach()
  tiny.update(ecs, 0, tiny.requireAll('draw', 'after_camera'))
end

function love.keypressed(key)
  tiny.update(ecs, {key=key, isDown=true}, tiny.requireAll('keyboard'))
  if key == 'escape' then
    love.event.quit()
  end
  if key=='p' then
    pause = not pause
  end
end

function love.keyreleased(key)
  tiny.update(ecs, {key=key, isDown=false}, tiny.requireAll('keyboard'))
end
