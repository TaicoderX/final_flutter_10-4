import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/bookmarkVocab.dart';

class CreateTerm extends StatefulWidget {
  const CreateTerm(this.text, this.isFavorite, this.vocabularyId,
      {Key? key, this.onFavoriteChanged})
      : super(key: key);

  final String text;
  final bool isFavorite;
  final String vocabularyId;
  final ValueChanged<bool>? onFavoriteChanged;

  @override
  State<CreateTerm> createState() => _CreateTermState();
}

class _CreateTermState extends State<CreateTerm> {
  late FlutterTts flutterTts;
  bool isFavorite = true;
  bool isVolumeOn = false;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
    flutterTts = FlutterTts();
  }

  Future<void> _speak(String text) async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(text).then((_) {
        if (mounted) {
          setState(() {
            isVolumeOn = false;
          });
        }
      });
    } catch (e) {
      // Handle exceptions
      print("Error occurred in TTS: $e");
    }
  }

  void _toggleFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    if (isFavorite) {
      try {
        await deleteBMVocab(token, widget.vocabularyId);
      } catch (e) {
        print("Error removing bookmark: $e");
      }
    } else {
      try {
        await createBMVocab(token, [
          {'_id': widget.vocabularyId}
        ]);
      } catch (e) {
        print("Error adding bookmark: $e");
      }
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isVolumeOn = !isVolumeOn;
                if (isVolumeOn) {
                  _speak(widget.text);
                } else {
                  flutterTts.stop();
                }
              });
            },
            child: Container(
              margin: EdgeInsets.all(40),
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: GestureDetector(
              onTap: _toggleFavoriteStatus,
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 55,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isVolumeOn = !isVolumeOn;
                  if (isVolumeOn) {
                    _speak(widget.text);
                  } else {
                    flutterTts.stop();
                  }
                });
              },
              child: Icon(
                isVolumeOn
                    ? Icons.volume_up_outlined
                    : Icons.volume_off_outlined,
                color: Colors.grey,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
