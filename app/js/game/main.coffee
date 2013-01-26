_.mixin(_.string.exports())

$(->
  window.game = Miner.Game.createNewGame()

  ui = window.ui = {}
  ui.gridView = new Miner.UI.GridView(el: $('.grid'))
  ui.moneyView = new Miner.UI.MoneyView(el: $('.money'))

  # Debug refreshing.
  $.event.special.swipe.horizontalDistanceThreshold = 300
  $(document).swipe(->
    $('body').remove()
    window.location.reload()
  )
)
