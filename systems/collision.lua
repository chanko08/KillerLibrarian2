local collision = {}

function collision.new(ent, x, y, width, height, filter)
  ent.pos = Vector(x,y)
  ent.vel = Vector(0,0)
  ent.collision = {}
  ent.collision.width = width
  ent.collision.height = height
  ent.collision.filter = filter
  ent.collision.cols = {}
  ent.collision.num_cols = 0
  ent.apply_gravity = true
  ent.max_fall_speed = 500

  return ent
end


collision.system = tiny.processingSystem()

collision.system.filter = tiny.requireAll('collision')

function collision.system:onAdd(entity)
  physics:add(
    entity,
    entity.pos.x,
    entity.pos.y,
    entity.collision.width,
    entity.collision.height
  )
end

function collision.system:onRemove(entity)
  physics:remove(entity)
end

function collision.system:process(entity, dt)
  if entity.apply_gravity then
    entity.vel = entity.vel +  Vector(0, 760) * dt
  end
  entity.vel.y = math.min(entity.vel.y, entity.max_fall_speed)
  entity.pos = entity.pos + entity.vel * dt
  local ax, ay, cols, num_cols = physics:move(entity, entity.pos.x, entity.pos.y, entity.collision.filter)

  entity.pos.x = ax
  entity.pos.y = ay
  entity.collision.cols = cols
  entity.collision.num_cols = num_cols
end

return collision
