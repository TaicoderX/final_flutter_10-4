import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/topic.dart';
import 'package:shop_app/models/VocabularyItem.dart';
import 'package:shop_app/screens/flipcard/flipcard_screen.dart';

class CloneTopic extends StatefulWidget {
  static String routeName = "/clone-topic";

  @override
  _StudySetScreenState createState() => _StudySetScreenState();
}

class _StudySetScreenState extends State<CloneTopic> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController? descriptionController;
  List<TextEditingController> termControllers = [];
  List<TextEditingController> definitionControllers = [];

  bool showDescription = false;
  List<Widget> containers = [];
  final ScrollController scrollController = ScrollController();
  List<FocusNode> focusNodes = [];
  FocusNode subjectFocusNode = FocusNode();
  FocusNode? descriptionFocusNode;
  int currentIndex = 0;
  String _token = '';
  List<VocabularyItem> vocabularyItems = [];
  bool _isDataLoaded = false;
  String originalSubject = '';
  String? originalDescription;
  List<VocabularyItem> originalVocabularyItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataLoaded) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      subjectController.text = arguments?['title'] ?? '';
      originalSubject = subjectController.text;
      descriptionController?.text = arguments?['description'] ?? '';
      originalDescription = descriptionController?.text;

      if (arguments != null && arguments['vocabularies'] != null) {
        List<dynamic> vocabularies = arguments['vocabularies'];
        containers.clear();
        focusNodes.clear();
        vocabularyItems.clear();

        for (var vocab in vocabularies) {
          FocusNode termFocusNode = FocusNode();
          FocusNode definitionFocusNode = FocusNode();
          TextEditingController termController =
              TextEditingController(text: vocab['englishWord']);
          TextEditingController definitionController =
              TextEditingController(text: vocab['vietnameseWord']);

          focusNodes.addAll([termFocusNode, definitionFocusNode]);

          containers.add(_buildContainer("Term", "Definition", termFocusNode,
              termController, definitionController));

          VocabularyItem item = VocabularyItem(
            id: vocab['_id'],
            termController: termController,
            definitionController: definitionController,
            originalTerm: vocab['englishWord'],
            originalDefinition: vocab['vietnameseWord'],
          );
          vocabularyItems.add(item);
        }

        _isDataLoaded = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(4, (_) => FocusNode());
    descriptionController = TextEditingController();
    addFocusListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(subjectFocusNode);
    });
    getToken();
  }

  void onClonePressed() async {
    String newTopicTitle = subjectController.text;
    String newTopicDescription = descriptionController?.text ?? '';
    List<Map<String, String>> vocabularyList = vocabularyItems
        .where((item) =>
            item.termController.text.isNotEmpty &&
            item.definitionController.text.isNotEmpty)
        .map((item) => {
              'englishWord': item.termController.text,
              'vietnameseWord': item.definitionController.text,
            })
        .toList();

    try {
      await createTopic(
              newTopicTitle, newTopicDescription, vocabularyList, _token, false)
          .then((value) async {
        Map<String, dynamic> topic = value['topic'];
        Map<String, dynamic> user = topic['ownerId'];
        Navigator.pushNamed(context, FlipCardScreen.routeName,
            arguments: {
              "_id": topic["_id"],
              "title": topic["topicNameEnglish"],
              'image': user["profileImage"] ?? '',
              'username': user["username"] ?? '',
              'description': topic["descriptionEnglish"] ?? '',
              'terms': topic["vocabularyCount"].toString(),
            });
      });
    } catch (e) {
      print('An error occurred: $e');
      // Show error feedback
    }
  }

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Edit set',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_rounded),
            onPressed: onClonePressed,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              _buildField('Subject, chapter, unit', 'Title', subjectController),
              if (descriptionController!.text.isEmpty && !showDescription)
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _toggleDescriptionField,
                    child: const Text('+ Description',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              if (descriptionController!.text.isNotEmpty || showDescription)
                _buildField("What's your set about", "Description",
                    descriptionController!),
              SizedBox(height: 20),
              ...containers,
              SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewContainer,
        child: Icon(
          Icons.add,
          size: 15,
        ),
        backgroundColor: Color(0xFF007BFF),
        shape: CircleBorder(),
        mini: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void addFocusListeners() {
    subjectFocusNode.addListener(() => scrollToFocus(subjectFocusNode));
    focusNodes.forEach((node) {
      node.addListener(() => scrollToFocus(node));
    });
  }

  void scrollToFocus(FocusNode node) {
    final widgetIndex = focusNodes.indexOf(node);
    double position = 0.0;
    if (widgetIndex >= 0) {
      position = widgetIndex > currentIndex
          ? widgetIndex * 200.0
          : widgetIndex * 200.0 - 200.0;
    }
    currentIndex = widgetIndex;

    scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    subjectFocusNode.dispose();
    descriptionFocusNode?.dispose();
    focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  Widget _buildContainer(
      String hintTerm,
      String hintDefinition,
      FocusNode termFocusNode,
      TextEditingController termController,
      TextEditingController definitionController) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildField(hintTerm, "Enter English Word", termController,
                  focusNode: termFocusNode),
              _buildField(hintDefinition, "Enter Vietnamese Word",
                  definitionController),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    String hint,
    String subTitle,
    TextEditingController controller, {
    FocusNode? focusNode,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.only(bottom: -5, top: 6),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 4.0),
              ),
              hintStyle: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 179, 179, 179),
              ),
            ),
            focusNode: focusNode,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              subTitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 132, 131, 131),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addNewContainer() {
    FocusNode termFocusNode = FocusNode();
    TextEditingController termController = TextEditingController();
    TextEditingController definitionController = TextEditingController();

    vocabularyItems.add(VocabularyItem(
      id: null,
      termController: termController,
      definitionController: definitionController,
      originalTerm: '',
      originalDefinition: '',
    ));

    setState(() {
      containers.add(_buildContainer("Term", "Definition", termFocusNode,
          termController, definitionController));
    });

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(termFocusNode));
  }

  void _toggleDescriptionField() {
    if (descriptionFocusNode == null) {
      descriptionFocusNode = FocusNode();
      descriptionFocusNode!
          .addListener(() => scrollToFocus(descriptionFocusNode!));
    }
    setState(() {
      showDescription = !showDescription;
    });
    if (showDescription) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(descriptionFocusNode);
      });
    }
  }
}
