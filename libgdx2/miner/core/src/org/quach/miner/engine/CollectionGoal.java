package org.quach.miner.engine;

import com.google.auto.value.AutoValue;

@AutoValue
abstract public class CollectionGoal {
  public static CollectionGoal create(final int day, final int amount) {
    return new AutoValue_CollectionGoal(day, amount);
  }

  abstract int day();
  abstract int amount();
}
