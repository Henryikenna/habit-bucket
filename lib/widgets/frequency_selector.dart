import 'package:flutter/material.dart';
import 'package:habit_bucket/enums/habit_frequency_enum.dart';
import 'package:habit_bucket/utils/capitalize_extension.dart';
import 'package:habit_bucket/utils/colors.dart';
import 'package:habit_bucket/utils/opacity.dart';

class FrequencySelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const FrequencySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    List<String> frequencyList = HabitFrequency.values
        .map((freq) => freq.name.capitalize())
        .toList();


    return Wrap(
      spacing: 8,
      children: frequencyList.map((freq) {
        final isActive = freq == selected;
        return ChoiceChip(
          label: Text(freq, style: TextStyle(fontSize: 15)),
          selected: isActive,
          checkmarkColor: HabitBucketColors.mainPurple,
          onSelected: (_) => onChanged(freq),
          selectedColor: HabitBucketColors.mainPurple.withOpacityFactor(0.15),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: isActive
                ? HabitBucketColors.mainPurple
                : Colors.grey.shade700,
          ),
        );
      }).toList(),
    );
  }
}
