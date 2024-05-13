import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/topic.dart';
import 'package:shop_app/controllers/user.controller.dart';
import 'package:shop_app/screens/add_folder/choose_folder_get_topic.dart';
import 'package:shop_app/screens/flipcard/components/clone_topic.dart';
import 'package:shop_app/screens/flipcard/components/custom_listtile.dart';
import 'package:shop_app/screens/flipcard/components/edit_topic.dart';
import 'package:shop_app/screens/init_screen.dart';
import 'components/flipcard_header.dart';
import 'components/flipcard_bottom.dart';
import 'components/flipcard_middle.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class FlipCardScreen extends StatefulWidget {
  static const String routeName = "/flipcards";
  const FlipCardScreen({super.key});

  @override
  _FlipCardScreenState createState() => _FlipCardScreenState();
}

class _FlipCardScreenState extends State<FlipCardScreen> {
  final PageController pageController = PageController(viewportFraction: 0.9);
  int currentPage = 0;
  String token = '';
  Map<String, dynamic> topics = {};
  String title = '';
  String description = '';
  late String topicId;
  late bool isDiscover;
  bool isStudyAll = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInitialData();
  }

  void _loadInitialData() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && args.containsKey("_id")) {
      topicId = args["_id"];
      isDiscover = args['isDiscover'] ?? false;
      _loadTopics();
    } else {
      print('Invalid arguments. Cannot load topics.');
    }
  }

  Future<void> _loadTopics() async {
    token = (await SharedPreferences.getInstance()).getString('token') ?? '';
    if (token.isEmpty) {
      print('Token is empty. Cannot load topics.');
      return;
    }
    try {
      var value = await getVocabularyByTopicId(topicId, token);
      // if(!isStudyAll){
      //   value
      // }
      if (value != null) {
        _updateTopics(value);
      } else {
        print('API returned null value.');
      }
    } catch (e) {
      print('Exception occurred while loading topics: $e');
    }
  }

  void _updateTopics(Map<String, dynamic> value) {
    if (mounted) setState(() => topics = value ?? {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      );

  AppBar _buildAppBar() => AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                size: 30, color: Color(0xFF444E66)),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, InitScreen.routeName, (route) => false)),
        actions: [_buildMoreOptionsButton(), const SizedBox(width: 10)],
      );

  IconButton _buildMoreOptionsButton() => IconButton(
        icon: const Icon(Icons.more_horiz, size: 30, color: Color(0xFF444E66)),
        onPressed: () => _showBottomSheet(context),
      );

  Widget _buildBody() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    title = args['title'] ?? 'Default Title';
    description = args['description'] ?? '';

    return SafeArea(
      child: Container(
        color: const Color(0xFFF6F7FB),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (!isDiscover)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                isStudyAll ? Colors.white : Colors.grey,
                            backgroundColor: isStudyAll
                                ? Colors.blue
                                : const Color(0xFFF6F7FB),
                          ),
                          onPressed: () {
                            setState(() {
                              isStudyAll = true;
                            });
                          },
                          child: Text('Study All'),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                !isStudyAll ? Colors.white : Colors.grey,
                            backgroundColor: !isStudyAll
                                ? Colors.blue
                                : const Color(0xFFF6F7FB),
                          ),
                          onPressed: () {
                            setState(() {
                              isStudyAll = false;
                            });
                          },
                          child: Text('Study Bookmarks'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Header(
                pageController: pageController,
                currentPage: currentPage,
                vocabularies: topics['vocabularies'] ?? []),
            Middle(
                title: args['title'],
                description: args['description'] ?? '',
                topicId: topicId,
                listTile: _buildListTile(args),
                vocabularies: topics['vocabularies'] ?? []),
            if (!isDiscover)
              Bottom(
                  currentPage: currentPage,
                  vocabularies: topics['vocabularies'] ?? [],
                  topicId: topicId),
          ],
        ),
      ),
    );
  }

  ListTile _buildListTile(Map<String, dynamic> args) => ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(args['image'])),
        title: Text(args['username'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${args['terms']} terms',
            style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      );

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    if (!isDiscover)
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.5,
            child: Container(
              height: 280,
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  CustomListTile(
                    title: "Export file",
                    icon: Icons.file_download,
                    onTap: () async {
                      Navigator.pop(context);
                      _showExportDialog(context);
                    },
                  ),
                  const Divider(),
                  CustomListTile(
                    title: "Add to folder",
                    icon: Icons.add_box_outlined,
                    onTap: () async {
                      Navigator.pop(context);
                      await Navigator.pushNamed(
                          context, ChooseFolderToGetTopic.routeName,
                          arguments: {'topicId': topicId});
                    },
                  ),
                  const Divider(),
                  CustomListTile(
                    title: "Edit set",
                    icon: Icons.edit,
                    onTap: () {
                      handleEditTopic(context, topicId, title, description,
                          topics['vocabularies']);
                    },
                  ),
                  const Divider(),
                  CustomListTile(
                    title: "Delete set",
                    icon: Icons.delete,
                    onTap: () {
                      handleDeleteTopic(context, token, topicId);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: Center(
                        child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600]),
                    )),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    if (isDiscover)
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                CustomListTile(
                  title: "Add to folder",
                  icon: Icons.add_box_outlined,
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.pushNamed(
                      context,
                      ChooseFolderToGetTopic.routeName,
                      arguments: {
                        'topicId': topicId,
                      },
                    );
                  },
                ),
                const Divider(),
                CustomListTile(
                  title: "Save and edit",
                  icon: Icons.edit,
                  onTap: () {
                    isDiscover
                        ? handleCloneTopic(context, topicId, title, description,
                            topics['vocabularies'])
                        : handleEditTopic(context, topicId, title, description,
                            topics['vocabularies']);
                  },
                ),
                const Divider(),
                ListTile(
                  title: Center(
                      child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  )),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
  }

  void handleEditTopic(BuildContext context, String topicId, String title,
      String description, List<dynamic> vocabularies) async {
    Navigator.pop(context);
    await Navigator.pushNamed(
      context,
      EditTopic.routeName,
      arguments: {
        'topicId': topicId,
        'title': title,
        'description': description,
        'vocabularies': vocabularies,
      },
    );
  }

  void handleCloneTopic(BuildContext context, String topicId, String title,
      String description, List<dynamic> vocabularies) async {
    Navigator.pop(context);
    await Navigator.pushNamed(
      context,
      CloneTopic.routeName,
      arguments: {
        'topicId': topicId,
        'title': title,
        'description': description,
        'vocabularies': vocabularies,
      },
    );
  }

  void handleDeleteTopic(
      BuildContext context, String token, String topicId) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to delete this topic?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: const Color(0xFF3F56FF),
      onConfirmBtnTap: () async {
        deleteTopic(token, topicId).then((value) async {
          if ((value?['message'] ?? '') != '') {
            SnackBar snackBar = SnackBar(
              content: Text(value?['message'] ?? ''),
              duration: const Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pushNamedAndRemoveUntil(
                context, InitScreen.routeName, (route) => false);
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: "Failed to delete topic. Please try again.",
            );
          }
        });
      },
    );
  }

  Future<void> _showExportDialog(BuildContext context) async {
    if (topics['vocabularies'] == null || topics['vocabularies'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('There is no data to export.'),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Export Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Export as CSV"),
                onTap: () {
                  Navigator.pop(context);
                  _exportFile(context, "csv");
                },
              ),
              ListTile(
                title: const Text("Export as Excel"),
                onTap: () {
                  Navigator.pop(context);
                  _exportFile(context, "excel");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _exportFile(BuildContext context, String format) async {
    if (topics['vocabularies'] == null || topics['vocabularies'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('There is no data to export.')),
      );
      return;
    }

    try {
      String? outputFile = await _pickSaveLocation(format);
      if (outputFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File location not selected.')),
        );
        return;
      }

      if (format == "csv") {
        await _exportToCSV(outputFile);
      } else if (format == "excel") {
        await _exportToExcel(outputFile);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File exported successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  Future<String?> _pickSaveLocation(String format) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'vocabularies_export.$format',
        type: FileType.custom,
        allowedExtensions: [format],
      );
      return outputFile;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file location: $e')),
      );
      return null;
    }
  }

  Future<void> _exportToCSV(String path) async {
    try {
      List<List<dynamic>> csvData = topics['vocabularies']
          .map<List<dynamic>>(
              (vocab) => [vocab['englishWord'], vocab['vietnameseWord']])
          .toList();

      String csv = const ListToCsvConverter().convert(csvData);
      await File(path).writeAsString(csv);
    } catch (e) {
      throw Exception('Failed to export to CSV: $e');
    }
  }

  Future<void> _exportToExcel(String path) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel[excel.getDefaultSheet()!];

      topics['vocabularies'].forEach((vocab) {
        sheet.appendRow([vocab['englishWord'], vocab['vietnameseWord']]);
      });

      List<int>? fileBytes = excel.save();
      if (fileBytes != null) {
        await File(path).writeAsBytes(fileBytes);
      } else {
        throw Exception('Failed to generate Excel file bytes');
      }
    } catch (e) {
      throw Exception('Failed to export to Excel: $e');
    }
  }
}
