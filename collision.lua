--[[
local Collision = class({})


function Collision:init()
  self.bump = bump.newWorld()
end

function Collision:onAdd(ent)
  self.bump:add(ent, ent.pos.x, ent.pos.y, ent.collision.width, ent.collision.height)
end

function Collision:process(ent, dt)
  ent.vel = ent.vel +  Vector(0, 200) * dt
  ent.vel.y = math.min(ent.vel.y, ent.max_fall_speed)
  ent.pos = ent.pos + ent.vel * dt
  local ax, ay, cols, num_cols = self.bump:move(ent, ent.pos.x, ent.pos.y, ent.collision.filter)

  ent.pos.x = ax
  ent.pos.y = ay

  return ent
end
]]

local collision = {}

function collision.new(ent, x, y, width, height, filter)
  ent.pos = Vector(x,y)
  ent.vel = Vector(0,0)
  ent.collision = {}
  ent.collision.width = width
  ent.collision.height = height
  ent.collision.filter = filter

  return ent
end


return collision
