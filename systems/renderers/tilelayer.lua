local TileLayerRenderer = tiny.processingSystem()

TileLayerRenderer.draw = true
TileLayerRenderer.with_camera = true

TileLayerRenderer.filter = tiny.requireAll('tilelayer')

function TileLayerRenderer:process(entity, dt)
  for j, tiledata in ipairs(entity.data) do
    love.graphics.draw(
      tiledata.tile.img,
      tiledata.tile.quad,
      entity.tilewidth * ((tiledata.index - 1) % entity.mapwidth),
      entity.tileheight * math.floor(tiledata.index / entity.mapwidth)
    )
  end

end


return TileLayerRenderer
