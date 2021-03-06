/// <reference path="../../public/third-party-js/backbone.d.ts" />

module Miner {
  export class OreView extends Backbone.View<any> {
    events() {
      return {
        'click .sell-ore': '_sellOre'
      };
    }

    constructor(options: Backbone.ViewOptions<any>) {
      super(options);

      dispatcher.on('update', this.render, this);
      this.render();
    }

    render() {
      var oreString = Util.numberWithCommas(game.ore) + ' tons @ ' + Util.numberWithCommas(game.orePrice()) + 'z / ton';
      this.$('.ore-ticker').text(oreString);
      this.$('.sell-ore').toggle(game.ore > 0);
      return this;
    }

    _sellOre() {
      var result = game.sellOre(game.ore);
      if (result.result === Result.SUCCESS) {
        console.log('Sold ' + result.soldQuantity + ' tons of ore for ' + result.revenue + ' zeny.');
      } else {
        alert('Failed to sell ore: ' + result + '.');
      }
    }
  }
}
