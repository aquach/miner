/// <reference path="../../public/third-party-js/backbone.d.ts" />

module Miner {
  export class MoneyView extends Backbone.View<any> {
    constructor(options: Backbone.ViewOptions<any>) {
      super(options);

      dispatcher.on('update', this.render, this);
      this.render();
    }

    render() {
      this.$el.text(Util.numberWithCommas(game.money) + 'z');
      return this;
    }
  }
}
