Miner.TerrainType = Miner.Util.createEnum(
  'ROUGH',
  'BARE',
  'MOUNTAIN',
  'VEIN'
)

class Miner.Tile
  constructor: (col, row, level) ->
    @col = col
    @row = row
    @level = level
    @terrainType = null
    @buildingType = null
    @buildingUnderConstruction = false

  isAdjacentTo: (tile) ->
    if tile.level != @level
      return false

    if (Math.abs(tile.row - @row) == 1 and tile.col == @col)
      return true
    if (Math.abs(tile.col - @col) == 1 and tile.row == @row)
      return true

    return false

  isConstructedBuilding: ->
    @buildingType != null and @buildingUnderConstruction == false
