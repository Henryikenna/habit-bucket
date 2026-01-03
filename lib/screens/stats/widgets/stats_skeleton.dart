import 'package:flutter/material.dart';
import 'package:habit_bucket/screens/stats/widgets/surface_card.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';

class StatsSkeleton extends StatelessWidget {
  const StatsSkeleton({super.key});


  @override
  Widget build(BuildContext context) {
    Widget bar(double w) => Container(
          height: 12,
          width: w,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withOpacityFactor(0.25),
            borderRadius: BorderRadius.circular(8),
          ),
        );

    return Column(
      children: [
        SurfaceCard(
          child: Row(
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withOpacityFactor(0.20),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              14.spaceW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bar(80),
                    8.spaceH,
                    bar(140),
                    8.spaceH,
                    bar(200),
                  ],
                ),
              )
            ],
          ),
        ),
        12.spaceH,
        Row(
          children: [
            Expanded(child: SurfaceCard(child: bar(double.infinity))),
            12.spaceW,
            Expanded(child: SurfaceCard(child: bar(double.infinity))),
          ],
        )
      ],
    );
  }
}
