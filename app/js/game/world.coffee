class Miner.World
  constructor: (width, height, levels) ->
    @tiles = [] 
    @width = width
    @height = height
    @levels = levels

  setTile: (tile) ->
    @tiles[@_index(tile.col, tile.row, tile.level)] = tile
    
  getTile: (col, row, level) ->
    @tiles[@_index(col, row, level)]

  _index: (col, row, level) ->
    level * (@width * @height) + row * @width + col

  @newWorld: (width, height, levels, mountainProbability, veinProbability) ->
    console.log(width)
    world = new World(width, height, levels)
    _.each(_.range(levels), (level) =>
      _.each(_.range(width), (col) =>
        _.each(_.range(height), (row) =>
          tile = new Miner.Tile(col, row, level)

          rand = Math.random()
          if rand < mountainProbability
            tile.terrainType = Miner.TerrainType.MOUNTAIN
          else if rand < mountainProbability + veinProbability and
            world.getTile(col, row, level - 1)?.terrainType != Miner.TerrainType.VEIN
              tile.terrainType = Miner.TerrainType.VEIN
          else
            tile.terrainType = Miner.TerrainType.ROUGH

          world.setTile(tile)
        )
      )
    )

    world
