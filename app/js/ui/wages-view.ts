/// <reference path="../../public/third-party-js/backbone.d.ts" />

module Miner {
  export class WagesView extends Backbone.View<any> {
    events() {
      return {
        'click': '_setWages'
      };
    }

    constructor(options: Backbone.ViewOptions<any>) {
      super(options);

      dispatcher.on('update', this.render, this);
      this.render();
    }

    render() {
      this.$el.text(Util.numberWithCommas(game.currentWage) + 'z / day');
      return this;
    }

    _setWages() {
      var wage: number;
      while (true) {
        wage = _.parseInt(prompt('Set wage per day to?', game.currentWage.toString()));
        if (!_.isNaN(wage) && wage >= 0)
          break;
      }
      game.currentWage = wage;
      dispatcher.trigger('update');
    }
  }
}
