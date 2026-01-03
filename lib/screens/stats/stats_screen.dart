import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/providers/stats_providers.dart';
import 'package:habit_bucket/screens/stats/widgets/consistency_ring.dart';
import 'package:habit_bucket/screens/stats/widgets/error_box.dart';
import 'package:habit_bucket/screens/stats/widgets/per_habit_stats_list.dart';
import 'package:habit_bucket/screens/stats/widgets/stat_card.dart';
import 'package:habit_bucket/screens/stats/widgets/stats_range_selector.dart';
import 'package:habit_bucket/screens/stats/widgets/stats_skeleton.dart';
import 'package:habit_bucket/screens/stats/widgets/streaks_list.dart';
import 'package:habit_bucket/screens/stats/widgets/surface_card.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  String _percent(double v) => '${(v * 100).round()}%';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(selectedStatsRangeProvider);
    final statsAsync = ref.watch(dashboardStatsProvider(range));
    final aggsAsync = ref.watch(statsAggregatesProvider(range));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your progress",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              6.spaceH,
              Text(
                "Consistency, not pressure. You’re building something real.",
                style: TextStyle(
                  fontSize: 13.5,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacityFactor(0.65),
                ),
              ),

              14.spaceH,
              const StatsRangeSelector(),
              14.spaceH,

              statsAsync.when(
                loading: () => const StatsSkeleton(),
                error: (e, _) => ErrorBox(message: e.toString()),
                data: (s) {
                  final consistency = s.consistency.clamp(0.0, 1.0);
                  final momentsLeft = s.missedMoments;

                  return Column(
                    children: [
                      // Top: ring + summary
                      SurfaceCard(
                        child: Row(
                          children: [
                            ConsistencyRing(
                              value: consistency,
                              label: _percent(consistency),
                            ),
                            14.spaceW,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  aggsAsync.when(
                                    loading: () => Text(
                                      "…",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacityFactor(0.75),
                                      ),
                                    ),
                                    error: (_, __) => Text(
                                      "Progress",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacityFactor(0.75),
                                      ),
                                    ),
                                    data: (a) => Text(
                                      a.label,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacityFactor(0.75),
                                      ),
                                    ),
                                  ),
                                  6.spaceH,
                                  Text(
                                    "${s.completions} check-ins",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                  6.spaceH,
                                  Text(
                                    momentsLeft == 0
                                        ? "You didn’t leave anything behind 💜"
                                        : "$momentsLeft moments left (that’s okay).",
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
                          ],
                        ),
                      ),

                      12.spaceH,

                      // Bottom: cards
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: "Consistency",
                              value: _percent(consistency),
                              subtitle: "Over ${s.opportunities} moments",
                              icon: Icons.auto_graph_rounded,
                            ),
                          ),
                          12.spaceW,
                          Expanded(
                            child: StatCard(
                              title: "Moments left",
                              value: "$momentsLeft",
                              subtitle: "Still part of the journey",
                              icon: Icons.favorite_border_rounded,
                            ),
                          ),
                        ],
                      ),

                      12.spaceH,

                      // New: aggregate cards
                      aggsAsync.when(
                        loading: () => const SizedBox.shrink(),
                        error: (e, _) => ErrorBox(message: e.toString()),
                        data: (a) {
                          final best = a.bestHabit;

                          final bestTitle = best?.habit.title ?? "—";

                          final bestValue = best == null
                              ? "—"
                              : _percent(best.rate.clamp(0.0, 1.0));

                          final bestSubtitle = best == null
                              ? "No habits yet"
                              : "${best.completions}/${best.opportunities} moments";

                          return Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  title: "Best habit",
                                  value: bestValue,
                                  subtitle: "$bestTitle • $bestSubtitle",
                                  icon: Icons.emoji_events_rounded,
                                ),
                              ),

                              12.spaceW,
                              Expanded(
                                child: StatCard(
                                  title: "Longest streak",
                                  value: "${a.longestStreakOverall}",
                                  subtitle: "Best run so far",
                                  icon: Icons.local_fire_department_rounded,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),

              18.spaceH,
              const PerHabitStatsList(),
              18.spaceH,

              Text(
                "Streaks",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              6.spaceH,
              Text(
                "Grey means you haven’t checked in yet for this period. Pink means you did.",
                style: TextStyle(
                  fontSize: 12.5,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacityFactor(0.65),
                ),
              ),
              12.spaceH,

              const Expanded(child: StreaksList()),
            ],
          ),
        ),
      ),
    );
  }
}
