class Miner.Session
  constructor: () -> 
    @money = 0

  _deductMoney: (amount) ->
    if @money - amount < 0
      return false

    @money -= amount
    return true

  buildBuilding: (world, tile, buildingType) ->
    placeable = world.canPlaceBuilding(tile, buildingType)
    if placeable != Miner.Error.SUCCESS
      return placeable

    if not @_deductMoney(buildingType.cost)
      return Miner.Error.INSUFFICIENT_FUNDS

    tile.buildingType = buildingType
    tile.remainingBuildingConstructionTime = buildingType.constructionTime

    return Miner.Error.SUCCESS

  advanceTime: (world) ->
    world.advanceTime()

  @newSession: ->
    new Session()

