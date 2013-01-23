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
    storageCapacity: 200
    livingCapacity: 25
    foodProduction: 25
    healthProduction: 25
  MINE: 
    id: 2
    cost: 1000
    validTerrain: [ Miner.TerrainType.VEIN ]
    constructionTime: 3
    workersRequired: 10
    oreProduction: 10
  PROCESSOR:
    id: 3
    cost: 2000
    constructionTime: 3
    processingCapacity: 40
    workersRequired: 30
    canBreakDown: true
    surfaceOnly: true
  QUARTERS:
    id: 4
    cost: 750
    constructionTime: 3
    livingCapacity: 25
    workersRequired: 0
    canBreakDown: true
  SPACEPORT:
    id: 5
    cost: 1000
    constructionTime: 4
    workersRequired: 20
    canBreakDown: true
  STORAGE:
    id: 6
    cost: 500
    constructionTime: 2
    canBreakDown: true
    storageCapacity: 200
  TUBE:
    id: 7
    cost: 250
    constructionTime: 1
  HYDROPONICS:
    id: 8
    cost: 750
    constructionTime: 3
    workersRequired: 5
    canBreakDown: true
    foodProduction: 25
  SICKBAY:
    id: 9
    cost: 750
    constructionTime: 3
    workersRequired: 5
    canBreakDown: true
    healthProduction: 25

for type of Miner.BuildingType
  _.defaults(Miner.BuildingType[type],
    cost: 0
    validTerrain: [ Miner.TerrainType.BARE ]
    canBuildOverBuildings: false
    constructionTime: 0
    workersRequired: 0
    canBreakDown: false
    livingCapacity: 0
    oreProduction: 0
    processingCapacity: 0
    storageCapacity: 0
    foodProduction: 0
    healthProduction: 0
    surfaceOnly: false
  )

