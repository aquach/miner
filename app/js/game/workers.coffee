Miner.Workers =
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

