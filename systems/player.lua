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

player.sound = {
  hurt = love.audio.newSource("assets/sfx/Hit_Hurt.wav", "static"),
  shoot = love.audio.newSource("assets/sfx/Laser_Shoot.wav", "static"),
  jump  = love.audio.newSource("assets/sfx/Jump.wav", "static")


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
    player.sound.jump:rewind()
    player.sound.jump:play()
    entity.vel.y = entity.jump_speed
    entity.jumping = true
    entity.ignore_next_ground_hit = true

    animation.switch(entity, 'jump')
  end



  if key == 'lctrl' then
    --default to shooting
    player.sound.shoot:rewind()
    player.sound.shoot:play()
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
    
    for i,col in ipairs(entity.collision.cols) do
      if col.normal.y < 0 and not entity.ignore_next_ground_hit then
        entity.jumping = false
      else
        entity.ignore_next_ground_hit = false
      end


      if col.other.enemy and entity.can_be_hurt then
        player.sound.hurt:play()
        entity.health = entity.health - 4
        entity.can_be_hurt = false
        Timer.add(0.5, function() entity.can_be_hurt=true end)
      end
    end

  end

  if entity.book_count == 0 then
    if entity.next_level_id == 0 then
      switch_state(game_win_state)
      return
    else
      switch_state(level_state, entity.next_level_id)
    end
  end


  if entity.health <= 0 then
    switch_state(game_over_state, entity.next_level_id - 1)
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
      if other.enemy or other.Book then
        return 'cross'
      end
      return 'slide'
    end
  )

  obj.jump_speed = -400
  obj.lateral_speed = 200
  obj.keyboard = true
  obj.max_fall_speed = 500
  obj.jumping = true
  obj.facing = 'right'
  obj.looking_up = false
  obj.health = 100
  print('TOTAL BOOKS!', map.properties.book_count)
  obj.total_books   = map.properties.book_count
  obj.book_count    = map.properties.book_count
  obj.next_level_id = map.properties.next_level or 0
  obj.score = 0
  obj.can_be_hurt = true


  camera = Camera(map, obj)

  return obj
end



return player
