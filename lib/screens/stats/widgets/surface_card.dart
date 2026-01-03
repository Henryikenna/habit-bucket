
import 'package:flutter/material.dart';

class SurfaceCard extends StatelessWidget {
  final Widget child;

  const SurfaceCard({super.key, required this.child});
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: child,
    );
  }
}
