import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habit_bucket/core/enums/habit_frequency_enum.dart';
import 'package:habit_bucket/core/local/app_db.dart';
import 'package:habit_bucket/providers/providers.dart';
import 'package:habit_bucket/providers/stats_providers.dart';
import 'package:habit_bucket/screens/habits/create_new_habit_screen.dart';
import 'package:habit_bucket/screens/habits/daily_view.dart';
import 'package:habit_bucket/utils/colors.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showTopBlur = false;
  // late AnimationController _bounceController;
  // late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      bool shouldShow = _scrollController.offset > 0;
      if (shouldShow != _showTopBlur) {
        setState(() {
          _showTopBlur = shouldShow;
        });
      }
    });
  }

  Widget getView({
    required int index,
    required List<Habit> habits,
    required int weekStartsOn,
    required Map<String, HabitStreak> streaks,
  }) {
    List<Widget> viewsList = [
      DailyView(
        frequency: HabitFrequency.daily,
        habitList: habits,
        weekStartsOn: weekStartsOn,
        streaks: streaks,
      ),
      SizedBox(height: 1500, child: Text("WEEKLY...MAIN CONTENT")),
      Center(child: Text("MONTHLY...MAIN CONTENT")),
    ];

    return viewsList[index];
  }

  int currentViewIndex = 0;

  void changeView(int index) {
    setState(() {
      currentViewIndex = index;
    });
  }

  HabitFrequency getViewBasedOnHabitFreq() {
    if (currentViewIndex == 0) {
      return HabitFrequency.daily;
    } else if (currentViewIndex == 1) {
      return HabitFrequency.weekly;
    } else {
      return HabitFrequency.monthly;
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(habitsProvider);
    final weekStartsOnAsync = ref.watch(weekStartsOnProvider);
    final weekStartsOn = weekStartsOnAsync.value ?? 1;
    final streaksAsync = ref.watch(habitStreaksProvider);
    final streaks = streaksAsync.value ?? {};

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.spaceH,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "${_getGreeting()},\nAlexis",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  height: 1.15,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

            24.spaceH,
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 64,
                    // height: double.infinity,
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              changeView(0);
                            },
                            // highlightColor: HabitBucketColors.blue,
                            splashColor: HabitBucketColors.mainPurple
                                .withOpacityFactor(0.2),
                            highlightColor: HabitBucketColors.mainPurple
                                .withOpacityFactor(0.1),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: currentViewIndex == 0
                                    ? HabitBucketColors.mainPurple
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.bolt,
                                    size: 24,
                                    color: currentViewIndex == 0
                                        ? HabitBucketColors.lightGray
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                  ),
                                  currentViewIndex == 0
                                      ? SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            top: 6,
                                          ),
                                          child: Text(
                                            "Daily",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              changeView(1);
                            },
                            splashColor: HabitBucketColors.mainPurple
                                .withOpacityFactor(0.2),
                            highlightColor: HabitBucketColors.mainPurple
                                .withOpacityFactor(0.1),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: currentViewIndex == 1
                                    ? HabitBucketColors.mainPurple
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.calendarWeek,
                                    size: 24,
                                    color: currentViewIndex == 1
                                        ? HabitBucketColors.lightGray
                                        // : Theme.of(context).brightness ==
                                        //       Brightness.light
                                        // ? HabitBucketColors.black
                                        // : HabitBucketColors.lightGray,
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                  ),
                                  currentViewIndex == 1
                                      ? SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            top: 6,
                                          ),
                                          child: Text(
                                            "Weekly",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              changeView(2);
                            },
                            splashColor: HabitBucketColors.mainPurple
                                .withOpacityFactor(0.2),
                            highlightColor: HabitBucketColors.mainPurple
                                .withOpacityFactor(0.1),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: currentViewIndex == 2
                                    ? HabitBucketColors.mainPurple
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidCalendar,
                                    size: 24,
                                    color: currentViewIndex == 2
                                        ? HabitBucketColors.lightGray
                                        // : Theme.of(context).brightness ==
                                        //       Brightness.light
                                        // ? HabitBucketColors.black
                                        // : HabitBucketColors.lightGray,
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                  ),
                                  currentViewIndex == 2
                                      ? SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            top: 6,
                                          ),
                                          child: Text(
                                            "Monthly",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: habitsAsync.when(
                      data: (habits) {
                        final viewFreq = getViewBasedOnHabitFreq();
                        final filtered = habits.where((h) {
                          final f = h.frequency; // 'daily'|'weekly'|'monthly'
                          return switch (viewFreq) {
                            HabitFrequency.daily => f == 'daily',
                            HabitFrequency.weekly => f == 'weekly',
                            HabitFrequency.monthly => f == 'monthly',
                          };
                        }).toList();

                        return AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(0.1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            key: ValueKey(currentViewIndex),
                            // child: viewsList[currentViewIndex],
                            child: getView(
                              index: currentViewIndex,
                              // habits: habits,
                              habits: filtered,
                              weekStartsOn: weekStartsOn,
                              streaks: streaks,
                            ),
                          ),
                        );
                      },
                      error: (e, _) => Center(child: Text('Error: $e')),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ],
              ),
            ),

            // 10.spaceH,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "new-habit-fab",
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  CreateNewHabitScreen(
                    currentSectionSelected: getViewBasedOnHabitFreq(),
                  ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          );
        },
        label: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.plus,
              color: HabitBucketColors.white,
              size: 18,
            ),
            6.spaceW,
            Text(
              "New habit",
              style: TextStyle(fontSize: 14, color: HabitBucketColors.white),
            ),
          ],
        ),
        backgroundColor: HabitBucketColors.mainPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(50),
        ),
        elevation: 0,
      ),
    );
  }
}
