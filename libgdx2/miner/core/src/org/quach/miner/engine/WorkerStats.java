package org.quach.miner.engine;

import com.google.auto.value.AutoValue;

@AutoValue
abstract public class WorkerStats {
  public static WorkerStats create(float miningSkill, float techSkill, float opsSkill) {
    return new AutoValue_WorkerStats(miningSkill, techSkill, opsSkill);
  }

  abstract float miningSkill();
  abstract float techSkill();
  abstract float opsSkill();
}
