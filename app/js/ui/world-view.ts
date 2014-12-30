/// <reference path="../../public/third-party-js/backbone.d.ts" />

module Miner {
  export class WorldView extends Backbone.View<any> {
    events() {
      return {
        //'click .cell': '_onClickCell',
        //'touchstart .cell': '_onClickCell'
      };
    }

    static TILE_WIDTH = 53;

    constructor(options: Backbone.ViewOptions<any>) {
      super(options);

      var allTiles = game.world.getAllTiles();
      _.each(allTiles, t => {
          var translation = game.world.size;
          var $cell = $('<div>').addClass('cell').addClass('x' + t.x).addClass('y' + t.y)
            .css({ left: WorldView.TILE_WIDTH * (t.x + translation) + 10, top: WorldView.TILE_WIDTH * ((t.y + translation) + (t.x + translation) / 2) - 100 });
        this.$el.append($cell);
      });

      dispatcher.on('update', this.render, this);
      this.render();
    }

    render() {
      var allTiles = game.world.getAllTiles();
      _.each(allTiles, t => {
        var terrainDisplayStr: string;
        switch (t.terrainType) {
          case TerrainType.MOUNTAIN:
            terrainDisplayStr = '^^^';
          break;
          case TerrainType.BARE:
            terrainDisplayStr = '';
          break;
          case TerrainType.VEIN:
            terrainDisplayStr = 'X';
          break;
        }
        var name = t.buildingType !== null ? t.buildingType.name : terrainDisplayStr;
        this.$('.cell.x' + t.x + '.y' + t.y).text(name);
      });

      return this;
    }
  }
}
