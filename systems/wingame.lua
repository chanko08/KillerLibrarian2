local wingame = {}
wingame.assets = {
  default = { path='assets/gfx/wingame.png', frame_width=640, frames=1}
}
wingame.system = tiny.processingSystem()
wingame.system.filter = tiny.requireAll('wingame')
wingame.system.keyboard = true


function wingame.system:process(entity, key)
  --transition back to game start

end


function wingame.new()
  local obj = {}
  obj.pos = Vector(0,0)

  animation.new(wingame.assets, obj)
  obj.wingame=true

  return obj
end

return wingame
