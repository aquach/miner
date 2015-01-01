/// <reference path="terrain-type.ts" />

module Miner {
  export interface BuildingType {
    id: number;
    name: string;
    cost: number;
    validTerrain: TerrainType;
    constructionDays: number;
    antiProximity: { [ id: string ]: number };
  }

  export module BuildingType {
    export var MOTHERSHIP: BuildingType = {
      id: 1,
      name: 'Mothership',
      cost: 0,
      validTerrain: TerrainType.BARE,
      constructionDays: 0,
      antiProximity: {}
    };

    export var MINE: BuildingType = {
      id: 2,
      name: 'Mine',
      cost: 1000,
      validTerrain: TerrainType.VEIN,
      constructionDays: 10,
      antiProximity: {
        7: 1
      }
    };

     export var REACTOR: BuildingType = {
      id: 3,
      name: 'Reactor',
      cost: 1000,
      validTerrain: TerrainType.BARE,
      constructionDays: 5,
      antiProximity: {
        4: 1,
        7: 1
      }
    };

    export var CANTEEN: BuildingType = {
      id: 4,
      name: 'Canteen',
      cost: 500,
      validTerrain: TerrainType.BARE,
      constructionDays: 5,
      antiProximity: {
        3: 1,
        4: 1
      }
    };

    export var TUBE: BuildingType = {
      id: 5,
      name: 'Tube',
      cost: 100,
      validTerrain: TerrainType.BARE,
      constructionDays: 1,
      antiProximity: {}
    };

    export var SPACEBANK: BuildingType = {
      id: 6,
      name: 'Spacebank',
      cost: 1000,
      validTerrain: TerrainType.BARE,
      constructionDays: 5,
      antiProximity: {
        6: 100
      }
    };

    export var QUARTERS: BuildingType = {
      id: 7,
      name: 'Quarters',
      cost: 500,
      validTerrain: TerrainType.BARE,
      constructionDays: 5,
      antiProximity: {
        2: 1,
        3: 1
      }
    };

    export var buildableBuildings = [ MINE, REACTOR, QUARTERS, CANTEEN, TUBE, SPACEBANK ];
  }
}
