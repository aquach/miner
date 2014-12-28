/// <reference path="terrain-type.ts" />

interface BuildingType {
  id: number;
  name: string;
  cost: number;
  validTerrain: TerrainType;
  constructionTime: number;
  oreProduction: number;
  miningCapacity: number;
  labCapacity: number;
  sickbayCapacity: number;
  opsCapacity: number;
}

module Buildings {
  export var buildings: { [k: string]: BuildingType } = {
    MOTHERSHIP: {
      id: 1,
      name: 'Mothership',
      cost: 0,
      validTerrain: TerrainType.BARE,
      constructionTime: 0,
      oreProduction: 1,
      miningCapacity: 5,
      labCapacity: 5,
      sickbayCapacity: 5,
      opsCapacity: 5
    },
    MINE: {
      id: 1,
      name: 'Mine',
      cost: 600,
      validTerrain: TerrainType.VEIN,
      constructionTime: 15,
      oreProduction: 10,
      miningCapacity: 5,
      labCapacity: 0,
      sickbayCapacity: 0,
      opsCapacity: 0
    },
    LAB: {
      id: 2,
      name: 'Lab',
      cost: 200,
      validTerrain: TerrainType.BARE,
      constructionTime: 5,
      oreProduction: 0,
      miningCapacity: 0,
      labCapacity: 5,
      sickbayCapacity: 0,
      opsCapacity: 0
    },
    SICKBAY: {
      id: 3,
      name: 'Sickbay',
      cost: 200,
      validTerrain: TerrainType.BARE,
      constructionTime: 5,
      oreProduction: 0,
      miningCapacity: 0,
      labCapacity: 0,
      sickbayCapacity: 5,
      opsCapacity: 0
    },
    OPS: {
      id: 4,
      name: 'Ops Center',
      cost: 200,
      validTerrain: TerrainType.BARE,
      constructionTime: 5,
      oreProduction: 0,
      miningCapacity: 0,
      labCapacity: 0,
      sickbayCapacity: 0,
      opsCapacity: 5
    }
  };
}
