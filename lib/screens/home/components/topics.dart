import 'package:dynamic_multi_step_form/dynamic_json_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/user.controller.dart';
import 'package:shop_app/screens/folders/components/topic_factory.dart';
import 'package:shop_app/screens/home/components/new_user.dart';
import 'package:shop_app/screens/local/local_storage.dart';

import 'section_title.dart';

class Topics extends StatefulWidget {
  final String searchQuery;

  const Topics({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _SpecialOffersState createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<Topics> {
  List<dynamic> topics = [];
  List<dynamic> filteredTopics = [];
  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    loadTopics();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Topics oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      searchTopic(widget.searchQuery);
    }
  }

  void searchTopic(String query) {
    final String searchQueryLowercase = query.toLowerCase().trim();
    filteredTopics = topics;
    if (searchQueryLowercase.isEmpty) {
      setState(() {
        filteredTopics = topics;
      });
    } else {
      setState(() {
        filteredTopics = topics.where((topic) {
          final String topicNameLowercase =
              topic["topicNameEnglish"].toLowerCase();
          return topicNameLowercase.contains(searchQueryLowercase);
        }).toList();
      });
    }
  }

  Future<void> loadTopics() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }

    try {
      var data = await getTopicByUserAPI(token);
      setState(() {
        topics = data['topics'] ?? [];
        filteredTopics = topics;
        LocalStorageService().saveData('topics', topics);
      });
    } catch (e) {
      print('Exception occurred while loading topics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (filteredTopics.isEmpty) {
      return NewUser();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(title: "Sets", press: () {}),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              filteredTopics.length,
              (index) => TopicWidgetFactory.createWidget(
                      filteredTopics[index], context, false)
            ),
          ),
        ),
      ],
    );
  }
}
