/// <reference path="../../public/third-party-js/lodash.d.ts" />
/// <reference path="building-type.ts" />
/// <reference path="terrain-type.ts" />

module Miner {
  export class Tile {
    constructor(
      public x: number,
      public y: number,
      public terrainType: TerrainType,
      public buildingType: BuildingType,
      public remainingBuildingConstructionTime: number) {
    }

    distanceToTile(tile: Tile) {
      return this.distanceTo(tile.x, tile.y);
    }

    distanceTo(x: number, y: number) {
      var z = 0 - x - y;
      var thisZ = 0 - x - y;
      return _.min([
        Math.abs(x - this.x),
        Math.abs(y - this.y),
        Math.abs(z - thisZ)
      ]);
    }

    isAdjacentTo(tile: Tile) {
      return this.distanceToTile(tile) === 1;
    }

    isConstructedBuilding() {
      return this.buildingType !== null && this.remainingBuildingConstructionTime === 0;
    }

    isUnderConstruction() {
      return this.buildingType !== null && this.remainingBuildingConstructionTime > 0;
    }

    placeBuilding(buildingType: BuildingType) {
      this.buildingType = buildingType;
      this.remainingBuildingConstructionTime = buildingType.constructionTime;
    }
  }
}
