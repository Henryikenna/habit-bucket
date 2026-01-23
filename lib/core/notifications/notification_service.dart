import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:habit_bucket/core/local/app_db.dart'; // Habit

class NotificationService {
  NotificationService(this._plugin);
  final FlutterLocalNotificationsPlugin _plugin;

  static const String channelId = 'habit_reminders';
  static const String channelName = 'Habit reminders';
  static const String channelDesc = 'Gentle reminders for your daily habits';

  static const int randomStartMinutes = 8 * 60;  // 08:00
  static const int randomEndMinutes = 20 * 60;   // 20:00
  static const int horizonDays = 7;              // schedule next 7 days

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);

    const channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDesc,
      importance: Importance.defaultImportance,
    );

    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.createNotificationChannel(channel);
  }

  Future<void> requestPermissionIfNeeded() async {
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();
  }

  /// Show an immediate test notification to verify notifications are working
  Future<void> showTestNotification() async {
    print('🧪 [NotificationService] Showing test notification NOW');

    await _plugin.show(
      999999, // Use a unique ID for test notifications
      'Test Notification',
      'If you see this, notifications are working! 🎉',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDesc,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: 'test',
    );

    print('   ✅ Test notification sent');
  }

  Future<void> scheduleHabit(Habit h) async {
    print('📅 [NotificationService] scheduleHabit called for: ${h.title}');
    print('   - frequency: ${h.frequency}');
    print('   - reminderEnabled: ${h.reminderEnabled}');
    print('   - reminderRandom: ${h.reminderRandom}');
    print('   - reminderTimeMinutes: ${h.reminderTimeMinutes}');

    if (h.deleted) {
      print('   ⏭️  Skipped (deleted)');
      return;
    }

    if (!(h.reminderEnabled)) {
      print('   ⏭️  Canceling (reminders disabled)');
      await cancelHabit(h);
      return;
    }

    // Recreate schedule for the next horizon window
    await cancelHabit(h);

    int scheduledCount = 0;
    for (int i = 0; i < horizonDays; i++) {
      final day = DateTime.now().add(Duration(days: i));

      // Check if this day matches the habit's frequency
      if (!_shouldScheduleForDay(h, day)) {
        continue;
      }

      final fireAt = _fireTimeForDay(h, day);

      if (fireAt.isBefore(DateTime.now())) {
        print('   ⏭️  Skipped ${day.toIso8601String().split('T')[0]} - time already passed');
        continue;
      }

      final id = _notificationId(h.id, day);

      await _plugin.zonedSchedule(
        id,
        'A gentle nudge',
        'If it fits today, ${h.title}.',
        tz.TZDateTime.from(fireAt, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDesc,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'habit:${h.id}',
      );

      scheduledCount++;
      print('   ✅ Scheduled for ${day.toIso8601String().split('T')[0]} at ${fireAt.hour}:${fireAt.minute.toString().padLeft(2, '0')}');
    }

    print('   📊 Total notifications scheduled: $scheduledCount');
  }

  /// Check if we should schedule a notification for this day based on habit frequency
  bool _shouldScheduleForDay(Habit h, DateTime day) {
    switch (h.frequency) {
      case 'daily':
        return true; // Schedule every day

      case 'weekly':
        if (h.weeklyDay == null) return false;
        return day.weekday % 7 == h.weeklyDay; // weekday: 1=Mon..7=Sun, convert to 0=Sun..6=Sat

      case 'monthly':
        if (h.monthlyDay == null) return false;
        final daysInMonth = DateTime(day.year, day.month + 1, 0).day;

        // If monthlyDay > days in this month, schedule on last day
        if (h.monthlyDay! > daysInMonth) {
          return day.day == daysInMonth;
        }

        return day.day == h.monthlyDay;

      default:
        return false;
    }
  }

  // Keep old method name for backward compatibility
  Future<void> scheduleDailyHabit(Habit h) => scheduleHabit(h);

  Future<void> cancelHabit(Habit h) async {
    for (int i = 0; i < horizonDays; i++) {
      final day = DateTime.now().add(Duration(days: i));
      await _plugin.cancel(_notificationId(h.id, day));
    }
  }

  Future<void> rescheduleAll(List<Habit> habits) async {
    for (final h in habits) {
      await scheduleHabit(h);
    }
  }

  // Keep old method name for backward compatibility
  Future<void> rescheduleAllDaily(List<Habit> habits) => rescheduleAll(habits);

  DateTime _fireTimeForDay(Habit h, DateTime day) {
    final date = DateTime(day.year, day.month, day.day);

    if (h.reminderRandom == true) {
      // deterministic random per habit per day
      final seed = _seed(h.id, date);
      final rnd = Random(seed);
      final span = (randomEndMinutes - randomStartMinutes).clamp(1, 24 * 60);
      final minuteOfDay = randomStartMinutes + rnd.nextInt(span);
      return date.add(Duration(minutes: minuteOfDay));
    }

    final t = (h.reminderTimeMinutes ?? (9 * 60)).clamp(0, 24 * 60 - 1);
    return date.add(Duration(minutes: t));
  }

  int _notificationId(String habitId, DateTime day) {
    final yyyymmdd = (day.year * 10000) + (day.month * 100) + day.day;
    final hex = habitId.replaceAll('-', '');
    final base =
        hex.length >= 8 ? int.tryParse(hex.substring(0, 8), radix: 16) ?? 0 : 0;
    return (base ^ yyyymmdd) & 0x7fffffff;
  }

  int _seed(String habitId, DateTime day) {
    final yyyymmdd = (day.year * 10000) + (day.month * 100) + day.day;
    final hex = habitId.replaceAll('-', '');
    final base =
        hex.length >= 8 ? int.tryParse(hex.substring(0, 8), radix: 16) ?? 12345 : 12345;
    return (base * 31 + yyyymmdd) & 0x7fffffff;
  }
}
