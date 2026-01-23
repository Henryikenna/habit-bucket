import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habit_bucket/core/enums/habit_frequency_enum.dart';
import 'package:habit_bucket/utils/capitalize_extension.dart';
import 'package:habit_bucket/utils/colors.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';
import 'package:habit_bucket/widgets/check_off_button.dart';

class HabitWidget extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onToggle;
  final bool isStreakActivated;
  final String title;
  final HabitFrequency habitFrequency;
  final int streakCount;
  // final VoidCallback? onMenuTap;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const HabitWidget({
    super.key,
    required this.isChecked,
    required this.isStreakActivated,
    required this.title,
    required this.habitFrequency,
    required this.onToggle,
    required this.streakCount,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        2.spaceH,
                      ],
                    ),

                    CheckOffButton(isChecked: isChecked, onTap: onToggle),
                  ],
                ),
              ),
              12.spaceH,
              Row(
                children: [
                  Container(
                    height: 28,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.transparent,
                    ),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.bolt,
                          size: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacityFactor(.5),
                        ),
                        6.spaceW,
                        Text(
                          "${habitFrequency.name.capitalize()} Habit",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacityFactor(.5),
                          ),
                        ),
                      ],
                    ),
                  ),

                  8.spaceW,

                  Container(
                    height: 28,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isStreakActivated
                            ? HabitBucketColors.pink
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacityFactor(.2),
                      ),
                      borderRadius: BorderRadius.circular(40),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.fireFlameCurved,
                          size: 12,
                          color: isStreakActivated
                              ? HabitBucketColors.pink
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacityFactor(.2),
                        ),
                        6.spaceW,
                        Text(
                          streakCount.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: isStreakActivated
                                ? HabitBucketColors.pink
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacityFactor(.2),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // if (onMenuTap != null) ...[
                  8.spaceW,
                  PopupMenuButton(
                    // onTap: onMenuTap,
                    elevation: 0,
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          onTap: onEditTap,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit),
                              8.spaceW,
                              Text("Edit"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: onDeleteTap,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              8.spaceW,
                              Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.ellipsisVertical,
                          size: 14,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacityFactor(.5),
                        ),
                      ),
                    ),
                  ),
                ],
                // ],
              ),
            ],
          ),
        ),

        Positioned(
          bottom: 45,
          child: CustomPaint(
            painter: _HookPainter(
              leftPadding: 16 + 2,
              topHeight: 0,
              spacing: 32,
              bottomHeight: 0,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacityFactor(.3),
            ),
          ),
        ),
      ],
    );
  }
}

class _HookPainter extends CustomPainter {
  final double leftPadding;
  final double topHeight;
  final double spacing;
  final double bottomHeight;
  final Color color;
  _HookPainter({
    required this.leftPadding,
    required this.topHeight,
    required this.spacing,
    required this.bottomHeight,
    // ignore: unused_element_parameter
    this.color = Colors.black,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    // X coordinate where the hook is drawn
    final double x = leftPadding / 2;
    // Start at bottom of big top widget
    final double startY = topHeight;
    // End at center of smaller bottom widget
    final double endY = topHeight + spacing + bottomHeight / 2;
    // Control point to create a hook-like / half-circle curve
    final double midY = (startY + endY) / 2;
    final path = Path()
      ..moveTo(x, startY)
      // Quadratic curve from bottom of top to center of bottom
      ..quadraticBezierTo(
        x - 16, // pull left to create the hook
        midY,
        x,
        endY,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HookPainter oldDelegate) {
    return leftPadding != oldDelegate.leftPadding ||
        topHeight != oldDelegate.topHeight ||
        spacing != oldDelegate.spacing ||
        bottomHeight != oldDelegate.bottomHeight;
  }
}
