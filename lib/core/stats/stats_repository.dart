import 'package:drift/drift.dart';
import 'package:habit_bucket/core/local/app_db.dart';
import 'package:habit_bucket/utils/period_keys.dart';

class StatsRepository {
  final AppDb db;
  StatsRepository(this.db);

  /// Completed count between [start, end] inclusive (based on completion period keys)
  Future<int> completedCountBetween(DateTime start, DateTime end) async {
    final s = startOfDay(start);
    final e = startOfDay(end);

    final q = db.selectOnly(db.completions)
      ..addColumns([db.completions.id.count()])
      ..where(db.completions.deleted.equals(false))
      ..where(db.completions.periodKey.isBetweenValues(s, e));
    final row = await q.getSingle();
    return row.read(db.completions.id.count()) ?? 0;
  }

  /// Completed count per habit between [start, end]
  Future<List<({String habitId, int count})>> completionCountsPerHabit(
      DateTime start, DateTime end) async {
    final s = startOfDay(start);
    final e = startOfDay(end);

    final q = db.selectOnly(db.completions)
      ..addColumns([
        db.completions.habitId,
        db.completions.id.count(),
      ])
      ..where(db.completions.deleted.equals(false))
      ..where(db.completions.periodKey.isBetweenValues(s, e))
      ..groupBy([db.completions.habitId]);

    final rows = await q.get();
    return rows
        .map((r) => (
              habitId: r.read(db.completions.habitId)!,
              count: r.read(db.completions.id.count()) ?? 0,
            ))
        .toList();
  }

  /// All completion period keys for a habit (sorted)
  Future<List<DateTime>> completionKeysForHabit(String habitId) async {
    final q = (db.select(db.completions)
          ..where((t) => t.habitId.equals(habitId) & t.deleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.periodKey)]))
        .get();
    final rows = await q;
    return rows.map((e) => e.periodKey).toList();
  }

  /// Habits created on/before a date (not deleted)
  Future<List<Habit>> activeHabitsUpTo(DateTime date) async {
    final d = date;
    return (db.select(db.habits)
          ..where((t) =>
              t.deleted.equals(false) &
              t.archivedAt.isNull() &
              t.createdAt.isSmallerOrEqualValue(d))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }
}
