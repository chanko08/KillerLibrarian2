--[[local collection = {}
--
local level_win = {}
level_win.system = tiny.System()

level_win.system.filter = tiny.requireAny('book_collected', 'LevelWin')

function level_win.system:update(dt)
  local level_win_info = _.first(_.select(self.entities, function(e) return e.LevelWin end))

  local books_collected = _.reduce(_.select(self.entities, function(e) return e.book_collected end), 0, function(tot, e) return tot+1 end)


  if level_win_info.total_books == books_collected then

    print('to next level!')
  end
end

function collection.book()

end
]]
