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

  describe 'workers', ->
    beforeEach -> 
      @session = Miner.Session.newSession()

    it 'pays workers their wage', ->
      @session.money = 200
      @session.workers = 10
      @session.wage = 3
      @session.payWorkers()
      expect(@session.money).toBe(200 - 10 * 3)

    it 'changes wage if there is not enough money', ->
      @session.money = 200
      @session.workers = 11
      @session.wage = 300
      @session.payWorkers()
      expect(@session.money).toBe(2)
      expect(@session.wage).toBe(18)

    it 'hires people', ->
      @session.workers = 0
      @session.hireWorkers(20)
      @session.addNewHires()
      expect(@session.workers).toBeGreaterThan(0)
      expect(@session.workersRequested).toBeLessThan(20)
      for i in [0..50]
        @session.addNewHires()
      expect(@session.workers).toBe(20)
      expect(@session.workersRequested).toBe(0)

    it 'fires people', ->
      @session.workers = 50
      @session.fireWorkers(20)
      expect(@session.workers).toBe(30)

    it 'does not go below 0 workers when firing people', ->
      @session.workers = 5
      @session.fireWorkers(20)
      expect(@session.workers).toBe(0)

    it 'computes morale', ->
      @session.morale = 1
      @session.wage = 0
      @session.computeMorale(0, 0, 0)
      expect(@session.morale).toBeLessThan(1)

    it 'checks for worker deaths from lack of health care', ->
      @session.workers = 10
      _.times(30, => @session.checkForDeaths(1, 0))
      expect(@session.workers).toBeLessThan(10)

    it 'checks for worker deaths from starving', ->
      @session.workers = 10
      _.times(30, => @session.checkForDeaths(0, 1))
      expect(@session.workers).toBeLessThan(10)
    
    it 'checks for workers staying when they are happy', ->
      @session.morale = 1
      @session.workers = 30
      _.times(30, => @session.checkForLeavingWorkers())
      expect(@session.workers).toBe(30)

    it 'checks for workers leaving when they are sad', ->
      @session.morale = 0
      @session.workers = 30
      _.times(30, => @session.checkForLeavingWorkers())
      expect(@session.workers).toBeLessThan(30)

  describe 'when mining for ore', ->
    beforeEach ->
      @session = Miner.Session.newSession()

    it 'drops ore if it cannot be processed', ->
      @session.ore = 0
      @session.mineForOre(40, 25, 50)
      expect(@session.ore).toBe(25)

    it 'only adds what can be mined', ->
      @session.ore = 0
      @session.mineForOre(25, 40, 50)
      expect(@session.ore).toBe(25)

    it 'caps the amount at storage capacity', ->
      @session.ore = 50
      @session.mineForOre(25, 40, 50)
      expect(@session.ore).toBe(50)
