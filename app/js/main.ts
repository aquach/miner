/// <reference path="../public/third-party-js/jquery.d.ts" />
/// <reference path="../public/third-party-js/backbone.d.ts" />
/// <reference path="engine/game-state.ts" />
/// <reference path="engine/result.ts" />
/// <reference path="ui/day-view.ts" />
/// <reference path="ui/money-view.ts" />
/// <reference path="ui/morale-view.ts" />
/// <reference path="ui/ore-view.ts" />
/// <reference path="ui/world-view.ts" />
/// <reference path="ui/wages-view.ts" />
/// <reference path="miner.ts" />

$(() => {
  Miner.game = Miner.GameState.newGameState();
  Miner.dispatcher = Backbone;

  new Miner.DayView({ el: $('.value.day') });
  new Miner.MoneyView({ el: $('.value.money') });
  new Miner.MoraleView({ el: $('.value.morale') });
  new Miner.OreView({ el: $('.value.ore') });
  new Miner.WagesView({ el: $('.value.wages') });
  new Miner.WorldView({ el: $('.world') });

  $('.advance-to-next-day').click(() => {
    var result = Miner.game.advanceToNextDay();
    if (result !== Miner.Result.SUCCESS)
      alert('Failed to go to next day. Why? ' + Miner.Result[result] + '.'); // TODO
  });

  // Debug refreshing.
  //$.event.special.swipe.horizontalDistanceThreshold = 300;
  //$(document).swipe(() => {
  //  $('body').remove();
  //  window.location.reload();
  //});
})
