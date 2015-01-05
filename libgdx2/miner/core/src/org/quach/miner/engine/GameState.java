package org.quach.miner.engine;

import com.badlogic.gdx.math.MathUtils;
import com.google.common.base.Optional;
import com.google.common.base.Predicate;
import com.google.common.collect.Iterators;
import com.google.common.collect.Lists;
import org.quach.miner.Miner;

import javax.annotation.Nullable;
import java.util.Iterator;
import java.util.List;

public class GameState {
  public int money;
  public int ore;
  public int currentDay;
  public int currentWage;
  public final World world;
  public final List<Worker> workers;
  public float yesterdaysMorale;
  public int interviewsConductedToday;
  public Worker lastInterviewedWorker;
  public boolean hiredToday;

  public GameState(
    int money,
    int ore,
    int currentDay,
    int currentWage,
    World world,
    List<Worker> workers,
    float yesterdaysMorale,
    final int interviewsConductedToday,
    Worker lastInterviewedWorker,
    boolean hiredToday
  ) {
    this.money = money;
    this.ore = ore;
    this.currentDay = currentDay;
    this.currentWage = currentWage;
    this.world = world;
    this.workers = workers;
    this.yesterdaysMorale = yesterdaysMorale;
    this.interviewsConductedToday = interviewsConductedToday;
    this.lastInterviewedWorker = lastInterviewedWorker;
    this.hiredToday = hiredToday;
  }

  private boolean deductMoney(int amount) {
    if (money - amount < 0)
      return false;

    money -= amount;
    return true;
  }

  private void gainMoney(int amount) {
    money += amount;
  }

  public int orePrice() {
    return (int)(Math.sin(currentDay / 30) * 10 + 20); // TODO
  }

  public SellOreResult sellOre(int amount) {
    if (ore < amount)
      return SellOreResult.create(Result.INSUFFICIENT_ORE, null, null);

    int revenue = amount * orePrice();
    gainMoney(revenue);
    ore -= amount;
    //dispatcher.trigger('update');

    return SellOreResult.create(Result.SUCCESS, amount, revenue);
  }

  public float interestRate() {
    boolean hasBank = world.countConstructedBuildings(BuildingType.SPACEBANK) > 0;
    return hasBank ? 0.005f : 0;
  }

  private void earnInterest() {
    int revenue = (int)(money * interestRate());
    gainMoney(revenue);
  }

  public CollectionGoal nextCollectionGoal() {
    return Iterators.find(Iterators.forArray(Miner.COLLECTION_DAYS), new Predicate<CollectionGoal>() {
      @Override
      public boolean apply(@Nullable final CollectionGoal c) {
        return c.day() >= currentDay;
      }
    });
  }

  private Result checkCollection() {
    Optional<CollectionGoal> collectionDay = Iterators.tryFind(Iterators.forArray(Miner.COLLECTION_DAYS), new Predicate<CollectionGoal>() {
      @Override
      public boolean apply(@Nullable final CollectionGoal c) {
        return c.day() == currentDay;
      }
    });
    if (collectionDay.isPresent()) {
      if (!deductMoney(collectionDay.get().amount()))
        return Result.GAME_OVER;
    }

    return Result.SUCCESS;
  }

  public float morale() {
    float totalMorale = 0;
    for (Worker w: workers) {
      totalMorale += w.morale;
    }
    return workers.size() > 0 ? totalMorale / workers.size() : 1;
  }

  private void payWorkers() {
    int amountToPay = workers.size() * currentWage;
    if (!deductMoney(amountToPay)) {
      // Not enough to pay everyone; recompute wage using all money remaining.
      currentWage = Math.max(0, money / workers.size());
      deductMoney(workers.size() * currentWage);
    }
  }

  public Result buildBuilding(int x, int y, BuildingType b) {
    Result isPlaceable = world.canPlaceBuilding(x, y, b);
    if (isPlaceable != Result.SUCCESS)
      return isPlaceable;

    if (!deductMoney(b.cost))
      return Result.INSUFFICIENT_FUNDS;

    world.placeBuilding(x, y, b);
    //dispatcher.trigger('update');

    return Result.SUCCESS;
  }

  private void mineForOre() {
    int oreProduction = 1 + world.countConstructedBuildings(BuildingType.MINE) * 10;
    ore += Math.ceil(oreProduction * miningSaturation());
  }

