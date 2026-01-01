import 'package:flutter/material.dart';

class BottomNavWidgetModel {
  final String name;
  final Widget icon;
  final Widget widget;

  const BottomNavWidgetModel({
    required this.name,
    required this.icon,
    required this.widget,
  });
}
