class Miner.UI.GridView extends Backbone.View
  events:
    'click .cell': '_onClickCell'
    'touchstart .cell': '_onClickCell'

  initialize: (options) ->
    for row in [0..game.world.height - 1]
      $row = $('<div>').addClass('row')
      for col in [0..game.world.width - 1]
        $cell = $('<div>').addClass('cell').addClass('r' + row).addClass('c' + col)
          .data({ row: row, col: col })
        $row.append($cell)
      @$el.append($row)

    @render()

  render: ->
    for row in [0..game.world.height - 1]
      for col in [0..game.world.width - 1]
        tile = game.world.getTile(col, row, 0)
        name = tile.buildingType?.name ? tile.terrainType.id
        @$(".cell.r#{row}.c#{col}").text(name)

  _onClickCell: (event) ->
    targetCell = $(event.target)
    col = targetCell.data('col')
    row = targetCell.data('row')
    tile = game.world.getTile(col, row, 0)

    selectedBuilding = $('.build-panel select').val()
    if selectedBuilding != "-1"
      buildingType = _.where(Miner.BuildingType, { id: +selectedBuilding })[0]
      console.log(game.session.buildBuilding(game.world, tile, buildingType))