  public float miningSaturation() {
    int numMines = world.countConstructedBuildings(BuildingType.MINE);
    float totalSkill = workerStats().miningSkill();
    return numMines == 0 ? 1 : MathUtils.clamp(totalSkill / numMines, 0, 1);
  }

  public float opsPercent() {
    int numBuildings = world.numConstructedBuildings();
    int numWorkers = workers.size();
    float opsBurden = numBuildings / 5.0f + numWorkers / 10.0f;
    float opsSkill = workerStats().opsSkill();
    return opsBurden == 0 ? 1 : opsSkill / opsBurden;
  }

  public int workerCapacity() {
    return (world.countConstructedBuildings(BuildingType.QUARTERS) + 1) * 5;
  }

  public WorkerStats workerStats() {
    // TODO: doesn't take teams into account
    float miningSkill = 0;
    float techSkill = 0;
    float opsSkill = 0;

    for (Worker w: workers) {
      miningSkill += w.miningSkill;
      techSkill += w.techSkill;
      opsSkill += w.opsSkill;
    }
    return WorkerStats.create(miningSkill, techSkill, opsSkill);
  }

  public WorkerRollResult rollWorker() {
    if (interviewsConductedToday >= 3)
      return WorkerRollResult.create(Result.TOO_MANY_INTERVIEWS, null);

    if (workers.size() >= workerCapacity())
      return WorkerRollResult.create(Result.NO_SPACE_FOR_WORKER, null);

    if (hiredToday)
      return WorkerRollResult.create(Result.ALREADY_HIRED_TODAY, null);

    if (!deductMoney(100))
      return WorkerRollResult.create(Result.INSUFFICIENT_FUNDS, null);

    Gender[] genderPool = {
      Gender.MALE,
      Gender.MALE,
      Gender.MALE,
      Gender.FEMALE,
      Gender.FEMALE,
      Gender.FEMALE,
      Gender.OTHER
    };

    Worker newWorker = new Worker(
      MathUtils.random(1 << 30),
      Miner.WORKER_NAME_POOL[MathUtils.random(Miner.WORKER_NAME_POOL.length)],
      genderPool[MathUtils.random(genderPool.length)],
      MathUtils.clamp((float)MinerMath.sampleNormal(0.3, 0.3), 0, 1),
      MathUtils.clamp((float)MinerMath.sampleNormal(0.3, 0.3), 0, 1),
      MathUtils.clamp((float)MinerMath.sampleNormal(0.3, 0.3), 0, 1),
      1,
      MathUtils.clamp((float)MinerMath.sampleNormal(0.8, 0.1), 0, 0.9f),
      null
    );

    lastInterviewedWorker = newWorker;
    interviewsConductedToday++;

    //dispatcher.trigger('update');

    return WorkerRollResult.create(Result.SUCCESS, newWorker);
  }

  public void hireInterviewedWorker() {
    workers.add(lastInterviewedWorker);
    lastInterviewedWorker = null;
    hiredToday = true;
    //dispatcher.trigger('update');
  }

  public Result advanceToNextDay() {
    Result result = checkCollection();
    if (result != Result.SUCCESS) return result;

    currentDay++;

    world.advanceConstruction();
    earnInterest();

    payWorkers();

    yesterdaysMorale = morale();
    Iterator<Worker> workerIter = workers.iterator();
    while (workerIter.hasNext()) {
      final Worker w = workerIter.next();
      boolean isStaying = w.advanceMorale(currentWage, opsPercent(), currentDay);
      if (!isStaying)
        workerIter.remove();
    }

    mineForOre();

    interviewsConductedToday = 0;
    lastInterviewedWorker = null;
    hiredToday = false;

    //dispatcher.trigger('update');

    // TODO
    //checkForDeaths(healthRating, foodRating)

    return Result.SUCCESS;
  }

  public static GameState newGameState() {
    return new GameState(
      3000,
      0,
      1,
      25,
      World.newWorld(4, 0.2f, 0.1f),
      Lists.newArrayList(
        new Worker(1, "Alice", Gender.FEMALE, 0.5f, 0.1f, 0.1f, 1, 0.9f, Team.MINING),
        new Worker(2, "Bob", Gender.MALE, 0.1f, 0.5f, 0.1f, 1, 0.9f, Team.TECH),
        new Worker(3, "Carol", Gender.OTHER, 0.1f, 0.1f, 0.5f, 1, 0.9f, Team.OPS)
      ),
      1,
      0,
      null,
      false
    );
  }
}
