/// <reference path="building-type.ts" />
/// <reference path="tile.ts" />
/// <reference path="result.ts" />
/// <reference path="util.ts" />

module Miner {
  export interface BuildingStats {
    oreProduction: number;
    miningCapacity: number;
    labCapacity: number;
    sickbayCapacity: number;
    opsCapacity: number;
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

    _index(x: number, y: number): number {
      return x * this.size + y;
    }

    // Buildings

    buildingStats(): BuildingStats {
      return {
        oreProduction: Util.sum(_.map(this._tiles, t => t.buildingType.oreProduction)),
        miningCapacity: Util.sum(_.map(this._tiles, t => t.buildingType.miningCapacity)),
        labCapacity: Util.sum(_.map(this._tiles, t => t.buildingType.labCapacity)),
        sickbayCapacity: Util.sum(_.map(this._tiles, t => t.buildingType.sickbayCapacity)),
        opsCapacity: Util.sum(_.map(this._tiles, t => t.buildingType.opsCapacity))
      };
    }

    countConstructedBuildings(buildingType: BuildingType): number {
      return _.filter(this._tiles, t => t.buildingType === buildingType && t.isConstructedBuilding()).length;
    }

    mothershipTile() {
      return _.find(this._tiles, t => t.buildingType == BuildingType.MOTHERSHIP);
    }

    canPlaceBuilding(tile: Tile, buildingType: BuildingType): Result {
      var isAdjacent = _.some(this._tiles, t => t.isConstructedBuilding() && tile.isAdjacentTo(t))
      if (!isAdjacent)
        return Result.NOT_ADJACENT;
      else if (tile.terrainType !== buildingType.validTerrain)
        return Result.INVALID_TERRAIN;
      else if (this.getTile(tile.x, tile.y).buildingType !== null)
        return Result.TILE_FILLED;
      else
        return Result.SUCCESS;
    }
    
    allPotentialBuildingTiles(buildingType: BuildingType) {
      return _.filter(this._tiles, t => this.canPlaceBuilding(t, buildingType) === Result.SUCCESS);
    }

    advanceTime() {
      _.each(this._tiles, t => {
        if (t.isUnderConstruction())
          t.remainingBuildingConstructionTime--;
      });
    }
  }

  export module World {
    export function newWorld(size: number, mountainProbability: number, veinProbability: number): World {
      var world = new World(size);
      _.each(_.range(-size, size), x => {
        _.each(_.range(-size, size), y => {
          var rand = Math.random();

          var terrainType: TerrainType;
          if (rand < mountainProbability)
            terrainType = TerrainType.MOUNTAIN;
          else if (rand < mountainProbability + veinProbability)
            terrainType = TerrainType.VEIN;
          else
            terrainType = TerrainType.BARE;

          var tile = new Tile(x, y, terrainType, null, 0);
          if (tile.distanceTo(0, 0) <= size)
            world._setTile(tile);
        });
      });

      var tile = world.getTile(0, 0);
      tile.terrainType = TerrainType.BARE;
      tile.buildingType = BuildingType.MOTHERSHIP;

      return world;
    }
  }
}
