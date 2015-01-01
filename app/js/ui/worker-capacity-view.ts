/// <reference path="../../public/third-party-js/backbone.d.ts" />

module Miner {
  export class WorkerCapacityView extends Backbone.View<any> {
    constructor(options: Backbone.ViewOptions<any>) {
      super(options);

      dispatcher.on('update', this.render, this);
      this.render();
    }

    render() {
      var goal = game.nextCollectionGoal();
      this.$el.text(Util.numberWithCommas(game.workers.length) + ' / ' + Util.numberWithCommas(game.workerCapacity()));
      return this;
    }
  }
}
