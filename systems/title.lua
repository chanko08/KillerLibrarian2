local title = {}
title.assets = {
  default = { path='assets/gfx/title.png', frame_width=640, frames=1}
}
title.system = tiny.processingSystem()
title.system.filter = tiny.requireAll('title')
title.system.keyboard = true


function title.system:process(entity, key)
  --transition back to game start
  switch_state(level_state, 1)

end


function title.new()
  local obj = {}
  obj.pos = Vector(0,0)

  animation.new(title.assets, obj)
  obj.title = true

  return obj
end

return title
