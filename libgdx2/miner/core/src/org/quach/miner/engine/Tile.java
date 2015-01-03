package org.quach.miner.engine;

public class Tile {
  public final int x;
  public final int y;
  public final TerrainType terrainType;

  private BuildingType buildingType;
  private int remainingBuildingConstructionDays;

  public Tile(
    final int x,
    final int y,
    final TerrainType terrainType,
    final BuildingType buildingType,
    final int remainingBuildingConstructionDays) {
    this.x = x;
    this.y = y;
    this.terrainType = terrainType;
    this.buildingType = buildingType;
    this.remainingBuildingConstructionDays = remainingBuildingConstructionDays;
  }

  public int distanceToTile(final Tile tile) {
    return distanceTo(tile.x, tile.y);
  }

  public int distanceTo(int x, int y) {
    return distanceBetween(x, y, x, y);
  }

  public boolean isAdjacentTo(final Tile tile) {
    return distanceToTile(tile) == 1;
  }

  public boolean isConstructedBuilding() {
    return buildingType != null && remainingBuildingConstructionDays == 0;
  }

  public boolean isUnderConstruction() {
    return buildingType != null && remainingBuildingConstructionDays > 0;
  }

  public static int distanceBetween(final int x1, final int y1, final int x2, final int y2) {
    final int z1 = 0 - x1 - y1;
    final int z2 = 0 - x2 - y2;
    return Math.max(Math.max(Math.abs(x1 - x2), Math.abs(y1 - y2)), Math.abs(z1 - z2));
  }
}
