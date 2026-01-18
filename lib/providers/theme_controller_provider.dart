import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/theme/theme_controller.dart';

final themeControllerProvider = ChangeNotifierProvider<ThemeController>((ref) {
  final controller = ThemeController();
  controller.load();
  ref.onDispose(controller.dispose);
  return controller;
});
