import 'package:flutter/material.dart';
import 'package:shop_app/screens/studyset/studyset_screen.dart';

class TopicEmptyScreen extends StatelessWidget {
  const TopicEmptyScreen({super.key});

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
              child: Image.asset('assets/images/book.png'),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                'Take the first step towards better grades.\nCreate a study topic.',
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
                  Navigator.pushNamed(context, StudySetScreen.routeName);
                },
                child: Text(
                  'ADD TOPIC',
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
