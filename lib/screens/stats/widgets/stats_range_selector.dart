import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/providers/stats_providers.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';

class StatsRangeSelector extends ConsumerWidget {
  const StatsRangeSelector({super.key});

  String _label(StatsRange r) {
    switch (r) {
      case StatsRange.week:
        return "Week";
      case StatsRange.month:
        return "Month";
      case StatsRange.last30Days:
        return "30D";
      case StatsRange.ytd:
        return "YTD";
      case StatsRange.allTime:
        return "All";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedStatsRangeProvider);

    final items = StatsRange.values;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final r in items) ...[
            _Chip(
              label: _label(r),
              selected: r == selected,
              onTap: () =>
                  ref.read(selectedStatsRangeProvider.notifier).state = r,
            ),
            10.spaceW,
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? cs.onSurface : cs.outline,
          ),
          color: selected ? cs.onSurface.withOpacityFactor(0.06) : cs.surface,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected
                ? cs.onSurface
                : cs.onSurface.withOpacityFactor(0.70),
          ),
        ),
      ),
    );
  }
}
