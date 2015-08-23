local librarycard = {}

librarycard.assets = {
  default = {
    path="assets/gfx/library_card.png",
    frame_width=32,
    frames='1-6'
  },
}


librarycard.system = tiny.processingSystem()
librarycard.system.filter = tiny.requireAll('librarycard')

function librarycard.system:process(entity, dt)
  if entity.collision.num_cols > 0 then
    --remove the entity
    tiny.removeEntity(ecs, entity)

    if entity.collision.cols[1].other.enemy then
      entity.collision.cols[1].other.hurt = true
    end
  end
end

function librarycard.new(player)
  --set up position of pl 
  local librarycard_width = 32
  local librarycard_height = 32
  local vx, vy = 0,0
  local x,y = player.pos:unpack()
  if player.looking_up then
    --x = x + player.collision.width / 2
    y = y - librarycard_height - 10
    vy = -1
  elseif player.facing == 'left' then
    x = x - librarycard_width - 10
    vx = -1
  else
    x = x + player.collision.width + 10
    vx = 1
  end
  

  local obj = collision.new(
    animation.new(
      librarycard.assets,
      {}
    ),
    x,
    y,
    32,
    32
  )


  obj.lateral_speed = 500
  obj.max_fall_speed = 0


  obj.vel.x = vx * obj.lateral_speed
  obj.vel.y = vy * obj.lateral_speed
  obj.librarycard = true
  obj.apply_gravity=false

  return obj
end

return librarycard
