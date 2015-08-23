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


animation = require 'systems.animation'
player    = require 'systems.player'
book      = require 'systems.book'
collision = require 'systems.collision'
enemy     = require 'systems.enemy'

TileLayerRenderer = require 'systems.renderers.tilelayer'

LevelLoader      = require 'levelloader'
Camera           = require 'camera'

ecs     = tiny.world()
physics = bump.newWorld()
camera  = true

pause = false

function state_refresh()
  tiny.clearEntities(ecs)
  tiny.clearSystems(ecs)
  physics = bump.newWorld()
end


function level_state(lvlid)
  state_refresh()
  tiny.addSystem(ecs, TileLayerRenderer)
  tiny.addSystem(ecs, animation.renderer)
  tiny.addSystem(ecs, animation.system)
  tiny.addSystem(ecs, player.controller)
  tiny.addSystem(ecs, player.system)
  tiny.addSystem(ecs, book.system)
  tiny.addSystem(ecs, enemy.system)
  tiny.addSystem(ecs, enemy.teenager.system)
  tiny.addSystem(ecs, collision.system)
  LevelLoader.load_level(lvlid)
  --initialize the proper systems
  print('entity count ... ', ecs:getEntityCount())
end


function love.load()
  ecs = tiny.world()
  physics = bump.newWorld()

  level_state(1)
end


function love.update(dt)
  if not pause then
    Timer.update(dt)
    camera:update(dt)
    tiny.update(ecs, dt, tiny.rejectAny('draw', 'keyboard'))
  end
end

function love.draw()
  camera:attach()
  tiny.update(ecs, 0, tiny.requireAll('draw', 'with_camera'))
  camera:detach()
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
