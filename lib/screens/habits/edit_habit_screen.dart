import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_bucket/core/helpers/habit_frequency_helper.dart';
import 'package:habit_bucket/core/local/app_db.dart';
import 'package:habit_bucket/providers/providers.dart';
import 'package:habit_bucket/utils/colors.dart';
import 'package:habit_bucket/utils/spacing.dart';

class EditHabitScreen extends ConsumerStatefulWidget {
  final String habitId;

  const EditHabitScreen({super.key, required this.habitId});

  @override
  ConsumerState<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends ConsumerState<EditHabitScreen> {
  final _titleController = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  String? _error;
  String? _originalTitle;
  String? _frequency;

  @override
  void initState() {
    super.initState();
    _loadHabit();
  }

  Future<void> _loadHabit() async {
    try {
      final habit = await ref
          .read(localHabitRepoProvider)
          .getHabitById(widget.habitId);

      if (habit == null) {
        if (mounted) {
          Navigator.of(context).pop();
        }
        return;
      }

      setState(() {
        _originalTitle = habit.title;
        _frequency = habit.frequency;
        _titleController.text = habit.title;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load habit';
        _loading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    final newTitle = _titleController.text.trim();

    if (newTitle.isEmpty) {
      setState(() => _error = 'Title cannot be empty');
      return;
    }

    if (newTitle == _originalTitle) {
      // No changes made
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      // Update in local database
      final db = ref.read(appDbProvider);
      await (db.update(
        db.habits,
      )..where((t) => t.id.equals(widget.habitId))).write(
        HabitsCompanion(
          title: Value(newTitle),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // Sync will happen automatically on next auth state change
      // or you can manually trigger it if needed

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Habit updated ✅')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to save changes. Please try again.';
        _saving = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Habit'),
        actions: [
          if (!_loading)
            TextButton(
              onPressed: _saving ? null : _saveChanges,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Save',
                      style: TextStyle(
                        color: HabitBucketColors.mainPurple,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title field
                    Text(
                      'Habit Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    8.spaceH,
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Morning exercise',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,
                    ),

                    24.spaceH,

                    // Frequency (read-only)
                    Text(
                      'Frequency',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    8.spaceH,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _frequency != null
                                ? getHabitFrequencyEnum(
                                    habitFrequency: _frequency!,
                                  ).name.toUpperCase()
                                : 'Unknown',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Cannot be changed',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.4),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_error != null) ...[
                      16.spaceH,
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
