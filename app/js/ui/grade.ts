
module Miner {
  export function grade(n: number): string {
    if (n < 0.16)
      return 'E';
    else if (n < 0.33)
      return 'D';
    else if (n < 0.5)
      return 'C';
    else if (n < 0.66)
      return 'B';
    else if (n < 0.84)
      return 'A';
    else if (n <= 1)
      return 'S';
  }
}
