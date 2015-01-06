package org.quach.miner.desktop;

import com.badlogic.gdx.backends.lwjgl.LwjglApplication;
import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration;
import org.quach.miner.MinerApplication;

public class DesktopLauncher {
	public static void main (final String[] arg) {
		final LwjglApplicationConfiguration config = new LwjglApplicationConfiguration();
		config.width = MinerApplication.WORLD_WIDTH;
		config.height = MinerApplication.WORLD_HEIGHT;
		new LwjglApplication(new MinerApplication(), config);
	}
}
