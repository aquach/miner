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
      public remainingBuildingConstructionDays: number) {
    }

    distanceToTile(tile: Tile) {
      return this.distanceTo(tile.x, tile.y);
    }

    distanceTo(x: number, y: number) {
      return Tile.distanceBetween(x, y, this.x, this.y);
    }

    isAdjacentTo(tile: Tile) {
      return this.distanceToTile(tile) === 1;
    }

    isConstructedBuilding() {
      return this.buildingType !== null && this.remainingBuildingConstructionDays === 0;
    }

    isUnderConstruction() {
      return this.buildingType !== null && this.remainingBuildingConstructionDays > 0;
    }
  }

  export module Tile {
    export function distanceBetween(x1: number, y1: number, x2: number, y2: number) {
      var z1 = 0 - x1 - y1;
      var z2 = 0 - x2 - y2;
      return _.max([
        Math.abs(x1 - x2),
        Math.abs(y1 - y2),
        Math.abs(z1 - z2)
      ]);
    }

    export function fromJSON(t: {}) {
      var tile = new Tile(null, null, null, null, null);
      _.merge(tile, t);
      return tile;
    }
  }
}
