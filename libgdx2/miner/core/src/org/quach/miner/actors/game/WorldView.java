package org.quach.miner.actors.game;

import com.badlogic.gdx.scenes.scene2d.Group;
import com.google.common.base.Function;
import com.google.common.collect.Iterators;
import org.quach.miner.Log;
import org.quach.miner.Miner;
import org.quach.miner.engine.Tile;

import javax.annotation.Nullable;

public class WorldView extends Group {
  private final TileView[] tiles;

  public WorldView() {
    tiles = Iterators.toArray(Iterators.transform(Miner.game.world.getAllTiles(), new Function<Tile, TileView>() {
      @Nullable
      @Override
      public TileView apply(@Nullable final Tile t) {
        final TileView view = new TileView();
        final int xAmount = TileView.TILE_WIDTH * (t.x + Miner.game.world.size);
        view.setX(xAmount + 10);
        view.setY(TileView.TILE_WIDTH * (t.y + Miner.game.world.size) + xAmount / 2);
        Log.log("(%d, %d) => %f %f", t.x, t.y, view.getX(), view.getY());
        return view;
      }
    }), TileView.class);

    for (final TileView t: tiles) {
      addActor(t);
    }
  }

//  @Override
//  public void act(final float t) {
//    super.act(t);
//  }
//
//  @Override
//  public void draw(final Batch b, final float parentAlpha) {
//  }
}
