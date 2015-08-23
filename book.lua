local book = {}

book.assets = {
  default = {
    path="assets/gfx/book.png",
    frame_width=32,
    frames=1
  },
}

function book.new(x, y)
  --set up position of player correctly

  local obj = collision.new(
    animation.new(
      book.assets,
      physics.new({}, x, y)
    ),
    32,
    32
  )

  obj.lateral_speed = 200
  obj.max_fall_speed = 0

  return obj
end

return book
