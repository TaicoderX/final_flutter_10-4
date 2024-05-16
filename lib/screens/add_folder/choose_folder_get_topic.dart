import 'package:flutter/material.dart';
import 'package:shop_app/controllers/folder.dart';
import 'package:shop_app/screens/add_folder/components/folder.dart';
import 'package:shop_app/screens/local/local_storage.dart';

class ChooseFolderToGetTopic extends StatefulWidget {
  static String routeName = "/choose_folder_get_topic";
  const ChooseFolderToGetTopic({Key? key}) : super(key: key);

  @override
  _ChooseFolderToGetTopicState createState() => _ChooseFolderToGetTopicState();
}

class _ChooseFolderToGetTopicState extends State<ChooseFolderToGetTopic> {
  List<dynamic> folders = [];
  Map<String, dynamic> userInfo = {};
  String token = '';
  bool _loading = true;
  String topicId = '';

  @override
  void initState() {
    loadFolders();
    super.initState();
  }

  Future<void> loadFolders() async {
    token = await LocalStorageService().getData('token');
    if (token.isEmpty) {
      print('Token is empty. Cannot load folders.');
      return;
    }
    userInfo = await LocalStorageService().getData('data');

    try {
      final args = ModalRoute.of(context)?.settings.arguments as Map;
      topicId = args['topicId'];
      var folderData = await getFolderByID(userInfo['_id'], token);
      List<dynamic> allFolders = folderData['folders'] ?? [];

      var dynamicList = await getFolderByTopicId(topicId, token);
      List<dynamic> folderIdsDynamic = dynamicList['folderIds'];
      List<String> alreadyInFolder =
          folderIdsDynamic.map((e) => e.toString()).toList();
      setState(() {
        folders = allFolders;
        ChooseFolderFactory.alreadyFolderAdded = alreadyInFolder;
        _loading = false;
      });

      LocalStorageService().saveData('folders', folders);
    } catch (e) {
      print('Exception occurred while loading folders: $e');
      _loading = false;
    }
  }

  void refreshUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
          'All Folders',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: (ChooseFolderFactory.newlySelectedFolders.isNotEmpty ||
                ChooseFolderFactory.deselectedFolders.isNotEmpty)
            ? [
                IconButton(
                  icon: Icon(
                    Icons.done_rounded,
                    size: 30,
                  ),
                  onPressed: () async {
                    var selectedFolders =
                        ChooseFolderFactory.newlySelectedFolders;
                    var removedFolders = ChooseFolderFactory.deselectedFolders;

                    for (var folder in selectedFolders) {
                      await addTopicToFolder(token, topicId, folder);
                    }

                    for (var folder in removedFolders) {
                      await removeTopicFromFolder(token, topicId, folder);
                    }

                    ChooseFolderFactory.newlySelectedFolders = [];
                    ChooseFolderFactory.deselectedFolders = [];
                    refreshUI();
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 20)
              ]
            : [],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(
            folders.length,
            (index) => ChooseFolderFactory.createWidget(
              folders[index],
              context,
              true,
              userInfo['profileImage'],
              userInfo['username'],
              refreshUI: refreshUI,
            ),
          ),
        ),
      ),
    );
  }
}
