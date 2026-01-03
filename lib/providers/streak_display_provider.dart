import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/core/stats/streaks.dart';
import 'package:habit_bucket/providers/stats_providers.dart';

final streakDisplayProvider = FutureProvider.family<int, ({String habitId, String frequency, DateTime currentKey, bool completed})>((ref, args) async {
  final repo = ref.read(statsRepoProvider);
  final keys = await repo.completionKeysForHabit(args.habitId);

  final asOf = args.completed
      ? args.currentKey
      : previousPeriodKey(args.frequency, args.currentKey);

  final s = calculateStreakAsOf(
    keysSorted: keys,
    frequency: args.frequency,
    asOfPeriodKey: asOf,
  );

  return s.current;
});
