import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/core/notifications/notification_bootstrap.dart';
import 'package:habit_bucket/screens/auth/auth_gate.dart';
import 'package:habit_bucket/screens/onboarding/onboarding_screen.dart';
import 'package:habit_bucket/theme/app_theme.dart';
import 'package:habit_bucket/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final themeController = ThemeController();
  await themeController.load();

  runApp(ProviderScope(child: MyApp(themeController: themeController)));
}

class MyApp extends StatefulWidget {
  final ThemeController themeController;

  const MyApp({super.key, required this.themeController});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _onboardingCompleted;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool('onboarding_completed') ?? false;
    setState(() {
      _onboardingCompleted = completed;
    });
  }

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
        animation: widget.themeController,
        builder: (context, _) {
          return MaterialApp(
            title: 'Habit Bucket',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: widget.themeController.themeMode,
            home: _onboardingCompleted == null
                ? const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  )
                : _onboardingCompleted!
                    ? NotificationBootstrap(
                        child: AuthGate(
                          themeController: widget.themeController,
                        ),
                      )
                    : const OnboardingScreen(),
          );
        },
      ),
    );
  }
}
