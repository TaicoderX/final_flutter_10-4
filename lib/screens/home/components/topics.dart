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
  _TopicsState createState() => _TopicsState();
}

class _TopicsState extends State<Topics> {
  List<dynamic> topics = [];
  List<dynamic> filteredTopics = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadTopics();
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
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      var data = await getTopicByUserAPI(token);
      setState(() {
        topics = data['topics'] ?? [];
        filteredTopics = topics;
        _loading = false;
      });
      await LocalStorageService().saveData('topics', topics);
    } catch (e) {
      print('Exception occurred while loading topics: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
          child: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          CircularProgressIndicator(),
        ],
      ));
    }

    if (filteredTopics.isEmpty) {
      return const NewUser();
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
                    filteredTopics[index], context, false)),
          ),
        ),
      ],
    );
  }
}
