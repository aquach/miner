package org.quach.miner;

import com.badlogic.gdx.ApplicationListener;
import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.Color;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Pixmap;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.g2d.SpriteBatch;
import com.badlogic.gdx.scenes.scene2d.Actor;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.ui.*;
import com.badlogic.gdx.scenes.scene2d.utils.ChangeListener;

public class Miner2 implements ApplicationListener {
    Skin skin;
    Stage stage;
    SpriteBatch batch;

    @Override
    public void create () {
        batch = new SpriteBatch();
        stage = new Stage();
        Gdx.input.setInputProcessor(stage);

        Skin skin = new Skin(Gdx.files.internal("data/uiskin.json"));

        // Generate a 1x1 white texture and store it in the skin named "white".
        Pixmap pixmap = new Pixmap(1, 1, Pixmap.Format.RGBA8888);
        pixmap.setColor(Color.WHITE);
        pixmap.fill();
        skin.add("white", new Texture(pixmap));


        // Create a table that fills the screen. Everything else will go inside this table.
        Table table = new Table();
        table.setFillParent(true);
        stage.addActor(table);

        Label nameLabel = new Label("Name:", skin);
        TextField nameText = new TextField("", skin);
        Label addressLabel = new Label("Address:", skin);
        TextField addressText = new TextField("", skin);

        table.add(nameLabel);
        table.add(nameText).width(100);
        table.row();
        table.add(addressLabel);
        table.add(addressText).width(100);

        // Create a button with the "default" TextButtonStyle. A 3rd parameter can be used to specify a name other than "default".
        final TextButton button = new TextButton("Click me!", skin);
        table.add(button);

        // Add a listener to the button. ChangeListener is fired when the button's checked state changes, eg when clicked,
        // Button#setChecked() is called, via a key press, etc. If the event.cancel() is called, the checked state will be reverted.
        // ClickListener could have been used, but would only fire when clicked. Also, canceling a ClickListener event won't
        // revert the checked state.
        button.addListener(new ChangeListener() {
            public void changed (ChangeEvent event, Actor actor) {
                System.out.println("Clicked! Is checked: " + button.isChecked());
                button.setText("Good job!");
            }
        });

        // Add an image actor. Have to set the size, else it would be the size of the drawable (which is the 1x1 texture).
        table.add(new Image(skin.newDrawable("white", Color.RED))).size(64);
    }

    @Override
    public void render () {
        Gdx.gl.glClearColor(0.2f, 0.2f, 0.2f, 1);
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
        stage.act(Math.min(Gdx.graphics.getDeltaTime(), 1 / 30f));
        stage.draw();
    }

    @Override
    public void resize (int width, int height) {
        stage.getViewport().update(width, height, true);
    }

    @Override
    public void dispose () {
        stage.dispose();
        skin.dispose();
    }

    @Override
    public void pause() {
    }

    @Override
    public void resume() {
    }
}
