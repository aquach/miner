describe 'Workers', ->
  beforeEach -> 
    @session = Miner.Session.newSession()

  it 'pays workers their wage', ->
    @session.money = 200
    @session.workers = 10
    @session.wage = 3
    @session.payWorkers()
    expect(@session.money).toBe(200 - 10 * 3)

  it 'changes wage if there is not enough money', ->
    @session.money = 200
    @session.workers = 11
    @session.wage = 300
    @session.payWorkers()
    expect(@session.money).toBe(2)
    expect(@session.wage).toBe(18)

  it 'hires people', ->
    @session.workers = 0
    @session.hireWorkers(20)
    @session.addNewHires()
    expect(@session.workers).toBeGreaterThan(0)
    expect(@session.workersRequested).toBeLessThan(20)
    for i in [0..50]
      @session.addNewHires()
    expect(@session.workers).toBe(20)
    expect(@session.workersRequested).toBe(0)

  it 'fires people', ->
    @session.workers = 50
    @session.fireWorkers(20)
    expect(@session.workers).toBe(30)

  it 'does not go below 0 workers when firing people', ->
    @session.workers = 5
    @session.fireWorkers(20)
    expect(@session.workers).toBe(0)

  it 'computes morale', ->
    @session.morale = 1
    @session.wage = 0
    @session.computeMorale(0, 0, 0)
    expect(@session.morale).toBeLessThan(1)

  it 'checks for worker deaths from lack of health care', ->
    @session.workers = 10
    _.times(30, => @session.checkForDeaths(1, 0))
    expect(@session.workers).toBeLessThan(10)

  it 'checks for worker deaths from starving', ->
    @session.workers = 10
    _.times(30, => @session.checkForDeaths(0, 1))
    expect(@session.workers).toBeLessThan(10)
  
  it 'checks for workers staying when they are happy', ->
    @session.morale = 1
    @session.workers = 30
    _.times(30, => @session.checkForLeavingWorkers())
    expect(@session.workers).toBe(30)

  it 'checks for workers leaving when they are sad', ->
    @session.morale = 0
    @session.workers = 30
    _.times(30, => @session.checkForLeavingWorkers())
    expect(@session.workers).toBeLessThan(30)

