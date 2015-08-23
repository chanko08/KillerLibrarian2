
local Camera = class({})

function Camera:init(map, player)
  self.player = player

  start_x, start_y = player.pos:unpack()
  local world = bump.newWorld()
  self.world = world
  self.cam = HumpCamera(start_x, start_y)

  self.pos = Vector(self.cam.x - love.graphics.getWidth()/2, self.cam.y - love.graphics.getHeight()/2)
  world:add(self.cam, self.pos.x, self.pos.y, love.graphics.getWidth(), love.graphics.getHeight())
  
  --create dimensions around the level to force the camera to stay inside of level boundaries
  world:add({side='left'}, -20, 0, 20, map.tileheight * map.height)
  world:add({side='right'}, map.tilewidth * map.width, 0, 20, map.tileheight * map.height)
  world:add({side='top'}, 0, -20, map.tilewidth * map.width, 20)
  world:add({side='top'}, 0, map.tileheight * map.height, map.tilewidth * map.width, 20)
end


function Camera:attach()
  self.cam:attach()
end

function Camera:detach()
  self.cam:detach()
end

function Camera:update(dt)
  self:lookAt(self.player.pos.x, self.player.pos.y)
end

function Camera:update_camera_topleft()
  self.pos = Vector(self.cam.x - love.graphics.getWidth()/2, self.cam.y - love.graphics.getHeight()/2)
end

function Camera:draw()
  items, num_items = self.world:getItems()
  for i,item in ipairs(items) do
    local x, y, w, h = self.world:getRect(item)

    love.graphics.rectangle('line', x, y, w, h)
  end
end


function Camera:move(x,y)
  self.cam:move(x,y)
  self:update_camera_topleft()
  local ax, ay, cols, num_cols = self.world:move(self.cam, self.pos.x, self.pos.y)

  self.cam:lookAt(ax + love.graphics.getWidth() / 2, ay + love.graphics.getHeight() / 2)
  self:update_camera_topleft()
end


function Camera:lookAt(x,y)
  self.cam:lookAt(x,y)
  self:update_camera_topleft()
  local ax, ay, cols, num_cols = self.world:move(self.cam, self.pos.x, self.pos.y)
  self.cam:lookAt(ax + love.graphics.getWidth() / 2, ay + love.graphics.getHeight() / 2)
  self:update_camera_topleft()
end

return Camera 
