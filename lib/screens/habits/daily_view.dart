// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:habit_bucket/enums/habit_frequency_enum.dart';
// import 'package:habit_bucket/screens/habits/widgets/habit_widget.dart';
// import 'package:habit_bucket/utils/colors.dart';
// import 'package:habit_bucket/utils/spacing.dart';
// import 'package:habit_bucket/widgets/check_off_button.dart';

// class DailyView extends StatefulWidget {
//   final HabitFrequency frequency;
//   const DailyView({super.key, required this.frequency});

//   @override
//   State<DailyView> createState() => _DailyViewState();
// }

// class _DailyViewState extends State<DailyView> {
//   bool _isChecked = true;
//   final bool _isStreakActivated = true;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Daily Habits",
//             style: TextStyle(fontSize: 18, color:  Theme.of(context).colorScheme.onSurface),
//           ),
//           8.spaceH,

//           // Stack(
//           //   children: [
//           //     Padding(
//           //       padding: EdgeInsets.only(left: 10),
//           //       child: Column(
//           //         crossAxisAlignment: CrossAxisAlignment.start,
//           //         children: [
//           //           Container(
//           //             padding: EdgeInsets.symmetric(
//           //               horizontal: 12,
//           //               vertical: 16,
//           //             ),
//           //             decoration: BoxDecoration(
//           //               color: HabitBucketColors.white,
//           //               borderRadius: BorderRadius.circular(4),
//           //             ),
//           //             child: Row(
//           //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //               children: [
//           //                 Column(
//           //                   crossAxisAlignment: CrossAxisAlignment.start,
//           //                   children: [
//           //                     Text(
//           //                       "30 pushups a day\ndrink water daily\nvisit my babe",
//           //                       style: TextStyle(
//           //                         fontSize: 14,
//           //                         color:  Theme.of(context).colorScheme.onSurface,
//           //                       ),
//           //                     ),
//           //                     2.spaceH,
//           //                   ],
//           //                 ),

//           //                 CheckOffButton(
//           //                   isChecked: _isChecked,
//           //                   onTap: () {
//           //                     setState(() {
//           //                       _isChecked = !_isChecked;
//           //                     });
//           //                   },
//           //                 ),
//           //               ],
//           //             ),
//           //           ),
//           //           12.spaceH,
//           //           Row(
//           //             children: [
//           //               Container(
//           //                 height: 28,
//           //                 padding: EdgeInsets.symmetric(
//           //                   horizontal: 8,
//           //                   vertical: 4,
//           //                 ),
//           //                 decoration: BoxDecoration(
//           //                   border: Border.all(
//           //                     color: HabitBucketColors.mediumGray,
//           //                   ),
//           //                   borderRadius: BorderRadius.circular(40),
//           //                   color: HabitBucketColors.lightGray,
//           //                 ),
//           //                 child: Row(
//           //                   // crossAxisAlignment: CrossAxisAlignment.start,
//           //                   mainAxisSize: MainAxisSize.min,
//           //                   children: [
//           //                     FaIcon(
//           //                       FontAwesomeIcons.bolt,
//           //                       size: 12,
//           //                       color: HabitBucketColors.borderBlack,
//           //                     ),
//           //                     6.spaceW,
//           //                     Text(
//           //                       "Daily Habit",
//           //                       style: TextStyle(
//           //                         fontSize: 12,
//           //                         color: HabitBucketColors.borderBlack,
//           //                       ),
//           //                     ),
//           //                   ],
//           //                 ),
//           //               ),

//           //               8.spaceW,

//           //               Container(
//           //                 height: 28,
//           //                 padding: EdgeInsets.symmetric(
//           //                   horizontal: 8,
//           //                   vertical: 4,
//           //                 ),
//           //                 decoration: BoxDecoration(
//           //                   border: Border.all(
//           //                     color: _isStreakActivated
//           //                         ? HabitBucketColors.pink
//           //                         : HabitBucketColors.mediumGray,
//           //                   ),
//           //                   borderRadius: BorderRadius.circular(40),
//           //                   color: HabitBucketColors.lightGray,
//           //                 ),
//           //                 child: Row(
//           //                   // crossAxisAlignment: CrossAxisAlignment.start,
//           //                   mainAxisSize: MainAxisSize.min,
//           //                   children: [
//           //                     FaIcon(
//           //                       FontAwesomeIcons.fireFlameCurved,
//           //                       size: 12,
//           //                       color: _isStreakActivated
//           //                           ? HabitBucketColors.pink
//           //                           : HabitBucketColors.mediumGray,
//           //                     ),
//           //                     6.spaceW,
//           //                     Text(
//           //                       "4",
//           //                       style: TextStyle(
//           //                         fontSize: 12,
//           //                         color: _isStreakActivated
//           //                             ? HabitBucketColors.pink
//           //                             : HabitBucketColors.mediumGray,
//           //                       ),
//           //                     ),
//           //                   ],
//           //                 ),
//           //               ),
//           //             ],
//           //           ),
//           //         ],
//           //       ),
//           //     ),

