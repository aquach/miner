package org.quach.miner;

import com.badlogic.gdx.Gdx;

public class Log {
  public static void log(final String formatString, final Object... args) {
    Gdx.app.log("Log", String.format(formatString, args));
  }
}
