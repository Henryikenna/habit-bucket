import 'package:flutter/material.dart';
import 'package:habit_bucket/theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeController themeController;

  const SettingsScreen({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: AnimatedBuilder(
            animation: themeController,
            builder: (context, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Settings",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Appearance",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  RadioGroup<AppThemeSetting>(
                    groupValue: themeController.setting,
                    onChanged: (value) {
                      if (value != null) {
                        themeController.setSetting(value);
                      }
                    },
                    child: Column(
                      children: const [
                        RadioListTile<AppThemeSetting>(
                          title: Text(
                            "Auto (Dark after 7pm, Light after 7am)",
                          ),
                          value: AppThemeSetting.auto,
                        ),
                        RadioListTile<AppThemeSetting>(
                          title: Text("Light"),
                          value: AppThemeSetting.light,
                        ),
                        RadioListTile<AppThemeSetting>(
                          title: Text("Dark"),
                          value: AppThemeSetting.dark,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
