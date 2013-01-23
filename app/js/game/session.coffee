Workers =
  payWorkers: ->
    amountToPay = @workers * @wage
    if not @_deductMoney(amountToPay)
      # Recompute wage using all money remaining.
      @wage = Math.floor(@money / @workers)
      @_deductMoney(@workers * @wage)

  hireWorkers: (numWorkers) ->
    @workersRequested += numWorkers

  HIRING_SPEED: 0.35
  addNewHires: ->
    if @workersRequested == 0
      return

    workers = _.max([ @workers, 10 ])
    fraction = @workersRequested / workers
    fractionAllowed = _.clamp(fraction * @HIRING_SPEED, 0.05, 0.3)
    newWorkers = _.min([ Math.floor(workers * fractionAllowed), @workersRequested ])

    if newWorkers == 0 and @workersRequested > 0
      newWorkers = 1

    @workers += newWorkers
    @workersRequested -= newWorkers

  fireWorkers: (numWorkers) ->
    if numWorkers > @workers
      numWorkers = @workers
    @workers -= numWorkers

  LEAVING_ROLL_CHANCE: 0.4
  checkForLeavingWorkers: ->
    if Math.random() < @LEAVING_ROLL_CHANCE 
      leavingFraction = _.clamp(Math.pow(0.02, (@morale + 0.5)), 0, 1)
      numWorkersLeaving = Math.floor(@workers * leavingFraction)
      @workers -= numWorkersLeaving

  HEALTH_DEATH_ROLL_CHANCE: 0.2
  HEALTH_DEATH_CHANCE: 0.15
  STARVING_DEATH_RATE: 0.02
  checkForDeaths: (foodRating, healthRating) ->
    if Math.random() < @HEALTH_DEATH_ROLL_CHANCE
      workerDeaths = 0
      for worker in [0..@workers - 1]
        if Math.random() < @HEALTH_DEATH_CHANCE * (1 - healthRating)
          workerDeaths++
      @workers -= workerDeaths

    # Starving to death rolls every round.
    workerDeaths = 0
    for worker in [0..@workers - 1]
      if Math.random() < @STARVING_DEATH_RATE * (1 - foodRating)
        workerDeaths++
    @workers -= workerDeaths

  MORALE_CHANGE_SPEED: 0.25
  computeMorale: (livingRating, foodRating, healthRating) ->
    wageFactor = _.clamp(Math.pow(@wage / 50, 0.6), 0, 1)
    livingFactor = _.clamp(Math.pow(livingRating, 2), 0, 1)
    foodFactor = _.clamp(Math.pow(foodRating, 2), 0, 1)
    healthFactor = _.clamp(Math.pow(healthRating, 2), 0, 1)

    average = _.sum([ wageFactor, livingFactor, foodFactor, healthFactor ]) / 4
    @morale = average * @MORALE_CHANGE_SPEED + @morale * (1 - @MORALE_CHANGE_SPEED)

class Miner.Session
  constructor: () ->
    @money = 0
    @ore = 0

    @wage = 10
    @workers = 0
    @workersRequested = 0
    @morale = 1

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

    @mineForOre(tonsProducable, tonsProcessable, storageCapacity)

    # Check for broken-down buildings.

    # Check for disasters.

  @newSession: ->
    new Miner.Session()

_.extend(Miner.Session.prototype, Workers)

