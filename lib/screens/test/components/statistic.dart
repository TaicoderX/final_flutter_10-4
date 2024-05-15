import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/controllers/learningStatistic.dart';
import 'package:shop_app/controllers/vocabStatistic.dart';
import 'package:shop_app/screens/flashcard/flashcard_screen.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'package:shop_app/screens/local/local_storage.dart';
import 'package:shop_app/screens/test/test_screen.dart';

class StatisticTest extends StatefulWidget {
  static const String routeName = '/statistic-test';
  const StatisticTest({Key? key}) : super(key: key);

  @override
  State<StatisticTest> createState() => _StatisticTestState();
}

class _StatisticTestState extends State<StatisticTest> {
  bool _isLoading = true;
  bool _hasCalledAPI = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasCalledAPI) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      List<Map<String, dynamic>> results = args['results'];
      String topicId = args['topicId'];
      callAPIToUpdate(results, topicId);
      _hasCalledAPI = true;
    }
  }

  void callAPIToUpdate(
      List<Map<String, dynamic>> results, String topicId) async {
    String token = await LocalStorageService().getData('token');
    await create_updateVocabStatistic(token, results);
    int random = Random().nextInt(10) + 1;
    await updateLearningStatistic(topicId, token, random * 60);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    int totalQuestions = args['totalQuestions'];
    int wrongAnswer = args['wrongAnswer'];
    List<dynamic> vocabularies = args['vocabularies'];
    String topicId = args['topicId'];
    List<dynamic> results = args['results'];
    int correctAnswers = totalQuestions - wrongAnswer;
    double correctPercentage = (correctAnswers / totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 10, 57),
        leading: !_isLoading
            ? IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.blue,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            : null,
      ),
      backgroundColor: const Color.fromARGB(255, 2, 10, 57),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: [
                  Expanded(
                    child: Column(children: [
                      Text(
                        correctPercentage < 50
                            ? 'You need to study more! '
                            : 'Good job! ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        correctPercentage < 50
                            ? "Practice with the topic terms until you've gotten them right."
                            : "You're doing great! Keep up the good work.",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ),
                  SizedBox(width: 20.0),
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.yellow,
                    size: 150.0,
                  ),
                ]),

                const SizedBox(height: 20.0),
                const Text(
                  'Your Result',
                  style: TextStyle(
                      color: Color.fromARGB(255, 137, 151, 185),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),

                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: correctPercentage / 100, // 8%
                            backgroundColor: Colors.orange,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 120, 226, 123)),
                            strokeWidth: 8,
                          ),
                        ),
                        Text(
                          '${correctPercentage.toStringAsFixed(1)}%',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(width: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Correct $correctAnswers',
                          style: TextStyle(
                              color: Color.fromARGB(255, 120, 226, 123),
                              fontSize: 16.0),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Incorrect $wrongAnswer',
                          style:
                              TextStyle(color: Colors.orange, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20.0),
                const Text(
                  'Next Steps',
                  style: TextStyle(
                      color: Color.fromARGB(255, 137, 151, 185),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 1, 121, 220),
                          padding: const EdgeInsets.all(20),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            FlashcardsView.routeName,
                            arguments: {
                              "vocabularies": vocabularies,
                              "topicId": topicId
                            },
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.flash_on,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 40),
                            Text(
                              'LEARN BY FLASHCARD',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10.0),

                //button try again

                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.all(20),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            side: BorderSide(color: Colors.white),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          await Navigator.pushNamed(
                            context,
                            GameScreen.routeName,
                            arguments: {
                              "vocabularies": args['vocabularies'],
                              "topicId": args['topicId'],
                            },
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 40),
                            Text(
                              'TRY AGAIN',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      for (var result in results)
                        _createBoxIncorrect(result['vietnameseWord'],
                            result['englishWord'], result['userAnswer']),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createBoxIncorrect(
      String question, String correctAns, String answer) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 72, 71, 71),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  question,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      correctAns,
                      style: TextStyle(color: Colors.green, fontSize: 20),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Center(
                      child: Text(
                        answer == "" ? "No answer" : answer,
                        softWrap: true,
                        style: TextStyle(color: Colors.red, fontSize: 20),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.red,
                width: double.infinity,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.close, color: Colors.white),
                    Text('Incorrect',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    SizedBox(width: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
