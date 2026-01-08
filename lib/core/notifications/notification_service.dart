// import 'dart:math';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

// import 'package:habit_bucket/core/local/app_db.dart'; // Habit model

// class NotificationService {
//   NotificationService(this._plugin);

//   final FlutterLocalNotificationsPlugin _plugin;

//   static const String channelId = 'habit_reminders';
//   static const String channelName = 'Habit reminders';
//   static const String channelDesc = 'Gentle reminders for your daily habits';

//   /// v1: Random reminder window (All day) = 08:00 - 20:00 local
//   static const int randomStartMinutes = 8 * 60;
//   static const int randomEndMinutes = 20 * 60;

//   /// how many days ahead we schedule
//   static const int horizonDays = 7;

//   Future<void> init() async {
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidSettings);

//     await _plugin.initialize(initSettings);

//     // Create channel (safe to call repeatedly)
//     const androidChannel = AndroidNotificationChannel(
//       channelId,
//       channelName,
//       description: channelDesc,
//       importance: Importance.defaultImportance,
//     );

//     final androidImpl =
//         _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//     await androidImpl?.createNotificationChannel(androidChannel);
//   }

//   /// Android 13+ runtime permission prompt
//   Future<void> requestPermissionIfNeeded() async {
//     final androidImpl =
//         _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//     await androidImpl?.requestNotificationsPermission();
//   }

//   /// Call whenever:
//   /// - habit created
//   /// - habit edited (relevant fields)
//   /// - app start (boot/timezone recovery strategy)
//   Future<void> scheduleDailyHabit(Habit h) async {
//     if (h.deleted) return;
//     if (h.frequency != 'daily') return; // v1 daily only
//     if (!(h.reminderEnabled)) {
//       await cancelHabit(h);
//       return;
//     }

//     // Cancel previous scheduled notifications for this habit within our horizon,
//     // then schedule again deterministically.
//     await cancelHabit(h);

//     for (int i = 0; i < horizonDays; i++) {
//       final day = DateTime.now().add(Duration(days: i));
//       final fireAt = _nextFireTimeForDay(h, day);

//       // If computed time is already in the past (can happen on day 0), skip.
//       if (fireAt.isBefore(DateTime.now())) continue;

//       final id = _notificationId(h.id, day);

//       await _plugin.zonedSchedule(
//         id,
//         _titleForHabit(h),
//         _bodyForHabit(h),
//         tz.TZDateTime.from(fireAt, tz.local),
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             channelId,
//             channelName,
//             channelDescription: channelDesc,
//             importance: Importance.defaultImportance,
//             priority: Priority.defaultPriority,

//             // v1: avoid exact alarms complexity on Android 14+
//             // This keeps it reliable without requiring exact-alarm permissions.
//           ),
//         ),
//         androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
//         // uiLocalNotificationDateInterpretation:
//         //     UILocalNotificationDateInterpretation.absoluteTime,
//         payload: 'habit:${h.id}',
//       );
//     }
//   }

//   Future<void> cancelHabit(Habit h) async {
//     for (int i = 0; i < horizonDays; i++) {
//       final day = DateTime.now().add(Duration(days: i));
//       await _plugin.cancel(_notificationId(h.id, day));
//     }
//   }

//   /// Reschedule everything (call on app start; also after timezone change/boot strategy)
//   Future<void> rescheduleAllDaily(List<Habit> habits) async {
//     // Optional: could skip cancelAll to avoid touching other channels.
//     // For v1 simplicity, we reschedule per habit.
//     for (final h in habits) {
//       await scheduleDailyHabit(h);
//     }
//   }

//   // ---------- helpers ----------

//   DateTime _nextFireTimeForDay(Habit h, DateTime day) {
//     final date = DateTime(day.year, day.month, day.day);

//     if (h.reminderRandom == true) {
//       // Deterministic random per habit per day, so reschedules are stable.
//       final seed = _stableSeed(h.id, date);
//       final rnd = Random(seed);
//       final span = (randomEndMinutes - randomStartMinutes).clamp(1, 24 * 60);
//       final minuteOfDay = randomStartMinutes + rnd.nextInt(span);

//       return date.add(Duration(minutes: minuteOfDay));
//     }

//     // Fixed time: reminderTimeMinutes is absolute minutes since midnight
//     final t = (h.reminderTimeMinutes ?? (9 * 60)).clamp(0, 24 * 60 - 1);
//     return date.add(Duration(minutes: t));
//   }

//   String _titleForHabit(Habit h) => 'A gentle nudge';
//   String _bodyForHabit(Habit h) => 'If it fits today, ${h.title}.';

//   int _notificationId(String habitId, DateTime day) {
//     // Stable, deterministic int id derived from UUID-ish string + YYYYMMDD.
//     // Avoids using String.hashCode (not guaranteed stable across runs).
//     final y = day.year;
//     final m = day.month;
//     final d = day.day;
//     final yyyymmdd = (y * 10000) + (m * 100) + d;

//     // Take first 8 hex chars of UUID as base (or fallback).
//     final hex = habitId.replaceAll('-', '');
//     final base = hex.length >= 8 ? int.tryParse(hex.substring(0, 8), radix: 16) ?? 0 : 0;

//     // Mix with date, keep within 31-bit positive range.
//     final mixed = (base ^ yyyymmdd) & 0x7fffffff;
//     return mixed;
//   }

//   int _stableSeed(String habitId, DateTime day) {
//     // Another deterministic mix (different from notification id).
//     final y = day.year;
//     final m = day.month;
//     final d = day.day;
//     final yyyymmdd = (y * 10000) + (m * 100) + d;

//     final hex = habitId.replaceAll('-', '');
//     final base = hex.length >= 8 ? int.tryParse(hex.substring(0, 8), radix: 16) ?? 12345 : 12345;

//     return (base * 31 + yyyymmdd) & 0x7fffffff;
//   }
// }











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

  Future<void> scheduleDailyHabit(Habit h) async {
    if (h.deleted) return;
    if (h.frequency != 'daily') return; // v1 daily only

    if (!(h.reminderEnabled)) {
      await cancelHabit(h);
      return;
    }

    // Recreate schedule for the next horizon window
    await cancelHabit(h);

    for (int i = 0; i < horizonDays; i++) {
      final day = DateTime.now().add(Duration(days: i));
      final fireAt = _fireTimeForDay(h, day);

      if (fireAt.isBefore(DateTime.now())) continue;

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
        // v1: avoid exact-alarm permission complexity on Android 14+
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'habit:${h.id}',
      );
    }
  }

  Future<void> cancelHabit(Habit h) async {
    for (int i = 0; i < horizonDays; i++) {
      final day = DateTime.now().add(Duration(days: i));
      await _plugin.cancel(_notificationId(h.id, day));
    }
  }

  Future<void> rescheduleAllDaily(List<Habit> habits) async {
    for (final h in habits) {
      await scheduleDailyHabit(h);
    }
  }

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
