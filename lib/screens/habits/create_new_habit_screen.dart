import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habit_bucket/enums/habit_frequency_enum.dart';
import 'package:habit_bucket/utils/colors.dart';
import 'package:habit_bucket/utils/spacing.dart';
import 'package:habit_bucket/widgets/app_button.dart';
import 'package:habit_bucket/widgets/app_input.dart';

class CreateNewHabitScreen extends StatefulWidget {
  final HabitFrequency currentSectionSelected;

  const CreateNewHabitScreen({super.key, required this.currentSectionSelected});

  @override
  State<CreateNewHabitScreen> createState() => _CreateNewHabitScreenState();
}

class _CreateNewHabitScreenState extends State<CreateNewHabitScreen>
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
        color: HabitBucketColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HabitBucketColors.mediumGray),
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
              color: isSelected ? Colors.white : HabitBucketColors.black,
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
          color: HabitBucketColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: HabitBucketColors.mediumGray),
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
              style: TextStyle(fontSize: 16, color: HabitBucketColors.black),
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
              color: HabitBucketColors.mediumGray,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildDaySelector() {
  //   List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Select day',
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w600,
  //           color: HabitBucketColors.black,
  //         ),
  //       ),
  //       12.spaceH,
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: List.generate(7, (index) {
  //           int dayValue = index + 1;
  //           // bool isSelected = _selectedDays.contains(dayValue);
  //           bool isSelected = _selectedDay == dayValue;

  //           return GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 // if (isSelected) {
  //                 //   _selectedDays.remove(dayValue);
  //                 // } else {
  //                 //   _selectedDays.add(dayValue);
  //                 // }

  //                 // if (_selectedDays.isEmpty) {
  //                 //   _selectedDays.add(dayValue);
  //                 // } else {
  //                 //   _selectedDays.clear();
  //                 //   _selectedDays.add(dayValue);
  //                 // }

  //                 _selectedDay = dayValue;
  //               });
  //             },
  //             child: AnimatedContainer(
  //               duration: Duration(milliseconds: 200),
  //               width: 40,
  //               height: 40,
  //               decoration: BoxDecoration(
  //                 color: isSelected
  //                     ? HabitBucketColors.mainPurple
  //                     : HabitBucketColors.white,
  //                 borderRadius: BorderRadius.circular(20),
  //                 border: Border.all(
  //                   color: isSelected
  //                       ? HabitBucketColors.mainPurple
  //                       : HabitBucketColors.mediumGray,
  //                 ),
  //               ),
  //               child: Center(
  //                 child: Text(
  //                   weekdays[index],
  //                   style: TextStyle(
  //                     color: isSelected
  //                         ? Colors.white
  //                         : HabitBucketColors.black,
  //                     fontWeight: FontWeight.w500,
  //                     fontSize: 12,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           );
  //         }),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildWeekdaySelector() {
  //   List<String> weekdays = [
  //     'Every Monday',
  //     'Every Tuesday',
  //     'Every Wednesday',
  //     'Every Thursday',
  //     'Every Friday',
  //     'Every Saturday',
  //     'Every Sunday',
  //   ];

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Select weekday',
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w600,
  //           color: HabitBucketColors.black,
  //         ),
  //       ),
  //       12.spaceH,
  //       Container(
  //         decoration: BoxDecoration(
  //           color: HabitBucketColors.white,
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(color: HabitBucketColors.mediumGray),
  //         ),
  //         child: Column(
  //           children: List.generate(weekdays.length, (index) {
  //             int dayValue = index + 1;
  //             bool isSelected = _selectedWeekday == dayValue;

  //             return GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   _selectedWeekday = dayValue;
  //                 });
  //               },
  //               child: AnimatedContainer(
  //                 duration: Duration(milliseconds: 200),
  //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //                 decoration: BoxDecoration(
  //                   color: isSelected
  //                       ? HabitBucketColors.mainPurple
  //                       : Colors.transparent,
  //                   borderRadius: index == 0
  //                       ? BorderRadius.only(
  //                           topLeft: Radius.circular(12),
  //                           topRight: Radius.circular(12),
  //                         )
  //                       : index == weekdays.length - 1
  //                       ? BorderRadius.only(
  //                           bottomLeft: Radius.circular(12),
  //                           bottomRight: Radius.circular(12),
  //                         )
  //                       : BorderRadius.zero,
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Text(
  //                       weekdays[index],
  //                       style: TextStyle(
  //                         color: isSelected
  //                             ? HabitBucketColors.white
  //                             : HabitBucketColors.black,
  //                         fontWeight: isSelected
  //                             ? FontWeight.w600
  //                             : FontWeight.w500,
  //                       ),
  //                     ),
  //                     Spacer(),
  //                     if (isSelected)
  //                       FaIcon(
  //                         FontAwesomeIcons.check,
  //                         color: HabitBucketColors.mainPurple,
  //                         size: 16,
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           }),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildSelectionContent() {
    switch (_selectedFrequency) {
      case HabitFrequency.daily:
        return _buildTimeSelector();
      // case HabitFrequency.weekly:
      //   return Column(
      //     children: [_buildDaySelector(), 20.spaceH, _buildTimeSelector()],
      //   );
      // case HabitFrequency.monthly:
      //   return Column(
      //     children: [_buildWeekdaySelector(), 20.spaceH, _buildTimeSelector()],
      //   );
      case HabitFrequency.weekly:
        return SizedBox();
      case HabitFrequency.monthly:
        return SizedBox();
    }
  }

  // Add this method to handle habit creation
  Future<void> _createHabit() async {
    // Validate the form
    if (_habitNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a habit name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() {
      _isCreatingHabit = true;
    });
    try {
      // Simulate API call or database operation
      await Future.delayed(Duration(seconds: 2));
      
      // TODO: Add your actual habit creation logic here
      // await HabitService.createHabit(
      //   name: _habitNameController.text.trim(),
      //   frequency: _selectedFrequency,
      //   hasRandomReminder: _isRandomReminderSelected,
      //   // Add other fields as needed
      // );
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Habit created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate back or to habits list
      Navigator.pop(context);
      
    } catch (error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create habit: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingHabit = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HabitBucketColors.lightGray,
      body: Hero(
        tag: "new-habit-fab",
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: HabitBucketColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: HabitBucketColors.mediumGray,
                          ),
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          size: 16,
                          color: HabitBucketColors.black,
                        ),
                      ),
                    ),
                    16.spaceW,
                    Text(
                      'Create New Habit',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: HabitBucketColors.black,
                      ),
                    ),
                  ],
                ),
              ), // 24.spaceH,
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      // FrequencySelector(
                      //   selected: _selectedFrequency,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _selectedFrequency = value;
                      //     });
                      //   },
                      // ),
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

                      //                 Row(
                      //                   children: [
                      //                     Expanded(
                      //                       child: Column(
                      //                         crossAxisAlignment: CrossAxisAlignment.start,
                      //                         mainAxisSize: MainAxisSize.min,
                      //                         children: [
                      //                           Text(
                      //                             "Random",
                      //                             style: TextStyle(
                      //                               fontSize: 16,
                      //                               fontWeight: FontWeight.w500,
                      //                               // fontFamily: 'Manrope',
                      //                             ),
                      //                           ),
                      //                           2.spaceH,
                      //                           Text(
                      //                             "Send you a reminder notification at a random time during the day/week/month.",
                      //                             style: TextStyle(
                      //                               fontSize: 12,
                      //                               fontWeight: FontWeight.w500,
                      //                               fontFamily: 'Manrope',
                      //                               color: Colors.grey[700],
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),
                      // 8.spaceW,
                      //                     Switch.adaptive(
                      //                       value: _isRandomReminderSelected,
                      //                       onChanged: (val) {},
                      //                     ),
                      //                   ],
                      //                 ),
                      if (_selectedFrequency == HabitFrequency.daily) ...[
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: HabitBucketColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: HabitBucketColors.mediumGray,
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
                                        color: HabitBucketColors.black,
                                      ),
                                    ),
                                    2.spaceH,
                                    Text(
                                      'Get reminded at a random time during the day',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: HabitBucketColors.mediumGray,
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
                                            opacity: _frequencyOpacityAnimation
                                                .value,
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
                      ] else ...[
                        Text(
                          '${_selectedFrequency == HabitFrequency.weekly ? 'Weekly' : ''}${_selectedFrequency == HabitFrequency.monthly ? 'Monthly' : ''} reminders coming soon...\nBut you can create your habit',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: HabitBucketColors.mediumGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      40.spaceH,
                    ],
                  ),
                ),
              ),

              Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  16.spaceH, // Add some spacing before the button
                  AppButton(
                    label: "Create Habit",
                    onPressed: _createHabit,
                    isLoading: _isCreatingHabit,
                  ),
                  // Optional: Add a cancel button
                  // 8.spaceH,
                  // AppButton(
                  //   label: "Cancel",
                  //   onPressed: _isCreatingHabit ? null : () => Navigator.pop(context),
                  //   isOutlined: true,
                  // ),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
