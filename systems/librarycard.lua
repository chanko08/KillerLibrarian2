local book = {}

book.assets = {
  default = {
    path="assets/gfx/book.png",
    frame_width=32,
    frames=1
  },
}


book.system = tiny.processingSystem()
book.system.filter = tiny.requireAll('book')

function book.system:process(entity, dt)
  if entity.collision.num_cols > 0 then
    --remove the entity
    tiny.removeEntity(ecs, entity)

    if entity.collision.cols[1].other.enemy then
      entity.collision.cols[1].other.hurt = true
    end
  end
end

function book.new(player)
  --set up position of pl 
  local book_width = 32
  local book_height = 32
  local vx, vy = 0,0
  local x,y = player.pos:unpack()
  if player.looking_up then
    --x = x + player.collision.width / 2
    y = y - book_height - 10
    vy = -1
  elseif player.facing == 'left' then
    x = x - book_width - 10
    vx = -1
  else
    x = x + player.collision.width + 10
    vx = 1
  end
  

  local obj = collision.new(
    animation.new(
      book.assets,
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
  obj.book = true
  obj.apply_gravity=false

  return obj
end

return book
