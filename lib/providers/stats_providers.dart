import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/core/local/app_db.dart';
import 'package:habit_bucket/core/stats/stats_repository.dart';
import 'package:habit_bucket/providers/providers.dart';
import 'package:habit_bucket/utils/period_keys.dart';
import 'package:habit_bucket/core/stats/opportunities.dart';
import 'package:habit_bucket/core/stats/streaks.dart';
import 'package:habit_bucket/providers/completion_providers.dart';

final statsRepoProvider = Provider<StatsRepository>((ref) {
  return StatsRepository(ref.watch(appDbProvider));
});

class DashboardStats {
  final int completions;
  final int opportunities;
  final double consistency; // 0..1
  final int missedMoments;

  DashboardStats({
    required this.completions,
    required this.opportunities,
    required this.consistency,
    required this.missedMoments,
  });
}

/// “This week” summary for Stats screen (you can add month/year later)
final thisWeekStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final uid = ref.watch(userIdProvider);
  if (uid == null) {
    return DashboardStats(
      completions: 0,
      opportunities: 0,
      consistency: 0,
      missedMoments: 0,
    );
  }

  final weekStartsOn = await ref.watch(weekStartsOnProvider.future);
  final now = DateTime.now();
  final start = weekStart(now, weekStartsOn: weekStartsOn);
  final end = start.add(const Duration(days: 6));

  // final habits = await ref.read(statsRepoProvider).activeHabitsUpTo(end);
  final habits = await ref.read(statsRepoProvider).habitsActiveDuring(start, end);
  final opportunities = habits.fold<int>(
    0,
    (sum, h) => sum + opportunitiesForHabitInRange(
      habit: h,
      rangeStart: start,
      rangeEnd: end,
      weekStartsOn: weekStartsOn,
    ),
  );

  final completions =
      await ref.read(statsRepoProvider).completedCountBetween(start, end);

  final missed = (opportunities - completions).clamp(0, 1 << 30);
  final consistency = opportunities == 0 ? 0 : completions / opportunities;

  return DashboardStats(
    completions: completions,
    opportunities: opportunities,
    consistency: consistency.toDouble(),
    missedMoments: missed,
  );
});

class HabitStreak {
  final String habitId;
  final int current;
  final int longest;
  HabitStreak(this.habitId, this.current, this.longest);
}

/// Streaks for all habits in the current view period
final habitStreaksProvider = FutureProvider<Map<String, HabitStreak>>((ref) async {
  final habits = await ref.watch(habitsProvider.future);
  final weekStartsOn = await ref.watch(weekStartsOnProvider.future);
  final now = DateTime.now();

  final repo = ref.read(statsRepoProvider);
  final map = <String, HabitStreak>{};

  for (final h in habits) {
    final key = periodKeyForHabit(habit: h, now: now, weekStartsOn: weekStartsOn);
    final keys = await repo.completionKeysForHabit(h.id);
    final s = calculateStreak(
      keysSorted: keys,
      frequency: h.frequency,
      currentPeriodKey: key,
    );
    map[h.id] = HabitStreak(h.id, s.current, s.longest);
  }

  return map;
});












enum StatsRange { week, month, last30Days, ytd, allTime }

final selectedStatsRangeProvider =
    StateProvider<StatsRange>((ref) => StatsRange.week);

({DateTime start, DateTime end, String label}) windowForRange({
  required StatsRange range,
  required DateTime now,
  required int weekStartsOn,
}) {
  final today = startOfDay(now);

  switch (range) {
    case StatsRange.week: {
      final start = weekStart(today, weekStartsOn: weekStartsOn);
      final end = start.add(const Duration(days: 6));
      return (start: start, end: end, label: "This week");
    }
    case StatsRange.month: {
      final start = DateTime(today.year, today.month, 1);
      final end = DateTime(today.year, today.month + 1, 0); // last day of month
      return (start: start, end: end, label: "This month");
    }
    case StatsRange.last30Days: {
      final start = today.subtract(const Duration(days: 29));
      return (start: start, end: today, label: "Last 30 days");
    }
    case StatsRange.ytd: {
      final start = DateTime(today.year, 1, 1);
      return (start: start, end: today, label: "Year to date");
    }
    case StatsRange.allTime: {
      // earliest reasonable start (or keep it fixed)
      final start = DateTime(2000, 1, 1);
      return (start: start, end: today, label: "All time");
    }
  }
}

