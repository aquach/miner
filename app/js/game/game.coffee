class Miner.Game
  constructor: (world, mine) ->
    @world = world
    @mine = mine

  @createNewGame: ->
    world = World.newWorld(10, 10, 3, 0.025, 0.05)
    session = Mine.newSession
    new Game(world, session)

  @loadGame: () ->

