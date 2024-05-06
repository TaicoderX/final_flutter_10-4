import 'package:flutter/material.dart';
import 'package:shop_app/screens/add_topic/add_topic_to_folder.dart';

class EmptyFolder extends StatelessWidget {
  const EmptyFolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'This folder has no sets',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Organize your study sets by adding them to this folder.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AddTopicToFolder.routeName);
            },
            child: Text('Add a set'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
