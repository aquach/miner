describe 'Session', ->
  it 'makes sessions', ->
    expect(Miner.Session.newSession()).toBeTruthy()

  describe 'building buildings', ->
    beforeEach -> 
      @session = Miner.Session.newSession()
      @world = Miner.World.newWorld(5, 5, 10, 0.25, 0.25, { col: 3, row: 3 })
      @tile = @world.getTile(3, 2, 0)
      @tile.terrainType = Miner.TerrainType.VEIN

    it 'refuses to buy buildings that are too expensive', ->
      expect(@session.buildBuilding(@world, @tile, Miner.BuildingType.MINE))
        .toEqual(Miner.Error.INSUFFICIENT_FUNDS)

    it 'will not decrement money for trying to place an invalid building', ->
      cost = Miner.BuildingType.PROCESSOR.cost
      @session.money = cost
      expect(@session.buildBuilding(@world, @tile, Miner.BuildingType.PROCESSOR))
        .not.toEqual(Miner.Error.SUCCESS)
      expect(@session.money).toBe(cost)

    describe 'when correctly placing a building', ->
      beforeEach ->
        @session.money = Miner.BuildingType.MINE.cost
        expect(@session.buildBuilding(@world, @tile, Miner.BuildingType.MINE))
          .toEqual(Miner.Error.SUCCESS)

      it 'decrements the correct amount', ->
        expect(@session.money).toBe(0)

      it 'sets the construction time correctly', ->
        expect(@tile.isUnderConstruction()).toBe(true)
        time = Miner.BuildingType.MINE.constructionTime
        expect(@tile.remainingBuildingConstructionTime).toBe(time)
        for t in [0..time - 1]
          @session.advanceTime(@world)
        expect(@tile.isUnderConstruction()).toBe(false)

