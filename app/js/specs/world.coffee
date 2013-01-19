describe 'World', ->
  it 'makes new worlds with the correct number of tiles', ->
    [width, height, levels] = [ 5, 10, 2 ]
    world = Miner.World.newWorld(width, height, levels, 0.1, 0.1)
    expect(world.tiles.length).toBe width * height * levels
    expect(world.tiles[0]).not.toBeUndefined()

  it 'makes new worlds where veins are never above other veins', ->
    height = 100
    world = Miner.World.newWorld(1, 1, height, 0.0, 1.0)
    _.each(_.range(height), (level) ->
      tile = world.getTile(0, 0, level)
      expectedTile = if level % 2 == 0 then Miner.TerrainType.VEIN else Miner.TerrainType.ROUGH
      expect(tile.terrainType).toBe(expectedTile)
    )
