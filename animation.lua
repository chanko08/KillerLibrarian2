local animation = {}


--[[
-- Assets format : { animation_name = {path = "path/to/spritesheet", frame_width=width_of_sprite_frame, frames=anim8_frame_section }
--]]

function animation.new(assets, ent)
  ent.animations = {}
  for asset_name, a in pairs(assets) do
    if not love.filesystem.exists(a.path) then
      error('picture file does not exist: ' .. a.path)
    end

    if not love.filesystem.isFile(a.path) then
      error('filepath to picture is for a directory: ' .. a.path)
    end

    local img = love.graphics.newImage(a.path)
    local g = anim8.newGrid(
      a.frame_width,
      img:getHeight(),
      img:getWidth(),
      img:getHeight()
    )
    local anim = anim8.newAnimation(g(a.frames,1), 1/10.0)
    local mirr = anim:clone()
    mirr:flipH()
    ent.animations[asset_name] = {
      animation = anim,
      sprite    = img,
      mirror    = mirr
    }
  end


  local start_animation = ent.animations['default'] or _.first(_.values(ent.animations))
  ent.current_animation = start_animation.animation
  ent.current_sprite    = start_animation.sprite

  return ent
end


function animation.switch(ent, animation_id, mirror)
  if ent.animations[animation_id] then
    if not mirror then
      ent.current_animation = ent.animations[animation_id].animation
    else 
      ent.current_animation = ent.animations[animation_id].mirror
    end
    ent.current_sprite    = ent.animations[animation_id].sprite
  end
end


return animation
