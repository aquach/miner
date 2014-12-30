/// <reference path="../public/third-party-js/jquery.d.ts" />
/// <reference path="engine/game-state.ts" />
/// <reference path="ui/world-view.ts" />

module Miner {
  export var game: GameState;
};

$(() => {
  Miner.game = Miner.GameState.newGameState();
  var worldView = new Miner.WorldView({ el: $('.world') });

  $('.advance-to-next-day').click(() => Miner.game.advanceToNextDay());
    //moneyView: new Miner.MoneyView({ el: $('.money') })

  // Debug refreshing.
  //$.event.special.swipe.horizontalDistanceThreshold = 300;
  //$(document).swipe(() => {
  //  $('body').remove();
  //  window.location.reload();
  //});
})
