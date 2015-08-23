local loader = {}

local assets = {
  levels = {
    'assets/lvls/lvl1.lua',
    'assets/lvls/lvl2.lua',
    'assets/lvls/lvl3.lua'
  },
}

local constructors = {
  Player   = player.new,
  Teenager = enemy.teenager.new,
  Granny   = enemy.granny.new,
  Book     = book.new
}

function loader.load_tiled_file(lvl_file)
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

function loader.load_tiles(tiled_map)
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


function loader.load_tilelayers(map, tiles)
  for i, layer in ipairs(map.layers) do
    local tilelayer = {}
    if layer.type == 'tilelayer' then
      local data = {}
      for i, tile_index in ipairs(layer.data) do
        if tile_index ~= 0 then
          local x = map.tilewidth * ((i - 1) % map.width)
          local y = map.tileheight * math.floor(i / map.width)
          table.insert(data, {
            index=i,
            tile=tiles[tile_index],
            pos=Vector(x,y),
            width=map.tilewidth,
            height=map.tileheight,
            name=layer.name,
          })
        end
      end
      layer.data = data
      layer.tilelayer = true
      layer.tilewidth = map.tilewidth
      layer.tileheight = map.tileheight
      layer.mapwidth = map.width
      layer.mapheight = map.height
      print('adding to entities ...')
      print(inspect(layer, {depth = 1}))
      ecs:addEntity(layer)
    end
  end
end

function loader.load_objectlayers(map, entity_constructors)
  local entities = {}
  for i, layer in ipairs(map.layers) do
    if layer.type == 'objectgroup' then
      for i, obj in ipairs(layer.objects) do
        if entity_constructors[obj.type] then
          local ent = entity_constructors[obj.type](map, obj)
          ent[obj.type] = true

          print('adding to entities ...')
          print(inspect(ent, {depth=1}))
          ecs:addEntity(ent)
        else
          print('could not find entity constructor for:'..obj.type)
        end
      end
    end
  end
end


function loader.load_collision(map)

  -- ground collision first
  for i, layer in ipairs(map.layers) do
    if layer.name == 'ground' then
      for i, tile in ipairs(layer.data) do
        physics:add(
          tile, 
          map.tilewidth * ((tile.index - 1) % map.width),
          map.tileheight * math.floor(tile.index / map.width),
          map.tilewidth,
          map.tileheight
        )
      end
    end
  end
--[[
  for i, entity in ipairs(map.entities) do
    if entity.collision then
      world:add(
        entity,
        entity.pos.x,
        entity.pos.y,
        entity.collision.width,
        entity.collision.height
      )
    end
  end
]]
end

function loader.load_level(lvlid)
  local lvl_file = assets.levels[tonumber(lvlid)]
  print('loading new level id: ' .. lvlid)
  print('loading new level: ' .. lvl_file)

  if lvlid == nil then
    error('level with level given level id not found:' .. strin(lvlid))
  end

  local map   = loader.load_tiled_file(lvl_file)
  local tiles = loader.load_tiles(map)




  loader.load_tilelayers(map, tiles)
  loader.load_objectlayers(map, constructors)
  loader.load_collision(map)
end

return loader
