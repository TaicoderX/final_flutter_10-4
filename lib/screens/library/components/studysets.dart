import 'package:flutter/material.dart';
import 'package:shop_app/controllers/user.controller.dart';
import 'package:shop_app/screens/folders/components/topic_factory.dart';
import 'package:shop_app/screens/library/components/topic_empty.dart';
import 'package:shop_app/screens/local/local_storage.dart';

class StudySets extends StatefulWidget {
  const StudySets({Key? key}) : super(key: key);

  @override
  State<StudySets> createState() => _StudySetsState();
}

class _StudySetsState extends State<StudySets> {
  List<dynamic> topics = [];
  List<dynamic> filteredTopics = [];
  Map<String, dynamic> userInfo = {};
  bool _loading = true;

  @override
  void initState() {
    loadTopics();
    super.initState();
  }

  Future<void> loadTopics() async {
    var storedTopics = await LocalStorageService().getData('topics');
    if (storedTopics != null) {
      setState(() {
        topics = storedTopics;
        filteredTopics = topics;
        _loading = false;
      });
      return;
    }

    final token = await LocalStorageService().getData('token');
    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }

    try {
      var data = await getTopicByUserAPI(token);
      setState(() {
        topics = data['topics'] ?? [];
        filteredTopics = topics;
      });
      LocalStorageService().saveData('topics', topics);
    } catch (e) {
      print('Exception occurred while loading topics: $e');
        _loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredTopics.isEmpty) {
      return const TopicEmptyScreen();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            // child: SectionTitle(title: "Sets", press: () {}),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: List.generate(
                filteredTopics.length,
                (index) => TopicWidgetFactory.createWidget(
                    topics[index], context, true, isLibrary: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
