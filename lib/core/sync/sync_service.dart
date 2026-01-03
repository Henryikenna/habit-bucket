// import 'package:drift/drift.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:habit_bucket/core/local/app_db.dart';

// class SyncService {
//   final AppDb db;
//   final SupabaseClient supabase;

//   SyncService(this.db, this.supabase);

//   Future<void> sync() async {
//     final user = supabase.auth.currentUser;
//     if (user == null) return;

//     final lastSync = await _getLastSync();
//     final now = DateTime.now().toUtc();

//     await _pushHabits(user.id, lastSync);
//     await _pushCompletions(user.id, lastSync);

//     await _pullHabits(user.id, lastSync);
//     await _pullCompletions(user.id, lastSync);
//     await _pullProfile(user.id);

//     await _setLastSync(now);
//   }

//   Future<DateTime> _getLastSync() async {
//     final row = await db.select(db.syncState)
//         .where((t) => t.key.equals('last_sync'))
//         .getSingleOrNull();

//     return row?.value ?? DateTime.fromMillisecondsSinceEpoch(0);
//   }

//   Future<void> _setLastSync(DateTime time) async {
//     await db.into(db.syncState).insertOnConflictUpdate(
//       SyncStateCompanion(
//         key: const Value('last_sync'),
//         value: Value(time),
//       ),
//     );
//   }

//   // ---------------- PUSH ----------------

//   Future<void> _pushHabits(String userId, DateTime since) async {
//     final local = await (db.select(db.habits)
//           ..where((t) => t.updatedAt.isBiggerThanValue(since)))
//         .get();

//     if (local.isEmpty) return;

//     final payload = local.map((h) => {
//       'id': h.id,
//       'user_id': userId,
//       'title': h.title,
//       'frequency': h.frequency,
//       'weekly_day': h.weeklyDay,
//       'monthly_day': h.monthlyDay,
//       'reminder_enabled': h.reminderEnabled,
//       'reminder_random': h.reminderRandom,
//       'reminder_time_minutes': h.reminderTimeMinutes,
//       'created_at': h.createdAt.toUtc().toIso8601String(),
//       'updated_at': h.updatedAt.toUtc().toIso8601String(),
//       'deleted': h.deleted,
//     }).toList();

//     await supabase.from('habits').upsert(payload);
//   }

//   Future<void> _pushCompletions(String userId, DateTime since) async {
//     final local = await (db.select(db.completions)
//           ..where((t) => t.updatedAt.isBiggerThanValue(since)))
//         .get();

//     if (local.isEmpty) return;

//     final payload = local.map((c) => {
//       'id': c.id,
//       'user_id': userId,
//       'habit_id': c.habitId,
//       'period_key': c.periodKey.toIso8601String(),
//       'created_at': c.createdAt.toUtc().toIso8601String(),
//       'updated_at': c.updatedAt.toUtc().toIso8601String(),
//       'deleted': c.deleted,
//     }).toList();

//     await supabase.from('habit_completions').upsert(payload);
//   }

//   // ---------------- PULL ----------------

//   Future<void> _pullHabits(String userId, DateTime since) async {
//     final remote = await supabase
//         .from('habits')
//         .select()
//         .eq('user_id', userId)
//         .gt('updated_at', since.toIso8601String());

//     for (final r in remote) {
//       await db.into(db.habits).insertOnConflictUpdate(
//         HabitsCompanion(
//           id: Value(r['id']),
//           title: Value(r['title']),
//           frequency: Value(r['frequency']),
//           weeklyDay: Value(r['weekly_day']),
//           monthlyDay: Value(r['monthly_day']),
//           reminderEnabled: Value(r['reminder_enabled']),
//           reminderRandom: Value(r['reminder_random']),
//           reminderTimeMinutes: Value(r['reminder_time_minutes']),
//           createdAt: Value(DateTime.parse(r['created_at'])),
//           updatedAt: Value(DateTime.parse(r['updated_at'])),
//           deleted: Value(r['deleted']),
//         ),
//       );
//     }
//   }

//   Future<void> _pullCompletions(String userId, DateTime since) async {
//     final remote = await supabase
//         .from('habit_completions')
//         .select()
//         .eq('user_id', userId)
//         .gt('updated_at', since.toIso8601String());

//     for (final r in remote) {
//       await db.into(db.completions).insertOnConflictUpdate(
//         CompletionsCompanion(
//           id: Value(r['id']),
//           habitId: Value(r['habit_id']),
//           periodKey: Value(DateTime.parse(r['period_key'])),
//           createdAt: Value(DateTime.parse(r['created_at'])),
//           updatedAt: Value(DateTime.parse(r['updated_at'])),
//           deleted: Value(r['deleted']),
//         ),
//       );
//     }
//   }

//   Future<void> _pullProfile(String userId) async {
//     final r = await supabase
//         .from('profiles')
//         .select()
//         .eq('user_id', userId)
//         .maybeSingle();

//     if (r == null) return;

//     await db.into(db.profile).insertOnConflictUpdate(
//       ProfileCompanion(
//         userId: Value(userId),
//         weekStartsOn: Value(r['week_starts_on']),
//         updatedAt: Value(DateTime.parse(r['updated_at'])),
//       ),
//     );
//   }
// }

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habit_bucket/core/local/app_db.dart';

