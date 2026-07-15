import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
// import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'app_db.g.dart';

class Habits extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get userId => text().nullable()(); // Supabase auth uid (populated on sync)
  TextColumn get title => text()();

  /// 'daily' | 'weekly' | 'monthly'
  TextColumn get frequency => text()();

  /// weekly habits: 0=Sun..6=Sat (store chosen day)
  IntColumn get weeklyDay => integer().nullable()();

  /// monthly habits: 1..31
  IntColumn get monthlyDay => integer().nullable()();

  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(true))();

  /// daily: if true, schedule a random time reminder each day
  BoolColumn get reminderRandom => boolean().withDefault(const Constant(true))();

  /// fixed reminder time in minutes since midnight (nullable)
  IntColumn get reminderTimeMinutes => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  /// Sync helpers (for background sync later)
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Completions extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get userId => text().nullable()(); // Supabase auth uid (populated on sync)
  TextColumn get habitId => text()();
  DateTimeColumn get periodKey => dateTime()(); // normalized to midnight local
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  /// Only one completion per habit per period
  @override
  List<Set<Column>> get uniqueKeys => [
        {habitId, periodKey},
      ];
}

class Profile extends Table {
  TextColumn get userId => text()(); // Supabase auth uid
  TextColumn get firstName => text().withDefault(const Constant(''))();
  TextColumn get lastName => text().withDefault(const Constant(''))();
  IntColumn get weekStartsOn =>
      integer().withDefault(const Constant(1))(); // 1=Mon, 0=Sun
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId};
}

// @DriftDatabase(tables: [Habits, Completions, Profile, SyncState])
// class AppDb extends _$AppDb {
//   AppDb() : super(_openConnection());

//   @override
//   int get schemaVersion => 2;
// }

@DriftDatabase(tables: [Habits, Completions, Profile, SyncState])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  /// Clears all local data (used on logout)
  Future<void> clearAllData() async {
    await delete(habits).go();
    await delete(completions).go();
    await delete(profile).go();
    await delete(syncState).go();
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // Incremental migrations
          if (from < 2) {
            await m.createTable(syncState);
          }
          if (from < 3) {
            // Add first_name and last_name columns to profile table
            await m.addColumn(profile, profile.firstName);
            await m.addColumn(profile, profile.lastName);
          }
          if (from < 4) {
            // Add userId to habits and completions for sync
            await m.addColumn(habits, habits.userId);
            await m.addColumn(completions, completions.userId);
            // Add createdAt to profile
            await m.addColumn(profile, profile.createdAt);
          }
        },
        beforeOpen: (details) async {
          // Optional: enable foreign keys, etc.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/habit_bucket.sqlite');
    return NativeDatabase(file);
  });
}



class SyncState extends Table {
  TextColumn get key => text()(); // e.g. 'last_sync'
  DateTimeColumn get value => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}
