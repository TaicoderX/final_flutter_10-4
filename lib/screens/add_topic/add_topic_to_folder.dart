import 'package:dynamic_multi_step_form/dynamic_json_form.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/controllers/user.controller.dart';
import 'package:shop_app/screens/folders/components/topic_factory.dart';
import 'package:shop_app/screens/local/local_storage.dart';

class AddTopicToFolder extends StatefulWidget {
  static String routeName = "/add_topic_to_folder";
  const AddTopicToFolder({Key? key}) : super(key: key);

  @override
  _SpecialOffersState createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<AddTopicToFolder> {
  List<dynamic> topics = [];
  List<dynamic> filteredTopics = [];
  Map<String, dynamic> userInfo = {};

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(
            filteredTopics.length,
            (index) =>
                TopicWidgetFactory.createWidget(topics[index], context, true),
          ),
        ),
      ),
    );
  }
}
