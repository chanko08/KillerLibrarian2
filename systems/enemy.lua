local enemy = {}

enemy.assets = {
  teenager = {
    default = {path='assets/gfx/teenager.png', frame_width=64, frames=1},
    walk    = {path='assets/gfx/teenager.png', frame_width=64, frames=1}
    
  },
  granny = {
    default = {path='assets/gfx/granny.png', frame_width=64, frames=1},
  }

}

enemy.sound = {
  hurt = love.audio.newSource('assets/sfx/Hit_Hurt_Enemy.wav', 'static')
}


enemy.collision_filter = function(enemy, other)
  if other.Player or other.librarycard then
    return 'cross'
  end
  return 'slide'
end

enemy.system = tiny.processingSystem()
enemy.system.filter = tiny.requireAll('enemy')
function enemy.system:process(entity, dt)
  if entity.hurt then
    enemy.sound.hurt:rewind()
    enemy.sound.hurt:play()
    entity.hurt = false
    entity.num_hits = entity.num_hits - 1
    if entity.num_hits <= 0 then
      tiny.removeEntity(ecs, entity)
    end
  end
end

enemy.teenager = {}
enemy.teenager.system = tiny.processingSystem()
enemy.teenager.system.filter = tiny.requireAll('Teenager')

function enemy.teenager.system:process(entity, dt)
  if entity.collision.num_cols > 0 then
    for i,col in ipairs(entity.collision.cols) do
      if col.normal.x < 0 then
        entity.facing = 'left'
        animation.switch(entity, 'walk', true) 
      elseif col.normal.x > 0 then
        entity.facing = 'right'
        animation.switch(entity, 'walk')
      end

    end
  end


  if entity.facing == 'left' then
    entity.vel.x = -entity.lateral_speed
  else
    entity.vel.x = entity.lateral_speed
  end

end

function enemy.teenager.new(map, obj)
  --set up position of player correctly
  local x = math.floor(obj.x / map.tilewidth) * map.tilewidth
  local y = (math.floor(obj.y / map.tileheight) - 1) * map.tileheight

  collision.new(
    animation.new(
      enemy.assets.teenager,
      obj 
    ),
    x,
    y,
    64,
    64,
    enemy.collision_filter
  )
  obj.enemy = true
  obj.teenager = true
  obj.facing = 'left'
  animation.switch(obj, 'walk', true)
  obj.lateral_speed = 100
  obj.num_hits=4


  return obj
end


enemy.granny = {}
function enemy.granny.new(map, obj)
  print('made granny')
  local x = math.floor(obj.x / map.tilewidth) * map.tilewidth
  local y = (math.floor(obj.y / map.tileheight) - 1) * map.tileheight

  collision.new(
    animation.new(
      enemy.assets.granny,
      obj 
    ),
    x,
    y,
    64,
    64,
    enemy.collision_filter
  )
  obj.enemy = true
  obj.facing = 'left'
  animation.switch(obj, 'walk', true)
  obj.lateral_speed = 100
  obj.num_hits = 3


  return obj

end

return enemy
