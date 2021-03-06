package org.quach.miner.engine;

import com.google.auto.value.AutoValue;

@AutoValue
abstract public class SellOreResult {
  abstract Result result();
  abstract Integer soldQuantity();
  abstract Integer revenue();

  public static SellOreResult create(final Result result, final Integer soldQuality, final Integer revenue) {
    return new AutoValue_SellOreResult(result, soldQuality, revenue);
  }
}
