import 'package:flutter/material.dart';
import 'package:habit_bucket/utils/colors.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Outfit',
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: HabitBucketColors.mainPurple,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: HabitBucketColors.lightGray,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Outfit',
      brightness: Brightness.dark,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: HabitBucketColors.mainPurple,
            brightness: Brightness.dark,
          ).copyWith(
            surface: HabitBucketColors.secondaryBlack,
            outline: HabitBucketColors.borderBlack,
          ),
      scaffoldBackgroundColor: HabitBucketColors.background,
    );
  }
}
