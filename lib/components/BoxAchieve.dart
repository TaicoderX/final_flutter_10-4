import 'package:flutter/material.dart';
import 'package:shop_app/models/Achievement.dart';

import '../constants.dart';

class BoxAchieve extends StatelessWidget {
  final double width, aspectRetio;
  final Achievement achievement;
  final VoidCallback onPress;

  const BoxAchieve({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.achievement,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: aspectRetio,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: greyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.network(achievement.images[0]),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                achievement.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: mainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}