class Miner.Session
  constructor: () ->
    @days = 0

    @money = 0
    @ore = 0
    @orePrice = @START_PRICE
    @lastOrePriceChange = 0

    @wage = 10
    @workers = 0
    @workersRequested = 0
    @morale = 1

  buildBuilding: (world, tile, buildingType) ->
    placeable = world.canPlaceBuilding(tile, buildingType)
    if placeable != Miner.Error.SUCCESS
      return placeable

    if not @_deductMoney(buildingType.cost)
      return Miner.Error.INSUFFICIENT_FUNDS

    tile.placeBuilding(buildingType)

    return Miner.Error.SUCCESS

  mineForOre: (tonsProducable, tonsProcessable, storageCapacity) ->
    tonsProduced = _.min([ tonsProducable, tonsProcessable ])
    totalOre = @ore + tonsProduced
    if totalOre > storageCapacity
      wastedOre = totalOre - storageCapacity
      totalOre = storageCapacity

    @ore = totalOre

  advanceTime: (world) ->
    world.advanceTime()

    workers = if @workers == 0 then 1 else @workers
    healthRating = _.clamp(world.aggregateProperty('healthProduction') / workers, 0, 1)
    foodRating = _.clamp(world.aggregateProperty('foodProduction') / workers, 0, 1)
    livingRating = _.clamp(world.aggregateProperty('livingCapacity') / workers, 0, 1)

    workRating = _.clamp(workers / world.aggregateProperty('workersRequired'), 0, 1)
    tonsProducable = world.aggregateProperty('oreProduction') * workRating
    tonsProcessable = world.aggregateProperty('processingCapacity') * workRating
    storageCapacity = world.aggregateProperty('storageCapacity')
    
    @payWorkers()

    @computeMorale(livingRating, foodRating, healthRating)

    @addNewHires()
    @checkForLeavingWorkers()
    @checkForDeaths(healthRating, foodRating)

    # You don't earn interest on newly mined ore, only on ore you had from last turn.
    @earnInterest()
    @mineForOre(tonsProducable, tonsProcessable, storageCapacity)

    # Check for broken-down buildings.

    # Check for disasters.

    @days++

    # Check for collection day.
    @checkCollection()

  @newSession: ->
    new Miner.Session()

_.extend(Miner.Session.prototype, Miner.Workers)
_.extend(Miner.Session.prototype, Miner.Money)

