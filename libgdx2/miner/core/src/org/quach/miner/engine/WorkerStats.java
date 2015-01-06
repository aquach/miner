package org.quach.miner.engine;

import com.google.auto.value.AutoValue;

@AutoValue
abstract public class WorkerStats {
  public static WorkerStats create(final float miningSkill, final float techSkill, final float opsSkill) {
    return new AutoValue_WorkerStats(miningSkill, techSkill, opsSkill);
  }

  abstract float miningSkill();
  abstract float techSkill();
  abstract float opsSkill();
}
