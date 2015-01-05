package org.quach.miner;

import com.badlogic.gdx.ApplicationListener;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.ui.VerticalGroup;
import com.badlogic.gdx.utils.viewport.FitViewport;
import org.quach.miner.actors.game.WorldView;

public class MinerApplication implements ApplicationListener {
  private Stage gameStage;

  public static int WORLD_WIDTH = 90;
  public static int WORLD_HEIGHT = 160;

  @Override
  public void create() {
    gameStage = new Stage(new FitViewport(WORLD_WIDTH, WORLD_HEIGHT));
    Gdx.input.setInputProcessor(gameStage);

    final VerticalGroup vGroup = new VerticalGroup().fill();
    vGroup.addActor(new WorldView());
    gameStage.addActor(vGroup);
  }

  @Override
  public void resize(final int width, final int height) {
   gameStage.getViewport().update(width, height, true);
  }

  @Override
  public void render() {
    Gdx.gl.glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
    gameStage.act(Gdx.graphics.getDeltaTime());
    gameStage.draw();
  }

  @Override
  public void dispose() {
    gameStage.dispose();
  }

  @Override
  public void pause() {
  }

  @Override
  public void resume() {
  }
}
