class Miner.UI.GridView extends Backbone.View
  events:
    'click .cell': '_onClickCell'
    'touchstart .cell': '_onClickCell'

  initialize: (options) ->
    for row in [0..game.world.height - 1]
      $row = $('<div>').addClass('row')
      for col in [0..game.world.width - 1]
        $row.append($('<div>').addClass('cell').addClass('r' + row).addClass('c' + col))
      @$el.append($row)

    @render()

  render: ->
    for row in [0..game.world.height - 1]
      for col in [0..game.world.width - 1]
        tile = game.world.getTile(row, col, 0)
        name = tile.buildingType?.name ? tile.terrainType.id
        @$(".cell.r#{row}.c#{col}").text(name)

  _onClickCell: (event) ->
    console.log($(event.target).text())
