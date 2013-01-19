class Miner.World
  constructor: (width, height, levels) ->
    @tiles = [] 
    @width = width
    @height = height
    @levels = levels

  _setTile: (tile) ->
    @tiles[@_index(tile.col, tile.row, tile.level)] = tile
    
  getTile: (col, row, level) ->
    tile = @tryGetTile(col, row, level)
    if tile
      tile
    else
      throw Miner.Error.OUT_OF_BOUNDS

  tryGetTile: (col, row, level) ->
    @tiles[@_index(col, row, level)]

  _index: (col, row, level) ->
    level * (@width * @height) + row * @width + col

  countBuildings: (buildingType) ->
    numBuildings = 0
    for level in [0..@levels - 1]
      for row in [0..@height - 1]
        for col in [0..@width - 1]
          if @getTile(col, row, level).buildingType == buildingType
            numBuildings++
    
    numBuildings

  @newWorld: (width, height, levels, mountainProbability, veinProbability) ->
    world = new World(width, height, levels)
    for level in [0..levels - 1]
      for row in [0..height - 1]
        for col in [0..width - 1]
          tile = new Miner.Tile(col, row, level)

          rand = Math.random()
          if rand < mountainProbability
            tile.terrainType = Miner.TerrainType.MOUNTAIN
          else if rand < mountainProbability + veinProbability and
            world.tryGetTile(col, row, level - 1)?.terrainType != Miner.TerrainType.VEIN
              tile.terrainType = Miner.TerrainType.VEIN
          else
            tile.terrainType = Miner.TerrainType.ROUGH

          world._setTile(tile)

    col = _.random(width - 1)
    row = _.random(height - 1)
    tile = world.getTile(col, row, 0)
    tile.buildingType = Miner.BuildingType.MOTHERSHIP

    world
