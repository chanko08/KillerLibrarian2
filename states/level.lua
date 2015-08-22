
local LevelScreenState = GameState.new()

local assets = {
  player = {
    walk  = {path="assets/gfx/player_walk.png", frame_width=36},
    stand = {"assets/gfx/player_stand.png",     frame_width=32},
    shoot = {"assets/gfx/player_fire.png",      frame_width=38},
  },
  levels = {
    'assets/lvls/lvl1.lua',
  },
}


local function load_tiled_file(filename)
  if not love.filesystem.exists(lvl_file) then
    error('tiled file not found: ' .. lvl_file)
  end

  if not love.filesystem.isFile(lvl_file) then
    error('given filepath leads to directory, not a tiled file')
  end

  local file = love.filesystem.load(lvl_file)
  local ok, contents = pcall(file)
  
  if not ok then 
    error('error occurred executing tile file. make sure tile file is a valid lua file\nfile error:\n' .. contents)
  end

  return contents
end

local function load_tiles(tiled_map)
  local tiles = {}

  for i, tileset in ipairs(tiled_map.tilesets) do
    -- load image
    local img_file = tileset.properties.src
    if not love.filesystem.exists(img_file) then
      error('tileset image not found: ' .. img_file)
    end

    if not love.filesystem.isFile(img_file) then
      error('given filepath leads to directory, not a tileset image')
    end

    local img = love.graphics.newImage(img_file)

    --split tiles into quads
    --TODO have this handle tile spacing and tile margin
    local tset_width = tileset.imagewidth / tileset.tilewidth
    local tset_height = tileset.imageheight / tileset.tileheight

    local tile_count = 0
    for j=1,tset_height do
      for i=1, tset_width do
        local x = tset_width  * (i - 1)
        local y = tset_height * (j - 1)
        local q = love.graphics.newQuad(
          x,
          y,
          tileset.tilewidth,
          tileset.tileheight,
          tileset.imagewidth,
          tileset.imageheight
        )

        tiles[tile_count + tileset.firstgid] = {
          quad       = q,
          tilewidth  = tileset.tilewidth,
          tileheight = tileset.tileheight,
          img        = img
        }

        tile_count = tile_count + 1
      end
    end
  end

  return tiles
end


local function load_tilelayers(tiled_map, tiles)
  for i, layer in ipairs(tiled_map.layers) do
    local tilelayer = {}
    if layer.type == 'tilelayer' then
      local data = {}
      for i, tile_index in ipairs(layer.data) do
        if tile_index ~= 0 then
          table.insert(data, {index=i, tile=tiles[tile_index]})
        end
      end
      layer.data = data
    end
  end
end

local function load_level(lvlid)
  lvl_file = assets.levels[lvlid]

  if lvlid == nil then
    error('level with level given level id not found:' .. strin(lvlid))
  end

  local map = load_tiled_file(lvl_file)
  local tiles = load_tiles(map)
  load_tilelayers(map, tiles)

  return map
end

function LevelScreenState:enter(from, lvlid)
  self.lvl = load_level(lvlid)
  self.camera = Camera(320, 200)
end


function LevelScreenState:draw()
  self.camera:attach()
  for i, layer in ipairs(self.lvl.layers) do
    if layer.type == 'tilelayer' then
      for j, tiledata in ipairs(layer.data) do
        love.graphics.draw(
          tiledata.tile.img,
          tiledata.tile.quad,
          self.lvl.tilewidth * ((tiledata.index - 1) % self.lvl.width),
          self.lvl.tileheight * math.floor(tiledata.index / self.lvl.width)
        )
      end
    end
  end
  self.camera:detach()
end


function LevelScreenState:keypressed(key)
  if key =='left' then
    self.camera:move(-20,0)
  end
  if key =='right' then
    self.camera:move(20,0)
  end
  if key =='up' then
    self.camera:move(0, -20)
  end
  if key =='down' then
    self.camera:move(0, 20)
  end
end

function LevelScreenState:keyreleased(key)
end

return LevelScreenState
