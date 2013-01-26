COLLECTION_DAYS = [
  { day: 30, amount: 250000 },
  { day: 60, amount: 500000 },
  { day: 90, amount: 500000 },
  { day: 120, amount: 2500000 },
  { day: 150, amount: 5000000 },
  { day: 180, amount: 50000000 },
]

Miner.Money =
  _deductMoney: (amount) ->
    if @money - amount < 0
      return false

    @money -= amount
    @trigger('money:loss', amount)
    return true

  _gainMoney: (amount) ->
    @money += amount
    @trigger('money:gain', amount)

  START_PRICE: 20
  MIN_PRICE: 5
  advanceOrePrice: ->
    oldPrice = @orePrice
    @orePrice = Miner.Util.sampleNormal(0, 4)
    @orePrice += (@START_PRICE - @orePrice) * 0.1
    @orePrice = Math.floor(@orePrice * 100 + 0.5) / 100

    if @orePrice < @MIN_PRICE
      @orePrice = @MIN_PRICE
    
    @lastOrePriceChange = @orePrice - oldPrice

  sellOre: (amount) ->
    if @ore < amount
      return Miner.Error.INSUFFICIENT_ORE

    revenue = amount * @orePrice
    @_gainMoney(revenue)
    @ore -= amount

    Miner.Error.SUCCESS

  CONVERSION: 1
  earnInterest: ->
    revenue = @ore * @CONVERSION
    @_gainMoney(revenue)

  nextCollectionGoal: ->
    _.find(COLLECTION_DAYS, (goal) => @days < goal.day)

  checkCollection: ->
    collection = _.find(COLLECTION_DAYS, (goal) => @days == goal.day)
    if collection
      if not @_deductMoney(collection.amount)
        return Miner.Error.GAME_OVER

    Miner.Error.SUCCESS

  collectionDays: ->
    COLLECTION_DAYS
