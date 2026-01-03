// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:habit_bucket/providers/providers.dart';
// import 'package:habit_bucket/screens/auth/sign_in_screen.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import 'package:habit_bucket/bottom_nav.dart';
// import 'package:habit_bucket/theme/theme_controller.dart';

// class AuthGate extends ConsumerWidget {
//   final ThemeController themeController;

//   const AuthGate({super.key, required this.themeController});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return StreamBuilder<AuthState>(
//       stream: Supabase.instance.client.auth.onAuthStateChange,
//       //      stream: Supabase.instance.client.auth.onAuthStateChange.listen((_) {
//       //   ref.read(syncServiceProvider).sync();
//       // }),
//       builder: (context, snapshot) {
//         Supabase.instance.client.auth.onAuthStateChange.listen((_) {
//           ref.read(syncServiceProvider).sync();
//         });

//         final session = Supabase.instance.client.auth.currentSession;

//         if (session == null) {
//           return const SignInScreen();
//         }

//         return BottomNav(themeController: themeController);
//       },
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/bottom_nav.dart';
import 'package:habit_bucket/providers/providers.dart';
import 'package:habit_bucket/screens/auth/sign_in_screen.dart';
import 'package:habit_bucket/theme/theme_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends ConsumerStatefulWidget {
  final ThemeController themeController;

  const AuthGate({super.key, required this.themeController});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  late final StreamSubscription<AuthState> _authSub;

  @override
  void initState() {
    super.initState();

    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      ref.read(syncServiceProvider).sync();
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      return const SignInScreen();
    }

    return BottomNav(themeController: widget.themeController);
  }
}
