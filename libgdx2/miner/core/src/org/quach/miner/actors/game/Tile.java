package org.quach.miner.actors.game;

import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.g2d.Batch;
import com.badlogic.gdx.graphics.glutils.ShapeRenderer;
import com.badlogic.gdx.scenes.scene2d.Actor;

public class Tile extends Actor {

  private final ShapeRenderer shapeRenderer = new ShapeRenderer();

  @Override
  public void act(final float t) {
    super.act(t);
  }

  @Override
  public void draw(final Batch b, final float parentAlpha) {
    b.end();

    shapeRenderer.begin(ShapeRenderer.ShapeType.Line);
    shapeRenderer.setColor(Color.BLACK);
    shapeRenderer.box(getX(), getWidth(), 0, getWidth(), getHeight(), 0);
    shapeRenderer.end();

    b.begin();
  }
}
