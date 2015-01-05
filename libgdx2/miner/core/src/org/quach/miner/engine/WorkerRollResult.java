package org.quach.miner.engine;

import com.google.auto.value.AutoValue;

@AutoValue
abstract public class WorkerRollResult {
  abstract Result result();
  abstract Worker worker();

  public static WorkerRollResult create(Result result, Worker worker) {
    return new AutoValue_WorkerRollResult(result, worker);
  }
}
