import 'package:drift/drift.dart';
import 'package:habit_bucket/core/local/app_db.dart';
import 'package:habit_bucket/models/habit_count_model.dart';
import 'package:habit_bucket/utils/period_keys.dart';

class StatsRepository {
  final AppDb db;
  StatsRepository(this.db);

  /// Completed count between [start, end] inclusive (based on completion period keys)
  // Future<int> completedCountBetween(DateTime start, DateTime end) async {
  //   final s = startOfDay(start);
  //   final e = startOfDay(end);

  //   final q = db.selectOnly(db.completions)
  //     ..addColumns([db.completions.id.count()])
  //     ..where(db.completions.deleted.equals(false))
  //     ..where(db.completions.periodKey.isBetweenValues(s, e));
  //   final row = await q.getSingle();
  //   return row.read(db.completions.id.count()) ?? 0;
  // }

  Future<int> completedCountBetween(DateTime start, DateTime end) async {
    final s = startOfDay(start);
    final e = startOfDay(
      end,
    ).add(const Duration(days: 1)); // exclusive upper bound

    // Join completions -> habits so deleted habits don't contribute
    final q =
        db.selectOnly(db.completions).join([
            innerJoin(
              db.habits,
              db.habits.id.equalsExp(db.completions.habitId),
            ),
          ])
          ..addColumns([db.completions.id.count()])
          ..where(db.completions.deleted.equals(false))
          ..where(db.habits.deleted.equals(false))
          ..where(db.completions.periodKey.isBetweenValues(s, e));

    final row = await q.getSingle();
    return row.read(db.completions.id.count()) ?? 0;
  }

  /// Completed count per habit between [start, end]
  // Future<List<({String habitId, int count})>> completionCountsPerHabit(
  //   DateTime start,
  //   DateTime end,
  // ) async {
  //   final s = startOfDay(start);
  //   final e = startOfDay(end);

  //   final q = db.selectOnly(db.completions)
  //     ..addColumns([db.completions.habitId, db.completions.id.count()])
  //     ..where(db.completions.deleted.equals(false))
  //     ..where(db.completions.periodKey.isBetweenValues(s, e))
  //     ..groupBy([db.completions.habitId]);

  //   final rows = await q.get();
  //   return rows
  //       .map(
  //         (r) => (
  //           habitId: r.read(db.completions.habitId)!,
  //           count: r.read(db.completions.id.count()) ?? 0,
  //         ),
  //       )
  //       .toList();
  // }

  Future<List<HabitCount>> completionCountsPerHabit(
    DateTime start,
    DateTime end,
  ) async {
    final s = startOfDay(start);
    final e = startOfDay(end).add(const Duration(days: 1)); // exclusive

    final q =
        db.selectOnly(db.completions).join([
            innerJoin(
              db.habits,
              db.habits.id.equalsExp(db.completions.habitId),
            ),
          ])
          ..addColumns([db.completions.habitId, db.completions.id.count()])
          ..where(db.completions.deleted.equals(false))
          ..where(db.habits.deleted.equals(false))
          ..where(db.completions.periodKey.isBetweenValues(s, e))
          ..groupBy([db.completions.habitId]);

    final rows = await q.get();
    return rows.map((r) {
      final id = r.read(db.completions.habitId)!;
      final c = r.read(db.completions.id.count()) ?? 0;
      return HabitCount(id, c);
    }).toList();
  }

  /// All completion period keys for a habit (sorted)
  // Future<List<DateTime>> completionKeysForHabit(String habitId) async {
  //   final q =
  //       (db.select(db.completions)
  //             ..where(
  //               (t) => t.habitId.equals(habitId) & t.deleted.equals(false),
  //             )
  //             ..orderBy([(t) => OrderingTerm.asc(t.periodKey)]))
  //           .get();
  //   final rows = await q;
  //   return rows.map((e) => e.periodKey).toList();
  // }

  Future<List<DateTime>> completionKeysForHabit(String habitId) async {
    final q =
        db.selectOnly(db.completions).join([
            innerJoin(
              db.habits,
              db.habits.id.equalsExp(db.completions.habitId),
            ),
          ])
          ..addColumns([db.completions.periodKey])
          ..where(db.completions.habitId.equals(habitId))
          ..where(db.completions.deleted.equals(false))
          ..where(db.habits.deleted.equals(false))
          ..orderBy([OrderingTerm.asc(db.completions.periodKey)]);

    final rows = await q.get();
    return rows.map((r) => r.read(db.completions.periodKey)!).toList();
  }

  /// Habits created on/before a date (not deleted)
  // Future<List<Habit>> activeHabitsUpTo(DateTime date) async {
  //   final d = date;
  //   return (db.select(db.habits)
  //         ..where((t) =>
  //             t.deleted.equals(false) &
  //             t.archivedAt.isNull() &
  //             t.createdAt.isSmallerOrEqualValue(d))
  //         ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
  //       .get();
  // }

  /// Habits that were "active at any point" during [start,end]
  /// Rules:
  /// - createdAt <= end
  /// - not deleted
  /// - archivedAt is null OR archivedAt >= start  (still existed during range)
  Future<List<Habit>> habitsActiveDuring(DateTime start, DateTime end) async {
    final s = startOfDay(start);
    final e = startOfDay(end);

    return (db.select(db.habits)
          ..where(
            (t) =>
                t.deleted.equals(false) &
                t.createdAt.isSmallerOrEqualValue(e) &
                (t.archivedAt.isNull() | t.archivedAt.isBiggerOrEqualValue(s)),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }
}
