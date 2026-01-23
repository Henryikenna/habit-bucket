import 'package:flutter/material.dart';
import 'package:habit_bucket/utils/opacity.dart';
import 'package:habit_bucket/utils/spacing.dart';
import 'package:habit_bucket/widgets/banner_ad_widget.dart';

class AdWallScreen extends StatelessWidget {
  const AdWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ad Wall",

          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            // color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: 11, // +1 for header
          padding: EdgeInsets.all(20),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildSupportHeader(context);
            }
            final adIndex = index - 1;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ad ${adIndex + 1}",

                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                3.spaceH,
                BannerAdWidget(),
              ],
            );
          },
          separatorBuilder: (context, index) => 8.spaceH,
        ),
      ),
    );
  }

  Widget _buildSupportHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: colorScheme.primary,
                size: 28,
              ),
              12.spaceW,
              Expanded(
                child: Text(
                  "Support the Dev",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          12.spaceH,
          Text(
            "Hey! I'm an indie developer working on this app in my spare time. "
            "If you're enjoying it, tapping an ad or two is a simple way to keep the lights on. "
            "No pressure — every little bit helps! ☕",
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: colorScheme.onPrimaryContainer.withOpacityFactor(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
