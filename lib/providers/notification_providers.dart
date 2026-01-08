// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:habit_bucket/core/notifications/notification_service.dart';

// final notificationPluginProvider =
//     Provider<FlutterLocalNotificationsPlugin>((ref) {
//   return FlutterLocalNotificationsPlugin();
// });

// final notificationServiceProvider = Provider<NotificationService>((ref) {
//   return NotificationService(ref.watch(notificationPluginProvider));
// });








import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_bucket/core/notifications/notification_service.dart';

final notificationPluginProvider =
    Provider<FlutterLocalNotificationsPlugin>((ref) {
  return FlutterLocalNotificationsPlugin();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref.watch(notificationPluginProvider));
});
