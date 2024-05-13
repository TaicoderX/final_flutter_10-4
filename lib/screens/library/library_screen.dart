import 'package:flutter/material.dart';
import 'package:shop_app/screens/library/components/folders.dart';
import 'package:shop_app/screens/library/components/studysets.dart';
import 'package:shop_app/screens/studyset/studyset_screen.dart';

import '../folders/new_folder_screen.dart';

class LibraryScreen extends StatefulWidget {
  static String routeName = "/library";
  final int initialTabIndex;

  const LibraryScreen({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.initialTabIndex;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_tabController.index == 0) {
                Navigator.pushNamed(context, StudySetScreen.routeName);
              } else if (_tabController.index == 1) {
                Navigator.pushNamed(context, NewFolderScreen.routeName);
              }
            },
          ),
          const SizedBox(width: 15),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: Container(
            width: 250,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _tabController,
                labelPadding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.0, color: Colors.blue),
                ),
                tabs: const [
                  Tab(
                    child: Text('Study sets',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Tab(
                    child: Text('Folders',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const StudySets(),
          const Folders(),
        ],
      ),
    );
  }
}
