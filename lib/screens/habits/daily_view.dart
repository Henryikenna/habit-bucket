import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habit_bucket/enums/habit_frequency_enum.dart';
import 'package:habit_bucket/models/habit_model.dart';
import 'package:habit_bucket/screens/habits/widgets/habit_widget.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';

List<HabitModel> habitList = [
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
];

class DailyView extends StatefulWidget {
  final HabitFrequency frequency;
  const DailyView({super.key, required this.frequency});

  @override
  State<DailyView> createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
  final bool _isChecked = true;
  final bool _isStreakActivated = true;

  @override
  Widget build(BuildContext context) {
    return habitList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.seedling, size: 48, color: Colors.grey),
                16.spaceH,
                Text("No daily habits yet", style: TextStyle(fontSize: 16)),
                8.spaceH,
                Text(
                  "Tap + to create your first habit!",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Daily Habits",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),

                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: "${habitList.length}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacityFactor(.95),
                              ),
                            ),
                            const TextSpan(text: "/"),
                            TextSpan(
                              text: "10",
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                8.spaceH,

                Expanded(
                  child: ListView.separated(
                    // shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      return HabitWidget(
                        isChecked: _isChecked,
                        isStreakActivated: _isStreakActivated,
                        title: habitList[index].title,
                        habitFrequency: habitList[index].habitFrequency,
                      );
                    },
                    separatorBuilder: (context, index) => 16.spaceH,
                    itemCount: habitList.length,
                  ),
                ),
              ],
            ),
          );
  }
}
