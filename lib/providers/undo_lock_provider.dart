import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks "locked" completions for the current run of the app.
/// Key: '$habitId|$periodKeyIso'
final completionLockProvider =
    StateNotifierProvider<CompletionLockNotifier, Set<String>>(
  (ref) => CompletionLockNotifier(),
);

class CompletionLockNotifier extends StateNotifier<Set<String>> {
  CompletionLockNotifier() : super(<String>{});

  void lock(String key) => state = {...state, key};
  void unlock(String key) {
    final next = {...state}..remove(key);
    state = next;
  }

  bool isLocked(String key) => state.contains(key);
}
