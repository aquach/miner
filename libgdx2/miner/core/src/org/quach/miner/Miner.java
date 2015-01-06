package org.quach.miner;

import org.quach.miner.engine.CollectionGoal;
import org.quach.miner.engine.GameState;

public class Miner {
  public static GameState game = GameState.newGameState();

  public static final CollectionGoal[] COLLECTION_DAYS = {
    CollectionGoal.create(30, 1000),
    CollectionGoal.create(60, 10000),
    CollectionGoal.create(120, 25000),
    CollectionGoal.create(180, 100000),
    CollectionGoal.create(365, 1000000),
  };

  public static final String WORKER_NAME_POOL[] = {
    "Alice",
    "Bob",
    "Brett",
    "Carlos",
    "Carol",
    "Charlie",
    "Chuck",
    "Craig",
    "Dan",
    "David",
    "Derek",
    "Erin",
    "Eve",
    "Frank",
    "JJ",
    "Josh",
    "Leo",
    "Mallory",
    "Mariel",
    "Mitch",
    "Oscar",
    "Peggy",
    "Sally",
    "Sam",
    "Sybil",
    "Trent",
    "Victor",
    "Walter",
    "Wendy"
  };
}
