createEnum = (list...) ->
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

Miner.Error = createEnum(
  'SUCCESS',
  'INSUFFICIENT_FUNDS',
  'OUT_OF_BOUNDS',
  'INVALID_TERRAIN',
  'TILE_FILLED'
)
