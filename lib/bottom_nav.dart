import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habit_bucket/models/bottom_nav_widget_model.dart';
import 'package:habit_bucket/screens/habits/habits_screen.dart';
import 'package:habit_bucket/screens/stats/stats_screen.dart';
import 'package:habit_bucket/utils/colors.dart';
import 'package:habit_bucket/utils/opacity.dart';

// class BottomNav extends StatefulWidget {
//   const BottomNav({super.key});

//   @override
//   State<BottomNav> createState() => _BottomNavState();
// }

// class _BottomNavState extends State<BottomNav> {
//   int currentIndex = 0;

//   List<BottomNavWidgetModel> widgetsList = [
//     BottomNavWidgetModel(
//       name: "Habits",
//       icon: FaIcon(FontAwesomeIcons.listCheck),
//       widget: HabitsScreen(),
//     ),
//     BottomNavWidgetModel(
//       name: "Stats",
//       icon: FaIcon(FontAwesomeIcons.chartLine),
//       widget: Container(),
//     ),
//     BottomNavWidgetModel(
//       name: "Settings",
//       icon: FaIcon(FontAwesomeIcons.gear),
//       widget: Container(),
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> screens = widgetsList.map((e) => e.widget).toList();

//     return Scaffold(
//       backgroundColor: HabitBucketColors.lightGray,
//       body: screens[currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: (value) => setState(() {
//           currentIndex = value;
//         }),
//         items: widgetsList
//             .map((e) => BottomNavigationBarItem(icon: e.icon, label: e.name))
//             .toList(),
//       ),
//     );
//   }
// }

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;

  final List<BottomNavWidgetModel> widgetsList = const [
    BottomNavWidgetModel(
      name: "Habits",
      icon: FaIcon(FontAwesomeIcons.listCheck),
      widget: HabitsScreen(),
    ),
    BottomNavWidgetModel(
      name: "Stats",
      icon: FaIcon(FontAwesomeIcons.chartLine),
      widget: StatsScreen(),
    ),
    BottomNavWidgetModel(
      name: "Settings",
      icon: FaIcon(FontAwesomeIcons.gear),
      widget: SizedBox(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: HabitBucketColors.lightGray,
      body: widgetsList[currentIndex].widget,
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: HabitBucketColors.black.withOpacityFactor(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: HabitBucketColors.mainPurple,
          unselectedItemColor: Colors.grey.shade400,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: widgetsList
              .map(
                (e) => BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: e.icon,
                  ),
                  label: e.name,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
