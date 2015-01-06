package org.quach.miner;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import java.util.List;
import java.util.Map;

public class Dispatcher {
  private static Map<String, List<Runnable>> runnablesByChannel = Maps.newHashMap();

  public static void trigger(final String channel) {
    if (runnablesByChannel.containsKey(channel)) {
      for (Runnable r: runnablesByChannel.get(channel))
        r.run();
    }
  }

  public static void on(String channel, Runnable r) {
    if (runnablesByChannel.containsKey(channel)) {
      runnablesByChannel.get(channel).add(r);
    } else {
      runnablesByChannel.put(channel, Lists.newArrayList(r));
    }
  }
}
