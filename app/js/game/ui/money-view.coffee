class Miner.UI.MoneyView extends Backbone.View
  initialize: (options) ->
    @render()
    @listenTo(game.session, 'money:gain', @_onGain)
    @listenTo(game.session, 'money:loss', @_onLoss)

  render: ->
    @$el.text('$' + _.numberFormat(game.session.money))

  _onGain: () -> @render()
  _onLoss: () -> @render()
