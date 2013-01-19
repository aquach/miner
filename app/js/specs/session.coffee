describe 'Session', ->
  it 'makes sessions', ->
    expect(Miner.Session.newSession()).toBeTruthy()

  describe 'building buildings', ->
    beforeEach -> 
      @session = Miner.Session.newSession()
      @world = Miner.World.newWorld(5, 5, 0.25, 0.25)

    #it 'refuses to buy buildings that are too expensive', ->
    #  expect(@session.buildBuilding(@world, 0, 0, 0, Miner.BuildingType.MINE)

    #it 'refuses to buy buildings that are not placeable', ->
    #  expect(@session.buildBuilding(@world, 0, 0, 0, Miner.BuildingType.MINE)
