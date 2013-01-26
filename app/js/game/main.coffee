$(->
  window.game = Miner.Game.createNewGame()

  new Miner.UI.GridView(el: $('.grid'))

  # Debug refreshing.
  $.event.special.swipe.horizontalDistanceThreshold = 300
  $(document).swipe(->
    $('body').remove()
    window.location.reload()
  )
)
