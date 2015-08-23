local losegame = {}
losegame.assets = {
  default = { path='assets/gfx/losegame.png', frame_width=640, frames=1}
}
losegame.system = tiny.processingSystem()
losegame.system.filter = tiny.requireAll('losegame')
losegame.system.keyboard = true


function losegame.system:process(entity, key)
  --transition back to game start
  switch_state(level_screen_state, entity.lvlid)

end


function losegame.new(lvlid)
  local obj = {}
  obj.pos = Vector(0,0)

  animation.new(losegame.assets, obj)
  obj.losegame=true
  obj.lvlid = lvlid

  return obj
end

return losegame
