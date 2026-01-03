// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:habit_bucket/utils/colors.dart';
// import 'package:habit_bucket/utils/opacity.dart';

// class StatsScreen extends StatelessWidget {
//   const StatsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Your Progress",
//                 style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 "Consistency over time",
//                 style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacityFactor(0.6)),

//               ),
//               const SizedBox(height: 24),

//               /// Streak Highlight
//               _HighlightCard(),

//               const SizedBox(height: 24),

//               /// Stats Grid
//               GridView.count(
//                 crossAxisCount: 2,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 children: const [
//                   _StatTile(
//                     title: "Current Streak",
//                     value: "🔥 7 days",
//                     icon: FontAwesomeIcons.fire,
//                   ),
//                   _StatTile(
//                     title: "Longest Streak",
//                     value: "14 days",
//                     icon: FontAwesomeIcons.trophy,
//                   ),
//                   _StatTile(
//                     title: "Completion Rate",
//                     value: "86%",
//                     icon: FontAwesomeIcons.chartPie,
//                   ),
//                   _StatTile(
//                     title: "Best Month",
//                     value: "March",
//                     icon: FontAwesomeIcons.calendar,
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 24),

//               /// Wrapped Preview
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   gradient: LinearGradient(
//                     colors: [
//                       HabitBucketColors.mainPurple,
//                       HabitBucketColors.mainPurple.withOpacityFactor(0.8),
//                     ],
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Your 2025 Wrapped",
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.surface,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 6),
//                     Text(
//                       "Available at the end of the year",
//                       style: TextStyle(
//                         color: Theme.of(
//                           context,
//                         ).colorScheme.surface.withOpacityFactor(.7),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _HighlightCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Theme.of(context).colorScheme.surface,
//         boxShadow: Theme.of(context).brightness == Brightness.dark
//             ? []
//             : [
//                 BoxShadow(
//                   color: Colors.black.withOpacityFactor(0.04),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: HabitBucketColors.mainPurple.withOpacityFactor(0.1),
//             ),
//             child: const Icon(
//               FontAwesomeIcons.bolt,
//               color: HabitBucketColors.mainPurple,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "You're on a roll",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 "Completed all habits today",
//                 style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacityFactor(0.55)),

//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StatTile extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;

//   const _StatTile({
//     required this.title,
//     required this.value,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//         color: Theme.of(context).colorScheme.surface,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacityFactor(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 18, color: HabitBucketColors.mainPurple),
//           const Spacer(),
//           Text(
//             value,
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4),
//           Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacityFactor(0.55)),
// ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:habit_bucket/providers/stats_providers.dart';
// import 'package:habit_bucket/screens/stats/widgets/consistency_ring.dart';
// import 'package:habit_bucket/screens/stats/widgets/error_box.dart';
// import 'package:habit_bucket/screens/stats/widgets/stat_card.dart';
// import 'package:habit_bucket/screens/stats/widgets/stats_skeleton.dart';
// import 'package:habit_bucket/screens/stats/widgets/streaks_list.dart';
// import 'package:habit_bucket/screens/stats/widgets/surface_card.dart';
// import 'package:habit_bucket/utils/opacity.dart';
// import 'package:habit_bucket/utils/spacing.dart';

// class StatsScreen extends ConsumerWidget {
//   const StatsScreen({super.key});

//   String _percent(double v) => '${(v * 100).round()}%';

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final weekStatsAsync = ref.watch(thisWeekStatsProvider);

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Your progress",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.w600,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               6.spaceH,
//               Text(
//                 "Consistency, not pressure. You’re building something real.",
//                 style: TextStyle(
//                   fontSize: 13.5,
//                   color: Theme.of(context)
//                       .colorScheme
//                       .onSurface
//                       .withOpacityFactor(0.65),
//                 ),
//               ),
//               16.spaceH,

//               weekStatsAsync.when(
//                 loading: () => const StatsSkeleton(),
//                 error: (e, _) => ErrorBox(message: e.toString()),
//                 data: (s) {
//                   final consistency = s.consistency.clamp(0.0, 1.0);
//                   final momentsLeft = s.missedMoments;

//                   return Column(
//                     children: [
//                       // Top row: ring + weekly summary
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 4,
//                             child: SurfaceCard(
//                               child: Row(
//                                 children: [
//                                   ConsistencyRing(
//                                     value: consistency,
//                                     label: _percent(consistency),
//                                   ),
//                                   14.spaceW,
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "This week",
//                                           style: TextStyle(
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.w600,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onSurface
//                                                 .withOpacityFactor(0.75),
//                                           ),
//                                         ),
//                                         6.spaceH,
//                                         Text(
//                                           "${s.completions} check-ins",
//                                           style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w700,
//                                             color: Theme.of(context).colorScheme.onSurface,
//                                           ),
//                                         ),
//                                         6.spaceH,
//                                         Text(
//                                           momentsLeft == 0
//                                               ? "You didn’t leave anything behind 💜"
//                                               : "$momentsLeft moments left (that’s okay).",
//                                           style: TextStyle(
//                                             fontSize: 12.5,
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .onSurface
//                                                 .withOpacityFactor(0.65),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       12.spaceH,

//                       // Bottom row: quick stat cards
//                       Row(
//                         children: [
//                           Expanded(
//                             child: StatCard(
//                               title: "Consistency",
//                               value: _percent(consistency),
//                               subtitle: "Over ${s.opportunities} moments",
//                               icon: Icons.auto_graph_rounded,
//                             ),
//                           ),
//                           12.spaceW,
//                           Expanded(
//                             child: StatCard(
//                               title: "Moments left",
//                               value: "$momentsLeft",
//                               subtitle: "Still part of the journey",
//                               icon: Icons.favorite_border_rounded,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 },
//               ),

//               18.spaceH,

//               Text(
//                 "Streaks",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//               6.spaceH,
//               Text(
//                 "Grey means you haven’t checked in yet for this period. Pink means you did.",
//                 style: TextStyle(
//                   fontSize: 12.5,
//                   color: Theme.of(context)
//                       .colorScheme
//                       .onSurface
//                       .withOpacityFactor(0.65),
//                 ),
//               ),

//               12.spaceH,

//               Expanded(
//                 child: StreaksList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/providers/stats_providers.dart';
import 'package:habit_bucket/screens/stats/widgets/consistency_ring.dart';
import 'package:habit_bucket/screens/stats/widgets/error_box.dart';
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
