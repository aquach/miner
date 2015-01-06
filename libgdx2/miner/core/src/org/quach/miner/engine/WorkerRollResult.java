package org.quach.miner.engine;

import com.google.auto.value.AutoValue;

@AutoValue
abstract public class WorkerRollResult {
  abstract Result result();
  abstract Worker worker();

  public static WorkerRollResult create(final Result result, final Worker worker) {
    return new AutoValue_WorkerRollResult(result, worker);
  }
}
