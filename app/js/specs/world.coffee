describe 'World', ->
  describe 'when constructing new worlds', ->
    it 'makes new worlds with the correct number of tiles', ->
      [ width, height, levels ] = [ 5, 10, 2 ]
      world = Miner.World.newWorld(width, height, levels, 0.1, 0.1)
      expect(world.tiles.length).toBe width * height * levels
      expect(world.tiles[0]).not.toBeUndefined()

    it 'makes new worlds where veins are only above rough', ->
      height = 100
      world = Miner.World.newWorld(1, 1, height, 0.5, 0.5)
      for level in [0..height - 1]
        tile = world.getTile(0, 0, level)
        aboveTile = world.tryGetTile(0, 0, level - 1)
        expectedTile = (if level == 0
          Miner.TerrainType.BARE
        else if aboveTile?.terrainType == Miner.TerrainType.VEIN
          Miner.TerrainType.ROUGH
        )
        if expectedTile
          expect(tile.terrainType).toBe(expectedTile)

    describe 'when setting mothership', ->
      it 'always constructs worlds with a mothership on the surface', ->
        world = Miner.World.newWorld(1, 1, 10, 0.2, 0.2)
        expect(world.getTile(0, 0, 0).buildingType).toBe(Miner.BuildingType.MOTHERSHIP)

      it 'puts the mothership on a bare tile', ->
        world = Miner.World.newWorld(1, 1, 10, 1, 1)
        expect(world.getTile(0, 0, 0).terrainType).toBe(Miner.TerrainType.BARE)

      it 'can force mothership location', ->
        world = Miner.World.newWorld(5, 5, 10, 0.2, 0.2, { col: 3, row: 3 })
        mothershipTile = world.mothershipTile()
        expect(mothershipTile.col).toBe(3)
        expect(mothershipTile.row).toBe(3)

  it 'errors when getting out of bounds tiles', ->
    world = Miner.World.newWorld(1, 1, 2, 0.2, 0.2)
    expect(-> world.getTile(-1, 2, 1)).toThrow()

  it 'finds the mothership tile', ->
    world = Miner.World.newWorld(1, 1, 2, 0.2, 0.2)
    mothershipTile = world.mothershipTile()
    expect(mothershipTile.col).toBe(0)
    expect(mothershipTile.row).toBe(0)

  it 'counts buildings', ->
    world = Miner.World.newWorld(3, 2, 6, 0.2, 0.2)
    world.getTile(0, 0, 0).buildingType = Miner.BuildingType.MINE
    world.getTile(1, 1, 1).buildingType = Miner.BuildingType.PROCESSOR
    world.getTile(2, 2, 2).buildingType = Miner.BuildingType.MINE
    expect(world.countConstructedBuildings(Miner.BuildingType.MINE)).toBe(2)
    expect(world.countConstructedBuildings(Miner.BuildingType.PROCESSOR)).toBe(1)
    
  describe 'when finding valid building locations', ->
    beforeEach ->
      @world = Miner.World.newWorld(5, 5, 10, 0.2, 0.2, { col: 3, row: 3 })

    it 'detects when buildings are not adjacent', ->
      expect(@world.canPlaceBuilding(@world.getTile(0, 0, 1), Miner.BuildingType.PROCESSOR))
        .toEqual(Miner.Error.NOT_ADJACENT)

    it 'detects when buildings are on invalid terrain', ->
      mountain = @world.getTile(3, 2, 0)
      mountain.terrainType = Miner.TerrainType.MOUNTAIN
      expect(@world.canPlaceBuilding(mountain, Miner.BuildingType.PROCESSOR))
        .toEqual(Miner.Error.INVALID_TERRAIN)

    it 'finds all potential building locations', ->
      @world.getTile(3, 2, 0).terrainType = Miner.TerrainType.MOUNTAIN
      @world.getTile(3, 4, 0).terrainType = Miner.TerrainType.BARE
      @world.getTile(2, 3, 0).terrainType = Miner.TerrainType.BARE
      expect(@world.allPotentialBuildingTiles(Miner.BuildingType.PROCESSOR).length)
        .toBe(2)

    describe 'when building on top of other buildings', ->
      beforeEach ->
        @mine = @world.getTile(3, 2, 0)
        @mine.terrainType = Miner.TerrainType.BARE
        @mine.buildingType = Miner.BuildingType.MINE

      it 'detects when buildings already exist', ->
        expect(@world.canPlaceBuilding(@mine, Miner.BuildingType.PROCESSOR))
          .toEqual(Miner.Error.TILE_FILLED)

      it 'detects when buildings can be built over', ->
        expect(@world.canPlaceBuilding(@mine, Miner.BuildingType.BULLDOZER))
          .toEqual(Miner.Error.SUCCESS)
  
  describe 'when advancing time', ->
    LEVELS = 10

    beforeEach ->
      @world = Miner.World.newWorld(5, 5, LEVELS, 0.2, 0.2, { col: 3, row: 3 })
      @mine = @world.getTile(3, 2, 0)
      @mine.terrainType = Miner.TerrainType.BARE
      @mine.buildingType = Miner.BuildingType.MINE

    it 'ticks down remaining time for buildings under construction', ->
      @mine.remainingBuildingConstructionTime = 1
      @world.advanceTime()
      expect(@mine.isConstructedBuilding()).toBe(true)

    it 'does not tick down remaining time for already constructed buildings', ->
      @mine.remainingBuildingConstructionTime = 1
      for t in [0..3]
        @world.advanceTime()
      expect(@mine.remainingBuildingConstructionTime).toBe(0)
      expect(@world.mothershipTile().remainingBuildingConstructionTime).toBe(0)

    it 'bulldozes land', ->
      bulldozer = @world.getTile(2, 2, 0)
      bulldozer.terrainType = Miner.TerrainType.ROUGH
      bulldozer.buildingType = Miner.BuildingType.BULLDOZER
      bulldozer.remainingBuildingConstructionTime = 1
      @world.advanceTime()
      expect(bulldozer.buildingType).toBe(null)
      expect(bulldozer.terrainType).toBe(Miner.TerrainType.BARE)

    it 'begins construction of new mine below', ->
      @mine.remainingBuildingConstructionTime = 1
      @world.advanceTime()
      belowTile = @world.getTile(@mine.col, @mine.row, @mine.level + 1)
      expect(belowTile.buildingType).toBe(Miner.BuildingType.MINE)
      expect(belowTile.remainingBuildingConstructionTime).toBe(Miner.BuildingType.MINE.constructionTime)

    it 'will not build new mine on the last level', ->
      mine = @world.getTile(3, 2, LEVELS - 1)
      mine.terrainType = Miner.TerrainType.BARE
      mine.buildingType = Miner.BuildingType.MINE
      mine.remainingBuildingConstructionTime = 1
      @world.advanceTime()

    it 'will not build new mine if a building already exists', ->
      @mine.remainingBuildingConstructionTime = 1
      belowTile = @world.getTile(@mine.col, @mine.row, @mine.level + 1)
      belowTile.terrainType = Miner.TerrainType.BARE
      belowTile.buildingType = Miner.BuildingType.PROCESSOR
      @world.advanceTime()
      expect(belowTile.buildingType).toBe(Miner.BuildingType.PROCESSOR)

