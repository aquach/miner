/// <reference path="../../public/third-party-js/lodash.d.ts" />

module Miner {
  export enum Gender {
    OTHER,
    FEMALE,
    MALE
  };

  export class Worker {
    // Numbers are all in the range [0, 1].
    constructor(
      public name: string,
      public gender: Gender,
      public miningSkill: number,
      public techSkill: number,
      public medicalSkill: number,
      public opsSkill: number,
      public morale: number
    ) { }

    advanceMorale(food: number) {
      // TODO
    }
  }
}
