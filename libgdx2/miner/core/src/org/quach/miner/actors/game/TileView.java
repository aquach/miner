package org.quach.miner.actors.game;

import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.g2d.Batch;
import com.badlogic.gdx.graphics.glutils.ShapeRenderer;
import com.badlogic.gdx.scenes.scene2d.Actor;

public class TileView extends Actor {

  public static int TILE_WIDTH = 20;

  private final ShapeRenderer shapeRenderer = new ShapeRenderer();

  public TileView() {
    setWidth(TILE_WIDTH);
    setHeight(TILE_WIDTH * (float)Math.sqrt(3) / 2);
  }

  @Override
  public void act(final float t) {
    super.act(t);
  }

  @Override
  public void draw(final Batch b, final float parentAlpha) {
    b.end();

    shapeRenderer.begin(ShapeRenderer.ShapeType.Line);
    shapeRenderer.setColor(Color.BLACK);
    shapeRenderer.box(getX(), getY(), 0, getWidth(), getHeight(), 0);
    shapeRenderer.end();

    b.begin();
  }
}
