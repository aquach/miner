/// <reference path="../../public/third-party-js/backbone.d.ts" />

module Miner {
  export class MiningSaturationView extends Backbone.View<any> {
    constructor(options: Backbone.ViewOptions<any>) {
      super(options);

      dispatcher.on('update', this.render, this);
      this.render();
    }

    render() {
      this.$el.text(Math.floor(game.miningSaturation() * 100) + '%');
      return this;
    }
  }
}
