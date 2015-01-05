package org.quach.miner.actors.game;

import com.badlogic.gdx.scenes.scene2d.Group;
import com.google.common.base.Function;
import com.google.common.collect.Iterators;
import org.quach.miner.Miner;
import org.quach.miner.engine.Tile;

import javax.annotation.Nullable;

public class WorldView extends Group {
  private final TileView[] tiles;

  public WorldView() {
    tiles = Iterators.toArray(Iterators.transform(Miner.world.getAllTiles(), new Function<Tile, TileView>() {
      @Nullable
      @Override
      public TileView apply(@Nullable Tile t) {
        final TileView view = new TileView();
        final int xAmount = TileView.TILE_WIDTH * (t.x + Miner.world.size);
        view.setX(xAmount + 10);
        view.setY(TileView.TILE_WIDTH * (t.y + Miner.world.size) + xAmount / 2 + 100);
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
