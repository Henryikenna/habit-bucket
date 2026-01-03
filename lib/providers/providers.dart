import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/core/local/app_db.dart';
import 'package:habit_bucket/core/local/local_repositories.dart';
import 'package:habit_bucket/core/sync/sync_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final appDbProvider = Provider<AppDb>((ref) {
  final db = AppDb();
  ref.onDispose(db.close);
  return db;
});

final localHabitRepoProvider = Provider<LocalHabitRepository>((ref) {
  return LocalHabitRepository(ref.watch(appDbProvider));
});

final localCompletionRepoProvider = Provider<LocalCompletionRepository>((ref) {
  return LocalCompletionRepository(ref.watch(appDbProvider));
});

final localProfileRepoProvider = Provider<LocalProfileRepository>((ref) {
  return LocalProfileRepository(ref.watch(appDbProvider));
});

/// Current Supabase user id (null when signed out)
final userIdProvider = Provider<String?>((ref) {
  return Supabase.instance.client.auth.currentUser?.id;
});

/// Week starts on (1=Mon,0=Sun). Falls back to Monday if signed out.
final weekStartsOnProvider = StreamProvider<int>((ref) {
  final uid = ref.watch(userIdProvider);
  if (uid == null) return Stream.value(1);
  return ref.watch(localProfileRepoProvider).watchWeekStartsOn(uid);
});

/// Stream all active habits from local DB
final habitsProvider = StreamProvider<List<Habit>>((ref) {
  return ref.watch(localHabitRepoProvider).watchActiveHabits();
});


final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    ref.watch(appDbProvider),
    Supabase.instance.client,
  );
});
