/// <reference path="../../public/third-party-js/backbone.d.ts" />

module Miner {
  export interface BuildViewOptions extends Backbone.ViewOptions<any> {
    worldView: WorldView
  }

  export class BuildView extends Backbone.View<any> {
    events() {
      return {
        'change select': '_markEligibleBuildingSpots',
        'click .done-building': '_finishBuilding'
      };
    }

    _isBuilding: boolean;
    _worldView: WorldView;

    constructor(options: BuildViewOptions) {
      super(options);

      this._worldView = options.worldView;
      this._worldView.on('click', this._onWorldViewCellClick, this);

      this.$('.done-building').hide();

      _.each(BuildingType.buildableBuildings, b => {
        this.$('select').append($('<option>').attr('value', b.id));
      });

      dispatcher.on('update', this.render, this);
      this.render();
    }

    render() {
      if (this._isBuilding)
        this._markEligibleBuildingSpots();

      _.each(BuildingType.buildableBuildings, b => {
        var canBuy = b.cost <= game.money;
        this.$('select option[value=' + b.id + ']').text(b.name + ' (' + Util.numberWithCommas(b.cost) + ' zeny)')
          .css('color', canBuy ? 'black' : 'grey');
      });
      return this;
    }

    _selectedBuildingType(): BuildingType {
      var selectedBuildingID = _.parseInt(this.$('select').val());
      return _.find(BuildingType.buildableBuildings, b => b.id === selectedBuildingID);
    }

    _markEligibleBuildingSpots() {
      if (this._selectedBuildingType() !== undefined) {
        this._isBuilding = true;
        this.$('select').hide();
        this.$('.done-building').show();
        this._worldView.markTiles(_.map(game.world.allPotentialBuildingTiles(this._selectedBuildingType()), t => ({ x: t.x, y: t.y })));
      }
    }

    _finishBuilding() {
      this._isBuilding = false;
      this.$('select').val("-1").show();
      this.$('.done-building').hide();
      this._worldView.markTiles([]);
    }

    _onWorldViewCellClick(c: Coords) {
      if (this._isBuilding && game.world.canPlaceBuilding(c.x, c.y, this._selectedBuildingType()) === Result.SUCCESS) {
        game.buildBuilding(c.x, c.y, this._selectedBuildingType());
      }
    }
  }
}
