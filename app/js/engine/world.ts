/// <reference path="building-type.ts" />
/// <reference path="tile.ts" />
/// <reference path="result.ts" />
/// <reference path="util.ts" />

module Miner {
  export interface Coords {
    x: number;
    y: number;
  }

  export class World {
    _tiles: Tile[];

    constructor(public size: number) {
      this._tiles = [];
    }

    // Tiles

    _setTile(tile: Tile) {
      this._tiles[this._index(tile.x, tile.y)] = tile;
    }
      
    getTile(x: number, y: number): Tile {
      return this._tiles[this._index(x, y)];
    }

    _validCoordinates(): Coords[] {
      var validTiles: Coords[] = [];
      _.each(_.range(-this.size, this.size + 1), x => {
        _.each(_.range(-this.size, this.size + 1), y => {
          if (Tile.distanceBetween(0, 0, x, y) <= this.size)
            validTiles.push({ x: x, y: y });
        });
      });
      return validTiles;
    }

    getAllTiles(): Tile[] {
      return _.map(this._validCoordinates(), c => this.getTile(c.x, c.y));
    }

    _index(x: number, y: number): number {
      // Sloppy indexing that wastes a little space.
      var margin = this.size * 2 + 2;
      return (x + this.size) * margin + (y + this.size);
    }

    // Buildings

    numConstructedBuildings(): number {
      return _.filter(this.getAllTiles(), t => t.isConstructedBuilding()).length;
    }

    countConstructedBuildings(buildingType: BuildingType): number {
      return _.filter(this.getAllTiles(), t => t.buildingType === buildingType && t.isConstructedBuilding()).length;
    }

    placeBuilding(x: number, y: number, buildingType: BuildingType) {
      var tile = this.getTile(x, y);
      tile.buildingType = buildingType;
      tile.remainingBuildingConstructionDays = buildingType.constructionDays;
      dispatcher.trigger('update');
    }

    canPlaceBuilding(x: number, y: number, buildingType: BuildingType): Result {
      var tile = this.getTile(x, y);
      var isAdjacent = _.some(this.getAllTiles(), t => t.isConstructedBuilding() && tile.isAdjacentTo(t))

      var tooCloseToOtherBuilding = _.some(this.getAllTiles(),
        t => _.some(buildingType.antiProximity, (dist: number, buildingTypeID: string) => t.buildingType !== null && t.buildingType.id === _.parseInt(buildingTypeID) && t.distanceTo(x, y) <= dist));

      if (!isAdjacent)
        return Result.NOT_ADJACENT;
      if (tooCloseToOtherBuilding)
        return Result.TOO_CLOSE_TO_BAD_BUILDING;
      else if (tile.terrainType !== buildingType.validTerrain)
        return Result.INVALID_TERRAIN;
      else if (tile.buildingType !== null)
        return Result.TILE_FILLED;
      else
        return Result.SUCCESS;
    }
    
    allPotentialBuildingTiles(buildingType: BuildingType) {
      return _.filter(this.getAllTiles(), t => this.canPlaceBuilding(t.x, t.y, buildingType) === Result.SUCCESS);
    }

    advanceConstruction() {
      _.each(this.getAllTiles(), t => {
        if (t.isUnderConstruction())
          t.remainingBuildingConstructionDays--;
      });
    }
  }

  export module World {
    export function newWorld(size: number, mountainProbability: number, veinProbability: number): World {
      var world = new World(size);
      _.each(world._validCoordinates(), c => {
        var rand = Math.random();

        var terrainType: TerrainType;
        if (rand < mountainProbability)
          terrainType = TerrainType.MOUNTAIN;
        else if (rand < mountainProbability + veinProbability)
          terrainType = TerrainType.VEIN;
        else
          terrainType = TerrainType.BARE;

        var tile = new Tile(c.x, c.y, terrainType, null, 0);
        world._setTile(tile);
      });

      var tile = world.getTile(0, 0);
      tile.terrainType = TerrainType.BARE;
      tile.buildingType = BuildingType.MOTHERSHIP;

      return world;
    }

    export function fromJSON(json: any) {
      var world = new World(json.size);
      world._tiles = _.map(json._tiles, t => Tile.fromJSON(t));
      return world;
    }
  }
}
