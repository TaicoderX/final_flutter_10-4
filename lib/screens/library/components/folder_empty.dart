import 'package:flutter/material.dart';
import 'package:shop_app/screens/folders/new_folder_screen.dart';

class FolderEmptyScreen extends StatelessWidget {
  const FolderEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              child: Image.asset('assets/images/folder.png'),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                'Take the first step towards better grades.\nCreate a study folder.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, NewFolderScreen.routeName);
                },
                child: Text(
                  'ADD FOLDER',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
