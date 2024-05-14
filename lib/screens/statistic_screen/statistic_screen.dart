import 'package:flutter/material.dart';
import 'package:shop_app/controllers/vocabStatistic.dart';
import 'package:shop_app/screens/local/local_storage.dart';

class StatisticScreen extends StatefulWidget {
  static const String routeName = '/statistic-screen';
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
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
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _topicId = arguments['topicId'];
    loadAllStatistics();
    super.didChangeDependencies();
  }

  void loadAllStatistics() async {
    setState(() {
      _isLoading = true;
    });
    _token = await LocalStorageService().getData('token');
    var res = await getVocabStatisticByTopicId(_topicId, _token);
    if (res != null && res['vocabStats'] != null) {
      setState(() {
        allStatistics = res['vocabStats'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 2, 10, 57),
        body: Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    if (allStatistics.isEmpty) {
      return Scaffold(
        appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 10, 57),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Vocab Statistic',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 10, 57),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Vocab Statistic',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
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
                for (var i = 0; i < allStatistics.length; i++)
                  _createBox(
                    allStatistics[i]['statistic']['learningCount'].toString(),
                    allStatistics[i]['vocabulary']['englishWord'],
                    allStatistics[i]['vocabulary']['vietnameseWord'],
                    allStatistics[i]['statistic']['learningStatus'],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createBox(String learningCount, String englishWord,
      String vietnameseWord, String learningStatus) {
    return Column(
      children: [
        SizedBox(height: 20),
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
                  'learning counted: $learningCount',
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
                      englishWord,
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Center(
                      child: Text(
                        vietnameseWord,
                        softWrap: true,
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(10),
                color:
                    learningStatus == "learning" ? Colors.yellow : Colors.green,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.close, color: Colors.white),
                    Text('Status: $learningStatus',
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
