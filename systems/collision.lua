  
local CollisionSystem = tiny.processingSystem()

CollisionSystem.filter = tiny.requireAll('collision')

function CollisionSystem:onAdd(entity)
  physics:add(
    entity,
    entity.pos.x,
    entity.pos.y,
    entity.collision.width,
    entity.collision.height
  )

end

function CollisionSystem:process(entity, dt)
  entity.vel = entity.vel +  Vector(0, 200) * dt
  entity.vel.y = math.min(entity.vel.y, entity.max_fall_speed)
  entity.pos = entity.pos + entity.vel * dt
  local ax, ay, cols, num_cols = physics:move(entity, entity.pos.x, entity.pos.y, entity.collision.filter)

  entity.pos.x = ax
  entity.pos.y = ay
end

return CollisionSystem
