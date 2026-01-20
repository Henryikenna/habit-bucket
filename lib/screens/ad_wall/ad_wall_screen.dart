import 'package:flutter/material.dart';
import 'package:habit_bucket/widgets/banner_ad_widget.dart';

class AdWallScreen extends StatelessWidget {
  const AdWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: 10,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return BannerAdWidget();
          },
        ),
      ),
    );
  }
}
