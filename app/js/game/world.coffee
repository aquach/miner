Miner.World = class World
  constructor: (width, height, levels) ->
    @tiles = [] 
    @width = width
    @height = height
    @levels = levels

  setTile: (tile) ->
    @tiles[@_index(tile)] = @tile
    
  getTile: (col, row, level) ->
    @tiles[@_index(tile)]

  _index: (tile) ->
    tile.level * (@width * @height) + tile.row * @width + tile.col

  @newWorld: (width, height, levels, mountainProbability, veinProbability) ->
    world = new World(width, height, levels)
    _.each(_.range(width), (col) =>
      _.each(_.range(height), (row) =>
        _.each(_.range(levels), (level) =>
          tile = new Tile(col, row, level)

          rand = Math.random
          if rand < mountainProbability
            tile.terrainType = TerrainType.MOUNTAIN
          else if rand < mountainProbability + veinProbability
            tile.terrainType = TerrainType.VEIN

          @setTile(tile)
        )
      )
    )
