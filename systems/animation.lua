local AnimationRenderer = tiny.processingSystem()

AnimationRenderer.draw = true
AnimationRenderer.with_camera = true

AnimationRenderer.filter = tiny.requireAll('animations')

function AnimationRenderer:process(entity, dt)
  entity.current_animation:draw(
    entity.current_sprite,
    entity.pos.x,
    entity.pos.y
  )
end

function AnimationRenderer.switch(ent, animation_id, mirror)
  if ent.animations[animation_id] then
    if not mirror then
      ent.current_animation = ent.animations[animation_id].animation
    else 
      ent.current_animation = ent.animations[animation_id].mirror
    end
    ent.current_sprite = ent.animations[animation_id].sprite
  end
end


return AnimationRenderer
