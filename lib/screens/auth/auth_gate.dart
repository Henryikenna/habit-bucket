import 'package:flutter/material.dart';
import 'package:habit_bucket/screens/auth/sign_in_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:habit_bucket/bottom_nav.dart';
import 'package:habit_bucket/theme/theme_controller.dart';

class AuthGate extends StatelessWidget {
  final ThemeController themeController;

  const AuthGate({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;

        if (session == null) {
          return const SignInScreen();
        }

        return BottomNav(themeController: themeController);
      },
    );
  }
}
