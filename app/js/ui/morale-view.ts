/// <reference path="../../public/third-party-js/backbone.d.ts" />
/// <reference path="grade.ts" />

module Miner {
  export class MoraleView extends Backbone.View<any> {
    constructor(options: Backbone.ViewOptions<any>) {
      super(options);

      dispatcher.on('update', this.render, this);
      this.render();
    }

    render() {
      var directionalArrow: string;
      var change = game.morale() - game.yesterdaysMorale;
      if (Math.abs(change) < 0.01) {
        directionalArrow = '->';
      }
      else if (change < 0) {
        directionalArrow = 'v';
      }
      else if (change > 0) {
        directionalArrow = '^';
      }
      this.$el.text(grade(game.morale()) + ' ' + directionalArrow);
      return this;
    }
  }
}