final dashboardStatsProvider =
    FutureProvider.family<DashboardStats, StatsRange>((ref, range) async {
  final uid = ref.watch(userIdProvider);
  if (uid == null) {
    return DashboardStats(
      completions: 0,
      opportunities: 0,
      consistency: 0,
      missedMoments: 0,
    );
  }

  final weekStartsOn = await ref.watch(weekStartsOnProvider.future);
  final now = DateTime.now();

  final w = windowForRange(range: range, now: now, weekStartsOn: weekStartsOn);
  final start = w.start;
  final end = w.end;

  final repo = ref.read(statsRepoProvider);

  final habits = await repo.habitsActiveDuring(start, end);

  final opportunities = habits.fold<int>(
    0,
    (sum, h) => sum + opportunitiesForHabitInRange(
      habit: h,
      rangeStart: start,
      rangeEnd: end,
      weekStartsOn: weekStartsOn,
    ),
  );

  final completions = await repo.completedCountBetween(start, end);

  final missed = (opportunities - completions).clamp(0, 1 << 30);
  final consistency = opportunities == 0 ? 0 : completions / opportunities;

  return DashboardStats(
    completions: completions,
    opportunities: opportunities,
    consistency: consistency.toDouble(),
    missedMoments: missed,
  );
});













class HabitRangeStat {
  final Habit habit;
  final int completions;
  final int opportunities;
  final double rate; // 0..1
  HabitRangeStat({
    required this.habit,
    required this.completions,
    required this.opportunities,
    required this.rate,
  });
}

class StatsAggregates {
  final String label;
  final HabitRangeStat? bestHabit;
  final int longestStreakOverall;
  final List<HabitRangeStat> perHabit; // sorted best->worst

  StatsAggregates({
    required this.label,
    required this.bestHabit,
    required this.longestStreakOverall,
    required this.perHabit,
  });
}

final statsAggregatesProvider =
    FutureProvider.family<StatsAggregates, StatsRange>((ref, range) async {
  final weekStartsOn = await ref.watch(weekStartsOnProvider.future);
  final now = DateTime.now();

  final w = windowForRange(range: range, now: now, weekStartsOn: weekStartsOn);
  final start = w.start;
  final end = w.end;

  final repo = ref.read(statsRepoProvider);

  final habits = await repo.habitsActiveDuring(start, end);

  // completion counts per habit in range
  final counts = await repo.completionCountsPerHabit(start, end);
  final countMap = {for (final x in counts) x.habitId: x.count};

  final perHabit = <HabitRangeStat>[];
  for (final h in habits) {
    final opp = opportunitiesForHabitInRange(
      habit: h,
      rangeStart: start,
      rangeEnd: end,
      weekStartsOn: weekStartsOn,
    );
    final done = countMap[h.id] ?? 0;
    final rate = opp == 0 ? 0.0 : (done / opp);
    perHabit.add(HabitRangeStat(
      habit: h,
      completions: done,
      opportunities: opp,
      rate: rate,
    ));
  }

  // Guard: require a minimum number of opportunities so "1/1" doesn't always win
  const minOppForBest = 5;

  perHabit.sort((a, b) {
    final ar = (a.opportunities >= minOppForBest) ? a.rate : -1.0;
    final br = (b.opportunities >= minOppForBest) ? b.rate : -1.0;
    final byRate = br.compareTo(ar);
    if (byRate != 0) return byRate;
    return b.completions.compareTo(a.completions);
  });

  final best = perHabit.isEmpty ? null : perHabit.first;
  // final streaks = await ref.watch(habitStreaksProvider.future);
  final streaks = await ref.watch(allHabitStreaksProvider.future);
  final longestOverall = streaks.values.fold<int>(
    0,
    (maxSoFar, s) => s.longest > maxSoFar ? s.longest : maxSoFar,
  );

  return StatsAggregates(
    label: w.label,
    bestHabit: best,
    longestStreakOverall: longestOverall,
    perHabit: perHabit,
  );
});
