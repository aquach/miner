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

