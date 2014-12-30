/// <reference path="../../public/third-party-js/lodash.d.ts" />
/// <reference path="result.ts" />
/// <reference path="worker.ts" />
/// <reference path="world.ts" />
/// <reference path="../miner.ts" />

module Miner {
  export interface WorkerStats {
    miningSkill: number;
    techSkill: number;
    medicalSkill: number;
    opsSkill: number;
  }

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

    sellOre(amount: number): { result: Result; soldQuantity?: number; revenue?: number; } {
      if (this.ore < amount)
        return { result: Result.INSUFFICIENT_ORE };

      var revenue = amount * this.orePrice();
      this._gainMoney(revenue);
      this.ore -= amount;
      dispatcher.trigger('update');

      return { result: Result.SUCCESS, soldQuantity: amount, revenue: revenue };
    }

    _earnInterest() {
      var revenue = Math.floor(this.money * INTEREST_RATE);
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
      return Util.sum(_.map(this.workers, w => w.morale)) / this.workers.length;
    }

    _payWorkers() {
      var amountToPay = this.workers.length * this.currentWage;
      if (!this._deductMoney(amountToPay)) {
        // Not enough to pay everyone; recompute wage using all money remaining.
        this.currentWage = Math.floor(this.money / this.workers.length);
        this._deductMoney(this.workers.length * this.currentWage);
      }
    }

    buildBuilding(x: number, y: number, b: BuildingType): Result {
      var isPlaceable = this.world.canPlaceBuilding(x, y, b);
      if (isPlaceable != Result.SUCCESS)
        return isPlaceable;

      if (!this._deductMoney(b.cost))
        return Result.INSUFFICIENT_FUNDS;

      this.world.placeBuilding(x, y, b);
      dispatcher.trigger('update');

      return Result.SUCCESS;
    }

    _mineForOre() {
      this.ore += this.world.buildingStats().oreProduction * this.miningSaturation();
    }

    miningSaturation() {
      var numMines = this.world.countConstructedBuildings(BuildingType.MINE);
      var totalSkill = this.workerStats().miningSkill;
      return numMines == 0 ? 1 : Util.clamp(totalSkill / numMines, 0, 1);
    }

    workerStats(): WorkerStats {
      return {
        miningSkill: Util.sum(_.map(this.workers, w => w.miningSkill)),
        techSkill: Util.sum(_.map(this.workers, w => w.techSkill)),
        medicalSkill: Util.sum(_.map(this.workers, w => w.medicalSkill)),
        opsSkill: Util.sum(_.map(this.workers, w => w.opsSkill))
      };
    }

    advanceToNextDay(): Result {
      this.currentDay++;
      this.world.advanceConstruction();
      this._earnInterest();
      var result = this._checkCollection();
      if (result !== Result.SUCCESS) return result;

      this._payWorkers();

      this.yesterdaysMorale = this.morale();
      _.each(this.workers, w => w.advanceMorale(1)); // TODO

      this._mineForOre();

      dispatcher.trigger('update');

      // TODO
      //checkForLeavingWorkers()
      //checkForDeaths(healthRating, foodRating)

      return Result.SUCCESS;
    }
  }

  export module GameState {
    export function newGameState(): GameState {
      return new GameState(
        1000,
        0,
        1,
        10,
        World.newWorld(5, 0.1, 0.1),
        [
          new Worker('Alice', Gender.FEMALE, 0.5, 0.2, 0.2, 0.2, 1),
          new Worker('Bob', Gender.MALE, 0.2, 0.5, 0.2, 0.2, 1),
          new Worker('Carol', Gender.FEMALE, 0.2, 0.2, 0.5, 0.2, 1),
          new Worker('David', Gender.OTHER, 0.2, 0.2, 0.2, 0.5, 1)
        ],
        1
      );
    }
  }
}
