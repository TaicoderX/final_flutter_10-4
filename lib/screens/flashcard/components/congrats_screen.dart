import 'package:dynamic_multi_step_form/dynamic_json_form.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shop_app/screens/quiz/components/statistic.dart';

class CongratsScreen extends StatefulWidget {
  static String routeName = "congrats";

  @override
  _CongratsScreenState createState() => _CongratsScreenState();
}

class _CongratsScreenState extends State<CongratsScreen> {
  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    playSound();
  }

  void playSound() async {
    await audioPlayer.play(AssetSource('sounds/cheering-and-clapping.mp3'));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade700,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.indigo.shade700,
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'TNN App',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 22),
                ),
              ],
            ),
            Stack(
              fit: StackFit.loose,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/image4.png"),
                    ),
                  ),
                ),
                Positioned(
                  left: 60,
                  right: 60,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.indigo.shade500,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Congrats!',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 25),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'You earn 300 points',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'keep going',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () => {},
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.pink.shade500,
                    Colors.pinkAccent.shade100,
                  ]),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 40,
                width: MediaQuery.of(context).size.width / 1.2,
                child: Center(
                  child: Text(
                    'Statistic',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 40,
                width: MediaQuery.of(context).size.width / 1.2,
                child: Center(
                  child: Text(
                    'Still Learning',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
