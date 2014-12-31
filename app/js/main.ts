/// <reference path="../public/third-party-js/jquery.d.ts" />
/// <reference path="../public/third-party-js/backbone.d.ts" />
/// <reference path="engine/game-state.ts" />
/// <reference path="engine/result.ts" />
/// <reference path="ui/build-view.ts" />
/// <reference path="ui/day-view.ts" />
/// <reference path="ui/money-view.ts" />
/// <reference path="ui/morale-view.ts" />
/// <reference path="ui/ore-view.ts" />
/// <reference path="ui/operations-view.ts" />
/// <reference path="ui/mining-saturation-view.ts" />
/// <reference path="ui/world-view.ts" />
/// <reference path="ui/workers-view.ts" />
/// <reference path="ui/wages-view.ts" />
/// <reference path="miner.ts" />

$(() => {
  Miner.game = Miner.GameState.newGameState();
  Miner.dispatcher = Backbone;

  new Miner.DayView({ el: $('.value.day') });
  new Miner.MiningSaturationView({ el: $('.value.mining-saturation') });
  new Miner.MoneyView({ el: $('.value.money') });
  new Miner.MoraleView({ el: $('.value.morale') });
  new Miner.OperationsView({ el: $('.value.operations') });
  new Miner.OreView({ el: $('.value.ore') });
  new Miner.WagesView({ el: $('.value.wages') });
  var worldView = new Miner.WorldView({ el: $('.world') });
  new Miner.BuildView({ el: $('.build-panel'), worldView: worldView });
  new Miner.WorkersView({ el: $('.workers') });

  $('.advance-to-next-day').click(() => {
    var result = Miner.game.advanceToNextDay();
    if (result !== Miner.Result.SUCCESS)
      alert('Failed to go to next day. Why? ' + Miner.Result[result] + '.');
  });

  $('html').keydown(e => {
    switch (e.which) {
      case 78: $('.advance-to-next-day').click(); break;
      case 83: $('.sell-ore').click(); break;
    }
  });
})
