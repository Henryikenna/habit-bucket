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
import 'package:habit_bucket/screens/habits/widgets/habit_widget.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';

// List<HabitModel> habitList = [
//   HabitModel(
//     title: "30 pushups a day\ndrink water daily\nvisit my babe",
//     habitFrequency: HabitFrequency.daily,
//   ),
//   HabitModel(
//     title: "30 pushups a day\ndrink water daily\nvisit my babe",
//     habitFrequency: HabitFrequency.daily,
//   ),
//   HabitModel(
//     title: "30 pushups a day\ndrink water daily\nvisit my babe",
//     habitFrequency: HabitFrequency.daily,
//   ),
//   HabitModel(
//     title: "30 pushups a day\ndrink water daily\nvisit my babe",
//     habitFrequency: HabitFrequency.daily,
//   ),
//   HabitModel(
//     title: "30 pushups a day\ndrink water daily\nvisit my babe",
//     habitFrequency: HabitFrequency.daily,
//   ),
//   HabitModel(
//     title: "30 pushups a day\ndrink water daily\nvisit my babe",
//     habitFrequency: HabitFrequency.daily,
//   ),
//   HabitModel(
//     title: "30 pushups a day\ndrink water daily\nvisit my babe",
//     habitFrequency: HabitFrequency.daily,
//   ),
//   HabitModel(
//     title: "30 pushups a day\ndrink water daily\nvisit my babe",
//     habitFrequency: HabitFrequency.daily,
//   ),
//   HabitModel(
//     title: "30 pushups a day\ndrink water daily\nvisit my babe",
//     habitFrequency: HabitFrequency.daily,
//   ),
//   HabitModel(
//     title: "30 pushups a day\ndrink water daily\nvisit my babe",
//     habitFrequency: HabitFrequency.daily,
//   ),
// ];

class DailyView extends ConsumerWidget {
  final HabitFrequency frequency;
  final List<Habit> habitList;
  final int weekStartsOn;
  final Map<String, HabitStreak> streaks;
  const DailyView({
    super.key,
    required this.frequency,
    required this.habitList,
    required this.weekStartsOn,
    required this.streaks,
  });

