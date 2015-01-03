package org.quach.miner.engine;

import com.google.common.collect.ImmutableMap;

import java.util.Map;

public enum BuildingType {
  MOTHERSHIP(
    1,
    "Mothership",
    0,
    TerrainType.BARE,
    0,
    ImmutableMap.<Integer, Integer>of()
  ),

  MINE(
    2,
    "Mine",
    1000,
    TerrainType.VEIN,
    10,
    ImmutableMap.of(7, 1)
  ),

  REACTOR(
    3,
    "Reactor",
    1000,
    TerrainType.BARE,
    5,
    ImmutableMap.of(4, 1, 7, 1)
  ),

  CANTEEN(
    4,
    "Canteen",
    500,
    TerrainType.BARE,
    5,
    ImmutableMap.of(3, 1, 4, 1)
  ),

  TUBE(
    5,
    "Tube",
    100,
    TerrainType.BARE,
    1,
    ImmutableMap.<Integer, Integer>of()
  ),

  SPACEBANK(
    6,
    "Spacebank",
    1000,
    TerrainType.BARE,
    5,
    ImmutableMap.of(6, 100)
  ),

  QUARTERS(
    7,
    "Quarters",
    500,
    TerrainType.BARE,
    5,
    ImmutableMap.of(2, 1, 3, 1)
  );

  public final int id;
  public final String name;
  public final int cost;
  public final TerrainType buildableType;
  public final int constructionTime;
  public final Map<Integer, Integer> antiProximity;

  BuildingType(
    final int id,
    final String name,
    final int cost,
    final TerrainType buildableType,
    final int constructionTime,
    final Map<Integer, Integer> antiProximity
  ) {
    this.id = id;
    this.name = name;
    this.cost = cost;
    this.buildableType = buildableType;
    this.constructionTime = constructionTime;
    this.antiProximity = antiProximity;
  }

  public static final BuildingType[] BUILDABLE_BUILDINGS = { MINE, REACTOR, QUARTERS, CANTEEN, TUBE, SPACEBANK };
}
