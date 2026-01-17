import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/providers/providers.dart';
import 'package:habit_bucket/theme/theme_controller.dart';
import 'package:habit_bucket/utils/spacing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends ConsumerWidget {
  final ThemeController themeController;

  const SettingsScreen({super.key, required this.themeController});

  void _showEditNameDialog(BuildContext context, WidgetRef ref, String currentFirstName, String currentLastName) {
    final firstNameController = TextEditingController(text: currentFirstName);
    final lastNameController = TextEditingController(text: currentLastName);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                textCapitalization: TextCapitalization.words,
              ),
              16.spaceH,
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                textCapitalization: TextCapitalization.words,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final firstName = firstNameController.text.trim();
                final lastName = lastNameController.text.trim();

                if (firstName.isEmpty || lastName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter both names')),
                  );
                  return;
                }

                try {
                  final userId = Supabase.instance.client.auth.currentUser?.id;
                  if (userId == null) return;

                  // Update local database
                  await ref.read(localProfileRepoProvider).updateProfileNames(
                        userId: userId,
                        firstName: firstName,
                        lastName: lastName,
                      );

                  // Update Supabase
                  await Supabase.instance.client.from('profiles').update({
                    'first_name': firstName,
                    'last_name': lastName,
                    'updated_at': DateTime.now().toIso8601String(),
                  }).eq('user_id', userId);

                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Name updated ✅')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update name')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final profile = profileAsync.value;
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
                  const SizedBox(height: 24),

                  // Profile Section
                  const Text(
                    "Profile",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  ListTile(
                    title: const Text('Name'),
                    subtitle: profile != null
                        ? Text('${profile.firstName} ${profile.lastName}')
                        : const Text('Loading...'),
                    trailing: const Icon(Icons.edit),
                    onTap: profile != null
                        ? () => _showEditNameDialog(
                              context,
                              ref,
                              profile.firstName,
                              profile.lastName,
                            )
                        : null,
                  ),

                  const SizedBox(height: 24),

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
