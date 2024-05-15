import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shop_app/controllers/vocabStatistic.dart';
import 'package:shop_app/screens/local/local_storage.dart';
import 'package:shop_app/screens/test/components/alphabet.dart';
import 'package:shop_app/screens/test/components/statistic.dart';
import 'package:shop_app/screens/test/components/word_button.dart';

class GameScreen extends StatefulWidget {
  static const routeName = '/test-screen';
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Alphabet englishAlphabet = Alphabet();
  late String word;
  late String hiddenWord = '';
  late bool hintStatus;
  int currentPosition = 0;
  int hintPosition = 0;
  Color color = Colors.yellow;
  String englishWord = '';
  late FlutterTts flutterTts;

  late TextEditingController _controller;
  late List<dynamic> _vocabularies;
  int _currentIndex = 0;
  List<Map<String, dynamic>> results = [];
  List<Map<String, dynamic>> vocabStatis = [];

  Widget createButton(index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 6.0),
      child: Center(
        child: WordButton(
          buttonTitle: englishAlphabet.alphabet[index].toUpperCase(),
          onPressed: () => wordPress(index),
        ),
      ),
    );
  }

  void initWords() {
    hintStatus = true;
    word = _vocabularies[_currentIndex]['vietnameseWord'];
    hiddenWord = '';
    currentPosition = 0;
    hintPosition = 0;
    englishWord = _vocabularies[_currentIndex]['englishWord'];
    if (englishWord.isNotEmpty) {
      for (var i = 0; i < englishWord.length; i++) {
        if (englishWord[i] == ' ') {
          hiddenWord += ' ';
        } else {
          hiddenWord += '_';
        }
      }
    }
    _speak(word, false);
  }

  void wordPress(int index) {
    setState(() {
      if (index == 26) {
        if (currentPosition > 0) {
          currentPosition--;
          while (currentPosition > 0 && hiddenWord[currentPosition] == ' ') {
            currentPosition--;
          }
          if (hiddenWord[currentPosition] != ' ') {
            hiddenWord = replaceCharAt(hiddenWord, currentPosition, '_');
          }
        }
      } else if (index < 26) {
        hintPosition++;
        if (currentPosition < hiddenWord.length &&
            hiddenWord[currentPosition] == '_') {
          hiddenWord = replaceCharAt(
              hiddenWord, currentPosition, englishAlphabet.alphabet[index]);
          currentPosition++;
          while (currentPosition < hiddenWord.length &&
              hiddenWord[currentPosition] == ' ') {
            currentPosition++;
          }
        }
      } else if (index == 27) {
        validateAndMoveOn();
      }
    });
  }

  String replaceCharAt(String str, int index, String replacement) {
    return str.substring(0, index) + replacement + str.substring(index + 1);
  }

  @override
  void initState() {
    flutterTts = FlutterTts();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _vocabularies = arguments['vocabularies'];
    _controller = TextEditingController();
    initWords();
  }

  Future<void> _speak(String text, bool isEn) async {
    await flutterTts.setLanguage(isEn ? "en-US" : "vi-VN");
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    _controller.dispose();
    flutterTts.stop();
    super.dispose();
  }

  void validateAndMoveOn() async {
    String answer = hiddenWord;
    String correctAnswer = _vocabularies[_currentIndex]['englishWord'];
    if (answer.toLowerCase() != correctAnswer.toLowerCase()) {
      results.add({
        'vietnameseWord': _vocabularies[_currentIndex]['vietnameseWord'],
        'englishWord': correctAnswer,
        'userAnswer': answer.replaceAll("_", "")
      });
    }else{
      vocabStatis.add({
        'vocabularyId': _vocabularies[_currentIndex]['_id'],
        'learningCount' : 1,
      });
    }

    if (_currentIndex < _vocabularies.length - 1) {
      setState(() {
        _currentIndex++;
        initWords();
        hintStatus = true;
        color = Colors.yellow;
      });
    } else {
      String _token = await LocalStorageService().getData('token');
      await create_updateVocabStatistic(_token, results);
      Navigator.pushNamed(context, StatisticTest.routeName, arguments: {
        'totalQuestions': _vocabularies.length,
        'wrongAnswer': results.length,
        'vocabularies': _vocabularies,
        'topicId': _vocabularies[0]['topicId'],
        'results': results,
        'vocabStatis': vocabStatis,
      });
    }
    _speak(_vocabularies[_currentIndex]['vietnameseWord'], false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.indigo.shade700,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6.0, 8.0, 6.0, 35.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              child: IconButton(
                                tooltip: 'Close',
                                iconSize: 39,
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(
                              child: IconButton(
                                tooltip: 'Hint',
                                iconSize: 39,
                                icon: Icon(
                                  Icons.lightbulb_outline_rounded,
                                  color: color,
                                ),
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onPressed: hintStatus &&
                                        hintPosition <
                                            englishWord
                                                .replaceAll(" ", "")
                                                .length
                                    ? () {
                                        wordPress(englishAlphabet.alphabet
                                            .indexOf(englishWord
                                                .replaceAll(
                                                    " ", "")[hintPosition]
                                                .toLowerCase()));
                                        setState(() {
                                          hintStatus = false;
                                          color = Colors.grey;
                                        });
                                      }
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      LinearProgressIndicator(
                        value: (_currentIndex + 1) / _vocabularies.length,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              word,
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontFamily: 'FiraMono',
                                letterSpacing: 8,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 35.0),
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              hiddenWord,
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontFamily: 'FiraMono',
                                  letterSpacing: 8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: const EdgeInsets.fromLTRB(10.0, 2.0, 8.0, 10.0),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    TableRow(children: [
                      TableCell(
                        child: createButton(0),
                      ),
                      TableCell(
                        child: createButton(1),
                      ),
                      TableCell(
                        child: createButton(2),
                      ),
                      TableCell(
                        child: createButton(3),
                      ),
                      TableCell(
                        child: createButton(4),
                      ),
                      TableCell(
                        child: createButton(5),
                      ),
                      TableCell(
                        child: createButton(6),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: createButton(7),
                      ),
                      TableCell(
                        child: createButton(8),
                      ),
                      TableCell(
                        child: createButton(9),
                      ),
                      TableCell(
                        child: createButton(10),
                      ),
                      TableCell(
                        child: createButton(11),
                      ),
                      TableCell(
                        child: createButton(12),
                      ),
                      TableCell(
                        child: createButton(13),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: createButton(14),
                      ),
                      TableCell(
                        child: createButton(15),
                      ),
                      TableCell(
                        child: createButton(16),
                      ),
                      TableCell(
                        child: createButton(17),
                      ),
                      TableCell(
                        child: createButton(18),
                      ),
                      TableCell(
                        child: createButton(19),
                      ),
                      TableCell(
                        child: createButton(20),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: createButton(21),
                      ),
                      TableCell(
                        child: createButton(22),
                      ),
                      TableCell(
                        child: createButton(23),
                      ),
                      TableCell(
                        child: createButton(24),
                      ),
                      TableCell(
                        child: createButton(25),
                      ),
                      TableCell(
                        child: createButton(26),
                      ),
                      TableCell(
                        child: createButton(27),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
