import 'package:dynamic_multi_step_form/dynamic_json_form.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/controllers/folder.dart';
import 'package:shop_app/screens/folders/components/folder_factory.dart';
import 'package:shop_app/screens/home/components/section_title.dart';

import 'package:shop_app/screens/local/local_storage.dart';

class AddToFolder extends StatefulWidget {
  static String routeName = "/add_to_folder";
  const AddToFolder({Key? key}) : super(key: key);

  @override
  State<AddToFolder> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<AddToFolder> {
  List<dynamic> folders = [];
  List<dynamic> filteredFolders = [];
  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    super.initState();
    loadFolder();
  }

  Future<void> loadFolder() async {
    var storedFolders = await LocalStorageService().getData('folders');
    userInfo = await LocalStorageService().getData('data');
    if (storedFolders != null) {
      setState(() {
        folders = storedFolders;
        filteredFolders = folders;
      });
      return;
    }

    final token = await LocalStorageService().getData('token');
    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }

    try {
      var res = await getFolderByID(userInfo["_id"], token);
      setState(() {
        folders = res['folders'] ?? [];
        filteredFolders = folders;
        LocalStorageService().saveData('folders', folders);
      });
    } catch (e) {
      print('Exception occurred while loading topics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var image = userInfo["profileImage"] ?? '';
    var name = userInfo["username"] ?? '';
    if (filteredFolders.isEmpty) {
      return Container();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: List.generate(
          filteredFolders.length,
          (index) => SpecialFolderFactory.createList(
              filteredFolders[index], context, image, name, false),
        ),
      ),
    );
  }
}
