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
    MEDICAL,
    OPS
  }

  export class Worker {
    // Numbers are all in the range [0, 1].
    constructor(
      public name: string,
      public gender: Gender,
      public miningSkill: number,
      public techSkill: number,
      public medicalSkill: number,
      public opsSkill: number,
      public morale: number,
      public team: Team
    ) { }

    _desiredWage(currentDay: number): number {
      return currentDay / 7;
    }

    static MORALE_INERTIA = 0.9;

    advanceMorale(opsPercent: number, currentDay: number) {
      var targetMorale = game.currentWage / this._desiredWage(currentDay) * opsPercent;
      this.morale = Util.clamp(this.morale * Worker.MORALE_INERTIA + targetMorale * (1 - Worker.MORALE_INERTIA), 0, 1);
    }
  }
}
