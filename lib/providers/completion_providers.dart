import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/core/local/app_db.dart';
import 'package:habit_bucket/providers/providers.dart';
import 'package:habit_bucket/utils/period_keys.dart';

DateTime periodKeyForHabit({
  required Habit habit,
  required DateTime now,
  required int weekStartsOn,
}) {
  switch (habit.frequency) {
    case 'daily':
      return startOfDay(now);
    case 'weekly':
      return weekStart(now, weekStartsOn: weekStartsOn);
    case 'monthly':
      return monthKey(now);
    default:
      return startOfDay(now);
  }
}

final isCompletedProvider =
    StreamProvider.family<bool, ({String habitId, DateTime periodKey})>((ref, args) {
  return ref
      .watch(localCompletionRepoProvider)
      .watchIsCompleted(args.habitId, args.periodKey);
});
