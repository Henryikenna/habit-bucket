import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/core/notifications/tz_init.dart';
import 'package:habit_bucket/providers/notification_providers.dart';
import 'package:habit_bucket/providers/providers.dart'; // localHabitRepoProvider

class NotificationBootstrap extends ConsumerStatefulWidget {
  final Widget child;
  const NotificationBootstrap({super.key, required this.child});

  @override
  ConsumerState<NotificationBootstrap> createState() => _NotificationBootstrapState();
}

class _NotificationBootstrapState extends ConsumerState<NotificationBootstrap> {
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _initOnce();
  }

  Future<void> _initOnce() async {
    if (_done) return;
    _done = true;

    await initLocalTimeZone();

    final service = ref.read(notificationServiceProvider);
    await service.init();
    await service.requestPermissionIfNeeded();

    // v1: reschedule on app start
    final repo = ref.read(localHabitRepoProvider);
    final habits = await repo.getAllNonDeletedHabits(); // add this method (below)
    await service.rescheduleAllDaily(habits);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
