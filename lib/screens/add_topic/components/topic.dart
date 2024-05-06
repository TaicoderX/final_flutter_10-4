import 'package:flutter/material.dart';
import 'package:shop_app/screens/add_topic/components/add_topic.dart';

class AddTopicWidgetFactory {
  static List<String> alreadyInFolder = [];
  static List<String> newlySelectedTopics = [];
  static List<String> deselectedTopics = [];

  static Widget createWidget(
      Map<String, dynamic> topic, BuildContext context, bool isLarge,
      {required void Function() refreshUI}) {
    String title = topic['topicNameEnglish'] ?? 'Title';
    String image = topic['ownerId']['profileImage'] ?? '';
    int words = topic['vocabularyCount'] ?? 0;
    String name = topic['ownerId']['username'] ?? 'Name';
    String topicId = topic['_id'];

    bool isSelected = alreadyInFolder.contains(topicId)
        ? !deselectedTopics.contains(topicId)
        : newlySelectedTopics.contains(topicId);

    return TopicAdded(
      title: title,
      image: image,
      words: words,
      name: name,
      isLarge: isLarge,
      isSelected: isSelected,
      press: () {
        if (alreadyInFolder.contains(topicId)) {
          if (deselectedTopics.contains(topicId)) {
            deselectedTopics.remove(topicId);
          } else {
            deselectedTopics.add(topicId);
          }
        } else {
          if (newlySelectedTopics.contains(topicId)) {
            newlySelectedTopics.remove(topicId);
          } else {
            newlySelectedTopics.add(topicId);
          }
        }
        refreshUI();
      },
    );
  }
}
