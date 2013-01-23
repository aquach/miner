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

