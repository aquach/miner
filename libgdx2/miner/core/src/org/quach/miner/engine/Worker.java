package org.quach.miner.engine;

import com.badlogic.gdx.math.MathUtils;

public class Worker {
  public final float id;
  public final String name;
  public final Gender gender;
  public final float miningSkill;
  public final float techSkill;
  public final float opsSkill;
  public final float moraleInertia;
  public final Team team;

  public float morale;

  // Numbers are all in the range [0, 1].
  public Worker(
      final float id,
      final String name,
      final Gender gender,
      final float miningSkill,
      final float techSkill,
      final float opsSkill,
      final float morale,
      final float moraleInertia,
      final Team team
      ) {
    this.id = id;
    this.name = name;
    this.gender = gender;
    this.miningSkill = miningSkill;
    this.techSkill = techSkill;
    this.opsSkill = opsSkill;
    this.morale = morale;
    this.moraleInertia = moraleInertia;
    this.team = team;
  }

  private float desiredWage(float currentDay) {
    return 25 + currentDay / 5;
  }

  public boolean advanceMorale(float currentWage, float opsPercent, float currentDay) {
    float targetMorale = currentWage / desiredWage(currentDay) * opsPercent;
    morale = MathUtils.clamp(morale * moraleInertia + targetMorale * (1 - moraleInertia), 0, 1);
    return !(morale < 0.05 && MathUtils.random() < 0.25);
  }
}
