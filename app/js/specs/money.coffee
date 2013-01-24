describe 'Money', ->
  beforeEach ->
    @session = Miner.Session.newSession()

  it 'advances the ore price', ->
    price = @session.orePrice
    @session.advanceOrePrice()
    newPrice = @session.orePrice
    expect(newPrice - price).toBe(@session.lastOrePriceChange)
    expect(Math.floor(newPrice * 100)).toBe(newPrice * 100)

  it 'sells ore', ->
    @session.ore = 50
    @session.orePrice = 25
    money = @session.money
    expect(@session.sellOre(49)).toBe(Miner.Error.SUCCESS)
    expect(@session.money).toBe(money + 49 * 25)

  it 'will not sell ore it does not have', ->
    @session.ore = 50
    expect(@session.sellOre(100)).toBe(Miner.Error.INSUFFICIENT_ORE)

  it 'earns interest', ->
    @session.ore = 50
    money = @session.money
    @session.earnInterest() 
    expect(@session.money).toBeGreaterThan(money)

  it 'checks for when collections are due and gives game over when you do not have enough money', ->
    @session.days = @session.collectionDays()[0].day
    expect(@session.checkCollection()).toBe(Miner.Error.GAME_OVER)

  it 'checks for when collections are due and deducts your money', ->
    @session.days = @session.collectionDays()[0].day
    @session.money = @session.collectionDays()[0].amount
    expect(@session.checkCollection()).toBe(Miner.Error.SUCCESS)
    expect(@session.money).toBe(0)

  it 'tells you about the next collection goal', ->
    firstDay = @session.collectionDays()[0].day
    expect(@session.nextCollectionGoal().day).toBe(firstDay)
    @session.days = firstDay
    expect(@session.nextCollectionGoal().day).toBe(@session.collectionDays()[1].day)
