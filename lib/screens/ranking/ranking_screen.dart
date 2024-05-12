import 'package:flutter/material.dart';

class Ranking extends StatelessWidget {
  static const String routeName = '/ranking';
  const Ranking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 10, 57),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.blue,
                      size: 40,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text(
                    'Ranking',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {
                        // Hành động khi nhấn vào icon
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.orange, // Set border color here
                      width: 2, // Set border width here
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage('avatar_image_url'),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'tainguyen68',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                              Text(
                                'Rank: 1',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ]),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Learning Count: 18',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Vocabularies Learned: 1',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Time Learned: 00:06:50',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ]),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  value: 0.54,
                                  backgroundColor: Colors.orange,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(255, 120, 226, 123)),
                                  strokeWidth: 8,
                                ),
                              ),
                              Text(
                                '54%',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                      // Nội dung câu trả lời của bạn
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
