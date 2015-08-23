local player = {}
player.assets = {

  walk  = {
    path="assets/gfx/player_walk.png",
    frame_width=36,
    frames='1-6'
  },
  default = {
    path="assets/gfx/player_stand.png",
    frame_width=32,
    frames=1
  },
  shoot = {
    path="assets/gfx/player_fire.png",
    frame_width=38,
    frames=1
  },
}


player.controller = tiny.processingSystem()
player.controller.filter = tiny.requireAll('Player')
player.controller.keyboard = true

local function handle_keyboard_down(entity, key)
  if key =='left' then
    entity.vel.x = -entity.lateral_speed
    entity.facing = key

    animation.switch(entity, 'walk', true)
  end
  if key =='right' then
    entity.vel.x = entity.lateral_speed
    entity.facing = key

    animation.switch(entity, 'walk')
  end

  if key=='up' then
    entity.looking_up = true
  end

  if key == ' ' and not entity.jumping then
    entity.vel.y = entity.jump_speed
    entity.jumping = true
    entity.ignore_next_ground_hit = true

    animation.switch(entity, 'jump')
  end



  if key == 'lctrl' then
    --default to shooting
    local librarycard = librarycard.new(entity)
    tiny.addEntity(ecs, librarycard)

    if entity.vel.x == 0 then
      local mir = true
      if entity.facing == 'right' then
        mir = false
      end
      animation.switch(entity, 'shoot', mir)
    end
  end
end

local function handle_keyboard_up(entity, key)
  if key =='left' then
    if entity.vel.x < 0 then
      entity.vel.x = 0

      animation.switch(entity, 'default', true)
    end
  end

  if key =='right' then
    if entity.vel.x > 0 then
      entity.vel.x = 0
      animation.switch(entity, 'default')
    end
  end

  if key=='up' then
    entity.looking_up = false
  end

  if key == 'lctrl' then
    if entity.vel.x == 0 then
      local mir = true
      if entity.facing == 'right' then
        mir = false
      end
      animation.switch(entity, 'default', mir)
    end
  end
end

function player.controller:process(entity, control)
  if control.key and control.isDown then
    handle_keyboard_down(entity, control.key)
  elseif control.key then
    handle_keyboard_up(entity, control.key)
  end
end


player.system = tiny.processingSystem()
player.system.filter = tiny.requireAll('Player')

function player.system:process(entity, dt)
  if entity.collision.num_cols > 0 then
    -- check if we hit the ground
    if entity.collision.cols[1].normal.y < 0 and not entity.ignore_next_ground_hit then
      entity.jumping = false
    else
      entity.ignore_next_ground_hit = false
    end
  end
end


function player.new(map, obj)
  --set up position of player correctly
  local x = math.floor(obj.x / map.tilewidth) * map.tilewidth
  local y = (math.floor(obj.y / map.tileheight) - 1) * map.tileheight

  collision.new(
    animation.new(
      player.assets,
      obj 
    ),
    x,
    y,
    32,
    64,
    function(player, other)
      if other.enemy then
        return 'cross'
      end
      return 'slide'
    end
  )

  obj.jump_speed = -390
  obj.lateral_speed = 200
  obj.keyboard = true
  obj.max_fall_speed = 500
  obj.jumping = true
  obj.facing = 'right'
  obj.looking_up = false
  obj.health = 100


  print('camera!')
  camera = Camera(map, obj)

  return obj
end



return player
