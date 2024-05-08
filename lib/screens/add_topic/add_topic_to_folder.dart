import 'package:dynamic_multi_step_form/dynamic_json_form.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/controllers/folder.dart';
import 'package:shop_app/controllers/user.controller.dart';
import 'package:shop_app/screens/add_topic/components/topic.dart';
import 'package:shop_app/screens/local/local_storage.dart';

class AddTopicToFolder extends StatefulWidget {
  static String routeName = "/add_topic_to_folder";
  const AddTopicToFolder({Key? key}) : super(key: key);

  @override
  _AddTopicToFolderState createState() => _AddTopicToFolderState();
}

class _AddTopicToFolderState extends State<AddTopicToFolder> {
  List<dynamic> topics = [];
  List<dynamic> filteredTopics = [];
  Map<String, dynamic> userInfo = {};
  String folderId = '';
  String token = '';
  bool _loading = true;

  @override
  void initState() {
    loadTopics();
    super.initState();
  }

  Future<void> loadTopics() async {
    token = await LocalStorageService().getData('token');
    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }

    try {
      var data = await getTopicByUserAPI(token);
      final args = ModalRoute.of(context)?.settings.arguments as Map;
      setState(() {
        topics = data['topics'] ?? [];
        filteredTopics = topics;

        List<dynamic> dynamicList = args['existingTopics'];
        folderId = args['folderId'];
        List<String> alreadyInFolder =
            dynamicList.map((item) => item.toString()).toList();
        AddTopicWidgetFactory.alreadyInFolder = alreadyInFolder;
        _loading = false;
      });
      LocalStorageService().saveData('topics', topics);
    } catch (e) {
      print('Exception occurred while loading topics: $e');
        _loading = false;
    }
  }

  void refreshUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    final Function onUpdate = args['onUpdate'];

    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'All Topics',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: (AddTopicWidgetFactory.newlySelectedTopics.isNotEmpty ||
                AddTopicWidgetFactory.deselectedTopics.isNotEmpty)
            ? [
                IconButton(
                    icon: Icon(
                      Icons.done_rounded,
                      size: 30,
                    ),
                    onPressed: () async {
                      var selectedTopics =
                          AddTopicWidgetFactory.newlySelectedTopics;
                      var removedTopics =
                          AddTopicWidgetFactory.deselectedTopics;

                      for (var topic in selectedTopics) {
                        await addTopicToFolder(token, topic, folderId);
                      }

                      for (var topic in removedTopics) {
                        await removeTopicFromFolder(token, topic, folderId);
                      }

                      AddTopicWidgetFactory.newlySelectedTopics = [];
                      AddTopicWidgetFactory.deselectedTopics = [];
                      refreshUI();
                      await onUpdate();
                      Navigator.pop(context);
                    }),
                SizedBox(width: 20)
              ]
            : [],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(
            filteredTopics.length,
            (index) => AddTopicWidgetFactory.createWidget(
                topics[index], context, true,
                refreshUI: refreshUI),
          ),
        ),
      ),
    );
  }
}