class SyncService {
  final AppDb db;
  final SupabaseClient supabase;

  SyncService(this.db, this.supabase);

  Future<void> sync() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final lastSync = await _getLastSync();
    final now = DateTime.now().toUtc();

    await _pushHabits(user.id, lastSync);
    await _pushCompletions(user.id, lastSync);

    await _pullHabits(user.id, lastSync);
    await _pullCompletions(user.id, lastSync);
    await _pullProfile(user.id);

    await _setLastSync(now);
  }

  // ---------------- SYNC STATE ----------------

  // Future<DateTime> _getLastSync() async {
  //   final row = await db.select(db.syncState)
  //       .where((t) => t.key.equals('last_sync'))
  //       .getSingleOrNull();
  //   return row?.value ?? DateTime.fromMillisecondsSinceEpoch(0);
  // }

  Future<DateTime> _getLastSync() async {
    final query = db.select(db.syncState)
      ..where((t) => t.key.equals('last_sync'));

    final row = await query.getSingleOrNull();

    return row?.value ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  Future<void> _setLastSync(DateTime t) async {
    await db
        .into(db.syncState)
        .insertOnConflictUpdate(
          SyncStateCompanion(key: const Value('last_sync'), value: Value(t)),
        );
  }

  // ---------------- PUSH ----------------

  Future<void> _pushHabits(String userId, DateTime since) async {
    final local = await (db.select(
      db.habits,
    )..where((t) => t.updatedAt.isBiggerThanValue(since))).get();

    if (local.isEmpty) return;

    await supabase
        .from('habits')
        .upsert(
          local
              .map(
                (h) => {
                  'id': h.id,
                  'user_id': userId,
                  'title': h.title,
                  'frequency': h.frequency,
                  'weekly_day': h.weeklyDay,
                  'monthly_day': h.monthlyDay,
                  'reminder_enabled': h.reminderEnabled,
                  'reminder_random': h.reminderRandom,
                  'reminder_time': _minutesToTime(h.reminderTimeMinutes),
                  'created_at': h.createdAt.toUtc().toIso8601String(),
                  'updated_at': h.updatedAt.toUtc().toIso8601String(),
                  'deleted': h.deleted,
                },
              )
              .toList(),
        );
  }

  Future<void> _pushCompletions(String userId, DateTime since) async {
    final local = await (db.select(
      db.completions,
    )..where((t) => t.updatedAt.isBiggerThanValue(since))).get();

    if (local.isEmpty) return;

    await supabase
        .from('habit_completions')
        .upsert(
          local
              .map(
                (c) => {
                  'id': c.id,
                  'user_id': userId,
                  'habit_id': c.habitId,
                  'completed_on': c.periodKey.toIso8601String().substring(
                    0,
                    10,
                  ),
                  'created_at': c.createdAt.toUtc().toIso8601String(),
                  'updated_at': c.updatedAt.toUtc().toIso8601String(),
                  'deleted': c.deleted,
                },
              )
              .toList(),
        );
  }

  // ---------------- PULL ----------------

  Future<void> _pullHabits(String userId, DateTime since) async {
    final remote = await supabase
        .from('habits')
        .select()
        .eq('user_id', userId)
        .gt('updated_at', since.toIso8601String());

    for (final r in remote) {
      await db
          .into(db.habits)
          .insertOnConflictUpdate(
            HabitsCompanion(
              id: Value(r['id']),
              title: Value(r['title']),
              frequency: Value(r['frequency']),
              weeklyDay: Value(r['weekly_day']),
              monthlyDay: Value(r['monthly_day']),
              reminderEnabled: Value(r['reminder_enabled']),
              reminderRandom: Value(r['reminder_random']),
              reminderTimeMinutes: Value(_timeToMinutes(r['reminder_time'])),
              createdAt: Value(DateTime.parse(r['created_at'])),
              updatedAt: Value(DateTime.parse(r['updated_at'])),
              deleted: Value(r['deleted']),
            ),
          );
    }
  }

  Future<void> _pullCompletions(String userId, DateTime since) async {
    final remote = await supabase
        .from('habit_completions')
        .select()
        .eq('user_id', userId)
        .gt('updated_at', since.toIso8601String());

    for (final r in remote) {
      await db
          .into(db.completions)
          .insertOnConflictUpdate(
            CompletionsCompanion(
              id: Value(r['id']),
              habitId: Value(r['habit_id']),
              periodKey: Value(DateTime.parse(r['completed_on'])),
              createdAt: Value(DateTime.parse(r['created_at'])),
              updatedAt: Value(DateTime.parse(r['updated_at'])),
              deleted: Value(r['deleted']),
            ),
          );
    }
  }

  Future<void> _pullProfile(String userId) async {
    final r = await supabase
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (r == null) return;

    await db
        .into(db.profile)
        .insertOnConflictUpdate(
          ProfileCompanion(
            userId: Value(userId),
            weekStartsOn: Value(r['week_starts_on']),
            updatedAt: Value(DateTime.parse(r['updated_at'])),
          ),
        );
  }

  // ---------------- HELPERS ----------------

  String? _minutesToTime(int? minutes) {
    if (minutes == null) return null;
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:00';
  }

  int? _timeToMinutes(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
