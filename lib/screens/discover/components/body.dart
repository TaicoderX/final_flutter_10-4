import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/topic.dart';
import 'package:shop_app/screens/discover/components/not_found.dart';
import 'package:shop_app/screens/flipcard/flipcard_screen.dart';
import 'package:shop_app/screens/folders/components/topic_in_folder.dart';

class Body extends StatefulWidget {
  final String searchQuery;

  const Body({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<dynamic> publicTopics = [];
  List<dynamic> filtered = [];
  String _currentSort = 'Original';

  @override
  void didUpdateWidget(covariant Body oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      searchTopic(widget.searchQuery);
    }
  }

  @override
  void initState() {
    super.initState();
    loadPublicTopicDetails();
  }

  void searchTopic(String query) {
    final String searchQueryLowercase = query.toLowerCase().trim();
    filtered = publicTopics;
    if (searchQueryLowercase.isEmpty) {
      setState(() {
        filtered = publicTopics;
      });
    } else {
      setState(() {
        filtered = filtered.where((topic) {
          final String topicNameLowercase =
              topic["topicNameEnglish"].toLowerCase();
          return topicNameLowercase.contains(searchQueryLowercase);
        }).toList();
      });
    }
  }

  Future<void> loadPublicTopicDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    try {
      Map<String, dynamic> data = await getPublicTopic(token);
      List<dynamic> topics = data['topics'];
      setState(() {
        publicTopics = topics;
        filtered = topics;
      });
    } catch (e) {
      print("Failed to load topic details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (filtered.isEmpty) {
      return NotFound();
    }
    return Container(
      color: Color(0xFFF6F7FB),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _currentSort,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 85, 85, 85)),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.sort,
                    ),
                    color: const Color(0xFF555555),
                    onPressed: () {
                      _showBottomSheet(context);
                    },
                  )
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  var topic = filtered[index];

                  return TopicInFolder(
                    image: topic['ownerId']['profileImage'] ?? "",
                    title: topic['topicNameEnglish'] ?? 'Title',
                    words: topic['vocabularyCount'] ?? 0,
                    name: topic['ownerId']['username'] ?? 'Name',
                    press: () {
                      Navigator.pushNamed(context, FlipCardScreen.routeName,
                          arguments: {
                            "_id": topic["_id"],
                            "title": topic["topicNameEnglish"],
                            'image': topic['ownerId']['profileImage'] ?? '',
                            'username': topic['ownerId']['username'] ?? '',
                            'terms': topic['vocabularyCount'].toString(),
                          });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'In original order',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF3F56FF)),
                      ),
                      onTap: () {
                        setState(() {
                          _currentSort = 'Original';
                        });
                        _sortVocabularies('Original');
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                        color: Colors.grey.shade300,
                        child: const SizedBox(
                            height: 1.0, width: double.infinity)),
                    ListTile(
                      title: const Text('Alphabetically',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF3F56FF))),
                      onTap: () {
                        setState(() {
                          _currentSort = 'Alphabetically';
                        });
                        _sortVocabularies('Alphabetically');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: ListTile(
                  title: const Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3F56FF),
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      letterSpacing: -1.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 30.0)
            ],
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _sortVocabularies(String sortType) {
    setState(() {
      if (sortType == 'Alphabetically') {
        List<dynamic> sorted = List.from(filtered);
        sorted.sort(
            (a, b) => a["topicNameEnglish"].compareTo(b["topicNameEnglish"]));
        filtered = sorted;
      } else if (sortType == 'Original') {
        filtered = List.from(publicTopics);
      }
      _currentSort = sortType;
    });
  }
}