//           //     Positioned(
//           //       bottom: 45,
//           //       child: CustomPaint(
//           //         painter: _HookPainter(
//           //           leftPadding: 16 + 2,
//           //           topHeight: 0,
//           //           spacing: 32,
//           //           bottomHeight: 0,
//           //         ),
//           //       ),
//           //     ),
//           //   ],
//           // ),
//           HabitWidget(
//             isChecked: _isChecked,
//             isStreakActivated: _isStreakActivated,
//             title: "30 pushups a day\ndrink water daily\nvisit my babe",
//             habitFrequency: widget.frequency,
//           ),
//           16.spaceH,
//           HabitWidget(
//             isChecked: _isChecked,
//             isStreakActivated: _isStreakActivated,
//             title: "30 pushups a day\ndrink water daily\nvisit my babe",
//             habitFrequency: widget.frequency,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // class _HookPainter extends CustomPainter {
// //   final double leftPadding;
// //   final double topHeight;
// //   final double spacing;
// //   final double bottomHeight;
// //   final Color color;
// //   _HookPainter({
// //     required this.leftPadding,
// //     required this.topHeight,
// //     required this.spacing,
// //     required this.bottomHeight,
// //     // ignore: unused_element_parameter
// //     this.color = Colors.black,
// //   });
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     final paint = Paint()
// //       ..color = color
// //       ..style = PaintingStyle.stroke
// //       ..strokeWidth = 2
// //       ..strokeCap = StrokeCap.round;
// //     // X coordinate where the hook is drawn
// //     final double x = leftPadding / 2;
// //     // Start at bottom of big top widget
// //     final double startY = topHeight;
// //     // End at center of smaller bottom widget
// //     final double endY = topHeight + spacing + bottomHeight / 2;
// //     // Control point to create a hook-like / half-circle curve
// //     final double midY = (startY + endY) / 2;
// //     final path = Path()
// //       ..moveTo(x, startY)
// //       // Quadratic curve from bottom of top to center of bottom
// //       ..quadraticBezierTo(
// //         x - 16, // pull left to create the hook
// //         midY,
// //         x,
// //         endY,
// //       );
// //     canvas.drawPath(path, paint);
// //   }

// //   @override
// //   bool shouldRepaint(covariant _HookPainter oldDelegate) {
// //     return leftPadding != oldDelegate.leftPadding ||
// //         topHeight != oldDelegate.topHeight ||
// //         spacing != oldDelegate.spacing ||
// //         bottomHeight != oldDelegate.bottomHeight;
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habit_bucket/enums/habit_frequency_enum.dart';
import 'package:habit_bucket/models/habit_model.dart';
import 'package:habit_bucket/screens/habits/widgets/habit_widget.dart';
import 'package:habit_bucket/utils/colors.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';

List<HabitModel> habitList = [
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
  HabitModel(
    title: "30 pushups a day\ndrink water daily\nvisit my babe",
    habitFrequency: HabitFrequency.daily,
  ),
];

class DailyView extends StatefulWidget {
  final HabitFrequency frequency;
  const DailyView({super.key, required this.frequency});

  @override
  State<DailyView> createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
  final bool _isChecked = true;
  final bool _isStreakActivated = true;

  @override
  Widget build(BuildContext context) {
    return habitList.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.seedling, size: 48, color: Colors.grey),
                16.spaceH,
                Text("No daily habits yet", style: TextStyle(fontSize: 16)),
                8.spaceH,
                Text(
                  "Tap + to create your first habit!",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Daily Habits",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),

                      // Text(
                      //   "${habitList.length}/10",
                      //   style: TextStyle(
                      // fontSize: 14,
                      // color:  Theme.of(context).colorScheme.onSurface,
                      //   ),
                      // ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color:  Theme.of(context).colorScheme.onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: "${habitList.length}",
                              style: TextStyle(
                                fontSize: 14,
                                color:  Theme.of(context).colorScheme.onSurface
                                .withOpacityFactor(.95),
                              ),
                            ),
                            const TextSpan(text: "/"),
                             TextSpan(
                              text: "10",
                              style: TextStyle(
                                fontSize: 14,
                                color:  Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                8.spaceH,

                Expanded(
                  child: ListView.separated(
                    // shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      return HabitWidget(
                        isChecked: _isChecked,
                        isStreakActivated: _isStreakActivated,
                        title: habitList[index].title,
                        habitFrequency: habitList[index].habitFrequency,
                      );
                    },
                    separatorBuilder: (context, index) => 16.spaceH,
                    itemCount: habitList.length,
                  ),
                ),
              ],
            ),
          );
  }
}
