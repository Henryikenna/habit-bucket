import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habit_bucket/core/enums/habit_frequency_enum.dart';
import 'package:habit_bucket/core/helpers/habit_frequency_helper.dart';
import 'package:habit_bucket/core/local/app_db.dart';
import 'package:habit_bucket/providers/completion_providers.dart';
import 'package:habit_bucket/providers/providers.dart';
import 'package:habit_bucket/providers/stats_providers.dart';
import 'package:habit_bucket/providers/streak_display_provider.dart';
import 'package:habit_bucket/providers/undo_lock_provider.dart';
import 'package:habit_bucket/screens/habits/edit_habit_screen.dart';
import 'package:habit_bucket/screens/habits/widgets/habit_widget.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';

class WeeklyView extends ConsumerWidget {
  final HabitFrequency frequency;
  final List<Habit> habitList;
  final int weekStartsOn;
  final Map<String, HabitStreak> streaks;

  const WeeklyView({
    super.key,
    required this.frequency,
    required this.habitList,
    required this.weekStartsOn,
    required this.streaks,
  });

  List<String> _getDayNames(int weekStartsOn) {
    final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    // Reorder based on week start
    if (weekStartsOn == 1) {
      // Monday first
      return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    }
    return days; // Sunday first
  }

  int _getDayIndex(String dayName) {
    const dayMap = {
      'Sunday': 0,
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
    };
    return dayMap[dayName]!;
  }

  List<Habit> _getHabitsForDay(String dayName) {
    final dayIndex = _getDayIndex(dayName);
    return habitList.where((h) => h.weeklyDay == dayIndex).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (habitList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.calendarWeek, size: 48, color: Colors.grey),
            16.spaceH,
            Text("No weekly habits yet", style: TextStyle(fontSize: 16)),
            8.spaceH,
            Text(
              "Tap + to create your first weekly habit!",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final dayNames = _getDayNames(weekStartsOn);
    final now = DateTime.now();

    return ListView.separated(
      padding: EdgeInsets.only(bottom: 80, left: 8, right: 8, top: 8),
      itemCount: dayNames.length,
      separatorBuilder: (context, index) => 24.spaceH,
      itemBuilder: (context, dayIndex) {
        final dayName = dayNames[dayIndex];
        final dayHabits = _getHabitsForDay(dayName);

        if (dayHabits.isEmpty) {
          return SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "${dayHabits.length} habit${dayHabits.length != 1 ? 's' : ''}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacityFactor(0.6),
                    ),
                  ),
                ],
              ),
            ),
            8.spaceH,

            // Habits for this day
            ...dayHabits.map((habit) {
              final key = periodKeyForHabit(
                habit: habit,
                now: now,
                weekStartsOn: weekStartsOn,
              );

              final completedAsync = ref.watch(
                isCompletedProvider((
                  habitId: habit.id,
                  periodKey: key,
                )),
              );
              final completed = completedAsync.value ?? false;

              final lockKey = '${habit.id}|${key.toIso8601String()}';
              final isLocked =
                  ref.watch(completionLockProvider).contains(lockKey);

              final streakAsync = ref.watch(
                streakDisplayProvider((
                  habitId: habit.id,
                  frequency: habit.frequency,
                  currentKey: key,
                  completed: completed,
                )),
              );
              final streakCount = streakAsync.value ?? 0;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: HabitWidget(
                  isChecked: completed,
                  streakCount: streakCount,
                  isStreakActivated: completed,
                  title: habit.title,
                  habitFrequency: getHabitFrequencyEnum(
                    habitFrequency: habit.frequency,
                  ),
                  onEditTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditHabitScreen(habitId: habit.id),
                      ),
                    );
                  },
                  onDeleteTap: () {
                    
                  },
                  onToggle: () async {
                    final repo = ref.read(localCompletionRepoProvider);
                    final locks = ref.read(completionLockProvider.notifier);

                    if (completed) {
                      if (isLocked) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Locked for this week ✅"),
                          ),
                        );
                        return;
                      }
                      await repo.unmarkCompleted(habit.id, key);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      return;
                    }

                    await repo.markCompleted(habit.id, key);

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    final controller = ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 8),
                        content: const Text("Marked done ✅"),
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () async {
                            locks.unlock(lockKey);
                            await repo.unmarkCompleted(habit.id, key);
                          },
                        ),
                      ),
                    );

                    unawaited(
                      Future.delayed(
                        const Duration(seconds: 8),
                        () async {
                          final stillCompleted =
                              await repo.isCompletedOnce(habit.id, key);
                          if (stillCompleted) locks.lock(lockKey);
                        },
                      ),
                    );

                    controller.closed.then((_) async {
                      final stillCompleted =
                          await repo.isCompletedOnce(habit.id, key);
                      if (stillCompleted) locks.lock(lockKey);
                    });
                  },
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
