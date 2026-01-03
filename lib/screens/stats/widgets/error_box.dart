
import 'package:flutter/material.dart';
import 'package:habit_bucket/screens/stats/widgets/surface_card.dart';

class ErrorBox extends StatelessWidget {
  final String message;

  const ErrorBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12.5,
        ),
      ),
    );
  }
}
