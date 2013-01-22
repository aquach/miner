Workers =
  payWorkers: ->
    amountToPay = @workers * @wage
    if not @_deductMoney(amountToPay)
      # Recompute wage using all money remaining.
      @wage = Math.floor(@money / @workers)
      @_deductMoney(@workers * @wage)

  hireWorkers: (numWorkers) ->
    @workersRequested += numWorkers

  HIRING_SPEED: 0.5
  addNewHires: ->
    if @workersRequested == 0
      return

    workers = _.max([ @workers, 10 ])
    fraction = @workersRequested / workers
    fractionAllowed = _.clamp(fraction * @HIRING_SPEED, 0.1, 0.4)
    newWorkers = _.min([ Math.floor(workers * fractionAllowed), @workersRequested ])

    @workers += newWorkers
    @workersRequested -= newWorkers

  fireWorkers: (numWorkers) ->
    if numWorkers > @workers
      numWorkers = @workers
    @workers -= numWorkers
  

class Miner.Session
  constructor: () -> 
    @money = 0

    @wage = 10
    @workers = 0
    @workersRequested = 0

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

  advanceTime: (world) ->
    world.advanceTime()
    
    @payWorkers()

    # Compute morale.

    @addNewHires()

    # Mine for ore.

    # Check for broken-down buildings.

    # Check for disasters.

  @newSession: ->
    new Miner.Session()

_.extend(Miner.Session.prototype, Workers)
