// import 'package:flutter/material.dart';

// class CheckOffButton extends StatelessWidget {
//   final bool isChecked;
//   final VoidCallback onTap;

//   const CheckOffButton({
//     super.key,
//     required this.isChecked,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         width: 32,
//         height: 32,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: isChecked
//               ? Theme.of(context).colorScheme.primary
//               : Colors.transparent,
//           border: Border.all(
//             color: isChecked
//                 ? Theme.of(context).colorScheme.primary
//                 : Colors.grey.shade400,
//             width: 2,
//           ),
//         ),
//         child: isChecked
//             ? const Icon(Icons.check, size: 18, color: Colors.white)
//             : null,
//       ),
//     );
//   }
// }











// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class CheckOffButton extends StatefulWidget {
//   final bool isChecked;
//   final VoidCallback onTap;
//   final Color? primaryColor;
//   final Color? uncheckedColor;

//   const CheckOffButton({
//     super.key,
//     required this.isChecked,
//     required this.onTap,
//     this.primaryColor,
//     this.uncheckedColor,
//   });

//   @override
//   State<CheckOffButton> createState() => _CheckOffButtonState();
// }

// class _CheckOffButtonState extends State<CheckOffButton>
//     with TickerProviderStateMixin {
//   late AnimationController _scaleController;
//   late AnimationController _checkController;
//   late AnimationController _rippleController;
//   late AnimationController _particleController;

//   late Animation<double> _scaleAnimation;
//   late Animation<double> _checkAnimation;
//   late Animation<double> _rippleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );

//     _checkController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _rippleController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _particleController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );

//     // Bounce scale animation
//     _scaleAnimation = TweenSequence<double>([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 40),
//       TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.9), weight: 30),
//       TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
//     ]).animate(CurvedAnimation(
//       parent: _scaleController,
//       curve: Curves.elasticOut,
//     ));

//     // Check icon draw animation
//     _checkAnimation = CurvedAnimation(
//       parent: _checkController,
//       curve: Curves.elasticOut,
//     );

//     // Ripple effect animation
//     _rippleAnimation = CurvedAnimation(
//       parent: _rippleController,
//       curve: Curves.easeOut,
//     );

//     if (widget.isChecked) {
//       _scaleController.value = 1.0;
//       _checkController.value = 1.0;
//     }
//   }

//   @override
//   void didUpdateWidget(CheckOffButton oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (widget.isChecked && !oldWidget.isChecked) {
//       // Animate to checked state
//       _scaleController.forward(from: 0);
//       _checkController.forward(from: 0);
//       _rippleController.forward(from: 0);
//       _particleController.forward(from: 0);
//     } else if (!widget.isChecked && oldWidget.isChecked) {
//       // Animate to unchecked state
//       _checkController.reverse();
//       _scaleController.reverse();
//     }
//   }

//   @override
//   void dispose() {
//     _scaleController.dispose();
//     _checkController.dispose();
//     _rippleController.dispose();
//     _particleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor =
//         widget.primaryColor ?? Theme.of(context).colorScheme.primary;
//     final uncheckedColor = widget.uncheckedColor ?? Colors.grey.shade400;

//     return GestureDetector(
//       onTap: widget.onTap,
//       child: SizedBox(
//         width: 48,
//         height: 48,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Ripple effect
//             if (widget.isChecked)
//               AnimatedBuilder(
//                 animation: _rippleAnimation,
//                 builder: (context, child) {
//                   return Container(
//                     width: 48 * (1 + _rippleAnimation.value * 0.5),
//                     height: 48 * (1 + _rippleAnimation.value * 0.5),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: primaryColor.withOpacity(
//                         0.3 * (1 - _rippleAnimation.value),
//                       ),
//                     ),
//                   );
//                 },
//               ),

//             // Particles
//             if (widget.isChecked)
//               AnimatedBuilder(
//                 animation: _particleController,
//                 builder: (context, child) {
//                   return Stack(
//                     children: List.generate(8, (index) {
//                       final angle = (index * math.pi * 2) / 8;
//                       final distance = 20 * _particleController.value;
//                       return Transform.translate(
//                         offset: Offset(
//                           math.cos(angle) * distance,
//                           math.sin(angle) * distance,
//                         ),
//                         child: Opacity(
//                           opacity: 1 - _particleController.value,
//                           child: Container(
//                             width: 4,
//                             height: 4,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: primaryColor,
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   );
//                 },
//               ),

