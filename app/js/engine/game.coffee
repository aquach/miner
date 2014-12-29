class Miner.Game
  constructor: (world, session) ->
    @world = world
    @session = session

  @createNewGame: ->
    world = Miner.World.newWorld(8, 8, 3, 0.025, 0.05)
    session = Miner.Session.newSession()
    session.money = 10000
    new Game(world, session)

  @loadGame: () ->

