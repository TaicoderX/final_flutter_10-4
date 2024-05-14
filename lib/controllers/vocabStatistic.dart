import 'dart:convert';

import 'package:http/http.dart' as http;
import 'config.dart';

Future<Map<String, dynamic>> getVocabStatisticByTopicId(String topicId, String token) async {
  var response = await http.get(
    Uri.parse(getVocabularyStatisticByTopicIdUrl + topicId),
    headers: {
      'token': '$token',
    },
  );

  if (response.statusCode == 200 || response.statusCode != 500) {
    return json.decode(response.body);
  } else {
    throw Exception(
        'Failed to load topics: Server responded with ${response.statusCode}');
  }
}