import 'package:habit_bucket/enums/habit_frequency_enum.dart';

class HabitModel {
  final String title;
  final HabitFrequency habitFrequency;

  HabitModel({required this.title, required this.habitFrequency});
}
