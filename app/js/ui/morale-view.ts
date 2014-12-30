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
      this.$el.text(grade(game.morale()));
      return this;
    }
  }
}
