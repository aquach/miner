package org.quach.miner.engine;

import com.google.auto.value.AutoValue;

@AutoValue
abstract public class CollectionGoal {
  public static CollectionGoal create(int day, int amount) {
    return new AutoValue_CollectionGoal(day, amount);
  }

  abstract int day();
  abstract int amount();
}
