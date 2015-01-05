package org.quach.miner.engine;

import com.badlogic.gdx.math.MathUtils;
import com.google.common.base.Function;
import com.google.common.base.Predicate;
import com.google.common.collect.Iterators;
import com.google.common.collect.Lists;

import javax.annotation.Nullable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class World {
  private Tile[] tiles;
  private List<Coords> validCoordinates;
  public final int size;

  public World(final int size) {
    this.size = size;
    tiles = new Tile[size * size * 10];
    validCoordinates = Lists.newArrayList();

    for (int x = -size; x <= size; x++)
      for (int y = -size; y <= size; y++)
        if (Tile.distanceBetween(0, 0, x, y) <= size)
          validCoordinates.add(new Coords(x, y));
  }

  // Tiles

  private void setTile(final Tile tile) {
    tiles[index(tile.x, tile.y)] = tile;
  }

  public Tile getTile(final int x, final int y) {
    return tiles[index(x, y)];
  }

  public Iterator<Tile> getAllTiles() {
    return Iterators.transform(this.validCoordinates.iterator(), new Function<Coords, Tile>() {
      @Nullable
      @Override
      public Tile apply(@Nullable final Coords input) {
        return getTile(input.x, input.y);
      }
    });
  }

  private int index(int x, int y) {
    // Sloppy indexing that wastes a little space.
    int margin = size * 2 + 2;
    return (x + size) * margin + (y + size);
  }

  // Buildings

  int numConstructedBuildings() {
    return Iterators.size(Iterators.filter(this.getAllTiles(), new Predicate<Tile>() {
      @Override
      public boolean apply(@Nullable final Tile t) {
        return t.isConstructedBuilding();
      }
    }));
  }

  int countConstructedBuildings(final BuildingType buildingType) {
    return Iterators.size(Iterators.filter(this.getAllTiles(), new Predicate<Tile>() {
      @Override
      public boolean apply(@Nullable final Tile input) {
        return input.buildingType == buildingType && input.isConstructedBuilding();
      }
    }));
  }

  void placeBuilding(int x, int y, final BuildingType buildingType) {
    final Tile tile = this.getTile(x, y);
    tile.buildingType = buildingType;
    tile.remainingBuildingConstructionDays = buildingType.constructionDays;
    //dispatcher.trigger('update');
  }

  Result canPlaceBuilding(final int x, final int y, final BuildingType buildingType) {
    final Tile tile = this.getTile(x, y);

    boolean isAdjacent = Iterators.any(this.getAllTiles(), new Predicate<Tile>() {
      @Override
      public boolean apply(@Nullable Tile t) {
        return t.isConstructedBuilding() && tile.isAdjacentTo(t);
      }
    });

    if (!isAdjacent)
      return Result.NOT_ADJACENT;

    boolean tooCloseToOtherBuilding = Iterators.any(this.getAllTiles(), new Predicate<Tile>() {
      @Override
      public boolean apply(@Nullable final Tile t) {
        return Iterators.any(buildingType.antiProximity.entrySet().iterator(), new Predicate<Map.Entry<Integer, Integer>>() {
          @Override
          public boolean apply(@Nullable Map.Entry<Integer, Integer> input) {
            return t.buildingType != null && t.buildingType.id == input.getKey() && t.distanceTo(x, y) <= input.getValue();
          }
        });
      }
    });

    if (tooCloseToOtherBuilding)
      return Result.TOO_CLOSE_TO_BAD_BUILDING;

    if (tile.terrainType != buildingType.validTerrain)
      return Result.INVALID_TERRAIN;
    if (tile.buildingType != null)
      return Result.TILE_FILLED;

    return Result.SUCCESS;
  }

  Iterator<Tile> allPotentialBuildingTiles(final BuildingType buildingType) {
    return Iterators.filter(this.getAllTiles(), new Predicate<Tile>() {
      @Override
      public boolean apply(@Nullable Tile t) {
        return canPlaceBuilding(t.x, t.y, buildingType) == Result.SUCCESS;
      }
    });
  }

  void advanceConstruction() {
    final Iterator<Tile> i = getAllTiles();
    while (i.hasNext()) {
      final Tile t = i.next();
      if (t.isUnderConstruction())
        t.remainingBuildingConstructionDays--;
    }
  }

  public static World newWorld(int size, float mountainProbability, float veinProbability) {
    final World world = new World(size);
    for (Coords c: world.validCoordinates) {
      final float rand = MathUtils.random();

      final TerrainType terrainType;
      if (rand < mountainProbability)
        terrainType = TerrainType.MOUNTAIN;
      else if (rand < mountainProbability + veinProbability)
        terrainType = TerrainType.VEIN;
      else
        terrainType = TerrainType.BARE;

      final Tile tile = new Tile(c.x, c.y, terrainType, null, 0);
      world.setTile(tile);
    }

    final Tile tile = world.getTile(0, 0);
    tile.terrainType = TerrainType.BARE;
    tile.buildingType = BuildingType.MOTHERSHIP;

    return world;
  }
}
