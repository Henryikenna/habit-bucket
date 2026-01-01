import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habit_bucket/utils/colors.dart';
import 'package:habit_bucket/utils/opacity.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your Progress",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                "Consistency over time",
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacityFactor(0.6)),

              ),
              const SizedBox(height: 24),

              /// Streak Highlight
              _HighlightCard(),

              const SizedBox(height: 24),

              /// Stats Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  _StatTile(
                    title: "Current Streak",
                    value: "🔥 7 days",
                    icon: FontAwesomeIcons.fire,
                  ),
                  _StatTile(
                    title: "Longest Streak",
                    value: "14 days",
                    icon: FontAwesomeIcons.trophy,
                  ),
                  _StatTile(
                    title: "Completion Rate",
                    value: "86%",
                    icon: FontAwesomeIcons.chartPie,
                  ),
                  _StatTile(
                    title: "Best Month",
                    value: "March",
                    icon: FontAwesomeIcons.calendar,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Wrapped Preview
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      HabitBucketColors.mainPurple,
                      HabitBucketColors.mainPurple.withOpacityFactor(0.8),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your 2025 Wrapped",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Available at the end of the year",
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withOpacityFactor(.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacityFactor(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: HabitBucketColors.mainPurple.withOpacityFactor(0.1),
            ),
            child: const Icon(
              FontAwesomeIcons.bolt,
              color: HabitBucketColors.mainPurple,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You're on a roll",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text(
                "Completed all habits today",
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacityFactor(0.55)),

              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacityFactor(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: HabitBucketColors.mainPurple),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacityFactor(0.55)),
),
        ],
      ),
    );
  }
}
