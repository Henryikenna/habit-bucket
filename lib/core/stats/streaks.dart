DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime _addMonths(DateTime d, int months) {
  final year = d.year + ((d.month - 1 + months) ~/ 12);
  final month = ((d.month - 1 + months) % 12) + 1;
  return DateTime(year, month, 1);
}

/// Returns (currentStreak, longestStreak)
({int current, int longest}) calculateStreak({
  required List<DateTime> keysSorted,
  required String frequency, // daily/weekly/monthly
  required DateTime currentPeriodKey,
}) {
  if (keysSorted.isEmpty) return (current: 0, longest: 0);

  final keys = keysSorted.map(_dayKey).toList();

  bool isConsecutive(DateTime a, DateTime b) {
    switch (frequency) {
      case 'daily':
        return b.difference(a).inDays == 1;
      case 'weekly':
        return b.difference(a).inDays == 7;
      case 'monthly':
        final next = _addMonths(a, 1);
        return b.year == next.year &&
            b.month == next.month &&
            b.day == next.day;
      default:
        return false;
    }
  }

  // Longest streak
  int longest = 1;
  int run = 1;
  for (int i = 1; i < keys.length; i++) {
    if (isConsecutive(keys[i - 1], keys[i])) {
      run++;
      if (run > longest) longest = run;
    } else {
      run = 1;
    }
  }

  // Current streak: must end at currentPeriodKey (or earlier if not completed this period)
  int current = 0;
  final currentKey = _dayKey(currentPeriodKey);

  // Find last index that matches currentKey
  int idx = keys.lastIndexWhere((k) => k == currentKey);
  if (idx == -1) {
    // Not completed this period -> current streak is 0
    return (current: 0, longest: longest);
  }

  current = 1;
  for (int i = idx; i > 0; i--) {
    if (isConsecutive(keys[i - 1], keys[i])) {
      current++;
    } else {
      break;
    }
  }

  return (current: current, longest: longest);
}

({int current, int longest}) calculateStreakAsOf({
  required List<DateTime> keysSorted,
  required String frequency, // daily/weekly/monthly
  required DateTime asOfPeriodKey,
}) {
  if (keysSorted.isEmpty) return (current: 0, longest: 0);

  DateTime dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime addMonths(DateTime d, int months) {
    final year = d.year + ((d.month - 1 + months) ~/ 12);
    final month = ((d.month - 1 + months) % 12) + 1;
    return DateTime(year, month, 1);
  }

  bool isConsecutive(DateTime a, DateTime b) {
    switch (frequency) {
      case 'daily':
        return b.difference(a).inDays == 1;
      case 'weekly':
        return b.difference(a).inDays == 7;
      case 'monthly':
        final next = addMonths(a, 1);
        return b.year == next.year &&
            b.month == next.month &&
            b.day == next.day;
      default:
        return false;
    }
  }

  final keys = keysSorted.map(dayKey).toList();

  // Longest streak
  int longest = 1;
  int run = 1;
  for (int i = 1; i < keys.length; i++) {
    if (isConsecutive(keys[i - 1], keys[i])) {
      run++;
      if (run > longest) longest = run;
    } else {
      run = 1;
    }
  }

  // Current streak as-of: must end at the most recent completion <= asOfPeriodKey
  final target = dayKey(asOfPeriodKey);
  int idx = keys.lastIndexWhere((k) => !k.isAfter(target));
  if (idx == -1) return (current: 0, longest: longest);

  int current = 1;
  for (int i = idx; i > 0; i--) {
    if (isConsecutive(keys[i - 1], keys[i])) {
      current++;
    } else {
      break;
    }
  }

  return (current: current, longest: longest);
}





DateTime previousPeriodKey(String frequency, DateTime currentKey) {
  switch (frequency) {
    case 'daily':
      return currentKey.subtract(const Duration(days: 1));
    case 'weekly':
      return currentKey.subtract(const Duration(days: 7));
    case 'monthly':
      return DateTime(currentKey.year, currentKey.month - 1, 1);
    default:
      return currentKey;
  }
}
