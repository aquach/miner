Miner.TerrainType =
  ROUGH: 0
  BARE: 1
  MOUNTAIN: 2
  VEIN: 3

Miner.BuildingType =
  MINE: 0

class Miner.Tile
  constructor: (col, row, level) ->
    @col = col
    @row = row
    @level = level
    @terrainType = null
    @buildingType = null
