local level_gui = {}
level_gui.system = tiny.processingSystem()
level_gui.system.filter = tiny.requireAll('Player')
level_gui.system.draw = true
level_gui.system.after_camera = true
local guibar = love.graphics.newImage('assets/gfx/guibar.png')
local font   = love.graphics.newFont('assets/fonts/numbers.ttf', 14)
function level_gui.system:process(entity)
  
  love.graphics.draw(guibar, 0, love.graphics.getHeight() - 64)
  love.graphics.setFont(font)
  love.graphics.print(entity.health, 130, love.graphics.getHeight() - 64 + 36)
  love.graphics.print(entity.score,  20,  love.graphics.getHeight() - 64 + 36)
  love.graphics.print(entity.book_count .. '/' .. entity.total_books, 220, love.graphics.getHeight() - 64 + 36)
  
end

return level_gui
