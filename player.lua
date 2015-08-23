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
      return 'slide'
    end
  )

  obj.jump_speed = -400
  obj.lateral_speed = 200
  obj.keyboard = true
  obj.max_fall_speed = 500


  print('camera!')
  camera = Camera(map, obj)

  return obj
end


return player
