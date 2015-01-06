package org.quach.miner.engine;

import com.badlogic.gdx.math.MathUtils;
import com.google.common.base.Optional;
import com.google.common.base.Predicate;
import com.google.common.collect.Iterators;
import com.google.common.collect.Lists;
import org.quach.miner.Dispatcher;
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
    final int money,
    final int ore,
    final int currentDay,
    final int currentWage,
    final World world,
    final List<Worker> workers,
    final float yesterdaysMorale,
    final int interviewsConductedToday,
    final Worker lastInterviewedWorker,
    final boolean hiredToday
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

  private boolean deductMoney(final int amount) {
    if (money - amount < 0)
      return false;

    money -= amount;
    return true;
  }

  private void gainMoney(final int amount) {
    money += amount;
  }

  public int orePrice() {
    return (int)(Math.sin(currentDay / 30) * 10 + 20); // TODO
  }

  public SellOreResult sellOre(final int amount) {
    if (ore < amount)
      return SellOreResult.create(Result.INSUFFICIENT_ORE, null, null);

    final int revenue = amount * orePrice();
    gainMoney(revenue);
    ore -= amount;
    Dispatcher.trigger("update");

    return SellOreResult.create(Result.SUCCESS, amount, revenue);
  }

  public float interestRate() {
    final boolean hasBank = world.countConstructedBuildings(BuildingType.SPACEBANK) > 0;
    return hasBank ? 0.005f : 0;
  }

  private void earnInterest() {
    final int revenue = (int)(money * interestRate());
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
    final Optional<CollectionGoal> collectionDay = Iterators.tryFind(Iterators.forArray(Miner.COLLECTION_DAYS), new Predicate<CollectionGoal>() {
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
    for (final Worker w: workers) {
      totalMorale += w.morale;
    }
    return workers.size() > 0 ? totalMorale / workers.size() : 1;
  }

  private void payWorkers() {
    final int amountToPay = workers.size() * currentWage;
    if (!deductMoney(amountToPay)) {
      // Not enough to pay everyone; recompute wage using all money remaining.
      currentWage = Math.max(0, money / workers.size());
      deductMoney(workers.size() * currentWage);
    }
  }

  public Result buildBuilding(final int x, final int y, final BuildingType b) {
    final Result isPlaceable = world.canPlaceBuilding(x, y, b);
    if (isPlaceable != Result.SUCCESS)
      return isPlaceable;

    if (!deductMoney(b.cost))
      return Result.INSUFFICIENT_FUNDS;

    world.placeBuilding(x, y, b);
    Dispatcher.trigger("update");

    return Result.SUCCESS;
  }

  private void mineForOre() {
    final int oreProduction = 1 + world.countConstructedBuildings(BuildingType.MINE) * 10;
    ore += Math.ceil(oreProduction * miningSaturation());
  }

  public float miningSaturation() {
    final int numMines = world.countConstructedBuildings(BuildingType.MINE);
    final float totalSkill = workerStats().miningSkill();
    return numMines == 0 ? 1 : MathUtils.clamp(totalSkill / numMines, 0, 1);
  }

  public float opsPercent() {
    final int numBuildings = world.numConstructedBuildings();
    final int numWorkers = workers.size();
    final float opsBurden = numBuildings / 5.0f + numWorkers / 10.0f;
    final float opsSkill = workerStats().opsSkill();
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

    for (final Worker w: workers) {
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

    final Gender[] genderPool = {
      Gender.MALE,
      Gender.MALE,
      Gender.MALE,
      Gender.FEMALE,
      Gender.FEMALE,
      Gender.FEMALE,
      Gender.OTHER
    };

    final Worker newWorker = new Worker(
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

    Dispatcher.trigger("update");

    return WorkerRollResult.create(Result.SUCCESS, newWorker);
  }

  public void hireInterviewedWorker() {
    workers.add(lastInterviewedWorker);
    lastInterviewedWorker = null;
    hiredToday = true;
    Dispatcher.trigger("update");
  }

  public Result advanceToNextDay() {
    final Result result = checkCollection();
    if (result != Result.SUCCESS) return result;

    currentDay++;

    world.advanceConstruction();
    earnInterest();

    payWorkers();

    yesterdaysMorale = morale();
    final Iterator<Worker> workerIter = workers.iterator();
    while (workerIter.hasNext()) {
      final Worker w = workerIter.next();
      final boolean isStaying = w.advanceMorale(currentWage, opsPercent(), currentDay);
      if (!isStaying)
        workerIter.remove();
    }

    mineForOre();

    interviewsConductedToday = 0;
    lastInterviewedWorker = null;
    hiredToday = false;

    Dispatcher.trigger("update");

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
