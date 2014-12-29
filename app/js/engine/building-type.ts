/// <reference path="terrain-type.ts" />

module Miner {
  export interface BuildingType {
    id: number;
    name: string;
    cost: number;
    validTerrain: TerrainType;
    constructionDays: number;
    oreProduction: number;
    miningCapacity: number;
    techCapacity: number;
    medicalCapacity: number;
    opsCapacity: number;
  }

  export module BuildingType {
    export var MOTHERSHIP: BuildingType = {
      id: 1,
      name: 'Mothership',
      cost: 0,
      validTerrain: TerrainType.BARE,
      constructionDays: 0,
      oreProduction: 1,
      miningCapacity: 5,
      techCapacity: 5,
      medicalCapacity: 5,
      opsCapacity: 5
    };

    export var MINE: BuildingType = {
      id: 1,
      name: 'Mine',
      cost: 600,
      validTerrain: TerrainType.VEIN,
      constructionDays: 15,
      oreProduction: 10,
      miningCapacity: 5,
      techCapacity: 0,
      medicalCapacity: 0,
      opsCapacity: 0
    };

     export var LAB: BuildingType = {
      id: 2,
      name: 'Lab',
      cost: 200,
      validTerrain: TerrainType.BARE,
      constructionDays: 5,
      oreProduction: 0,
      miningCapacity: 0,
      techCapacity: 5,
      medicalCapacity: 0,
      opsCapacity: 0
    };

    export var SICKBAY: BuildingType = {
      id: 3,
      name: 'Sickbay',
      cost: 200,
      validTerrain: TerrainType.BARE,
      constructionDays: 5,
      oreProduction: 0,
      miningCapacity: 0,
      techCapacity: 0,
      medicalCapacity: 5,
      opsCapacity: 0
    };

    export var OPS: BuildingType = {
      id: 4,
      name: 'Ops Center',
      cost: 200,
      validTerrain: TerrainType.BARE,
      constructionDays: 5,
      oreProduction: 0,
      miningCapacity: 0,
      techCapacity: 0,
      medicalCapacity: 0,
      opsCapacity: 5
    };

    export var buildableBuildings = [ MINE, LAB, SICKBAY, OPS ];
  }
}
