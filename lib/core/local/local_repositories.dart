import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'app_db.dart';

final _uuid = Uuid();

class LocalHabitRepository {
  final AppDb db;
  LocalHabitRepository(this.db);

  Stream<List<Habit>> watchActiveHabits() {
    final q =
        (db.select(db.habits)
              ..where((t) => t.archivedAt.isNull() & t.deleted.equals(false))
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .watch();
    return q;
  }

  Future<String> createHabit({
    required String title,
    required String frequency, // daily/weekly/monthly
    int? weeklyDay,
    int? monthlyDay,
    required bool reminderEnabled,
    required bool reminderRandom,
    int? reminderTimeMinutes,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();

    await db
        .into(db.habits)
        .insert(
          HabitsCompanion.insert(
            id: id,
            title: title,
            frequency: frequency,
            weeklyDay: Value(weeklyDay),
            monthlyDay: Value(monthlyDay),
            reminderEnabled: Value(reminderEnabled),
            reminderRandom: Value(reminderRandom),
            reminderTimeMinutes: Value(reminderTimeMinutes),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );

    return id;
  }

  Future<void> softDeleteHabit(String habitId) async {
    await (db.update(db.habits)..where((t) => t.id.equals(habitId))).write(
      HabitsCompanion(
        deleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Stream<List<Habit>> watchAllNonDeletedHabits() {
    final q =
        (db.select(db.habits)
              ..where((t) => t.deleted.equals(false))
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .watch();
    return q;
  }

  Future<List<Habit>> getAllNonDeletedHabits() {
    final q = (db.select(db.habits)
      ..where((t) => t.deleted.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]));
    return q.get();
  }

  // Future<List<Habit>> getAllNonDeletedHabits() {
  //   final q = (db.select(db.habits)
  //     ..where((t) => t.deleted.equals(false))
  //     ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]));
  //   return q.get();
  // }

  Future<Habit?> getHabitById(String id) {
    return (db.select(
      db.habits,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> countActiveHabitsByFrequency(String frequency) async {
    final habits = await (db.select(db.habits)
          ..where((t) =>
              t.archivedAt.isNull() &
              t.deleted.equals(false) &
              t.frequency.equals(frequency)))
        .get();
    return habits.length;
  }
}

class LocalCompletionRepository {
  final AppDb db;
  LocalCompletionRepository(this.db);

  /// periodKey must be normalized (midnight local) for daily/weekly/monthly logic.
  Stream<bool> watchIsCompleted(String habitId, DateTime periodKey) {
    final q =
        (db.select(db.completions)..where(
              (t) =>
                  t.habitId.equals(habitId) &
                  t.periodKey.equals(periodKey) &
                  t.deleted.equals(false),
            ))
            .watch();
    return q.map((rows) => rows.isNotEmpty);
  }

  // Future<void> markCompleted(String habitId, DateTime periodKey) async {
  //   final now = DateTime.now();
  //   await db.into(db.completions).insert(
  //         CompletionsCompanion.insert(
  //           id: _uuid.v4(),
  //           habitId: habitId,
  //           periodKey: periodKey,
  //           createdAt: Value(now),
  //           updatedAt: Value(now),
  //         ),
  //         mode: InsertMode.insertOrIgnore,
  //       );
  // }

  // Future<void> unmarkCompleted(String habitId, DateTime periodKey) async {
  //   // Soft delete any matching completion row
  //   final q = db.update(db.completions)
  //     ..where((t) => t.habitId.equals(habitId) & t.periodKey.equals(periodKey));
  //   await q.write(
  //     CompletionsCompanion(
  //       deleted: const Value(true),
  //       updatedAt: Value(DateTime.now()),
  //     ),
  //   );
  // }

  Future<void> markCompleted(String habitId, DateTime periodKey) async {
    final now = DateTime.now();

    // 1) Try to revive an existing (possibly soft-deleted) row
    final updatedCount =
        await (db.update(db.completions)..where(
              (t) => t.habitId.equals(habitId) & t.periodKey.equals(periodKey),
            ))
            .write(
              CompletionsCompanion(
                deleted: const Value(false),
                updatedAt: Value(now),
              ),
            );

    if (updatedCount > 0) return;

    // 2) Otherwise insert new
    await db
        .into(db.completions)
        .insert(
          CompletionsCompanion.insert(
            id: _uuid.v4(),
            habitId: habitId,
            periodKey: periodKey,
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> unmarkCompleted(String habitId, DateTime periodKey) async {
    final q = db.update(db.completions)
      ..where((t) => t.habitId.equals(habitId) & t.periodKey.equals(periodKey));

    await q.write(
      CompletionsCompanion(
        deleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> isCompletedOnce(String habitId, DateTime periodKey) async {
    final rows =
        await (db.select(db.completions)..where(
              (t) =>
                  t.habitId.equals(habitId) &
                  t.periodKey.equals(periodKey) &
                  t.deleted.equals(false),
            ))
            .get();
    return rows.isNotEmpty;
  }
}

class LocalProfileRepository {
  final AppDb db;
  LocalProfileRepository(this.db);

  Stream<int> watchWeekStartsOn(String userId) {
    final q = (db.select(
      db.profile,
    )..where((t) => t.userId.equals(userId))).watchSingleOrNull();
    return q.map((row) => row?.weekStartsOn ?? 1);
  }

  Stream<ProfileData?> watchProfile(String userId) {
    final q = (db.select(
      db.profile,
    )..where((t) => t.userId.equals(userId))).watchSingleOrNull();
    return q;
  }

  Future<ProfileData?> getProfile(String userId) async {
    return await (db.select(db.profile)
          ..where((t) => t.userId.equals(userId)))
        .getSingleOrNull();
  }

  Future<void> upsertWeekStartsOn(String userId, int value) async {
    await db
        .into(db.profile)
        .insertOnConflictUpdate(
          ProfileCompanion(
            userId: Value(userId),
            weekStartsOn: Value(value),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<void> createProfile({
    required String userId,
    required String firstName,
    required String lastName,
    int weekStartsOn = 1,
  }) async {
    await db.into(db.profile).insert(
          ProfileCompanion(
            userId: Value(userId),
            firstName: Value(firstName),
            lastName: Value(lastName),
            weekStartsOn: Value(weekStartsOn),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<void> updateProfileNames({
    required String userId,
    required String firstName,
    required String lastName,
  }) async {
    await (db.update(db.profile)..where((t) => t.userId.equals(userId))).write(
      ProfileCompanion(
        firstName: Value(firstName),
        lastName: Value(lastName),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
