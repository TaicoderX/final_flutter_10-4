import 'package:flutter/material.dart';
import 'package:shop_app/controllers/learningStatistic.dart';
import 'package:shop_app/screens/local/local_storage.dart';

class Ranking extends StatefulWidget {
  static const String routeName = '/ranking';
  const Ranking({Key? key}) : super(key: key);

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  List<dynamic> allStatistics = [];
  String _topicId = '';
  String _token = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _topicId = arguments['topicId'];
    loadAllStatistics();
  }

  void loadAllStatistics() async {
    _isLoading = true;
    _token = await LocalStorageService().getData('token');
    var res = await getStatisticByTopicId(_topicId, _token);
    if (res != null && res['learningStatistic'] != null) {
      setState(() {
        allStatistics = res['learningStatistic'];
        _isLoading = false;
      });
    }
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secsStr = secs.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secsStr";
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 2, 10, 57),
        body: Center(
          child: CircularProgressIndicator(color: Colors.orange,),
        ),
      );
    }

    if (allStatistics.isEmpty) {
      return Scaffold(
        appBar: AppBar(
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
              
            ),
        backgroundColor: const Color.fromARGB(255, 2, 10, 57),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'No one has learned this topic yet!',
            style: TextStyle(color: Colors.white, fontSize: 24),
            textAlign: TextAlign.center,
          ),
        )),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 10, 57),
      body: SafeArea(
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
              
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: allStatistics.length,
                itemBuilder: (context, index) {
                  return _createBox(
                    allStatistics[index]['userId']['profileImage'],
                    allStatistics[index]['userId']['username'],
                    index + 1,
                    allStatistics[index]['learningCount'],
                    allStatistics[index]['vocabLearned'],
                    formatTime(allStatistics[index]['learningTime']),
                    allStatistics[index]['learningPercentage'] * 1.0,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createBox(String url, String username, int rank, int learningCount,
      int vocabulariesLearned, String timeLearned, double percentLearned) {
    return Column(
      children: [
        SizedBox(
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
                  backgroundImage: NetworkImage(url),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        username,
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      Text(
                        'Rank: $rank',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
                          'Learning Count: $learningCount',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Vocabularies Learned: ${int.parse(vocabulariesLearned.toString())}',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Time Learned: $timeLearned',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ]),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          value: percentLearned,
                          backgroundColor: Colors.orange,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 120, 226, 123)),
                          strokeWidth: 8,
                        ),
                      ),
                      Text(
                        '${(percentLearned * 100).toStringAsFixed(1)}%',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
