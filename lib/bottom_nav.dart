import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habit_bucket/models/bottom_nav_widget_model.dart';
import 'package:habit_bucket/screens/habits/habits_screen.dart';
import 'package:habit_bucket/screens/settings/settings_screen.dart';
import 'package:habit_bucket/screens/stats/stats_screen.dart';
import 'package:habit_bucket/utils/opacity.dart';

class BottomNav extends StatefulWidget {

  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;

  late final List<BottomNavWidgetModel> widgetsList;

  @override
  void initState() {
    super.initState();

    widgetsList = [
      const BottomNavWidgetModel(
        name: "Habits",
        icon: FaIcon(FontAwesomeIcons.listCheck),
        widget: HabitsScreen(),
      ),
      const BottomNavWidgetModel(
        name: "Stats",
        icon: FaIcon(FontAwesomeIcons.chartLine),
        widget: StatsScreen(),
      ),
      BottomNavWidgetModel(
        name: "Settings",
        icon: const FaIcon(FontAwesomeIcons.gear),
        widget: SettingsScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // body: widgetsList[currentIndex].widget,
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.symmetric(vertical: 8),
      //   decoration: BoxDecoration(
      //     color: surface,
      //     borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacityFactor(0.06),
      //         blurRadius: 20,
      //         offset: const Offset(0, -4),
      //       ),
      //     ],
      //   ),

      extendBody: false,
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  body: widgetsList[currentIndex].widget,
  bottomNavigationBar: Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacityFactor(
            Theme.of(context).brightness == Brightness.dark ? 0.18 : 0.06,
          ),
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
          // selectedItemColor: Theme.of(context).colorScheme.primary,
          // unselectedItemColor: Colors.grey.shade400,
          selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacityFactor(0.45),
     
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
