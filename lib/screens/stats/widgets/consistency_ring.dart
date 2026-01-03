
import 'package:flutter/material.dart';
import 'package:habit_bucket/utils/colors.dart';
import 'package:habit_bucket/utils/opacity.dart';

class ConsistencyRing extends StatelessWidget {
  final double value; // 0..1
  final String label;

  const ConsistencyRing({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: 54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: 6,
            backgroundColor:
                Theme.of(context).colorScheme.outline.withOpacityFactor(0.25),
            valueColor: AlwaysStoppedAnimation(HabitBucketColors.mainPurple),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
