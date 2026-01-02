import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  final _client = Supabase.instance.client;

  Future<int> getWeekStartsOn() async {
    final user = _client.auth.currentUser!;
    final row = await _client.from('profiles').select('week_starts_on').eq('user_id', user.id).maybeSingle();
    return (row?['week_starts_on'] as int?) ?? 1;
  }

  Future<void> setWeekStartsOn(int value) async {
    final user = _client.auth.currentUser!;
    await _client.from('profiles').upsert({
      'user_id': user.id,
      'week_starts_on': value, // 1=Mon,0=Sun
    });
  }
}
