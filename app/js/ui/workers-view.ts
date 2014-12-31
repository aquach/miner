/// <reference path="../../public/third-party-js/backbone.d.ts" />

module Miner {
  export class WorkersView extends Backbone.View<any> {
    constructor(options: Backbone.ViewOptions<any>) {
      super(options);

      dispatcher.on('update', this.render, this);
      this.render();
    }

    render() {
      this.$('table .worker').remove();
      _.each(game.workers, w => {
        var cells = [
          w.name + ' (' + Gender[w.gender][0] + ')',
          grade(w.miningSkill),
          grade(w.techSkill),
          grade(w.medicalSkill),
          grade(w.opsSkill),
          grade(w.morale)
        ];
        this.$('table').append('<tr class="worker">' + _.map(cells, c => '<td>' + c + '</td>').join() + '</tr>');
      });
      return this;
    }
  }
}