  // final bool _isChecked = true;
  // final bool _isStreakActivated = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return habitList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.seedling, size: 48, color: Colors.grey),
                16.spaceH,
                Text("No daily habits yet", style: TextStyle(fontSize: 16)),
                8.spaceH,
                Text(
                  "Tap + to create your first habit!",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Daily Habits",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),

                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: "${habitList.length}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacityFactor(.95),
                              ),
                            ),
                            const TextSpan(text: "/"),
                            TextSpan(
                              text: "10",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                8.spaceH,

                Expanded(
                  child: ListView.separated(
                    // shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 80),
                    //                     itemBuilder: (context, index) {
                    //                       final habit = habitList[index];
                    //                       final now = DateTime.now();

                    //                       final key = periodKeyForHabit(
                    //                         habit: habit,
                    //                         now: now,
                    //                         weekStartsOn: weekStartsOn,
                    //                       );

                    //                       final completedAsync = ref.watch(
                    //                         isCompletedProvider((
                    //                           habitId: habit.id,
                    //                           periodKey: key,
                    //                         )),
                    //                       );

                    //                       final completed = completedAsync.value ?? false;

                    //                       // final streakCount = streaks[habit.id]?.current ?? 0;

                    //                       final lockKey = '${habit.id}|${key.toIso8601String()}';
                    // final isLocked = ref.watch(completionLockProvider).contains(lockKey);

                    // final streakAsync = ref.watch(
                    //   streakDisplayProvider((
                    //     habitId: habit.id,
                    //     frequency: habit.frequency,
                    //     currentKey: key,
                    //     completed: completed,
                    //   )),
                    // );

                    // final streakCount = streakAsync.value ?? 0;

                    //                       final repo = ref.read(statsRepoProvider);
                    // final keys = await repo.completionKeysForHabit(habit.id);

                    // final currentKey = periodKeyForHabit(
                    //   habit: habit,
                    //   now: DateTime.now(),
                    //   weekStartsOn: weekStartsOn,
                    // );

                    // final prevKey = previousPeriodKey(habit.frequency, currentKey);

                    // final before = calculateStreakAsOf(
                    //   keysSorted: keys,
                    //   frequency: habit.frequency,
                    //   asOfPeriodKey: prevKey,
                    // ).current;

                    // final including = calculateStreakAsOf(
                    //   keysSorted: keys,
                    //   frequency: habit.frequency,
                    //   asOfPeriodKey: currentKey,
                    // ).current;

                    // // display choice:
                    // final displayStreak = completed ? including : before;
                    // final isStreakActivated = completed; // pink when completed, grey when not

                    //                       return HabitWidget(
                    //                         isChecked: completed,
                    //                         // onToggle: () async {
                    //                         //   final repo = ref.read(localCompletionRepoProvider);
                    //                         //   if (completed) {
                    //                         //     await repo.unmarkCompleted(habit.id, key);
                    //                         //   } else {
                    //                         //     await repo.markCompleted(habit.id, key);
                    //                         //   }
                    //                         // },
                    //                         onToggle: () async {
                    //   final repo = ref.read(localCompletionRepoProvider);
                    //   final locks = ref.read(completionLockProvider.notifier);

                    //   // If already completed:
                    //   if (completed) {
                    //     // Allow uncheck only if still within undo window (i.e., not locked yet)
                    //     if (isLocked) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(content: Text("Locked for today ✅")),
                    //       );
                    //       return;
                    //     }

                    //     // If not locked, treat as an undo
                    //     await repo.unmarkCompleted(habit.id, key);
                    //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    //     return;
                    //   }

                    //   // Mark completed immediately
                    //   await repo.markCompleted(habit.id, key);

                    //   // Show undo snackbar for 8 seconds
                    //   ScaffoldMessenger.of(context).hideCurrentSnackBar();

                    //   final controller = ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       duration: const Duration(seconds: 8),
                    //       content: const Text("Marked done ✅"),
                    //       action: SnackBarAction(
                    //         label: "Undo",
                    //         onPressed: () async {
                    //           // Only undo if not locked yet
                    //           locks.unlock(lockKey);
                    //           await repo.unmarkCompleted(habit.id, key);
                    //         },
                    //       ),
                    //     ),
                    //   );

                    //   // After 8 seconds, lock it (if it’s still completed)
                    //   unawaited(Future.delayed(const Duration(seconds: 8), () async {
                    //     // Re-check current completion state from the DB stream value
                    //     // (best-effort: if user undid, it won’t be completed)
                    //     final stillCompleted = await repo.isCompletedOnce(habit.id, key);
                    //     if (stillCompleted) {
                    //       locks.lock(lockKey);
                    //     }
                    //   }));

                    //   // Also lock if snackbar closes naturally (extra safety)
                    //   controller.closed.then((_) async {
                    //     final stillCompleted = await repo.isCompletedOnce(habit.id, key);
                    //     if (stillCompleted) locks.lock(lockKey);
                    //   });
                    // },

                    //                         // isStreakActivated: _isStreakActivated,
                    //                         isStreakActivated: completed,
                    //                         title: habit.title,
                    //                         habitFrequency: getHabitFrequencyEnum(
                    //                           habitFrequency: habit.frequency,
                    //                         ),
                    //                         streakCount: streakCount,
                    //                       );
                    //                     },
                    itemBuilder: (context, index) {
                      final habit = habitList[index];
                      final now = DateTime.now();

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
                      final isLocked = ref
                          .watch(completionLockProvider)
                          .contains(lockKey);

                      final streakAsync = ref.watch(
                        streakDisplayProvider((
                          habitId: habit.id,
                          frequency: habit.frequency,
                          currentKey: key,
                          completed: completed,
                        )),
                      );
                      final streakCount = streakAsync.value ?? 0;

                      return HabitWidget(
                        isChecked: completed,
                        streakCount: streakCount,
                        isStreakActivated:
                            completed, // pink only when completed
                        title: habit.title,
                        habitFrequency: getHabitFrequencyEnum(
                          habitFrequency: habit.frequency,
                        ),
                        onToggle: () async {
                          final repo = ref.read(localCompletionRepoProvider);
                          final locks = ref.read(
                            completionLockProvider.notifier,
                          );

                          if (completed) {
                            if (isLocked) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Locked for today ✅"),
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
                          final controller = ScaffoldMessenger.of(context)
                              .showSnackBar(
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

                          // After 8 seconds, lock it (if it’s still completed)
                          unawaited(
                            Future.delayed(
                              const Duration(seconds: 8),
                              () async {
                                final stillCompleted = await repo
                                    .isCompletedOnce(habit.id, key);
                                if (stillCompleted) locks.lock(lockKey);
                              },
                            ),
                          );

                          controller.closed.then((_) async {
                            final stillCompleted = await repo.isCompletedOnce(
                              habit.id,
                              key,
                            );
                            if (stillCompleted) locks.lock(lockKey);
                          });
                        },
                      );
                    },

                    separatorBuilder: (context, index) => 16.spaceH,
                    itemCount: habitList.length,
                  ),
                ),
              ],
            ),
          );
  }
}
