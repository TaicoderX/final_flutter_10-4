import 'package:flutter/material.dart';
import 'package:shop_app/screens/quiz/quiz_page_screen.dart';

class Options extends StatefulWidget {
  static String routeName = "/options";
  const Options({Key? key}) : super(key: key);
  @override
  State<Options> createState() => _OptionsState();
}

class _OptionsState extends State<Options> {
  late bool isShuffle = false;
  late bool isFeedback = true;
  String editText = '0';
  late String displayText = '0';
  late String selectedOption = 'English';
  var vocabularies;
  String topicId = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getArgs();
  }

  void getArgs() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    vocabularies = args['vocabularies'];
    topicId = args['topicId'];
    displayText = vocabularies.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 2, 10, 57),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.white,
                      iconSize: 45.0,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 2.0)),
                                  ),
                                  child: const Text(
                                    'Topic 3',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                const Text(
                                  "Chủ đề 2",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                const Text(
                                  "Set up your test",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                        ),
                        Image.asset(
                          'assets/images/exam.png',
                          width: 40.0,
                          height: 40.0,
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Question Count (${vocabularies.length} max)",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 51, 50, 50),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: 40,
                            height: 40,
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                              onChanged: (value) {
                                setState(() {
                                  editText = value;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: editText == '0' ? displayText : editText,
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ]),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Study Language",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                        Container(
                          width: 150,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedOption,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedOption = newValue!;
                              });
                            },
                            items: <String>[
                              'English',
                              'Vietnamese',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        )
                      ]),
                  const SizedBox(height: 10),
                  const Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Shuffle Question",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                        Switch(
                          value: isShuffle,
                          onChanged: (value) {
                            setState(() {
                              isShuffle = value;
                            });
                          },
                          activeColor: Colors.blue,
                        )
                      ]),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Instant Feedback",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                        Switch(
                          value: isFeedback,
                          onChanged: (value) {
                            setState(() {
                              isFeedback = value;
                            });
                          },
                          activeColor: Colors.blue,
                        )
                      ]),
                  const Spacer(flex: 10),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              QuizPage.routeName,
                              arguments: {
                                "vocabularies": vocabularies,
                                "topicId": topicId,
                                "maxQuestions":
                                    int.parse(editText) >= vocabularies.length
                                        ? vocabularies.length
                                        : int.parse(editText) == 0
                                            ? vocabularies.length
                                            : int.parse(editText),
                                "language": selectedOption,
                                'shuffle': isShuffle,
                                'feedback': isFeedback,
                              },
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'START',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
