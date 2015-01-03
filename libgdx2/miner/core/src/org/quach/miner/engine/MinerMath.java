package org.quach.miner.engine;

import com.badlogic.gdx.math.MathUtils;

public class MinerMath {
  private Double randomCache = null;

  public double sampleNormal(final double mean, final double sigma) {
    final double value;
    if (randomCache != null) {
      value = randomCache;
      randomCache = null;
    } else {
      final double u1 = MathUtils.random();
      final double u2 = MathUtils.random();
      final double coeff = Math.sqrt(-2 * Math.log(u1));
      value = coeff * Math.cos(2 * MathUtils.PI * u1);
      randomCache = coeff * Math.sin(2 * Math.PI * u2);
    }

    return mean + sigma * value;
  }
}
