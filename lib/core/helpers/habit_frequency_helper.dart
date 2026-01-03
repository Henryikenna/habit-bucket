import 'package:habit_bucket/core/enums/habit_frequency_enum.dart';

HabitFrequency getHabitFrequencyEnum({
  required String habitFrequency,
}) {
  switch (habitFrequency) {
    case 'daily':
      return HabitFrequency.daily;
    case 'weekly':
      return HabitFrequency.weekly;
    case 'monthly':
      return HabitFrequency.monthly;
    default:
      return HabitFrequency.daily;
  }
}