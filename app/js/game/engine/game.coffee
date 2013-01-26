class Miner.Game
  constructor: (world, mine) ->
    @world = world
    @mine = mine

  @createNewGame: ->
    world = Miner.World.newWorld(8, 8, 3, 0.025, 0.05)
    session = Miner.Session.newSession
    new Game(world, session)

  @loadGame: () ->

