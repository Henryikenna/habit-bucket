import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/providers/providers.dart';
import 'package:habit_bucket/providers/stats_providers.dart';
import 'package:habit_bucket/screens/stats/widgets/error_box.dart';
import 'package:habit_bucket/screens/stats/widgets/surface_card.dart';
import 'package:habit_bucket/utils/colors.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';

class StreaksList extends ConsumerWidget {
  const StreaksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streaksAsync = ref.watch(habitStreaksProvider);
    final habitsAsync = ref.watch(habitsProvider);

    return habitsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorBox(message: e.toString()),
      data: (habits) {
        return streaksAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorBox(message: e.toString()),
          data: (map) {
            if (habits.isEmpty) {
              return Center(
                child: Text(
                  "Create a habit to start tracking streaks.",
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacityFactor(0.7),
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: habits.length,
              separatorBuilder: (_, __) => 10.spaceH,
              itemBuilder: (context, i) {
                final h = habits[i];
                final s = map[h.id];
                final current = s?.current ?? 0;
                final longest = s?.longest ?? 0;

                return SurfaceCard(
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: HabitBucketColors.mainPurple.withOpacityFactor(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.local_fire_department_rounded,
                          color: HabitBucketColors.mainPurple,
                        ),
                      ),
                      12.spaceW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              h.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            4.spaceH,
                            Text(
                              "${h.frequency} • longest $longest",
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacityFactor(0.65),
                              ),
                            ),
                          ],
                        ),
                      ),
                      12.spaceW,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: Text(
                          "$current",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
