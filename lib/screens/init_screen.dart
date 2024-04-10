import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/discover/discover_screen.dart';
import 'package:shop_app/screens/folders/new_folder_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/library/library_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/studyset/studyset_screen.dart';

const Color inActiveIconColor = Color(0xFF5C667A);

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = 0;

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  final pages = [
    const HomeScreen(),
    const DiscoverScreen(),
    Container(),
    LibraryScreen(),
    ProfileScreen()
  ];

  Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('data');
    if (userJson == null) return null;
    Map<String, dynamic> userData = json.decode(userJson);
    return userData;
  }

  Future show() {
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            Container(
              margin:
                  const EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kSecondaryColor.withOpacity(0.1),
              ),
              child: ListTile(
                leading: const Icon(Icons.flip_to_front_rounded),
                title: const Text(
                  'Study Set',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  Navigator.pop(context);

                  await Navigator.pushNamed(context, StudySetScreen.routeName);
                },
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kSecondaryColor.withOpacity(0.1),
              ),
              child: ListTile(
                leading: const Icon(Icons.folder_copy_outlined),
                title: const Text(
                  'Folder',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  // Handle ADD TOPIC action
                  Navigator.pop(context);
                  await Navigator.pushNamed(context, NewFolderScreen.routeName);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 20, top: 5, right: 20, bottom: 30),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4C56FF),
        unselectedItemColor: inActiveIconColor,
        currentIndex: currentSelectedIndex,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          fontSize: 9,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          fontSize: 9,
        ),
        onTap: (index) {
          if (index == 2) {
            show();
          } else {
            updateCurrentIndex(index);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/Shop Icon.svg",
                color: currentSelectedIndex == 0
                    ? const Color(0xFF4C56FF)
                    : inActiveIconColor,
                width: 25,
                height: 25),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/telescope.svg",
                color: currentSelectedIndex == 1
                    ? const Color(0xFF4C56FF)
                    : inActiveIconColor,
                width: 25,
                height: 25),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/circle-plus.svg",
                color: inActiveIconColor, width: 35, height: 35),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/folder-open.svg",
                color: currentSelectedIndex == 3
                    ? const Color(0xFF4C56FF)
                    : inActiveIconColor,
                width: 25,
                height: 25),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/circle-user.svg",
                color: currentSelectedIndex == 4
                    ? const Color(0xFF4C56FF)
                    : inActiveIconColor,
                width: 25,
                height: 25),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
