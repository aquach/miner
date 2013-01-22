class Miner.World
  constructor: (width, height, levels) ->
    @tiles = [] 
    @width = width
    @height = height
    @levels = levels

  # Tiles

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

  # Buildings

  countConstructedBuildings: (buildingType) ->
    (1 for tile in @tiles when tile.buildingType == buildingType and tile.isConstructedBuilding()).length

  mothershipTile: ->
    _.find(@tiles, (tile) -> tile.buildingType == Miner.BuildingType.MOTHERSHIP)

  canPlaceBuilding: (tile, buildingType) ->
    adjacency = _.some(@tiles, (t) -> t.isConstructedBuilding() and tile.isAdjacentTo(t))
    if not adjacency
      Miner.Error.NOT_ADJACENT
    else if tile.terrainType not in buildingType.validTerrain
      Miner.Error.INVALID_TERRAIN
    else if tile.buildingType != null and not buildingType.canBuildOverBuildings
      Miner.Error.TILE_FILLED
    else
      Miner.Error.SUCCESS

  placeBuilding: (tile, buildingType) ->
    tile.buildingType = buildingType
    tile.remainingBuildingConstructionTime = buildingType.constructionTime
  
  allPotentialBuildingTiles: (buildingType) ->
    tile for tile in @tiles when @canPlaceBuilding(tile, buildingType) == Miner.Error.SUCCESS

  advanceTime: ->
    finishedTiles = []
    for tile in @tiles
      if tile.isUnderConstruction()
        tile.remainingBuildingConstructionTime--
        if tile.remainingBuildingConstructionTime == 0
          finishedTiles.push(tile)

    # So that a tile doesn't get updated by an effect earlier in the same update.
    for tile in finishedTiles
      if tile.buildingType == Miner.BuildingType.BULLDOZER
        tile.buildingType = null
        tile.terrainType = Miner.TerrainType.BARE
      else if tile.buildingType == Miner.BuildingType.MINE
        belowTile = @tryGetTile(tile.col, tile.row, tile.level + 1)
        if belowTile?
          @placeBuilding(belowTile, Miner.BuildingType.MINE)

    
  # World generation

  @newWorld: (width, height, levels, mountainProbability, veinProbability, mothershipParams = null) ->
    world = new World(width, height, levels)
    for level in [0..levels - 1]
      for row in [0..height - 1]
        for col in [0..width - 1]
          tile = new Miner.Tile(col, row, level)

          if world.tryGetTile(col, row, level - 1)?.terrainType != Miner.TerrainType.VEIN
            rand = Math.random()
            if rand < mountainProbability
              tile.terrainType = Miner.TerrainType.MOUNTAIN
            else if rand < mountainProbability + veinProbability
              tile.terrainType = Miner.TerrainType.VEIN
          else
            tile.terrainType = Miner.TerrainType.ROUGH

          world._setTile(tile)

    if mothershipParams
      { col: col, row: row } = mothershipParams
    else
      col = _.random(width - 1)
      row = _.random(height - 1)

    tile = world.getTile(col, row, 0)
    tile.terrainType = Miner.TerrainType.BARE
    tile.buildingType = Miner.BuildingType.MOTHERSHIP

    world

