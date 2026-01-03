import 'package:habit_bucket/core/local/app_db.dart';
import 'package:habit_bucket/utils/period_keys.dart';

// opportunities = number of periods where habit was due

int opportunitiesForHabitInRange({
  required Habit habit,
  required DateTime rangeStart,
  required DateTime rangeEnd,
  required int weekStartsOn,
}) {
  final start = startOfDay(rangeStart);
  final end = startOfDay(rangeEnd);

  if (end.isBefore(start)) return 0;

  switch (habit.frequency) {
    case 'daily':
      return end.difference(start).inDays + 1;

    case 'weekly': {
      // count week starts between start..end inclusive
      DateTime ws = weekStart(start, weekStartsOn: weekStartsOn);
      if (ws.isBefore(start)) ws = ws.add(const Duration(days: 7));
      int count = 0;
      while (!ws.isAfter(end)) {
        count++;
        ws = ws.add(const Duration(days: 7));
      }
      return count;
    }

    case 'monthly': {
      DateTime mk = monthKey(start);
      if (mk.isBefore(start)) {
        // if start is after the 1st, move to next month
        mk = DateTime(mk.year, mk.month + 1, 1);
      }
      int count = 0;
      while (!mk.isAfter(end)) {
        count++;
        mk = DateTime(mk.year, mk.month + 1, 1);
      }
      return count;
    }

    default:
      return 0;
  }
}
