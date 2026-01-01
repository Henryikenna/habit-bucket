import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeSetting { light, dark, auto } // auto = 7pm-7am

class ThemeController extends ChangeNotifier with WidgetsBindingObserver {
  static const _prefKey = 'app_theme_setting';

  ThemeController() {
    WidgetsBinding.instance.addObserver(this);
  }

  AppThemeSetting _setting = AppThemeSetting.auto;
  Timer? _timer;

  AppThemeSetting get setting => _setting;

  /// The actual ThemeMode used by MaterialApp.
  ThemeMode get themeMode {
    switch (_setting) {
      case AppThemeSetting.light:
        return ThemeMode.light;
      case AppThemeSetting.dark:
        return ThemeMode.dark;
      case AppThemeSetting.auto:
        return _isNightNow() ? ThemeMode.dark : ThemeMode.light;
    }
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);

    if (raw != null) {
      _setting = AppThemeSetting.values.firstWhere(
        (e) => e.name == raw,
        orElse: () => AppThemeSetting.auto,
      );
    }

    _rescheduleTimer();
    notifyListeners();
  }

  Future<void> setSetting(AppThemeSetting value) async {
    if (_setting == value) return;

    _setting = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, value.name);

    _rescheduleTimer();
    notifyListeners();
  }

  bool _isNightNow() {
    final hour = DateTime.now().hour;
    // Night = 7pm..6:59am
    return hour >= 19 || hour < 7;
  }

  void _rescheduleTimer() {
    _timer?.cancel();
    _timer = null;

    // Only schedule switches when Auto mode is enabled.
    if (_setting != AppThemeSetting.auto) return;

    final now = DateTime.now();
    final next = _nextBoundary(now);

    final delay = next.difference(now);
    _timer = Timer(delay, () {
      // Time crossed a boundary -> rebuild theme + schedule next boundary.
      notifyListeners();
      _rescheduleTimer();
    });
  }

  DateTime _nextBoundary(DateTime now) {
    // Boundaries are 07:00 and 19:00 local time.
    final sevenAm = DateTime(now.year, now.month, now.day, 7);
    final sevenPm = DateTime(now.year, now.month, now.day, 19);

    if (now.isBefore(sevenAm)) return sevenAm;
    if (now.isBefore(sevenPm)) return sevenPm;

    // Otherwise, next is tomorrow 07:00
    final tomorrow = now.add(const Duration(days: 1));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 7);
  }

  /// If user backgrounds the app and returns after 7/19 boundary,
  /// we refresh instantly.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_setting == AppThemeSetting.auto &&
        state == AppLifecycleState.resumed) {
      _rescheduleTimer();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }
}
