import 'dart:convert';

import 'package:http/http.dart' as http;
import 'config.dart';

Future<Map<String, dynamic>> getAllAchievement() async {
  var response = await http.get(
    Uri.parse(getAchievementByUser),
    // headers: {
    //   'token': '$token',
    // },
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> createAchivement(List<Map<String, String>> listAchievement) async {
  var response = await http.post(
    Uri.parse(createAchievement),
    // headers: {
    //   'token': '$token',
    // },
    body: jsonEncode(listAchievement),
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}