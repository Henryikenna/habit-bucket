DateTime startOfDay(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

DateTime weekStart(DateTime dt, {required int weekStartsOn}) {
  // weekStartsOn: 1=Monday, 0=Sunday
  final d = startOfDay(dt);
  final weekday = d.weekday; // 1=Mon..7=Sun
  final sundayBased = weekday % 7; // Sun=0, Mon=1, ... Sat=6

  final startIndex = weekStartsOn == 1 ? 1 : 0; // Mon=1, Sun=0
  final diff = (sundayBased - startIndex) % 7;
  return d.subtract(Duration(days: diff));
}

DateTime monthKey(DateTime dt) => DateTime(dt.year, dt.month, 1);
