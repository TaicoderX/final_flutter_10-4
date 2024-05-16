import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shop_app/screens/flashcard/components/congrats_screen.dart';

class FlashcardsView extends StatefulWidget {
  static String routeName = '/flashcards';

  @override
  _FlashcardsViewState createState() => _FlashcardsViewState();
}

class _FlashcardsViewState extends State<FlashcardsView> {
  late FlutterTts flutterTts;
  int currentIndex = 0;
  bool showFront = true;
  Offset cardPosition = Offset.zero;
  double cardRotation = 0.0;
  bool _autoplayInProgress = false;
  bool isVolumeOn = false;
  FlipCardController controllerFlipCard = FlipCardController();
  List<dynamic> flashcards = [];
  String topicId = "";

  bool shuffle = false;
  bool playAudio = false;
  bool isSpacedRepetition = true;
  bool isTerm = true;
  bool isSorting = false;
  bool currentTermIsEnglish = true;

  @override
  void initState() {
    super.initState();
    getFlashcards();
    flutterTts = FlutterTts();
  }

  Future<void> getFlashcards() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final args = ModalRoute.of(context)?.settings.arguments as Map;
        setState(() {
          topicId = args['topicId'];
          flashcards = args['vocabularies'];
        });
      }
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _nextCard() {
    if (!showFront)
      controllerFlipCard.toggleCardWithoutAnimation();
    if (currentIndex + 1 == flashcards.length) {
      Navigator.pushNamed(context, CongratsScreen.routeName);
    }
    setState(() {
      currentIndex = (currentIndex + 1) % flashcards.length;
      showFront = true;
      cardPosition = Offset.zero;
      cardRotation = 0.0;
    });
    if (playAudio && !isVolumeOn && !_autoplayInProgress) {
      String text = isTerm
          ? flashcards[currentIndex]['englishWord']
          : flashcards[currentIndex]['vietnameseWord'];
      _speak(text, isTerm);
    }
  }

  void _previousCard() {
    if (!showFront) controllerFlipCard.toggleCardWithoutAnimation();
    setState(() {
      currentIndex = (currentIndex - 1 + flashcards.length) % flashcards.length;
      showFront = true;
      cardPosition = Offset.zero;
      cardRotation = 0.0;
    });
  }

  Future<void> _speak(String text, bool isEn) async {
    await flutterTts.setLanguage(isEn ? "en-US" : "vi-VN");
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(text).then((_) {
      if (mounted) {
        setState(() {
          isVolumeOn = false;
        });
      }
    });
  }

  void _startAutoplay() async {
    if(!isTerm) controllerFlipCard.toggleCard();
    if (_autoplayInProgress) return;
    _autoplayInProgress = true;
    try {
      if (!showFront) _nextCard();
      while (
          _autoplayInProgress && currentIndex < flashcards.length && mounted) {
        await _speak(flashcards[currentIndex]['englishWord']!, true);

        if (isSpacedRepetition && _autoplayInProgress)
          await Future.delayed(Duration(milliseconds: 500));
        if (!mounted) break;
        controllerFlipCard.toggleCard();
        if (!mounted) break;
        setState(() {
          showFront = false;
        });

        if (isSpacedRepetition && _autoplayInProgress)
          await Future.delayed(Duration(milliseconds: 500));
        await _speak(flashcards[currentIndex]['vietnameseWord']!, false);

        if (isSpacedRepetition && _autoplayInProgress)
          await Future.delayed(Duration(milliseconds: 1000));
        if (currentIndex + 1 < flashcards.length && mounted) {
          _nextCard();
        } else {
          if (mounted) {
            setState(() {
              _autoplayInProgress = false;
              currentIndex = 0;
              controllerFlipCard.toggleCardWithoutAnimation();
            });
          }
          Navigator.pushNamed(context, CongratsScreen.routeName);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _autoplayInProgress = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (flashcards.isEmpty) {
      return Container();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        title: Text(
          '${currentIndex + 1}/${flashcards.length}',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 3),
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.grey[700],
              ),
              onPressed: () {
                bottomSheet();
              }),
          SizedBox(
            width: 10,
          )
        ],
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          LinearProgressIndicator(
            value: (currentIndex + 1) / flashcards.length,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) => _onDragUpdate(context, details),
              onPanEnd: (details) => _onDragEnd(context, details),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 320,
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: cardPosition,
                    child: Transform.rotate(
                      angle: cardRotation,
                      child: FlipCard(
                        direction: FlipDirection.HORIZONTAL,
                        onFlip: () => _flipCard(),
                        front: isTerm ? buildFlashCard(
                            flashcards[currentIndex]['englishWord']!, true) : buildFlashCard(
                              flashcards[currentIndex]['vietnameseWord']!, false),
                        back: isTerm ? buildFlashCard(
                            flashcards[currentIndex]['vietnameseWord']!, false) : buildFlashCard(
                              flashcards[currentIndex]['englishWord']!, true),
                        controller: controllerFlipCard,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: currentIndex > 0 ? _previousCard : null,
              ),
              Text(
                _autoplayInProgress ? 'Auto-play cards is ON' : '',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              IconButton(
                icon: Icon(_autoplayInProgress
                    ? Icons.pause_circle
                    : Icons.play_arrow_rounded),
                onPressed: _autoplayInProgress ? _stopAutoplay : _startAutoplay,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  void _stopAutoplay() {
    _autoplayInProgress = false;
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails details) {
    setState(() {
      cardPosition += details.delta;
      cardRotation = cardPosition.dx * 0.001;
    });
  }

  void _onDragEnd(BuildContext context, DragEndDetails details) {
    final double velocityThreshold = 100.0;
    if (details.velocity.pixelsPerSecond.distance > velocityThreshold) {
      _nextCard();
    } else {
      setState(() {
        cardPosition = Offset.zero;
        cardRotation = 0.0;
      });
    }
  }

  void _flipCard() {
    setState(() {
      showFront = !showFront;
    });
  }

  Widget buildFlashCard(String text, bool isFront) {
    return Container(
      width: 320,
      height: 500,
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
          ),
        ],
        border: Border.all(
          color: cardPosition.distance == 0 ? Colors.transparent : Colors.blue,
          width: 2.0,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 10,
            top: 10,
            child: IconButton(
              icon:
                  Icon(Icons.volume_up_outlined, size: 23, color: Colors.black),
              onPressed: () {
                _speak(text, isFront);
                setState(() {
                  isVolumeOn = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> bottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => FractionallySizedBox(
          heightFactor: 1,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Color.fromARGB(255, 47, 50, 92),
            ),
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.25),
                    const Text(
                      "Options",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => setState(() {
                        shuffle = !shuffle;
                        if (shuffle) {
                          flashcards.shuffle();
                        }
                      }),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(color: Colors.white, width: 2.0)),
                          child: Icon(
                            Icons.shuffle,
                            color: shuffle ? Colors.blue : Colors.white,
                            size: 30,
                          )),
                    ),
                    InkWell(
                      onTap: () => setState(() {
                        playAudio = !playAudio;
                      }),
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50),
                              border:
                                  Border.all(color: Colors.white, width: 2.0)),
                          child: Column(
                            children: [
                              Icon(Icons.volume_up,
                                  color: playAudio ? Colors.blue : Colors.white,
                                  size: 30),
                            ],
                          )),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '   Shuffle',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '  Play audio',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Auto-play delay',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Switch(
                      value: isSpacedRepetition,
                      onChanged: (value) {
                        setState(() {
                          isSpacedRepetition = !isSpacedRepetition;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
                const Text(
                  "There are delays between words when the Auto-play feature is enabled",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Sorting',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Switch(
                      value: isSorting,
                      onChanged: (bool value) {
                        setState(() {
                          isSorting = value;
                          if (isSorting) {
                            flashcards.sort((a, b) => a['englishWord']
                                .length
                                .compareTo(b['englishWord'].length));
                          }
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
                const Text(
                  "Sort your cards word count to make it easier to study",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30.0),
                const Text(
                  "Card orientation",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  "Front",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 72, 71, 71),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                isTerm ? Colors.white : Colors.grey,
                            backgroundColor: isTerm
                                ? Colors.grey
                                : const Color.fromARGB(255, 72, 71, 71),
                          ),
                          onPressed: () {
                            setState(() {
                              isTerm = true;
                            });
                          },
                          child: Text('Term'),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                !isTerm ? Colors.white : Colors.grey,
                            backgroundColor: !isTerm
                                ? Colors.grey
                                : const Color.fromARGB(255, 72, 71, 71),
                          ),
                          onPressed: () {
                            setState(() {
                              isTerm = false;
                            });
                          },
                          child: Text('Definition'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () => {
                    setState(() {
                      shuffle = false;
                      playAudio = false;
                      isSpacedRepetition = true;
                      isTerm = true;
                      isSorting = false;
                    })
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Restart Flashcards",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
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
}
