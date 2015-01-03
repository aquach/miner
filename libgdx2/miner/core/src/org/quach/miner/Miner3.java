package org.quach.miner;

import com.badlogic.gdx.ApplicationListener;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.ui.VerticalGroup;
import org.quach.miner.actors.game.WorldView;

public class Miner3 implements ApplicationListener {
  private Stage gameStage;

  @Override
  public void create() {
    gameStage = new Stage();
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
