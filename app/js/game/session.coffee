class Miner.Session
  constructor: () -> 
    @money = 0

  netWorth: () ->
    -10000

  _gameOver: () ->

  _deductMoney: (amount, forced = false) ->
    if @money - amount <= @netWorth()
      @_gameOver() if forced
      return false

    @money -= amount
    return true

  buildBuilding: (world, col, row, level, buildingType) ->
    placeable = world.canPlaceBuilding(col, row, level, buildingType)
    if placeable != Miner.Error.SUCCESS
      return placeable

    if not @_deductMoney(buildingType.cost)
      return Miner.Error.INSUFFICIENT_FUNDS

    tile = world.getTile(col, row, level)
    tile.buildingType = buildingType

    return Miner.Error.SUCCESS

  @newSession: ->
    new Session()
