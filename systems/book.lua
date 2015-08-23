local book = {}
book.assets = {
  default = {
    path="assets/gfx/book.png",
    frame_width=32,
    frames=1
  },
}

book.sound = {
  pickup = love.audio.newSource('assets/sfx/Pickup_Coin.wav')
}


book.system = tiny.processingSystem()
book.system.filter = tiny.requireAll('book')

function book.system:process(entity, dt)
  if entity.collision.num_cols > 0 then
    -- did we collide with the player? if yes then increment the number of collectibles they have
    for i,col in ipairs(entity.collision.cols) do
      if col.other.Player then
        book.sound.pickup:play()
        col.other.book_count = col.other.book_count - 1
        tiny.removeEntity(ecs, entity)
      end
    end
  end
end


function book.new(map, obj)
  --set up position of player correctly
  local x = math.floor(obj.x / map.tilewidth) * map.tilewidth
  local y = (math.floor(obj.y / map.tileheight) - 1) * map.tileheight

  collision.new(
    animation.new(
      book.assets,
      obj 
    ),
    x,
    y,
    64,
    64,
    function(book, other)
      if other.Player then
        return 'cross'
      end

      return 'slide'
    end
  )
  obj.book = true

  return obj
end

return book
