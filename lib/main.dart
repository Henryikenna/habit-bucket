
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
