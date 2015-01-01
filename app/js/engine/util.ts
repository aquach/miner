/// <reference path="../../public/third-party-js/lodash.d.ts" />

module Miner {
  export module Util {
  //  interface EnumV {
  //    id: number;
  //    name: string;
  //  };
  //
  //  export function createEnum(...list: string[]) {
  //    var obj: { [k: string]: EnumV } = {};
  //    var id = 1
  //    _.each(list, item => {
  //      obj[item] = {
  //        id: id,
  //        name: item,
  //        toString: () => item
  //      };
  //      id++;
  //    });
  //    return obj;
  //  }

    export function clamp(value: number, low: number, high: number): number {
      if (value < low)
        return low;
      else if (value > high)
        return high;
      else
        return value;
    };

    export function sum(list: number[]): number {
      return _.reduce(list, ((memo: number, num: number) => memo + num), 0);
    }

    export function numberWithCommas(x: number) {
      return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    var randomCache: number = null;
    export function sampleNormal(mean: number, sigma: number): number {
      var value: number;
      if (randomCache != null) {
        value = randomCache;
        randomCache = null;
      } else {
        var u1 = Math.random();
        var u2 = Math.random();
        var coeff = Math.sqrt(-2 * Math.log(u1));
        value = coeff * Math.cos(2 * Math.PI * u1);
        randomCache = coeff * Math.sin(2 * Math.PI * u2);
      }

      return mean + sigma * value;
    }
  }
}