//             // Main button
//             AnimatedBuilder(
//               animation: _scaleAnimation,
//               builder: (context, child) {
//                 return Transform.scale(
//                   scale: _scaleAnimation.value,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: widget.isChecked ? primaryColor : Colors.transparent,
//                       border: Border.all(
//                         color: widget.isChecked ? primaryColor : uncheckedColor,
//                         width: 2.5,
//                       ),
//                       boxShadow: widget.isChecked
//                           ? [
//                               BoxShadow(
//                                 color: primaryColor.withOpacity(0.4),
//                                 blurRadius: 8,
//                                 spreadRadius: 1,
//                               ),
//                             ]
//                           : null,
//                     ),
//                     child: AnimatedBuilder(
//                       animation: _checkAnimation,
//                       builder: (context, child) {
//                         return Transform.scale(
//                           scale: _checkAnimation.value,
//                           child: Transform.rotate(
//                             angle: _checkAnimation.value * math.pi * 2,
//                             child: widget.isChecked
//                                 ? const Icon(
//                                     Icons.check,
//                                     size: 20,
//                                     color: Colors.white,
//                                   )
//                                 : null,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


















// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class CheckOffButton extends StatefulWidget {
//   final bool isChecked;
//   final VoidCallback onTap;
//   final Color? primaryColor;
//   final Color? uncheckedColor;

//   const CheckOffButton({
//     super.key,
//     required this.isChecked,
//     required this.onTap,
//     this.primaryColor,
//     this.uncheckedColor,
//   });

//   @override
//   State<CheckOffButton> createState() => _CheckOffButtonState();
// }

// class _CheckOffButtonState extends State<CheckOffButton>
//     with TickerProviderStateMixin {
//   late AnimationController _scaleController;
//   late AnimationController _checkController;
//   late AnimationController _rippleController;
//   late AnimationController _particleController;

//   late Animation<double> _scaleAnimation;
//   late Animation<double> _checkAnimation;
//   late Animation<double> _rippleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 400),
//       vsync: this,
//     );

//     _checkController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _rippleController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _particleController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );

//     // Bounce scale animation
//     _scaleAnimation = TweenSequence<double>([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 40),
//       TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.9), weight: 30),
//       TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
//     ]).animate(CurvedAnimation(
//       parent: _scaleController,
//       curve: Curves.elasticOut,
//     ));

//     // Check icon draw animation
//     _checkAnimation = CurvedAnimation(
//       parent: _checkController,
//       curve: Curves.elasticOut,
//     );

//     // Ripple effect animation
//     _rippleAnimation = CurvedAnimation(
//       parent: _rippleController,
//       curve: Curves.easeOut,
//     );

//     // Set initial state without triggering animations
//     if (widget.isChecked) {
//       _scaleController.value = 1.0;
//       _checkController.value = 1.0;
//       _rippleController.value = 1.0;
//       _particleController.value = 1.0;
//     }
//   }

//   @override
//   void didUpdateWidget(CheckOffButton oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (widget.isChecked && !oldWidget.isChecked) {
//       // Animate to checked state
//       _scaleController.forward(from: 0);
//       _checkController.forward(from: 0);
//       _rippleController.forward(from: 0);
//       _particleController.forward(from: 0);
//     } else if (!widget.isChecked && oldWidget.isChecked) {
//       // Reset to unchecked state instantly
//       _scaleController.value = 0;
//       _checkController.value = 0;
//       _rippleController.value = 0;
//       _particleController.value = 0;
//     }
//   }

//   @override
//   void dispose() {
//     _scaleController.dispose();
//     _checkController.dispose();
//     _rippleController.dispose();
//     _particleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor =
//         widget.primaryColor ?? Theme.of(context).colorScheme.primary;
//     final uncheckedColor = widget.uncheckedColor ?? Colors.grey.shade400;

//     return GestureDetector(
//       onTap: widget.onTap,
//       child: SizedBox(
//         width: 48,
//         height: 48,
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Ripple effect
//             if (widget.isChecked)
//               AnimatedBuilder(
//                 animation: _rippleAnimation,
//                 builder: (context, child) {
//                   return Container(
//                     width: 48 * (1 + _rippleAnimation.value * 0.5),
//                     height: 48 * (1 + _rippleAnimation.value * 0.5),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: primaryColor.withOpacity(
//                         0.3 * (1 - _rippleAnimation.value),
//                       ),
//                     ),
//                   );
//                 },
//               ),

//             // Particles
//             if (widget.isChecked)
//               AnimatedBuilder(
//                 animation: _particleController,
//                 builder: (context, child) {
//                   return Stack(
//                     children: List.generate(8, (index) {
//                       final angle = (index * math.pi * 2) / 8;
//                       final distance = 20 * _particleController.value;
//                       return Transform.translate(
//                         offset: Offset(
//                           math.cos(angle) * distance,
//                           math.sin(angle) * distance,
//                         ),
//                         child: Opacity(
//                           opacity: 1 - _particleController.value,
//                           child: Container(
//                             width: 4,
//                             height: 4,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: primaryColor,
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   );
//                 },
//               ),

