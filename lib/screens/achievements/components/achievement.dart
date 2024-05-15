import 'package:flutter/material.dart';
import 'package:shop_app/models/Achievement.dart';
import 'package:shop_app/screens/details/components/achievement_description.dart';
import 'package:shop_app/screens/details/components/achievement_images.dart';
import 'package:shop_app/screens/details/components/top_rounded_container.dart';

class AchievementComponent extends StatelessWidget {
  static String routeName = "/achievement_details";

  const AchievementComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final AchievementDetailsArguments agrs =
        ModalRoute.of(context)!.settings.arguments as AchievementDetailsArguments;
    final achievement = agrs.achievement;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          AchievementImages(achievement: achievement),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                AchievementDescription(
                  achievement: achievement,
                  pressOnSeeMore: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TopRoundedContainer(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back to Achievements"),
            ),
          ),
        ),
      ),
    );
  }
}

class AchievementDetailsArguments {
  final Achievement achievement;

  AchievementDetailsArguments({required this.achievement});
}
