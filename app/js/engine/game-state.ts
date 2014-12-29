/// <reference path="../../public/third-party-js/lodash.d.ts" />
/// <reference path="result.ts" />

module Miner {
  export interface GameState {
    money: number;
    ore: number;
    currentDay: number;
  };

  export module GameState {
    export var gs: GameState = null;

    export interface CollectionGoal {
      currentDay: number;
      amount: number;
    };

    export var COLLECTION_DAYS: CollectionGoal[] = [
      { currentDay: 30, amount: 250000 },
      { currentDay: 60, amount: 500000 },
      { currentDay: 90, amount: 500000 },
      { currentDay: 120, amount: 2500000 },
      { currentDay: 150, amount: 5000000 },
      { currentDay: 180, amount: 50000000 }
    ];

    function _deductMoney(amount: number): Boolean {
      if (gs.money - amount < 0)
        return false;

      gs.money -= amount;
      return true;
    }

    function _gainMoney(amount: number) {
      gs.money += amount;
    }

    function orePrice(): number {
      return Math.floor(Math.sin(gs.currentDay / 30) * 20 + 10);
    }

    function sellOre(amount: number): Result {
      if (gs.ore < amount)
        return Result.INSUFFICIENT_ORE;

      var revenue = amount * orePrice();
      _gainMoney(revenue);
      gs.ore -= amount;

      return Result.SUCCESS;
    }

    export var INTEREST_RATE: number = 0.01;
    function earnInterest() {
      var revenue = gs.money * INTEREST_RATE;
      _gainMoney(revenue);
    }

    function nextCollectionGoal(): CollectionGoal {
      return _.find(COLLECTION_DAYS, goal => gs.currentDay < goal.currentDay);
    }

    function checkCollection(): Result {
      var collectionDay = _.find(COLLECTION_DAYS, goal => gs.currentDay == goal.currentDay);
      if (collectionDay) {
        if (!_deductMoney(collectionDay.amount))
          return Result.GAME_OVER;
      }

      return Result.SUCCESS;
    }
  }
}
