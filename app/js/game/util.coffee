Miner.Util = {}

Miner.Util.createEnum = (list...) ->
  obj = {}
  id = 1
  _.each(list, (item) ->
    obj[item] =
      id: id,
      name: item
      toString: () -> item
    id++
  )
  obj

_.mixin(
  clamp: (value, low, high) ->
    if value < low
      low
    else if value > high
      high
    else
      value
  sum: (list) ->
    _.reduce(list, ((memo, num) -> memo + num), 0)
)

(->
  randomCache = null
  Miner.Util.sampleNormal = (mean, sigma) ->
    if randomCache?
      value = randomCache
      randomCache = null
    else
      u1 = Math.random()
      u2 = Math.random()
      coeff = Math.sqrt(-2 * Math.log(u1))
      value = coeff * Math.cos(2 * Math.PI * u1)
      randomCache = coeff * Math.sin(2 * Math.PI * u2)

    mean + sigma * value
)()
