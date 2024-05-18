import 'package:flutter/material.dart';
import 'package:shop_app/components/BoxAchieve.dart';
import 'package:shop_app/controllers/achievement.dart';
import 'package:shop_app/models/Achievement.dart';
import 'package:shop_app/screens/achievements/components/achievement.dart';

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
    getAllAchivements().then((achievementsMap) {
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
          icon: const Icon(Icons.arrow_back_sharp),
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
                itemBuilder: (context, index) => BoxAchieve(
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
