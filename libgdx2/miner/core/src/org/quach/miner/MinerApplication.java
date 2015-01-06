package org.quach.miner;

import com.badlogic.gdx.ApplicationListener;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.Input;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.BitmapFont;
import com.badlogic.gdx.graphics.g2d.NinePatch;
import com.badlogic.gdx.scenes.scene2d.Actor;
import com.badlogic.gdx.scenes.scene2d.InputEvent;
import com.badlogic.gdx.scenes.scene2d.InputListener;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.ui.*;
import com.badlogic.gdx.scenes.scene2d.utils.ChangeListener;
import com.badlogic.gdx.scenes.scene2d.utils.NinePatchDrawable;
import com.badlogic.gdx.utils.viewport.FitViewport;
import org.quach.miner.actors.game.Grade;
import org.quach.miner.actors.game.WorldView;

public class MinerApplication implements ApplicationListener {
  private Stage gameStage;

  public static final int WORLD_WIDTH = 450;
  public static final int WORLD_HEIGHT = 800;

  @Override
  public void create() {
    gameStage = new Stage(new FitViewport(WORLD_WIDTH, WORLD_HEIGHT));
    Gdx.input.setInputProcessor(gameStage);

    final Skin skin = new Skin(Gdx.files.internal("skin.json"));

    loadFonts(skin);

    final NinePatchDrawable buttonUpPatch =
      new NinePatchDrawable(new NinePatch(new Texture(Gdx.files.internal("button-up.png")), 1, 1, 1, 1));
    final NinePatchDrawable buttonDownPatch =
      new NinePatchDrawable(new NinePatch(new Texture(Gdx.files.internal("button-down.png")), 1, 1, 1, 1));
    final TextButton.TextButtonStyle textButtonStyle = new TextButton.TextButtonStyle();
    textButtonStyle.up = buttonUpPatch;
    textButtonStyle.down = buttonDownPatch;
    textButtonStyle.fontColor = skin.getColor("black32");
    textButtonStyle.font = skin.getFont("default-large");
    skin.add("default", textButtonStyle);

    final Label.LabelStyle labelStyle = new Label.LabelStyle();
    labelStyle.font = skin.getFont("default");
    skin.add("default", labelStyle);

    final Table topBarTable = new Table();
    topBarTable.setSkin(skin);
    final Label dayAndZenyLabel = topBarTable.add("").pad(5).left().expandX().getActor();
    final Label moraleLabel = topBarTable.add("").pad(5).right().expandX().getActor();

    final Runnable updateLabels = new Runnable() {
      @Override
      public void run() {
        dayAndZenyLabel.setText("Day " + Miner.game.currentDay + ": " + Miner.game.money + "z");

        String directionalArrow = "";
        final float change = Miner.game.morale() - Miner.game.yesterdaysMorale;
        if (Math.abs(change) < 0.01) {
          directionalArrow = "->";
        } else if (change < 0) {
          directionalArrow = "v";
        } else if (change > 0) {
          directionalArrow = "^";
        }
        moraleLabel.setText("Morale: " + Grade.grade(Miner.game.morale()) + " " + directionalArrow);
      }
    };
    updateLabels.run();

    Dispatcher.on("update", updateLabels);

    final Table rootTable = new Table();
    rootTable.setFillParent(true);
    rootTable.add(topBarTable).expandX().fillX();
    rootTable.row();
    rootTable.add(new WorldView()).prefWidth(WORLD_WIDTH).prefHeight(WORLD_WIDTH).expand().fill();
    rootTable.row();

    final Button advanceDayButton = rootTable.add(new TextButton("See what tomorrow brings", skin)).pad(5)
      .prefHeight(100).expandX().fillX().getActor();
    advanceDayButton.addListener(new ChangeListener() {
      @Override
      public void changed(final ChangeEvent event, final Actor actor) {
        Miner.game.advanceToNextDay();
      }
    });

    gameStage.addActor(rootTable);

    gameStage.addListener(new InputListener() {
      @Override
      public boolean keyDown(final InputEvent event, final int keycode) {
        switch (keycode) {
          case Input.Keys.D:
            rootTable.setDebug(!rootTable.getDebug(), true);
            return true;
        }
        return false;
      }
    });
  }

  private void loadFonts(final Skin skin) {
    {
      final BitmapFont font = new BitmapFont(Gdx.files.internal("pixelmix.fnt"));
      font.setScale(2);
      skin.add("default", font);
    }

    {
      final BitmapFont font = new BitmapFont(Gdx.files.internal("pixelmix.fnt"));
      font.setScale(3);
      skin.add("default-large", font);
    }
  }

  @Override
  public void resize(final int width, final int height) {
    gameStage.getViewport().update(width, height, true);
  }

  @Override
  public void render() {
    Gdx.gl.glClearColor(0.75f, 0.75f, 0.75f, 1.0f);
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
