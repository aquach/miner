/// <reference path="../../public/third-party-js/backbone.d.ts" />

module Miner {
  export class WorkersView extends Backbone.View<any> {
    events() {
      return {
        'click .interview': '_interview',
        'click .hire': '_hire',
        'click .pass': '_pass'
      };
    }

    constructor(options: Backbone.ViewOptions<any>) {
      super(options);

      this.$('.interview-stats').hide();
      dispatcher.on('update', this.render, this);
      this.render();
    }

    render() {
      this.$('table .worker').remove();
      this.$('.interview').toggle(!game.hiredToday && game.workers.length < game.workerCapacity());
      this.$('.interview-stats').toggle(game.lastInterviewedWorker !== null);
      _.each(game.workers, w => {
        var cells = [
          w.name + ' (' + Gender[w.gender][0] + ')',
          grade(w.miningSkill),
          grade(w.techSkill),
          grade(w.opsSkill),
          grade(w.morale)
        ];
        this.$('table').append('<tr class="worker">' + _.map(cells, c => '<td>' + c + '</td>').join() + '</tr>');
      });
      return this;
      }

    _interview() {
      var result = game.rollWorker();
      if (result.result !== Result.SUCCESS) {
        alert(Result[result.result]);
        return;
      }

      this.$('.interview-stats').show();

      var worker = result.worker;
      this.$('.value.name').text(worker.name);
      this.$('.value.gender').text(Gender[worker.gender]);
      this.$('.value.mining').text(grade(worker.miningSkill));
      this.$('.value.tech').text(grade(worker.techSkill));
      this.$('.value.ops').text(grade(worker.opsSkill));
    }

    _hire() {
      this.$('.interview-stats').hide();
      game.hireInterviewedWorker();
    }

    _pass() {
      this.$('.interview-stats').hide();
    }
  }
}
