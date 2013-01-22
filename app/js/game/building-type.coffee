Miner.BuildingType =
  BULLDOZER:
    id: 0
    cost: 5
    validTerrain: [ Miner.TerrainType.ROUGH, Miner.TerrainType.BARE ]
    canBuildOverBuildings: true
    constructionTime: 1
  MOTHERSHIP:
    id: 1
    cost: 100000000
  MINE: 
    id: 2
    cost: 1000
    validTerrain: [ Miner.TerrainType.VEIN ]
    constructionTime: 3
    workerCapacity: 10
  PROCESSOR:
    id: 3
    cost: 2000
    constructionTime: 3
    workerCapacity: 30
    canBreakDown: true
  QUARTERS:
    id: 4
    cost: 750
    constructionTime: 3
    workerCapacity: 0
    canBreakDown: true
  SPACEPORT:
    id: 5
    cost: 1000
    constructionTime: 4
    workerCapacity: 20
    canBreakDown: true
  STORAGE:
    id: 6
    cost: 500
    constructionTime: 2
    canBreakDown: true
  TUBE:
    id: 7
    cost: 250
    constructionTime: 1
  HYDROPONICS:
    id: 8
    cost: 750
    constructionTime: 3
    workerCapacity: 5
    canBreakDown: true
  SICKBAY:
    id: 9
    cost: 750
    constructionTime: 3
    workerCapacity: 5
    canBreakDown: true

for type of Miner.BuildingType
  _.defaults(Miner.BuildingType[type],
    cost: 0
    validTerrain: [ Miner.TerrainType.BARE ]
    canBuildOverBuildings: false
    constructionTime: 0
    workerCapacity: 0
    canBreakDown: false
  )

