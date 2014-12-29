/// <reference path="../../public/third-party-js/lodash.d.ts" />
/// <reference path="result.ts" />
/// <reference path="worker.ts" />
/// <reference path="world.ts" />

module Miner {
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

  export var INTEREST_RATE: number = 0.01;

  export class GameState {
    constructor(
      public money: number,
      public ore: number,
      public currentDay: number,
      public currentWage: number,
      public world: World,
      public workers: Worker[],
      public yesterdaysMorale: number
    ) { }

    _deductMoney(amount: number): Boolean {
      if (this.money - amount < 0)
        return false;

      this.money -= amount;
      return true;
    }

    _gainMoney(amount: number) {
      this.money += amount;
    }

    orePrice(): number {
      return Math.floor(Math.sin(this.currentDay / 30) * 20 + 10);
    }

    sellOre(amount: number): Result {
      if (this.ore < amount)
        return Result.INSUFFICIENT_ORE;

      var revenue = amount * this.orePrice();
      this._gainMoney(revenue);
      this.ore -= amount;

      return Result.SUCCESS;
    }

    _earnInterest() {
      var revenue = this.money * INTEREST_RATE;
      this._gainMoney(revenue);
    }

    nextCollectionGoal(): CollectionGoal {
      return _.find(COLLECTION_DAYS, goal => this.currentDay < goal.currentDay);
    }

    _checkCollection(): Result {
      var collectionDay = _.find(COLLECTION_DAYS, goal => this.currentDay == goal.currentDay);
      if (collectionDay) {
        if (!this._deductMoney(collectionDay.amount))
          return Result.GAME_OVER;
      }

      return Result.SUCCESS;
    }

    morale(): number {
      return Util.sum(_.map(this.workers, w => w.morale));
    }

    _payWorkers() {
      var amountToPay = this.workers.length * this.currentWage;
      if (!this._deductMoney(amountToPay)) {
        // Not enough to pay everyone; recompute wage using all money remaining.
        this.currentWage = Math.floor(this.money / this.workers.length);
        this._deductMoney(this.workers.length * this.currentWage);
      }
    }

    advanceToNextDay() {
      this.currentDay++;
      this.world.advanceConstruction();
      this._earnInterest();
      var result = this._checkCollection();
      if (result !== Result.SUCCESS) return result;

      this._payWorkers();

      this.yesterdaysMorale = this.morale();
      _.each(this.workers, w => w.advanceMorale(1)); // TODO
    }
  }
}
