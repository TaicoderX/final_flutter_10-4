import 'dart:convert';

import 'package:dynamic_multi_step_form/dynamic_json_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/folder.dart';
import 'package:shop_app/screens/folders/components/folder_factory.dart';
import 'package:shop_app/screens/library/library_screen.dart';

import 'package:shop_app/screens/local/local_storage.dart';

import 'section_title.dart';

class Folders extends StatefulWidget {
  final String searchQuery;
  const Folders({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<Folders> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<Folders> {
  List<dynamic> folders = [];
  List<dynamic> filteredFolders = [];
  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    super.initState();
    loadFolder();
  }

  @override
  void didUpdateWidget(covariant Folders oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      searchFolder(widget.searchQuery);
    }
  }

  void searchFolder(String query) {
    final String searchQueryLowercase = query.toLowerCase().trim();
    filteredFolders = folders;
    if (searchQueryLowercase.isEmpty) {
      setState(() {
        filteredFolders = folders;
      });
    } else {
      setState(() {
        filteredFolders = folders.where((topic) {
          final String topicNameLowercase =
              topic["folderNameEnglish"].toLowerCase();
          return topicNameLowercase.contains(searchQueryLowercase);
        }).toList();
      });
    }
  }

  Future<void> loadFolder() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String dataString = prefs.getString('data') ?? '';
    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }

    try {
      userInfo = json.decode(dataString);
      var res = await getFolderByID(userInfo["_id"], token);
      setState(() {
        folders = res['folders'] ?? [];
        filteredFolders = folders;
      });
      LocalStorageService().saveData('folders', folders);
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Folders",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LibraryScreen(initialTabIndex: 1),
                ),
              );
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              filteredFolders.length,
              (index) => SpecialFolderFactory.createList(
                  filteredFolders[index], context, image, name, false),
            ),
          ),
        ),
      ],
    );
  }
}
