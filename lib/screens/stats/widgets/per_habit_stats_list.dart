import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/providers/stats_providers.dart';
import 'package:habit_bucket/screens/stats/widgets/error_box.dart';
import 'package:habit_bucket/screens/stats/widgets/surface_card.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';

class PerHabitStatsList extends ConsumerWidget {
  const PerHabitStatsList({super.key});

  String _percent(double v) => "${(v * 100).round()}%";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(selectedStatsRangeProvider);
    final aggsAsync = ref.watch(statsAggregatesProvider(range));

    return aggsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => ErrorBox(message: e.toString()),
      data: (a) {
        final items = a.perHabit;

        if (items.isEmpty) {
          return SurfaceCard(
            child: Text(
              "No habits in this period yet.",
              style: TextStyle(
                fontSize: 12.5,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacityFactor(0.70),
              ),
            ),
          );
        }

        // best habit id to tag it in the list
        final bestId = a.bestHabit?.habit.id;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Habits",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            10.spaceH,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => 10.spaceH,
              itemBuilder: (context, i) {
                final h = items[i];
                final isBest = h.habit.id == bestId;

                return SurfaceCard(
                  child: Row(
                    children: [
                      // Left: title + details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    h.habit.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                                if (isBest) ...[
                                  8.spaceW,
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacityFactor(0.06),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                      ),
                                    ),
                                    child: Text(
                                      "Top",
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            6.spaceH,
                            Text(
                              "${h.completions}/${h.opportunities} moments • ${h.habit.frequency}",
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

                      // Right: percent pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: Text(
                          _percent(h.rate.clamp(0.0, 1.0)),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
