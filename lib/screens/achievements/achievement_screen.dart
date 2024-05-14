import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shop_app/components/achivement_card.dart';
import 'package:shop_app/controllers/bookmarkVocab.dart';
import 'package:shop_app/models/Achievement.dart';
import 'package:shop_app/screens/achievements/components/achievement.dart';

import '../../controllers/achievement.dart';

class AchievementScreen extends StatefulWidget {
  static String routeName = "/achievement";
  const AchievementScreen({super.key});

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  List<Achievement> achievements = [];
  @override
  void initState() {
    loadAchievements();
    super.initState();
  }

  Future<void> loadAchievements() async {
    getAllAchievements().then((achievementsMap) {
      var achievementsList = achievementsMap['achievements'] as List<dynamic>;
      List<Achievement> loadedAchievements =
          achievementsList.map((achievementJson) {
        return Achievement.fromJson(achievementJson);
      }).toList();
      setState(() {
        achievements = loadedAchievements;
      });
    }).catchError((error) {
      print("Failed to load achievements: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.angle_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Text(
            "Achievements",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: achievements.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) => AchievementCard(
                  achievement: achievements[index],
                  onPress: () => Navigator.pushNamed(
                    context,
                    AchievementComponent.routeName,
                    arguments: AchievementDetailsArguments(
                        achievement: achievements[index]),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
