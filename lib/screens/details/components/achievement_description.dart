import 'package:flutter/material.dart';
import 'package:shop_app/models/Achievement.dart';

class AchievementDescription extends StatelessWidget {
  const AchievementDescription({
    Key? key,
    required this.achievement,
    this.pressOnSeeMore,
  }) : super(key: key);

  final Achievement achievement;
  final GestureTapCallback? pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            achievement.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 64,
          ),
          child: Text(
            achievement.description,
            maxLines: 3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        )
      ],
    );
  }
}
