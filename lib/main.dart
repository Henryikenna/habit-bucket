// import 'package:flutter/material.dart';
// import 'package:habit_bucket/bottom_nav.dart';
// import 'package:habit_bucket/utils/colors.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         //remove keyboard on touching anywhere on the screen.
//         FocusScopeNode currentFocus = FocusScope.of(context);

//         if (!currentFocus.hasPrimaryFocus) {
//           currentFocus.unfocus();
//           FocusManager.instance.primaryFocus?.unfocus();
//         }
//       },
//       child: MaterialApp(
//         title: 'Habit Bucket',
//         theme: ThemeData(
//           fontFamily: 'Outfit',
//           colorScheme: ColorScheme.fromSeed(
//             seedColor: HabitBucketColors.mainPurple,
//           ),
//         ),
//         // home: HomeScreen(),
//         home: BottomNav(),
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:habit_bucket/bottom_nav.dart';
import 'package:habit_bucket/theme/app_theme.dart';
import 'package:habit_bucket/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeController = ThemeController();
  await themeController.load();

  runApp(MyApp(themeController: themeController));
}

class MyApp extends StatelessWidget {
  final ThemeController themeController;

  const MyApp({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: AnimatedBuilder(
        animation: themeController,
        builder: (context, _) {
          return MaterialApp(
            title: 'Habit Bucket',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeController.themeMode,
            home: BottomNav(themeController: themeController),
          );
        },
      ),
    );
  }
}
