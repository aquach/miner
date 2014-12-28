/// <reference path="../../../public/third-party-js/lodash.d.ts" />
/// <reference path="building-type.ts" />
/// <reference path="terrain-type.ts" />

class Tile {
  constructor(
    public x: number,
    public y: number,
    public z: number,
    public terrainType: TerrainType,
    public buildingType: BuildingType,
    public remainingBuildingConstructionTime: number) {
  }

  distanceTo(tile: Tile) {
    return _.min([
      Math.abs(tile.x - this.x),
      Math.abs(tile.y - this.y),
      Math.abs(tile.z - this.z)
    ]);
  }

  isAdjacentTo(tile: Tile) {
    return this.distanceTo(tile) === 1;
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
