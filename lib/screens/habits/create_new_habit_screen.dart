import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habit_bucket/core/enums/habit_frequency_enum.dart';
import 'package:habit_bucket/providers/notification_providers.dart';
import 'package:habit_bucket/providers/providers.dart';
import 'package:habit_bucket/utils/colors.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';
import 'package:habit_bucket/widgets/app_button.dart';
import 'package:habit_bucket/widgets/app_input.dart';

class CreateNewHabitScreen extends ConsumerStatefulWidget {
  final HabitFrequency currentSectionSelected;

  const CreateNewHabitScreen({super.key, required this.currentSectionSelected});

  @override
  ConsumerState<CreateNewHabitScreen> createState() =>
      _CreateNewHabitScreenState();
}

class _CreateNewHabitScreenState extends ConsumerState<CreateNewHabitScreen>
    with TickerProviderStateMixin {
  final TextEditingController _habitNameController = TextEditingController();

  // String _selectedFrequency = '';

  // final bool _isRandomReminderSelected = true;

  bool _randomReminders = true;
  HabitFrequency _selectedFrequency = HabitFrequency.daily;
  TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 0);
  int _selectedWeekday = 1; // 1 = Monday
  // List<int> _selectedDays = [1]; // For weekly selection
  int _selectedDay = 1; // For weekly selection

  // Animation controllers
  late AnimationController _reminderAnimationController;
  late AnimationController _frequencyAnimationController;

  // Animations
  late Animation<double> _reminderHeightAnimation;
  late Animation<double> _frequencyOpacityAnimation;

  bool _isCreatingHabit = false;

  @override
  void initState() {
    super.initState();

    _selectedFrequency = widget.currentSectionSelected;

    _reminderAnimationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _frequencyAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _reminderHeightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _reminderAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _frequencyOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _frequencyAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start with reminders expanded if not random
    if (!_randomReminders) {
      _reminderAnimationController.forward();
      _frequencyAnimationController.forward();
    }
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    _reminderAnimationController.dispose();
    _frequencyAnimationController.dispose();
    super.dispose();
  }

  void _toggleRandomReminders(bool value) {
    setState(() {
      _randomReminders = value;
    });

    if (value) {
      _reminderAnimationController.reverse();
      _frequencyAnimationController.reverse();
    } else {
      _reminderAnimationController.forward();
      _frequencyAnimationController.forward();
    }
  }

  void _selectTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: HabitBucketColors.mainPurple,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _selectFrequency(HabitFrequency frequency) {
    setState(() {
      _selectedFrequency = frequency;
    });

    // Reset selections when frequency changes
    if (frequency == HabitFrequency.daily) {
      // _selectedDays = [];
      _selectedDay = 1;
    } else if (frequency == HabitFrequency.weekly) {
      // _selectedDays = [1]; // Default to Monday
      _selectedDay = 1;
    } else if (frequency == HabitFrequency.monthly) {
      _selectedWeekday = 1; // Default to Monday
    }
  }

  Widget _buildFrequencySelector() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        children: [
          _buildFrequencyOption('Daily', HabitFrequency.daily),
          _buildFrequencyOption('Weekly', HabitFrequency.weekly),
          _buildFrequencyOption('Monthly', HabitFrequency.monthly),
        ],
      ),
    );
  }

  Widget _buildFrequencyOption(String label, HabitFrequency frequency) {
    bool isSelected = _selectedFrequency == frequency;
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectFrequency(frequency),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? HabitBucketColors.mainPurple
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return GestureDetector(
      onTap: _selectTime,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.clock,
              color: HabitBucketColors.mainPurple,
              size: 20,
            ),
            12.spaceW,
            Text(
              'Reminder time',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Spacer(),
            Text(
              _selectedTime.format(context),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: HabitBucketColors.mainPurple,
              ),
            ),
            8.spaceW,
            FaIcon(
              FontAwesomeIcons.chevronRight,
              color: Theme.of(context).colorScheme.outline,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionContent() {
    switch (_selectedFrequency) {
      case HabitFrequency.daily:
        return _buildTimeSelector();
      case HabitFrequency.weekly:
        return SizedBox();
      case HabitFrequency.monthly:
        return SizedBox();
    }
  }

  Future<void> _createHabit() async {
    final title = _habitNameController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit name')),
      );
      return;
    }

    setState(() => _isCreatingHabit = true);

    try {
      final freqStr = switch (_selectedFrequency) {
        HabitFrequency.daily => 'daily',
        HabitFrequency.weekly => 'weekly',
        HabitFrequency.monthly => 'monthly',
      };

      // Check if limit reached
      final currentCount = await ref
          .read(localHabitRepoProvider)
          .countActiveHabitsByFrequency(freqStr);
      if (currentCount >= 10) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'You can only have 10 $freqStr habits. Delete one to add more.',
              ),
            ),
          );
          setState(() => _isCreatingHabit = false);
        }
        return;
      }

      // Reminder rules
      final reminderEnabled =
          true; // you don’t currently have a disable toggle in UI
      final reminderRandom = (_selectedFrequency == HabitFrequency.daily)
          ? _randomReminders
          : false; // weekly/monthly fixed time (for now)

      final reminderTimeMinutes = (reminderRandom || !reminderEnabled)
          ? null
          : (_selectedTime.hour * 60 + _selectedTime.minute);

      // Due day defaults (you can build UI for these next)
      final int? weeklyDay = _selectedFrequency == HabitFrequency.weekly
          ? 1 // Monday default (0=Sun..6=Sat in our schema, but your code uses 1=Mon)
          : null;

      final int? monthlyDay = _selectedFrequency == HabitFrequency.monthly
          ? 1
          : null;

      final id = await ref
          .read(localHabitRepoProvider)
          .createHabit(
            title: title,
            frequency: freqStr,
            weeklyDay: weeklyDay == null ? null : _toSundayBased(weeklyDay),
            monthlyDay: monthlyDay,
            reminderEnabled: reminderEnabled,
            reminderRandom: reminderRandom,
            reminderTimeMinutes: reminderTimeMinutes,
          );

      final habit = await ref.read(localHabitRepoProvider).getHabitById(id);
      if (habit != null) {
        await ref.read(notificationServiceProvider).scheduleDailyHabit(habit);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create habit: $e')));
    } finally {
      if (mounted) setState(() => _isCreatingHabit = false);
    }
  }

  /// Your local state uses 1=Monday. DB uses 0=Sun..6=Sat.
  /// Convert 1..7 (Mon..Sun) to 0..6 (Sun..Sat)
  int _toSundayBased(int weekdayMonBased) {
    // weekdayMonBased: 1=Mon..7=Sun
    return weekdayMonBased % 7; // Sun->0, Mon->1, ... Sat->6
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Hero(
        tag: "new-habit-fab",
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    16.spaceW,
                    Expanded(
                      child: Text(
                        'Create New Habit',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                24.spaceH,
                Text(
                  "Habit name",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    // fontFamily: 'Manrope',
                  ),
                ),
                4.spaceH,
                AppInput(
                  controller: _habitNameController,
                  hintText: "Enter habit name",
                ),
                16.spaceH,
                Text(
                  "Frequency",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    // fontFamily: 'Manrope',
                  ),
                ),
                4.spaceH,
                _buildFrequencySelector(),
                16.spaceH,
                Text(
                  "Reminder",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    // fontFamily: 'Manrope',
                  ),
                ),
                8.spaceH,

                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.shuffle,
                        color: HabitBucketColors.mainPurple,
                        size: 20,
                      ),
                      12.spaceW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Random reminder',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            2.spaceH,
                            Text(
                              'Get reminded at a random time during the day',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacityFactor(0.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _randomReminders,
                        onChanged: _toggleRandomReminders,
                        activeThumbColor: HabitBucketColors.mainPurple,
                      ),
                    ],
                  ),
                ),

                // Animated Reminder Settings
                AnimatedBuilder(
                  animation: _reminderHeightAnimation,
                  builder: (context, child) {
                    return ClipRect(
                      child: Align(
                        alignment: Alignment.topCenter,
                        heightFactor: _reminderHeightAnimation.value,
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              20.spaceH,
                              AnimatedBuilder(
                                animation: _frequencyOpacityAnimation,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _frequencyOpacityAnimation.value,
                                    child: _buildSelectionContent(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                40.spaceH,
                AppButton(
                  label: "Create Habit",
                  onPressed: _createHabit,
                  isLoading: _isCreatingHabit,
                ),
                16.spaceH,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
