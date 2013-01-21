describe 'Tile', ->
  it 'detects adjacent tiles', ->
    expect(new Miner.Tile(0, 0, 0).isAdjacentTo(new Miner.Tile(1, 0, 0))).toBe(true)
    expect(new Miner.Tile(0, 1, 0).isAdjacentTo(new Miner.Tile(1, 0, 0))).toBe(false)
    expect(new Miner.Tile(1, 1, 0).isAdjacentTo(new Miner.Tile(1, 0, 0))).toBe(true)
    expect(new Miner.Tile(2, 2, 2).isAdjacentTo(new Miner.Tile(2, 3, 2))).toBe(true)
    expect(new Miner.Tile(2, 2, 2).isAdjacentTo(new Miner.Tile(2, 3, 0))).toBe(false)
    expect(new Miner.Tile(2, 2, 2).isAdjacentTo(new Miner.Tile(2, 2, 2))).toBe(false)

  it 'recognizes constructed buildings', ->
    tile = new Miner.Tile(0, 0, 0)
    tile.buildingType = Miner.BuildingType.MINE
    expect(tile.isConstructedBuilding()).toBe(true)

    tile.buildingUnderConstruction = true
    expect(tile.isConstructedBuilding()).toBe(false)

    tile = new Miner.Tile(0, 0, 0)
    expect(tile.isConstructedBuilding()).toBe(false)
