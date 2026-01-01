import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habit_bucket/enums/habit_frequency_enum.dart';
import 'package:habit_bucket/screens/habits/create_new_habit_screen.dart';
import 'package:habit_bucket/screens/habits/daily_view.dart';
import 'package:habit_bucket/utils/colors.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen>
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

    // _bounceController = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 1500),
    // )..repeat(reverse: true);

    // _bounceAnimation = Tween<double>(begin: 0, end: -8).animate(
    //   CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    // );
  }

  List<Widget> viewsList = [
    DailyView(frequency: HabitFrequency.daily),
    SizedBox(height: 1500, child: Text("WEEKLY...MAIN CONTENT")),
    Center(child: Text("MONTHLY...MAIN CONTENT")),
  ];

  int currentViewIndex = 0;

  // HabitFrequency _habitFrequency = HabitFrequency.daily;

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
    return Scaffold(
      backgroundColor: HabitBucketColors.lightGray,
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
                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         _getGreeting(), // "Good morning", "Good afternoon", etc.
            //         style: TextStyle(
            //           fontSize: 36,
            //           color: HabitBucketColors.black,
            //         ),
            //       ),
            //       4.spaceH,
            //       Text(
            //         "Alexis",
            //         style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
            //       ),
            //       8.spaceH,
            //       // Add a motivational stat
            //       Container(
            //         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            //         decoration: BoxDecoration(
            //           color: HabitBucketColors.mainPurple.withOpacityFactor(
            //             0.1,
            //           ),
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //         child: Text(
            //           "🔥 5 day streak • 3/5 habits today",
            //           style: TextStyle(
            //             fontSize: 14,
            //             color: HabitBucketColors.mainPurple,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
                        right: BorderSide(color: HabitBucketColors.borderBlack),
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
                                        : HabitBucketColors.black,
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

                                              // fontFamily: manropeFont,
                                              // fontWeight: FontWeight.w600,
                                              // color: currentViewIndex == 0
                                              //     ? HabitBucketColors.lightGray
                                              //     : HabitBucketColors.black,
                                              color: HabitBucketColors.black,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Container(
                        //   width: double.infinity,
                        //   height: 1,
                        //   decoration: BoxDecoration(
                        //     color: HabitBucketColors.mediumGray,
                        //   ),
                        // ),
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
                                        : HabitBucketColors.black,
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
                                              // fontFamily: manropeFont,
                                              // fontWeight: FontWeight.w500,
                                              // color: currentViewIndex == 1
                                              //     ? HabitBucketColors.lightGray
                                              //     : HabitBucketColors.black,
                                              color: HabitBucketColors.black,
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
                                        : HabitBucketColors.black,
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
                                              // fontFamily: manropeFont,
                                              // fontWeight: FontWeight.w500,
                                              // color: currentViewIndex == 1
                                              //     ? HabitBucketColors.lightGray
                                              //     : HabitBucketColors.black,
                                              color: HabitBucketColors.black,
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
                    // child: Stack(
                    //   fit: StackFit.expand,
                    //   children: [
                    //     // SingleChildScrollView(
                    //     //   controller: _scrollController,
                    //     //   padding: EdgeInsets.only(bottom: 80),
                    //       // child: viewsList[currentViewIndex],
                    //       // child: AnimatedSwitcher(
                    //  AnimatedSwitcher(
                    //         duration: Duration(milliseconds: 300),
                    //         transitionBuilder: (child, animation) {
                    //           return FadeTransition(
                    //             opacity: animation,
                    //             child: SlideTransition(
                    //               position: Tween<Offset>(
                    //                 begin: Offset(0.1, 0),
                    //                 end: Offset.zero,
                    //               ).animate(animation),
                    //               child: child,
                    //             ),
                    //           );
                    //         },
                    //         child: Container(
                    //           key: ValueKey(currentViewIndex),
                    //           child: viewsList[currentViewIndex],
                    //         ),
                    //       ),
                    //     // ),

                    //     Positioned(
                    //       top: 0,
                    //       left: 0,
                    //       right: 0,
                    //       child: AnimatedOpacity(
                    //         opacity: _showTopBlur ? 1.0 : 0.0,
                    //         duration: Duration(milliseconds: 200),
                    //         child: ClipRect(
                    //           child: BackdropFilter(
                    //             filter: ImageFilter.blur(sigmaX: 0, sigmaY: 10),
                    //             child: Container(
                    //               height: 40,
                    //               decoration: BoxDecoration(
                    //                 gradient: LinearGradient(
                    //                   begin: Alignment.topCenter,
                    //                   end: Alignment.bottomCenter,
                    //                   colors: [
                    //                     HabitBucketColors.lightGray,
                    //                     HabitBucketColors.lightGray
                    //                         .withOpacityFactor(0.8),
                    //                     HabitBucketColors.lightGray
                    //                         .withOpacityFactor(0.0),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    child: AnimatedSwitcher(
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
                        child: viewsList[currentViewIndex],
                      ),
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
        // child: Center(
        //   child: FaIcon(
        //     FontAwesomeIcons.plus,
        //     color: HabitBucketColors.white,
        //     size: 24,
        //   ),
        // ),
      ),
    );
  }
}
