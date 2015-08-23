local PlayerController = tiny.processingSystem()

PlayerController.filter = tiny.requireAll('Player')

PlayerController.keyboard = true

local function handle_keyboard_down(entity, key)
  if key =='left' then
    entity.vel.x = -entity.lateral_speed

    AnimationRenderer.switch(entity, 'walk', true)
  end
  if key =='right' then
    entity.vel.x = entity.lateral_speed

    AnimationRenderer.switch(entity, 'walk')
  end

  if key == ' ' then
    Timer.add(0.5, function() entity.vel.y = entity.max_fall_speed end)

    entity.vel.y = entity.jump_speed
    AnimationRenderer.switch(entity, 'jump')
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
end

function PlayerController:process(entity, control)
  if control.key and control.isDown then
    handle_keyboard_down(entity, control.key)
  elseif control.key then
    handle_keyboard_up(entity, control.key)
  end
end


return PlayerController
