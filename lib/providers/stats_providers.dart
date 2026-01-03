import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  final habits = await ref.read(statsRepoProvider).activeHabitsUpTo(end);
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