//             // Main button
//             AnimatedBuilder(
//               animation: _scaleController,
//               builder: (context, child) {
//                 // Clamp the scale value to prevent errors
//                 final scale = widget.isChecked 
//                     ? (_scaleController.isAnimating 
//                         ? _scaleAnimation.value 
//                         : 1.0)
//                     : 1.0;
                    
//                 return Transform.scale(
//                   scale: scale,
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     width: 32,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: widget.isChecked ? primaryColor : Colors.transparent,
//                       border: Border.all(
//                         color: widget.isChecked ? primaryColor : uncheckedColor,
//                         width: 2.5,
//                       ),
//                       boxShadow: widget.isChecked
//                           ? [
//                               BoxShadow(
//                                 color: primaryColor.withOpacity(0.4),
//                                 blurRadius: 8,
//                                 spreadRadius: 1,
//                               ),
//                             ]
//                           : null,
//                     ),
//                     child: AnimatedBuilder(
//                       animation: _checkAnimation,
//                       builder: (context, child) {
//                         return Transform.scale(
//                           scale: _checkAnimation.value,
//                           child: Transform.rotate(
//                             angle: _checkAnimation.value * math.pi * 2,
//                             child: widget.isChecked
//                                 ? const Icon(
//                                     Icons.check,
//                                     size: 20,
//                                     color: Colors.white,
//                                   )
//                                 : null,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

























import 'package:flutter/material.dart';
import 'package:habit_bucket/utils/colors.dart';
import 'dart:math' as math;

import 'package:habit_bucket/utils/opacity.dart';

class CheckOffButton extends StatefulWidget {
  final bool isChecked;
  final VoidCallback onTap;
  final Color? primaryColor;
  final Color? uncheckedColor;

  const CheckOffButton({
    super.key,
    required this.isChecked,
    required this.onTap,
    this.primaryColor,
    this.uncheckedColor,
  });

  @override
  State<CheckOffButton> createState() => _CheckOffButtonState();
}

class _CheckOffButtonState extends State<CheckOffButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _checkController;
  late AnimationController _rippleController;
  late AnimationController _particleController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _checkController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Bounce scale animation - NO CurvedAnimation wrapper!
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 0.9)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.9, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_scaleController); // Direct animation, no CurvedAnimation

    // Check icon draw animation
    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );

    // Ripple effect animation
    _rippleAnimation = CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    );

    // Set initial state without triggering animations
    if (widget.isChecked) {
      _scaleController.value = 1.0;
      _checkController.value = 1.0;
      _rippleController.value = 1.0;
      _particleController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CheckOffButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isChecked && !oldWidget.isChecked) {
      // Animate to checked state
      _scaleController.forward(from: 0);
      _checkController.forward(from: 0);
      _rippleController.forward(from: 0);
      _particleController.forward(from: 0);
    } else if (!widget.isChecked && oldWidget.isChecked) {
      // Reset to unchecked state instantly
      _scaleController.value = 0;
      _checkController.value = 0;
      _rippleController.value = 0;
      _particleController.value = 0;
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _checkController.dispose();
    _rippleController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        widget.primaryColor ?? HabitBucketColors.mainPurple;
    final uncheckedColor = widget.uncheckedColor ?? HabitBucketColors.mediumGray;

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ripple effect
            if (widget.isChecked)
              AnimatedBuilder(
                animation: _rippleAnimation,
                builder: (context, child) {
                  return Container(
                    width: 48 * (1 + _rippleAnimation.value * 0.5),
                    height: 48 * (1 + _rippleAnimation.value * 0.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withOpacityFactor(
                        0.3 * (1 - _rippleAnimation.value),
                      ),
                    ),
                  );
                },
              ),

            // Particles
            if (widget.isChecked)
              AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  return Stack(
                    children: List.generate(8, (index) {
                      final angle = (index * math.pi * 2) / 8;
                      final distance = 20 * _particleController.value;
                      return Transform.translate(
                        offset: Offset(
                          math.cos(angle) * distance,
                          math.sin(angle) * distance,
                        ),
                        child: Opacity(
                          opacity: 1 - _particleController.value,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),

            // Main button
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isChecked ? primaryColor : Colors.transparent,
                      border: Border.all(
                        color: widget.isChecked ? primaryColor : uncheckedColor,
                        width: 2.5,
                      ),
                      boxShadow: widget.isChecked
                          ? [
                              BoxShadow(
                                color: primaryColor.withOpacityFactor(0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: AnimatedBuilder(
                      animation: _checkAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _checkAnimation.value,
                          child: Transform.rotate(
                            angle: _checkAnimation.value * math.pi * 2,
                            child: widget.isChecked
                                ? const Icon(
                                    Icons.check,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
