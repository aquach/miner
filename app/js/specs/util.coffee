describe 'Util', ->
  it 'clamps', ->
    expect(_.clamp(-1, 1, 4)).toBe(1)
    expect(_.clamp(2, 1, 4)).toBe(2)
    expect(_.clamp(5, 1, 4)).toBe(4)

  it 'samples the normal distribution', ->
    mean = 5
    sigma = 2
    n = 5000
    values = (Miner.Util.sampleNormal(mean, sigma) for i in [0..n])
    sampledMean = _.sum(values) / n
    sampledVariance = _.sum(_.map(values, (value) -> value * value)) / (n - 1) - sampledMean * sampledMean
    expect(sampledMean).toBeCloseTo(mean, 0)
    expect(sampledVariance).toBeCloseTo(sigma * sigma, 0)
