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
    cost: 25
    power: 10
    validTerrain: [ Miner.TerrainType.VEIN ]
    constructionTime: 3
  PROCESSOR:
    id: 3
    cost: 30
    power: 10
    validTerrain: [ Miner.TerrainType.BARE ]
    constructionTime: 3
  POWER_PLANT:
    id: 4
    cost: 40
    power: 0
    validTerrain: [ Miner.TerrainType.BARE ]
    constructionTime: 3

