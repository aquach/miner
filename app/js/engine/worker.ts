/// <reference path="../../public/third-party-js/lodash.d.ts" />

module Miner {
  export enum Gender {
    OTHER,
    FEMALE,
    MALE
  };

  export enum Team {
    MINING,
    TECH,
    OPS
  }

  export class Worker {
    // Numbers are all in the range [0, 1].
    constructor(
      public id: number,
      public name: string,
      public gender: Gender,
      public miningSkill: number,
      public techSkill: number,
      public opsSkill: number,
      public morale: number,
      public moraleInertia: number,
      public team: Team
      ) { }

    _desiredWage(currentDay: number): number {
      return currentDay / 7;
    }

    advanceMorale(opsPercent: number, currentDay: number): boolean {
      var targetMorale = game.currentWage / this._desiredWage(currentDay) * opsPercent;
      this.morale = Util.clamp(this.morale * this.moraleInertia + targetMorale * (1 - this.moraleInertia), 0, 1);
      return !(this.morale < 0.05 && Math.random() < 0.25);
    }
  }

  export module Worker {
    export function fromJSON(json: {}) {
      var worker = new Worker(null, null, null, null, null, null, null, null, null);
      _.merge(worker, json);
      return worker;
    }
  }
}
